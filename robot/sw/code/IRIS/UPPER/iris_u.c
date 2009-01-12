/*
  #################################################################################
  # RAGOBOT:IRMAN MAIN CONTROLLER PROGRAM
  # ------------------------------------------------------------------------------
  # Data assembly, error detection, I2C queue and reporting, Channel Sync and Compression
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
  # 9/20/2004:
  #      Original by Jonathan Friedman, UCLA (jf@ee.ucla.edu)
  # 2/24/2005:
  #      Major code restructuring by Jonathan Friedman, UCLA
  #################################################################################
*/


//#define _B2_


#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>
#include "jonathan.h"
#include "ircomm_u.h"
#include "uart0.h"
#include "tp.h"



//----------------------------------------------------------------
//- INIT ROUTINES
//----------------------------------------------------------------

void init_mcu(void) {
	// Input/Output Ports initialization
  		sbi(DDRB, 1); //IRIS_LED1 as ouput
		DDRB = B8(10010110); //DNC pins are outputs; 
		sbi(PORTB, 5); //enable pull-up resistor on PGM_CLK input
						//xxx check if there is a master pull-up enable or something that needs to be turned on
		//PORTC init is controlled by iris_init() in ircomm.c
		DDRD = B8(11111010); //DNC pins are outputs; TP are outputs; IRIS_CTRL is input
		sbi(PORTD, 2); //enable pull-up resistor on IRIS_CTRL
		
} //init_MCU

//Configures 16-bit timer and starts it running; non-interrupt mode of operation
void init_clock(void){
	TCCR1A = B8(00000000);	
	TCCR1B = B8(00001001);
	TCCR1C = B8(00000000);
	OCR1AH = 0x03; //number of 16MHz cycles to run the timer for before interrupt flag is set
	OCR1AL = 0x80; //d640 = 40uS period
}

void stall(uint16_t limit){
  uint16_t blah, i, j;
  blah=0;
  for(i=0;i<0xFFFF;i++){
    for(j=0;j<limit;j++){
      blah++;
    }
  }	
}



//----------------------------------------------------------------
//- MAIN PROGRAM
//----------------------------------------------------------------

int main(void){
	//VAR
		uint8_t xfr_timer;
	//INIT
		cli(); //disable interrupts (in case function is called multiple times)
		init_tp();
		init_mcu();
		init_air();
		init_iris();
		init_serial(USRT);
		init_clock();
		tpl(OFF); //debug led off		
		sbi(TIFR1, 1); //reset clock interrupt
		xfr_timer = 0;

	//WAIT FOR IRISL TO BOOT
		stall(3); //let pull-up resistor have some time to charge the input
		while(PIND & _BV(2) == 0x00); //wait for IRISL to boot up
		
	//PGM	
	  	while(1){ 	
		  	//Timing loop indicator
		  		tp5(HIGH); //RTOS timing indicator xxx
			//Wait for arriving bytes
		  		air_get_channels();
		  		/*
		  		if (get_air_capture() != 0x00) {
			  		UART_send_BIN8(get_air_capture());
					send_byte_serial(10);
			  		send_byte_serial(13);
		  		}
		  		*/
		  		//DEBUG: CLONE CHANNEL TO EXTRAPOLATE WORST CASE PROCESSING SCENARIO
		  		/*
		  		if ((get_air_capture() & B8(00100000)) == 0x00){
			  		set_air_capture(0x00);	
		  		}
		  		else {
			  		set_air_capture(0xFF);
		  		}
		  		*/
		  		set_air_capture(0x00);
		  		
		  	//Process each new symbol through its channel machine
				air_proc_channel(0);//0
				air_proc_channel(1);//1
				air_proc_channel(2);//2
				air_proc_channel(3);//3
				air_proc_channel(4);//4
				air_proc_channel(5);//5
				air_proc_channel(6);//6
			
			//Manage the XFR queue (to IRISL)
				xfr_timer++;
				//1000uS period over 56uS interval = 17 (952uS)
				//PIND.2 is a control line from IRISL effectively implementing flow control.
				if (xfr_timer >= 17 && ((PIND & _BV(2)) > 0)){ 
					xfr_timer = 0;
					//transfer_sym();	
					transfer_sym_debug();	
				}
				
				//debug_transfer_sym();
				//tpl(TOGGLE);	
				
			//Close timing loop
				tp5(LOW); //RTOS timing indicator xxx
				
			//Constant sample time
				while((TIFR1 & 2) == 0x00);
				sbi(TIFR1, 1);
		}
} //main
