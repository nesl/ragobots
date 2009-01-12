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

module VerifyDualMotorControllerM {
	provides{
		interface StdControl;
	}
	uses{
		interface DualMotorControl;
		interface Timer;
		interface Leds;
	}
}

implementation {


	MotorParams params;

	command result_t StdControl.init(){
		call Leds.init();
		call DualMotorControl.init();
		atomic{
			params.motorID = 0;
			params.dir = FORWARD;
			params.speed = 127;
	//		
		}
		  //call DualMotorControl.changeMotorParams(&params);
		dbg(DBG_USR1, "VerifyDualMotorController Initialization complete\n");
		call Leds.redToggle();
		call Leds.greenToggle();
		call Leds.yellowToggle();
		return SUCCESS;
	}


	command result_t StdControl.start(){
		return call Timer.start(TIMER_REPEAT, 10000);
	}

	command result_t StdControl.stop(){
		return call Timer.stop();
	}

	event result_t Timer.fired(){
		call Leds.redToggle();
		dbg(DBG_USR1, "Timer Fired\n");
		  /*		atomic{
			if(params.speed < 121){
				params.speed = params.speed + 5;
				params.dir = FORWARD;
			}else {
				params.speed = 50;
//				params.dir = BACKWARD;
			}
			}*/
			params.motorID = 0;
			call DualMotorControl.changeMotorParams(&params);
		return SUCCESS;
	}

	async event result_t DualMotorControl.motorParamsChanged(MotorParams *changed_params){
		call Leds.greenToggle();
		dbg(DBG_USR1, "DMC signal received\n");
		atomic{
			if(params.motorID != 1){
				params.motorID = 1;
				call DualMotorControl.changeMotorParams(&params);
			}
		}
		return SUCCESS;
	}
}
