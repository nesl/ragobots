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
includes Localization;

module TestOrientationM {
  provides interface StdControl;
  
  uses{
    interface Leds;
    interface Timer;
    interface Orient;
    interface MotionControl;
  }
}

implementation {

  uint8_t orientDone = 1;
  uint16_t goalOrientation; 
  /**
   * Initializes all hardware and s/w components.
   *
   * @return Returns <code>SUCCESS</code> if hardware and s/w components 
   * are initialized, <code>FAIL</code> otherwise. 
   */
  command result_t StdControl.init(){
    call Leds.init();
    call MotionControl.init();
    goalOrientation = 0;
    orientDone = 1;
    //    call MotionControl.init();
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
    call Timer.start(TIMER_REPEAT, 20000);
    
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
    if(orientDone == 1){
      goalOrientation += 90;
      if(goalOrientation > 360){
	goalOrientation = 90;
      }
      call Orient.orient(goalOrientation);
      orientDone = 0;
    } 
    return SUCCESS;
  }

  event result_t Orient.oriented(uint16_t dir){
    call Leds.redToggle();
    orientDone = 1;
    return SUCCESS;
  }

  event result_t MotionControl.moveDone(){
    return SUCCESS;
  }

  event result_t MotionControl.turnDone(){
    return SUCCESS;
  }

  event result_t MotionControl.abortDone()
  {
    return SUCCESS;
  }
}

