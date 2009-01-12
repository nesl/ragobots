// $Id: 

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

/* 
 * @author Parixit Aghera
 */

includes M1_RFIDControllerM;

module TestMotionRFIDM {
  provides {
    interface StdControl;
  }
  uses {
    interface MotionControl;
    interface RFIDController;
    interface Timer;
    interface Leds; 
  }
}
implementation {
#define BUFSIZE 8
  enum {
    SEARCHING_TAG,
    TAG_FOUND,
    TAG_READ
  };

  uint8_t state;
  uint8_t readbuf[BUFSIZE];

  task void move(){
    call MotionControl.move(80);
    return;
  }
  task void abortMove(){
    call MotionControl.abortMove();
    return;
  }
  command result_t StdControl.init() {
    state = SEARCHING_TAG;
    call MotionControl.init();
    return SUCCESS;
  }

  command result_t StdControl.start() {
    state = TAG_READ;
    call  Leds.init();
    call Timer.start(TIMER_REPEAT, 400);
    call Leds.redToggle();
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    call Timer.stop();
    return SUCCESS;
   }

  event result_t Timer.fired() {
    switch(state){
    case SEARCHING_TAG:
      call RFIDController.findTags(1);
      break;

    case TAG_READ:
      post move();
      state = SEARCHING_TAG;
      break;
    }
    return SUCCESS;
  }

  event result_t RFIDController.findTagsDone(uint8_t numTagsFound) {
    if (numTagsFound > 0) {
      state = TAG_FOUND;
      call Leds.yellowToggle();
      post abortMove(); 
    }
    else {
      call Leds.redToggle();
    }
    return SUCCESS;
  }
  
 event result_t RFIDController.readTagDone(uint8_t numBytesRead) {
   if (numBytesRead > 0) {
     call Leds.redToggle();
     state = TAG_READ;
   }
   else {
     call Leds.greenToggle();
   }
   return SUCCESS;
 }

 event result_t RFIDController.writeTagDone(bool isWriteSuccess) {
   return SUCCESS;
 }

 event result_t MotionControl.turnDone(){
   return SUCCESS;
 }
 
 event result_t MotionControl.moveDone(){
   post move();
   return SUCCESS;
 }
 
 event result_t MotionControl.abortDone()
  {
    call RFIDController.readTag(0, readbuf, 8);
    return SUCCESS;
  }

}

