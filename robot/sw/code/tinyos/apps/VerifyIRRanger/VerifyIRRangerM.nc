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
 * This application verifies functionality of the IR Ranger device.
 * @author parixit@ee.ucla.edu
 **/

module VerifyIRRangerM{
  provides interface StdControl;
  uses {
	interface IntOutput as LedIntOutput;
	interface IRRanger;
    interface Leds;
    interface Timer;
    interface IntOutput as RfmIntOutput;
  }
}

implementation{

  command result_t StdControl.init() {
	call Leds.init();
	call Leds.greenToggle();
	call IRRanger.init();
    return SUCCESS;
  }

  command result_t StdControl.start() {
    result_t ok1;

	call Timer.start(TIMER_REPEAT, 2000);

    return ok1;
  }

  command result_t StdControl.stop() {
    result_t ok1;
    return ok1;
  }

  async event void IRRanger.distance(uint8_t distance){
	call Leds.redToggle();
	call RfmIntOutput.output(distance);

//	call LedIntOutput.output(distance/10);
	return;
  }

  event result_t Timer.fired(){
	call Leds.yellowToggle();
	call IRRanger.getDistance();
	return SUCCESS;
  }

  event result_t LedIntOutput.outputComplete(result_t success){
	  return success;
  }

  event result_t RfmIntOutput.outputComplete(result_t success){
	  return success;
  }
}
