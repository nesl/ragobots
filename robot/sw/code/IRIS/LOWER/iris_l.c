/*
  #################################################################################
  # RAGOBOT:IRIS LOWER CONTROL CODE
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
#include "tp.h"
#include "ircomm_l.h"
#include "i2c.h"
#include "uart0.h"



//----------------------------------------------------------------
//- INIT ROUTINES
//----------------------------------------------------------------

inline void init_mcu(void) {
	// Input/Output Ports initialization
		cbi(PORTD, 2); //output 0 on IRIS_CNTRL to signal to IRISU that we are not ready	
  		DDRD = B8(10101110); //UART, IRIS TX DATA, ALERT, CB2, IRIS VCC
		
  		DDRC = B8(00001101); //Transmitter Power Level Control, I2C, Reset, TP6
  							//BUGFIX: PC1 is configured as an input to protect it because it is incorrectly shorted to PC2; all control in this code is done from PC2.  		
  		DDRB = B8(11101011); //debug LED, BLED, Clock-out, PGM I/F, XO
} //init_MCU


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
		
	//INIT
		cli(); //disable interrupts (in case function is called multiple times)
		init_mcu();
		init_I2C();
		init_serial(USRT);
		init_tp();
		init_iris();
		init_irtx(); //turn on tx encoder
		iris_tx(HIGH); //turn on tx output
		iris_rx(ON); //turn on receivers
		tpl(OFF); //LED to OFF state
		tp6(LOW); //TP to LOW state
		sei(); //enable interrupts (go live)
		sbi(PORTD, 2); //signal IRISU that we are ready to go!

	//PGM	
	  	while(1)
		{
		  	tp6(TOGGLE);
		  	if (i2c_count() > 0) {
			  	I2C_send();
		  	}
		}
} //main
