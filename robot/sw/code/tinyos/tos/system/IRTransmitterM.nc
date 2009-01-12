/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 * IR Transmitter from Panasonic LN51L
 * 
 * @author Anitha Vijayakumar avijayak@ee.ucla.edu
 **/

//The IR Transmitter uses the PWM2 which is the AC- pin on Rev A ragobot.
//THe PWM mode is FAST PWM with top = ICRN
//It uses the timer3 for PWM output.

//OCR3A registers
//OCR1A is used by Servo.
//Panasonic IR Transmitter needs to have a duty cycle of 600/1600 = 37.5%
//So IR Transmitter is off for 2/3rds the time and on 1/3 the time.

//AC- is hooked on to PE3/OC3A

module IRTransmitterM{
  provides{
    interface IRTransmitter;
  }
  uses{
     interface Leds;
  }
}

implementation{

enum state {
	OFF=0,
	ENABLE,
	DISABLE };

  int state;

  command result_t IRTransmitter.init(){

    unsigned char sreg;

    atomic state = DISABLE;

	//outp(0xF1,TCCR3A);
	//outp(0x40,TCCR3B);

	//TCNT3H = 0x00;
	//TCNT3L = 0x00;
   
    //Save the global interrupt flag
    //sreg = SREG;

    //Disable all the interrupts
    //cli();

    //OCR3AH = 0x00;
    //OCR3AL = PERIOD_REST;


    //SREG=sreg;
	
    //Confirgure OC1B as output
    //sbi(PORTB,0x06);

	
    return SUCCESS;
  }
   
  /**
   * Switch the IR Transmitter on.
   *
   * @return SUCCESS if Transmitter is on , FAIL otherwise.
   **/
  command result_t IRTransmitter.IROn(){
	
	call Leds.greenOn();

	TCNT1H = 0x00;
	TCNT1L = 0x00;

	//This gives a 40KHz wave with 50% duty cycle.
	outp(0xA2,TCCR3A);
	outp(0x59,TCCR3B);

	ICR3 = 0x0B8;

	OCR3A =0x5C;

    	sbi(DDRE,0x03);

     atomic state = ENABLE;

      return SUCCESS;
  }

  /**
   * Switch the IR Transmitter off.
   *
   * @return SUCCESS if Transmitter is off , FAIL otherwise.
   **/
  command result_t IRTransmitter.IROff(){
      
      atomic state = OFF;

      cbi(DDRE,0x03);
      return SUCCESS;
  }

  task void handle_interrupt() {
      call Leds.redToggle();

   }

  TOSH_SIGNAL(SIG_OUTPUT_COMPARE3A){


     if(state == ENABLE)
     {
 	atomic state = DISABLE;
	OCR1AL = PERIOD_REST;
     }
     else if (state == DISABLE)
     {
        atomic state = ENABLE;
	OCR1AL = PERIOD_ACTIVE;
     }
     else if(state == OFF)
     {
        OCR1AL = PERIOD_REST;
     }
    post handle_interrupt();

  }

}


