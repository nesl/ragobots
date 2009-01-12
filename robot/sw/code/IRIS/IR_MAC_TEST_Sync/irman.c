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
#include "JONATHAN.h"
#include "IRMAN_RAGOBOT.h"
#include "IR_COMM.h"
#include "uart0.h"
#include "I2C.h"

void init_mcu(void) {
  // Input/Output Ports initialization
	
  // Port D initialization
  // Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
  // State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
  PORTC=0x00;
  DDRC = 0xFE;
  PORTD=0x00;
  DDRD=0x00;
		
  // Timer/Counter 0 initialization
  // Clock source: System Clock
  // Clock value: Timer 0 Stopped
  // Mode: Normal top=FFh
  // OC0 output: Disconnected
  ASSR=0x00;
  TCNT0=0x00;
	
	
	
  // External Interrupt(s) initialization
  // INT0: Off
  // INT1: Off
  // INT2: Off
  // INT3: Off
  // INT4: Off
  // INT5: Off
  // INT6: Off
  // INT7: Off
  EIMSK=0x00;
	
  // Analog Comparator initialization
  // Analog Comparator: Off
  // Analog Comparator Input Capture by Timer/Counter 1: Off
  // Analog Comparator Output: Off
  ACSR=0x80;
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


void stk_ledon(uint8_t num){
	DDRB = 0xFF;
	PORTB = num;
}

int main(void){
	volatile uint8_t dq_p;
	init_mcu();
	init_serial();
	//sei(); //enable interrupts (go live)
	cli();
	//init_irclock();
	//air_led_medium();
	sbi(DDRC,5); //RTOS timing indicator
	cbi(DDRC,3); //pushbutton
	start_irclock();
	stk_ledon(0xFF); //LED's off
	air_init();
	dq_p = 0;
  	while(1){
		//Wait for arriving bytes
	  	air_get_symbols();
	  	
		//Timing loop indicator
	  	sbi(PORTC,5);
	  	
	  	//Tx process
	  	
	  	
	  	//Process each new symbol through its channel machine
		air_proc_channel(0);//0
		air_proc_channel(1);//1
		air_proc_channel(2);//2
		air_proc_channel(3);//3
		air_proc_channel(4);//4
		air_proc_channel(5);//5
		air_proc_channel(6);//6
		
		//Manage the I2C queue
		
		//Close timing loop
		cbi(PORTC,5);
		//stk_ledon(TIFR0);
	}
} //main
