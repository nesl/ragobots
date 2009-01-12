//$Id:
//$Log:

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

module PanTiltControllerM {
  provides interface PanTiltController;
  uses {
    interface ServoController as PanTiltServos;
    interface Timer as PanLockedTimer;
    interface Timer as TiltLockedTimer;
    interface Timer as PanBusyTimer;
    interface Timer as TiltBusyTimer;
  }
}
implementation {

  // State variables
  bool panIsLocked, tiltIsLocked;
  int8_t currentPanPosition, currentTiltPosition;

  command result_t PanTiltController.init() {
    call PanTiltServos.init();
    panIsLocked = FALSE;
    tiltIsLocked = FALSE;
    currentPanPosition = -1;
    currentTiltPosition = -1;
    return SUCCESS;
  }

  // The current implementation does not take care of concurrency
  command result_t PanTiltController.setPanPosition(int8_t panPosition, uint8_t panLock) {
    // Check if panPosition lies in the [-90,90] interval.
    if( panPosition > 90 || panPosition < -90)
      return FAIL;

    /* Check if the pan servo is busy with previous task. */
    if(panIsLocked)
      return FAIL;
    else
      panIsLocked = TRUE;

    call PanLockedTimer.start(TIMER_ONE_SHOT, panLock);
    call PanBusyTimer.start(TIMER_ONE_SHOT, BUSY_PERIOD);
    call PanTiltServos.setPosition(PAN_SERVO_ID, panPosition);
    
    currentPanPosition = panPosition;
    return SUCCESS;
  }

  event result_t PanLockedTimer.fired() {
    atomic panIsLocked = FALSE;
    return SUCCESS;
  }

  event result_t PanBusyTimer.fired() {
    signal PanTiltController.panPositionChanged(currentPanPosition);
    return SUCCESS;
  }

  // The current implementation does not take care of concurrency
  command result_t PanTiltController.setTiltPosition(int8_t tiltPosition, uint8_t tiltLock) {
    bool proceed = FALSE;

    // Check if tiltPosition lies in the [-90,90] interval.
    if( tiltPosition > 90 || tiltPosition < -90)
      return FAIL;

    /* Check if the tilt servo is busy with previous task. */
    if(tiltIsLocked)
      return FAIL;
    else
      tiltIsLocked = TRUE;

    call TiltLockedTimer.start(TIMER_ONE_SHOT, tiltLock);
    call TiltBusyTimer.start(TIMER_ONE_SHOT, BUSY_PERIOD);
    call PanTiltServos.setPosition(TILT_SERVO_ID, tiltPosition);

    currentTiltPosition = tiltPosition;

    return SUCCESS;
  }

  event result_t TiltLockedTimer.fired() {
    atomic tiltIsLocked = FALSE;
    return SUCCESS;
  }

  event result_t TiltBusyTimer.fired() {
    signal PanTiltController.tiltPositionChanged(currentTiltPosition);
    return SUCCESS;
  }
}
