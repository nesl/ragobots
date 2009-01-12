//$Id: MotionControlM.nc,v 1.11 2004/10/23 22:16:22 parixit Exp $
//$Log: MotionControlM.nc,v $
//Revision 1.11  2004/10/23 22:16:22  parixit
//Cleaned up the state machines and modified the interfaces to avoid un-neccessary return values.
//
//Revision 1.10  2004/10/12 22:02:54  parixit
//Removed abortMoveDone signal.
//

/*                                                                      tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.
 * All rights reserved.
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/* 
 * Implementation of MotionControl Interface
 * 
 * @author Balaji Vasu (vbalaji@cs.ucla.edu)
 * @author Parixit Aghera (parixit@ee.ucla.edu)
 *
 */

module MotionControlM
{
    provides
    {
	interface MotionControl;
    }
    uses
    {
	interface DualMotorControl;
	interface Timer as mfTimer;
	interface Timer as turnTimer;
	interface Leds;
    }
}

implementation
{
  typedef enum {
    ONE_MOTOR_MF_STARTED,
    ONE_MOTOR_TURNING_STARTED,
    BOTH_MOTOR_MF_STARTED,
    BOTH_MOTOR_TURNING_STARTED,
    MOVING_FORWARD,
    TURNING,
    IDLE
  } MotorState;

  // State machine (mState value) while turning:
  // IDLE -> ONE_MOTOR_TURNING_STARTED -> BOTH_MOTOR_TURNING_STARTED -> TURNING -> IDLE
  // Similar state machine for moving forward

  int16_t degreeToMove;
  MotorParams params;
  MotorState mState;  //0 if the robot's turning
  int8_t distanceToMove;

  task void signalMoveDone(){
    signal MotionControl.moveDone();
  }
 
  task void signalTurnDone(){
    signal MotionControl.turnDone();
  }

  command result_t MotionControl.init() {
    atomic {
      mState = IDLE;
    }

    call DualMotorControl.init();
    return SUCCESS;
  }

  command result_t MotionControl.turnRobot(int16_t degree) {
    MotorState localState;
    atomic localState = mState;

    if(localState != IDLE ) {
      return FAIL;
    }

    if(degree == 0){
      post signalTurnDone();
      return SUCCESS;
    }

    degree = -degree; // Clockwise negative and anti-clockwise positive
    //turn the robot the specified angle


    atomic {
      degreeToMove = degree;
      mState = ONE_MOTOR_TURNING_STARTED;
      params.motorID= 0;
      params.speed = 127;
      if(degree >=0)
	params.dir = FORWARD;
      else
	params.dir = BACKWARD;

      call DualMotorControl.changeMotorParams(&params);
    }

    call turnTimer.start(TIMER_REPEAT, abs(degree) * 7);
    //Parixit: The factor of 13 is valid for turn on styrofoam + paper platform. For table top surface use 10.
    return SUCCESS;
  }

  command result_t MotionControl.move(int8_t distance) {
    uint8_t localState;
    atomic localState = mState;

    if(localState != IDLE)
      return FAIL;

    if(distance == 0){
      post signalMoveDone();
      return SUCCESS;
    }

    atomic {
      distanceToMove =distance;

      mState = ONE_MOTOR_MF_STARTED;
      params.motorID = 0;
      params.speed = 127;
      if(distance >= 0)
	params.dir = FORWARD;
      else
	params.dir = BACKWARD;

      call DualMotorControl.changeMotorParams(&params);
    }

    call mfTimer.start(TIMER_REPEAT,abs(distanceToMove) * 70);
    return SUCCESS;
  }

  async event result_t DualMotorControl.motorParamsChanged(MotorParams *changed_params) {
    atomic {
      if(mState == ONE_MOTOR_MF_STARTED) {
	params.motorID = 1;
	params.speed = 127;
	if(distanceToMove >= 0) params.dir = FORWARD;
	else params.dir = BACKWARD;
	call DualMotorControl.changeMotorParams(&params); // this call will result in another motorParamsChanged event.

	mState = BOTH_MOTOR_MF_STARTED;
      }
      else if(mState == ONE_MOTOR_TURNING_STARTED) { // this call will result in another motorParamsChanged event.
	params.motorID = 1;
	params.speed = 127;
	if(degreeToMove >=0) params.dir = BACKWARD;
	else params.dir = FORWARD;
	call DualMotorControl.changeMotorParams(&params); // this call will result in another motorParamsChanged event.

	mState = BOTH_MOTOR_TURNING_STARTED;
      }
      else if(mState == BOTH_MOTOR_MF_STARTED)
	mState = MOVING_FORWARD;
      else if(mState == BOTH_MOTOR_TURNING_STARTED)
	mState = TURNING;
    }

    return SUCCESS;
  }

  command result_t MotionControl.abortMove()
    {
      MotorState lmState;
      atomic lmState = mState;

      if(lmState == IDLE)
	return FAIL;
      else
	atomic mState = IDLE;

      // call Leds.redToggle();
      call mfTimer.stop();
      call turnTimer.stop();
      call DualMotorControl.reset();

      return SUCCESS;
    }

  event result_t turnTimer.fired() {
    MotorState lmState;
    atomic lmState = mState;

    if(lmState != TURNING)
      return FAIL;
    else
      atomic mState = IDLE;

    call turnTimer.stop();

    call DualMotorControl.reset();
    post signalTurnDone();

    return SUCCESS;
  }

  event result_t mfTimer.fired() {
    MotorState lmState;
    atomic lmState = mState;

    if(lmState != MOVING_FORWARD)
      return FAIL;
    else
      atomic mState = IDLE;

    call mfTimer.stop();

    call DualMotorControl.reset();
    post signalMoveDone();

    return SUCCESS;
  }
}
