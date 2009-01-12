// $Id: VerifyM1_rfidM.nc,v 1.3 2004/10/14 11:12:15 davidlee Exp $

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
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/* 
 * @author David Lee
 */

includes M1_RFIDControllerM;

module VerifyM1_rfidM {
  provides {
    interface StdControl;
  }
  uses {
    interface RFIDController;
    interface Timer;
    interface Leds; 
  }
}
implementation {
#define BUFSIZE 8
#define STATE_FINDID  0x00
#define STATE_WRITETAG 0x01
#define STATE_READTAG  0x02

  uint8_t writebuf[BUFSIZE];
  uint8_t readbuf[BUFSIZE];
  uint8_t state = STATE_FINDID;
 
  command result_t StdControl.init() {
    call RFIDController.init();
    return SUCCESS;
  }

  command result_t StdControl.start() {
    call Timer.start(TIMER_ONE_SHOT, 500);
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    call Timer.stop();
    return SUCCESS;
   }

  event result_t Timer.fired() {
    writebuf[0] = 0xDE;
    writebuf[1] = 0xAD;
    writebuf[2] = 0xBE;
    writebuf[3] = 0xEF;
    writebuf[4] = 0x60;
    writebuf[5] = 0x0D;
    writebuf[6] = 0xF0;
    writebuf[7] = 0x0D;
    if (state == STATE_FINDID) {
      call RFIDController.findTags(1);
    }
    else if (state == STATE_WRITETAG) {
      call RFIDController.writeTag(0, writebuf, 8);
    }
    else {
      call RFIDController.readTag(0, readbuf, 8);
    }
    return SUCCESS;
  }

  event result_t RFIDController.findTagsDone(uint8_t numTagsFound) {
    if (numTagsFound > 0) {
      state = STATE_READTAG;
      //call Leds.greenToggle();
      if (call RFIDController.writeTag(0, writebuf, 8) == FAIL) {
	call Leds.yellowToggle();
	call Timer.start(TIMER_ONE_SHOT, 500);
      }
    }
    else {
      call Leds.redToggle();
      if (call RFIDController.findTags(1) == FAIL) {
	call Timer.start(TIMER_ONE_SHOT, 500);
	call Leds.yellowToggle();
      }
    }
    return SUCCESS;
  }
  
 event result_t RFIDController.readTagDone(uint8_t numBytesRead) {
   if (numBytesRead > 0) {
     if (memcmp(readbuf, writebuf, 8) == 0) {
       call Leds.greenToggle();
       call Timer.start(TIMER_ONE_SHOT, 500);
     }
   }
   else {
     call Leds.redToggle();
     if (call RFIDController.readTag(0, readbuf, 8) == FAIL) {
       call Leds.yellowToggle();
       call Timer.start(TIMER_ONE_SHOT, 500);
       }
   }
   return SUCCESS;
 }

 event result_t RFIDController.writeTagDone(bool isWriteSuccess) {
   if (isWriteSuccess) {
     state = STATE_READTAG;
     call Leds.greenToggle();
     if (call RFIDController.readTag(0, readbuf, 8) == FAIL) {
       call Leds.yellowToggle();
       call Timer.start(TIMER_ONE_SHOT, 500);
     }
   }
   else {
     call Leds.redToggle();
     if (call RFIDController.writeTag(0, writebuf, 8) == FAIL) {
       call Timer.start(TIMER_ONE_SHOT, 500);
     }
   }
   return SUCCESS;
 }
}

