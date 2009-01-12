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
  * @author avijayak@ee.ucla.edu
  **/


module TestIRTransmitterM {
	provides{
		interface StdControl;
	}
	uses{
		interface StdControl as RFControl;
		interface IRTransmitter; 
		interface Timer;
		interface Leds;
		interface SendMsg;
		interface ReceiveMsg;
	}
}

implementation {
	command result_t StdControl.init(){
      call Leds.init();
      call RFControl.init();
      call IRTransmitter.init();
	
	  return SUCCESS;
        }

	command result_t StdControl.start(){
	    call RFControl.start();
		call Timer.start(TIMER_ONE_SHOT,1000);
		return SUCCESS;
	}

	command result_t StdControl.stop(){
  	        call RFControl.stop();
		call IRTransmitter.IROff();
		return call Timer.stop();
	}

	event result_t Timer.fired(){
		call Leds.redToggle();
		call IRTransmitter.IROn();

  	  return SUCCESS;
	}

	event TOS_MsgPtr ReceiveMsg.receive(TOS_MsgPtr m) {

		return m;
	}

	event result_t SendMsg.sendDone(TOS_MsgPtr ptr,result_t success) {
		return SUCCESS;
	}


}
