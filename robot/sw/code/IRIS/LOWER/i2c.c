/*
#################################################################################
# RAGOBOT:IRMAN I2C SERIAL MODULE
# ------------------------------------------------------------------------------
# Implements buffering and bus management of the TWI unit onboard IRMAN
# 
# APPLIES TO (Ragobot Part Numbers):
# ------------------------------------------------------------------------------
# RBTBDYB
#
# COPYRIGHT NOTICE
# ------------------------------------------------------------------------------
# "Copyright (c) 2000-2003 The Regents of the University  of California.
# All rights reserved.
# Permission to use, copy, modify, and distribute this software and its
# documentation for any purpose, without fee, and without written agreement is
# hereby granted, provided that the above copyright notice, the following
# two paragraphs and the author appear in all copies of this software.
# IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
# DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
# OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
# CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
# ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
# PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
#
# DEVELOPED BY
# ------------------------------------------------------------------------------
# Jonathan Friedman, GSR
# Networked and Embedded Systems Laboratory (NESL)
# University of California, Los Angeles (UCLA)
#
# REVISION HISTORY
# ------------------------------------------------------------------------------
# <for dates and comments, see cvs>
# Original by Jonathan Friedman, UCLA (jf@ee.ucla.edu) 		
#################################################################################
*/

#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>
#include "jonathan.h"
#include "uart0.h"
#include "i2c.h"
#include "tp.h"


volatile uint8_t i2c_state;

//TX Queue (outgoing)
volatile uint8_t i2c_buffer[MAX_BUFFER_LEN];
volatile uint8_t i2c_head;
volatile uint8_t i2c_tail;

//RX Queue (incoming)
volatile uint8_t i2c_ibuffer[MAX_IBUFFER_LEN];
volatile uint8_t i2c_ihead;
volatile uint8_t i2c_itail;

//----------------------------------------------------------------
//- INITIALIZATION
//----------------------------------------------------------------

void init_I2C(){
	//Device will boot up in non-addressed slave mode
	//	i.e. it is waiting to hear its address on the bus, or 
	//	being commanded into transmitter mode
	
	TWBR = 32; 	// bit rate register (master mode only)
				//		200kHz with prescaler = 1;	
	TWCR = B8(01000101); //control register
	//TWSR //Status register (no init required)
	//TWDR //data register (no init required)
	TWAR = (IRIS_ADDRESS <<1) + 0 ; //address register (disable broadcast receive)
	TWAMR = 0x00; //address mask register (use entire address space)
	cbi(PORTC, 4); //disable internal pull-up resistors
	cbi(PORTC, 5);
	
	init_i2c_buffer();
	init_i2c_ibuffer();
	i2c_state = IDLE;
}

//----------------------------------------------------------------
//- I2C OUTGOING DATA QUEUE
//----------------------------------------------------------------

//insert from head
//read from tail
//the goal is to be fast (very fast) and light
//no protection is provided for buffer overflow! Be carefull!


void init_i2c_buffer(void){
	i2c_head = 0;
	i2c_tail = 0;
}

inline uint8_t i2c_count(void){
	if (i2c_head >= i2c_tail){	
		return (i2c_head - i2c_tail);
	}
	else {
		return ((MAX_BUFFER_LEN-i2c_tail)+i2c_head);
	}
}

inline void i2c_enqueue(uint8_t datain){
	i2c_buffer[i2c_head] = datain;
	i2c_head++;
	if (i2c_head >= MAX_BUFFER_LEN){
		i2c_head = 0;
	}
}

inline uint8_t i2c_dequeue(void){
	uint8_t oldtail;
	oldtail = i2c_tail;
	i2c_tail++;
	if (i2c_tail >= MAX_BUFFER_LEN){
		i2c_tail = 0;
	}
	return i2c_buffer[oldtail];
}

//----------------------------------------------------------------
//- I2C INCOMING DATA QUEUE
//----------------------------------------------------------------

//insert from head
//read from tail
//the goal is to be fast (very fast) and light
//no protection is provided for buffer overflow! Be carefull!


void init_i2c_ibuffer(void){
	i2c_ihead = 0;
	i2c_itail = 0;
}

inline uint8_t i2c_icount(void){
	if (i2c_ihead >= i2c_itail){	
		return (i2c_ihead - i2c_itail);
	}
	else {
		return ((MAX_IBUFFER_LEN-i2c_itail)+i2c_ihead);
	}
}

inline void i2c_ienqueue(uint8_t datain){
	i2c_ibuffer[i2c_ihead] = datain;
	i2c_ihead++;
	if (i2c_ihead >= MAX_IBUFFER_LEN){
		i2c_ihead = 0;
	}
}

