// $Id: 
// $Log:

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
  * Implementation of  TestMotionControl Application.
  *
  * @author Parixit Aghera (parixit@ee.ucla.edu)
  **/ 

module TestMotionControlM {
  provides interface StdControl;

  uses{
    interface MotionControl;
    interface Leds;
    interface Timer;
  }
}

implementation {
  int16_t turnAngle;

  /**
   * Initializes all hardware and s/w components.
   *
   * @return Returns <code>SUCCESS</code> if hardware and s/w components 
   * are initialized, <code>FAIL</code> otherwise. 
   */
  command result_t  StdControl.init(){
    call Leds.init();
    call MotionControl.init();
    turnAngle = 0;
    return SUCCESS;
  }

  /**
   * Starts exploration.
   *
   * @return Returns <code>SUCCESS</code> if exploration starts without any problem,
   *  <code>FAIL</code> otherwise. 
   */
  command result_t StdControl.start(){
    call Leds.redOff();
    call Leds.greenOff();
    call Leds.yellowOff();
    call Timer.start(TIMER_REPEAT, 5000);
    return SUCCESS;
  }

  /**
   * Stops Exploration.
   *
   * @return Returns <code>SUCCESS</code> if exploration starts without any problem,
   *  <code>FAIL</code> otherwise. 
   */
  command result_t StdControl.stop(){
    return SUCCESS;
  }

  event result_t Timer.fired(){
    turnAngle = turnAngle + 30;
    if(turnAngle > 180){
      turnAngle = 30;
    }
    //    turnAngle = 90;
    call Leds.redToggle();
    call MotionControl.turnRobot(turnAngle);
    return SUCCESS;
  }

  event result_t MotionControl.turnDone(){
    return SUCCESS;
  }

  event result_t MotionControl.moveDone(){
    return SUCCESS;
  }

  event result_t MotionControl.abortDone()
  {
    return SUCCESS;
  }

}

