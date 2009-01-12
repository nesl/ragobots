//$id: $
//$log: $

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
includes Localization;

module OrientM
{
  provides interface Orient;

  uses {
    interface MotionControl;
    interface Timer;
    interface Leds;
    interface Localization;
  }
}

implementation 
{

  #define WAIT_PERIOD 2000 //Wait period is time it will wait before checking out the orientation.
  #define ALLOWED_VARIATION 5 // in degree.
  uint16_t goalOrientation;
  enum {
    IDLE,
    ORIENT
  };
  uint8_t state = 0;

  int16_t calculateTurnAngle(int16_t current, int16_t goal){ // co -> current orientation, g -> goal orientation
    int16_t diff1, diff2;
    diff1 =  goal - current;
    if(diff1 > 0)
      diff2 = goal - 360 - current;
    else
      diff2 = 360 - current + goal;
    
    if(abs(diff1) > abs(diff2))
      return diff2;
    else
      return diff1;
  }

  command result_t Orient.orient(uint16_t dir){
    // Function changed by Advait
    if(state == ORIENT)
      return FAIL;

    state = ORIENT;
    goalOrientation = dir;
    call Localization.getLocation();
    return SUCCESS;
  }

  command void Orient.abort(){
    state = IDLE;
    call Timer.stop();

    return;
  }

  event result_t Timer.fired() {
    call Localization.getLocation();

    return SUCCESS;
  }

  event void MotionControl.turnDone() {
    call Timer.start(TIMER_ONE_SHOT, 1000);

    return;
  }

  event void MotionControl.moveDone() {
    return;
  }

  event void Localization.location(LocalizationInfo *local){
    int16_t turnAngle;

    if(state == ORIENT){
      turnAngle = calculateTurnAngle(local->o, goalOrientation);

      if(abs(turnAngle) > ALLOWED_VARIATION) {
	if(call MotionControl.turnRobot(turnAngle) == FAIL)
	  signal Orient.orientFailed(local->o);
      }
      else {
	state = IDLE;
	signal Orient.oriented(local->o);
      }
    }

    return;
  }
}
