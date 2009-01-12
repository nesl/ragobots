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
  * @author advait@cs.ucla.edu
  **/

module TestPanTiltM {
	provides{
		interface StdControl;
	}
	uses{
		interface PanTiltController as PTC;
		interface Timer;
		interface Leds;
		interface StdControl as RFControl;
		interface ReceiveMsg as RFReceiveMsg;
	}
}

implementation {
	int8_t position;

	command result_t StdControl.init(){
		call Leds.init();
		call PTC.init();
		call RFControl.init();
		position = 0;
		return SUCCESS;
	}

	command result_t StdControl.start(){
		call RFControl.start();
		return call Timer.start(TIMER_REPEAT, 5000);
		//return SUCCESS;
	}

	command result_t StdControl.stop(){
		call RFControl.stop();
		return call Timer.stop();
		//return SUCCESS;
	}

	event result_t Timer.fired(){
		switch(position){
			case 0:
			  call Leds.yellowToggle();
			  position = 90;
			  call PTC.setPanPosition(position, 100);
			  break;
			case 45:
			  position = -45;
			  call PTC.setPanPosition(position, 100);
			  break;
			case 90:
			  call Leds.yellowToggle();
			  position = -90;
			  call PTC.setPanPosition(position, 100);
			  break;
		        case -45:
			  position = -90;
			  call PTC.setPanPosition(position, 100);
			  break;
			case -90:
			  position = 0;
			  call PTC.setPanPosition(position, 100);
			  break;
		}
		return SUCCESS;
	}

	event TOS_MsgPtr RFReceiveMsg.receive(TOS_MsgPtr m) {
		position = (uint8_t)(*(m->data));
		call Leds.yellowToggle();
		call PTC.setPanPosition(position, 10);
		return m;
	}

	event void PTC.panPositionChanged(int8_t currentPanPosition) {
		call Leds.redToggle();
	}

	event void PTC.tiltPositionChanged(int8_t currentTiltPosition) {
		call Leds.redToggle();
	}
}
