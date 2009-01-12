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

module VerifyServoM {
	provides{
		interface StdControl;
	}
	uses{
		interface ServoController as ServoController0;
		interface ServoController as ServoController1;
		interface Timer;
		interface Leds;
	}
}

implementation {
	int8_t position;

	command result_t StdControl.init(){
		call Leds.init();
		call ServoController0.init();
		call Leds.redToggle();
		call ServoController1.init();
		call Leds.greenToggle();
		position = -90;
		return SUCCESS;
	}


	command result_t StdControl.start(){
		return call Timer.start(TIMER_REPEAT, 1000);
	}

	command result_t StdControl.stop(){
		return call Timer.stop();
	}
	event result_t Timer.fired(){
	  position++;
	  if(position > 90){
	    position = -90;
	  }
	  call Leds.yellowToggle();
	  call ServoController1.setPosition(0, position);
	  call ServoController1.setPosition(1, position);
	  return SUCCESS;
	}
}
