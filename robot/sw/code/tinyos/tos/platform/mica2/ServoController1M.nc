//$Id: ServoController1M.nc,v 1.5 2004/05/24 08:12:03 parixit Exp $
//$Log: ServoController1M.nc,v $
//Revision 1.5  2004/05/24 08:12:03  parixit
//Cosmetic Changes
//
//Revision 1.4  2004/05/03 04:46:24  parixit
//Increased the Servo resolution to 1 degree. The resolution is more than 1 degree (ie. it can move less than 1 degree).
//
//Revision 1.3  2004/03/15 12:35:53  parixit
//Changed the TIMER1_CNT_RANGER back to 256. Resolution should be increased later on.
//Set the control registers same as the version 1.1
//

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

module ServoController1M {
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

  		//Set timer as ICR1 non-inverted PWM on OC1A and OC1B with TOP=0xFF.
		//		outp(0xA1,TCCR1A);
		outp(0xA0,TCCR1A);
  		//Set prescale select to CK/1 No prescaling.
  		//outp(0x44,TCCR1B);
		outp(0x51,TCCR1B);

		/* Save global interrupt flag */
		sreg = SREG;

		/* Disable interrupts 		*/
		cli();
		/*Set TOP value to 0xFFFF */
		ICR1 = 0xFFFF;

		/* Set OCR1A and OCR1B */
		OCR1A = calculateOCRVal(0);
		OCR1B = calculateOCRVal(0);

		/* Restore global interrupt flag */
		SREG = sreg;

  		//Configure OC1A and OC1B to Output.
  		sbi(DDRB,0x06);
  		sbi(DDRB,0x05);

	  	return SUCCESS;
	}

	command result_t ServoController.setPosition(uint8_t motor_id, int8_t position){

		uint8_t sreg;

		//Check whether the rotation is within the range.
		if((position > MAX_TURN) || (position < (-MAX_TURN))){
			return FAIL;
		}

		/* Save global interrupt flag */
		sreg = SREG;

		/* Disable interrupts */
		cli();

		/* Set OCR1A / OCR1B */
		if(motor_id == 0){
			OCR1A = calculateOCRVal(position);
		}else if(motor_id == 1){
			OCR1B = calculateOCRVal(position);
		}else{
			return FAIL;
		}
		/* Restore global interrupt flag */
		SREG = sreg;

		return SUCCESS;
	}

}

