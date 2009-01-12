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
#include "ddsc.h"
#include "utilities.h"
#include "i2c.h"
#include "uart0.h"

//insert from head
//read from tail
//the goal is to be fast (very fast) and light
//no protection is provided for buffer overflow! Be carefull!
volatile uint8_t i2c_buffer[MAX_BUFFER_LEN];
volatile uint8_t i2c_head;
volatile uint8_t i2c_tail;

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

//FYI:
//	SOS default seems to be TWBR = 0x0A; TWSR1:0 = b00 (prescaler = 1) 
//	for clock = 205.3 kHz

void init_I2C_slave()
{
	init_i2c_buffer();
  	TWCR = B8(01000101); //control register
  	TWAR = (DDSC_ADDRESS <<1) + 1; //address register (disable broadcast receive)
  	TWAMR = 0x00; //address mask register (use entire address space)
}

//we respond to general call and specific address call the same way

SIGNAL(SIG_TWI){
  //if (TWSR != 0x60) while(1);
  if (TWSR == 0x60 || TWSR == 0x70){
    //general call or I'm specifically being addressed	
    //TWCR = B8(10000101); //receive and NACK (i.e. end of data payload after 1 byte rx)
    TWCR = B8(11000101); //always return ACK after data (accept infinite transfer length from master!)
    
  }
  else if (TWSR == 0x80 || TWSR == 0x90){
	  	//ACK was just returned
	  	//	receive byte
  		i2c_enqueue(TWDR);
  		TWCR = B8(11000101); //always return ACK after data (accept infinite transfer length from master!)
  }
  else if (TWSR == 0x88 || TWSR == 0x98){
	//NACK was just returned
    //receive byte
    i2c_enqueue(TWDR);
    //switch to the no-longer addressed slave mode (waiting on new bus transfer to address me)
    TWCR = B8(11000101);
  }
  else {
    //if error or unrecognized bus condition, abort current transfer and await next packet
    //switch to the no-longer addressed slave mode (waiting on new bus transfer to address me)
    TWCR = B8(11000101);
  }	
} //signal(SIG_2WIRE_SERIAL)
