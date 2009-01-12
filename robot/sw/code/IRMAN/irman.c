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
#include "irman.h"
#include "motor.h"
#include "ircomm.h"
#include "uart0.h"
#include "i2c.h"

void init_mcu(void) {
  // Input/Output Ports initialization
  
  // Port B initialization 
  // 1) set BCU ALERT to output (high)
  // 2) set M_DIR0 and MDIR1 to output (low)
  // 3) set ICL_ENC and ICH_ENC to output (low)
  // 4) set the rest to inputs
  // Func0=Out Func1=Out Func2=Out Func3=In Func4=In Func5=In Func6=Out Func7=Out 
  // State0=1 State1=0 State2=0 State3=T State4=T State5=T State6=0 State7=0
  PORTB = 0x01;
  DDRB = 0xC7;

  // Port C initialization
  // 1) set ACC_EN, BUMP_DETECTED, I2C_SDA, I2C_SCL to inputs
  // 2) set BUMP_RESET to output (high)
  // Func0=In Func1=In Func2=In Func3=Out Func4=In Func5=In Func6=In Func7=In 
  // State0=T State1=T State2=T State3=1 State4=T State5=T State6=T State7=T 
  PORTC=0x08;
  DDRC = 0x08;

  // Port D initialization
  // 1) Set M_PWM1 and M_PWM0 to output (high) to disable to outputs of the h-bridge
  // 2) Set CLIFF_3.3_VCC to output (low)
  // Func0=In Func1=In Func2=In Func3=In Func4=In Func5=Out Func6=Out Func7=Out 
  // State0=T State1=T State2=T State3=T State4=T State5=1 State6=1 State7=0 
  PORTD=0x60;
  DDRD=0xE0;
		
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

#define sval 0x002F

void tx_cliff_val(){
  UART_send_HEX16((uint16_t)IRC0_THRESHOLD);
  send_byte_serial(' ');
  UART_send_HEX16((uint16_t)cliff0_val);
#ifdef _B2_
  send_byte_serial(' '); 
  UART_send_HEX16((uint16_t)IRC1_THRESHOLD);
  send_byte_serial(' ');
  UART_send_HEX16((uint16_t)cliff1_val);
#endif 
  send_byte_serial(10);	
  send_byte_serial(13);	
}

#define STs 0x0000
void do_clock(){
  //8 periods
  sbi(PORTD,3);
  stall(STs);
  cbi(PORTD,3);
  stall(STs);
  sbi(PORTD,3);
  stall(STs);
  cbi(PORTD,3);
  stall(STs);
  sbi(PORTD,3);
}

void cliff_avoidance() 
{
  if (robot_state == ROBOT_MOVE) 
    {
      if ((cliff0_val >= IRC0_THRESHOLD) || (cliff1_val >= IRC1_THRESHOLD))
	{
	  clear_irman_hi(); //signal to brain that edge detected
	  //STATE1 - BACK AWAY FROM LEDGE
	  move(M_REV3,M_REV3);
	  while ((cliff0_val >= IRC0_THRESHOLD) || (cliff1_val >= IRC1_THRESHOLD));
	  
	  //STATE2 - CLEARANCE FOR TURN
	  move(M_REV4,M_REV4);
	  stall(0x000E);
	  
	  //STATE3 - TURN (left)
	  // move(M_REV4,M_FWD4);
	  //stall(0x000E);
	  //testled_off();
	  set_irman_hi(); //clear the signal to the brain
	  move(M_STOP,M_STOP);      
	}
    }
}

int main(void){
  init_mcu();
  init_motor();
  init_serial();
  init_ircliff();
  init_I2C_slave();
  robot_state = ROBOT_STOP;
  stall(sval); //power-on stall... so we don't run away from the programmer! ;)
  sei(); //enable interrupts (go live)
  
  //IRC0_THRESHOLD = 0x03A3;
  //IRC1_THRESHOLD = 0x03A3;
  
  //ircliff_calibrate();
  //ircliff_medium();
  while(1)
   {
     i2c_parse();
     
     cliff_avoidance();
     
     
   }
}
