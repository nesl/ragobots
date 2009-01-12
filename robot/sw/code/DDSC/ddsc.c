/*
  #################################################################################
  # RAGOBOT:IRMAN MAIN CONTROLLER PROGRAM
  # ------------------------------------------------------------------------------
  # Controls all functions involving the IRMAN controller on the Ragobot Robot
  # 
  # APPLIES TO (Ragobot Part Numbers):
  # ------------------------------------------------------------------------------
  # RBTBDYC
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
  # ---------------------------------------------------------------------------
  # Jonathan Friedman, GSR
  # Networked and Embedded Systems Laboratory (NESL)
  # University of California, Los Angeles (UCLA)
  #
  # David Lee, GSR
  # Networked and Embedded Systems Laboratory (NESL)
  # University of California, Los Angeles (UCLA)
  #
  # REVISION HISTORY
  # ---------------------------------------------------------------------------
  # 9/20/2004:
  #      Original by Jonathan Friedman, UCLA (jf@ee.ucla.edu)
  # 2/24/2005:
  #      Major code restructuring by Jonathan Friedman, UCLA
  # 6/14/2005:
  #      Major code cleanup by David Lee, UCLA
  # 2/14/2006
  #      Ported for RBTBDYC
  #############################################################################
*/

#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>
#include "utilities.h"
#include "ddsc.h"
#include "uart0.h"
#include "i2c.h"
#include "tp.h"

void init_mcu(void) {
  // Input/Output Ports initialization
  
  // Port B initialization 
  // 7) 	Traction Detection to output/no pull-up
  // 6) 	LED off
  // 5) 	PGM
  // 4)		PGM/DDSC_ALERT; output; default 0 (inactive)
  // 3)		PGM/Nerve_EN; output; default disabled
  // 2,1)	Enable lines for various; outputs; default disabled
  // 0)		HEAD electrical fault; input; pull-up enabled
  PORTB = B8(00100001);
  DDRB =  B8(11011110);

  // Port C initialization
  // 7-4)	DNC, Reset, I2C; inputs or overridden; no pull-up
  // 3-0)	Electrical fault; inputs; pull-up enabled
  PORTC= B8(00001111);
  DDRC = B8(00000000);

  // Port D initialization
  // 7-2)	Device Discovery inputs; externally pulled-up
  // 1-0)	Enable lines for FOOT0, FOOT1 interfaces; output; no pull-up
  PORTD= B8(00000000);
  DDRD = B8(00000011);
		
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

int main(void){
	uint8_t blah; //xxx DEBUG ONLY DELETE ME!
	
	init_mcu();
	init_serial(UART); //debugging only (will override FOOT enable lines)
	init_I2C_slave();
	sei(); //enable interrupts (go live)
  
	while(1)
	{
		if (i2c_count() > 0){
			//send_byte_serial(10);
			//send_byte_serial(13);
			//send_byte_serial(i2c_count()+0x30);
			send_byte_serial('-');
			blah = i2c_dequeue();
			if (blah == 0x7F) tpl(TOGGLE);
		 	UART_send_HEX8(blah);
		} 
	}
}