inline uint8_t i2c_idequeue(void){
	uint8_t oldtail;
	oldtail = i2c_itail;
	i2c_itail++;
	if (i2c_itail >= MAX_IBUFFER_LEN){
		i2c_itail = 0;
	}
	return i2c_ibuffer[oldtail];
}


//----------------------------------------------------------------
//- USER ROUTINES
//----------------------------------------------------------------

//sent in this order: ADDR, datain, datain2
inline void I2C_send(){
	//check for logical state is IDLE and stop condition from last attempt has completed transmission
	if (i2c_state == IDLE && ((TWCR & _BV(4)) == 0x00)){ 
		//TAKE CONTROL OF BUS	
			i2c_state = BUSY;
			TWCR = B8(11100101); //send START on bus
	}	
}

//----------------------------------------------------------------
//- INTERRUPT SERVICE ROUTINES
//----------------------------------------------------------------

// we respond to general call and specific address call the same way
// we only make 1 attempt to receive the intended receiver 
//		located at (IRIS_REPORTING_ADDRESS).
SIGNAL(SIG_TWI){
	tp6(HIGH); //xxx
	/*
	//DEBUG!!!
		send_byte_serial('R');
		UART_send_HEX8(TWSR);
		send_byte_serial(10);
		send_byte_serial(13);
	//END DEBUG!!!
	*/
	
	
	
	//-------------------------
	//- I2C MASTER TRANSMIT
	//-------------------------
	
	if (TWSR == 0x08){
		//finished transmitting a START condition; I am now master of the bus
		//write ADDR+W
		TWDR = ((IRIS_REPORTING_ADDRESS<<1) + WRITE);
		TWCR = B8(11000101);
	}
	
	else if (TWSR == 0x18 || TWSR == 0x28){
		//address or data sent, received ACK
		if (i2c_count() > 0){
			TWDR = i2c_dequeue();
			TWCR = B8(11000101); //transmit the data
		}
		else {
			//although we received ACK we have nothing left to send!
			i2c_state = IDLE;
			TWCR = B8(11010101); //transmit the STOP condition (to release bus)
		}
	}
	
	else if (TWSR == 0x20){
		//address sent, received NACK
		//Throw data away (it will get old)
		if (i2c_count() >= 2){
			if (i2c_count() %2	== 1){
				i2c_dequeue();
			}
			else {
				i2c_dequeue();
				i2c_dequeue();
			}
		}
		//Transmit the STOP condition and release bus
			i2c_state = IDLE;
			TWCR = B8(11010101);			
	}
	else if (TWSR == 0x30){
		//data sent, received NACK
		
		//Are we finished? Then this is correct!
		if (i2c_count() == 0){
			//Transmit the STOP condition and release bus
			i2c_state = IDLE;
			TWCR = B8(11010101);	
		}
		
		//Error: NACK received, but we still have data to send!
		else {
			if (i2c_count() %2 == 1){
				//error! drop 1 byte to restore alignment
					i2c_dequeue();
			}
			//Transmit the STOP condition and release bus
				i2c_state = IDLE;
				TWCR = B8(11010101);	
		}
	}

	else if (TWSR == 0x38){
		//lost arbitration, give up!
		i2c_state = IDLE;
		TWCR = B8(11000101);
		
		//******************
		//* WRITE ME SOON!!!
		//******************
		//handle state = 0x68; lost arbitration because other master is talking to ME!!!
	}
	
	
	
	//-------------------------
	//- I2C SLAVE RECEIVE
	//-------------------------
	
	else if (TWSR == 0x60 || TWSR == 0x70){
		//general call or I'm specifically being addressed	
		TWCR = B8(11000101); //receive and ACK (commands are always 2-bytes fixed)
	}
	else if (TWSR == 0x80 || TWSR == 0x90){
		//received first byte	
		i2c_ienqueue(TWDR);
		//NACK incoming second byte to signal end of command
		TWCR = B8(10000101); //receive and NACK (commands are always 2-bytes fixed)
	}
	else if (TWSR == 0x88 || TWSR == 0x98){
		//receive second byte
		i2c_ienqueue(TWDR);
		//switch to the no-longer addressed slave mode (waiting on new bus transfer to address me)
		TWCR = B8(11000101);
	}
	else {
		//if error or unrecognized bus condition, abort current transfer and await next packet
		//switch to the no-longer addressed slave mode (waiting on new bus transfer to address me)
		i2c_state = IDLE;
		TWCR = B8(11010101);
	}	
	
	tp6(LOW); //xxx
	
} //signal(SIG_2WIRE_SERIAL)
