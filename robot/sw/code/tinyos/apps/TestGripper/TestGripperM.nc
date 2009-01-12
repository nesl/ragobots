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

module TestGripperM {
	provides{
		interface StdControl;
	}
	uses{
		interface GripperController as GC;
		interface Timer;
		interface Leds;
		interface StdControl as RFControl;
		interface ReceiveMsg as RFReceiveMsg;
	}
}

implementation {
	bool grab;

	command result_t StdControl.init(){
		grab = FALSE;
		call Leds.init();
		call RFControl.init();
		return SUCCESS;
	}

	command result_t StdControl.start(){
		call RFControl.start();
		call Leds.redToggle();
		return call Timer.start(TIMER_REPEAT, 5000);
		//return SUCCESS;
	}

	command result_t StdControl.stop(){
		call RFControl.stop();
		return call Timer.stop();
		//return SUCCESS;
	}

	event result_t Timer.fired(){
		if(grab) {
			call GC.releaseObject();
			grab=FALSE;
		}
		else {
			call GC.grabObject();
			grab=TRUE;
		}
		call Leds.greenToggle();
		return SUCCESS;
	}

	event TOS_MsgPtr RFReceiveMsg.receive(TOS_MsgPtr m) {
		uint8_t cmd = (uint8_t)(*(m->data));
		if(cmd==0) {
			call GC.releaseObject();
			grab=FALSE;
		}
		else {
			call GC.grabObject();
			grab=TRUE;
		}
		call Leds.yellowToggle();
		return m;
	}

	async event void GC.objectGrabbed(uint8_t objectType) {
		call Leds.redToggle();
	}
	async event void GC.objectDropped() {
		call Leds.redToggle();
	}
	async event void GC.objectReleased() {
		call Leds.redToggle();
	}

}
