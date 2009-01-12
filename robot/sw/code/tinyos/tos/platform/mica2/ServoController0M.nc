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
  * @author parixit@ee.ucla.edu
  **/

module ServoController0M {
	provides {
		interface ServoController;
	}
}

implementation{

	//Covert position of servo to a value of OCR registar.
	uint8_t calculateOCRVal(int8_t position){
		uint8_t OCRVal;
		uint16_t pulseWidth;
		pulseWidth = NEUTRAL_PULSE_WIDTH + position * PULSE_SENSITIVITY;
		OCRVal = (uint8_t) (pulseWidth/2 * CNT_RANGE)/COUNTER_PERIOD;
		return OCRVal;
	}

	command result_t ServoController.init(){
		//Set the TCCR0 for Phase Control
		outp(0x66, TCCR0);

	  	//Intitialize the OCR0 Registar.
	  	outp(calculateOCRVal(0),OCR0);

		//Configure OC0 to Output.
	  	sbi(DDRB,0x04);

	  	return SUCCESS;
	}

	command result_t ServoController.setPosition(uint8_t motor_id, int8_t position){

		//Check whether the rotation is withing the range.
		if((position > MAX_TURN) || (position < (-MAX_TURN))){
			return FAIL;
		}
		if(motor_id == 0){
			outp(calculateOCRVal(position),OCR0);
		}else{
			return FAIL;
		}
		return SUCCESS;
	}

}
