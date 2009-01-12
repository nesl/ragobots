// $Id: ServoController3M.nc,v 1.2 2004/06/14 00:14:19 parixit Exp $

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
  *
  * @author Parixit Aghera parixit@ee.ucla.edu
  **/

module ServoController3M {
	provides {
		interface ServoController;
	}
}

implementation{
	#define TIMER1_CNT_RANGE 65536

	//Covert position of servo to a value of OCR registar.
	uint16_t calculateOCRVal(int8_t position){
		uint16_t OCRVal;
		uint32_t pulseWidth;
		pulseWidth = (uint32_t) (NEUTRAL_PULSE_WIDTH + (int16_t) position * PULSE_SENSITIVITY);
		OCRVal =(uint16_t) (((pulseWidth/2) * TIMER1_CNT_RANGE)/COUNTER_PERIOD);
		return OCRVal;

	}

	command result_t ServoController.init(){
		uint8_t sreg;

  		//Set timer as 8-bit non-inverted PWM on OC3A  OP=0xFF.
  		outp(0x81,TCCR3A);

  		//Set prescale select to CK/256.
  		outp(0x44,TCCR3B);

		/* Save global interrupt flag */
		sreg = SREG;

		/* Disable interrupts 		*/
		cli();

		/* Set OCR3A */
		OCR3A = calculateOCRVal(0);
	    
		/* Restore global interrupt flag */
		SREG = sreg;


  		//Configure OC3A to Output.
  		sbi(DDRE,0x03);
 
	  	return SUCCESS;
	}

	command result_t ServoController.setPosition(uint8_t motor_id, int8_t position){

		uint8_t sreg;

		//Check whether the rotation is withing the range.
		if((position > MAX_TURN) || (position < (-MAX_TURN))){
			return FAIL;
		}

		/* Save global interrupt flag */
		sreg = SREG;

		/* Disable interrupts */
		cli();


		/* Set OC3A */
		if(motor_id == 0){
		  OCR3A = calculateOCRVal(position);
		}else{
			return FAIL;
		}
		/* Restore global interrupt flag */
		SREG = sreg;
		return SUCCESS;
	}

}

