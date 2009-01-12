// $Id: TreasureHuntM.nc,v 1.2 2004/10/14 04:04:35 parixit Exp $ 
// $Log: TreasureHuntM.nc,v $
// Revision 1.2  2004/10/14 04:04:35  parixit
// Updated for CENS Demo. Still not functional.
//

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
 * This program performs treasure hunt. It requires the path to be explored.
 * Once the path has been specified by the player, ragobot starts exploring the
 * terrain by 
 * @author Parixit Aghera
 **/

module TreasureHuntM {
  provides{
    interface StdControl;
  }
  uses {
    interface Navigation;
    interface Timer as RFIDTimer;
    interface CB2Bus as CB2;
    interface RFIDController;
    interface ReceiveMsg as CmdReceiveMsg;
    interface SendMsg as HintTreasureSendMsg;
  }
}

implementation {
  #define TOS_BASE_NODE_ADDR 1

  /**************** Data Types and Variables ******************/
  typedef enum {
    IDLE,
    NAVIGATION,
    TAG_DETECTED,
    TAG_READ,
    TAG_PROCESSED
  }THState;

  enum{
    ABORT_MSG=0,
      NAV_MSG=1
   };

/*   typedef enum{ */
/*     TREASURE_TAG=0x01, */
/*       HINT_TAG=0x02 */
/*    }; */

  THState state = IDLE;
  
  int16_t x,y;

  #define MAX_TAG_BUF 8
  uint8_t tagBuf[MAX_TAG_BUF];

  TOS_Msg tagMsg;

  /****************  Tasks  ******************/

  task void  navigate(){
    if(state == NAVIGATION){
      call Navigation.abort();
      call Navigation.moveTo(x,y);
    }else if(state == IDLE || state == TAG_PROCESSED){
      state = NAVIGATION;
      call Navigation.moveTo(x,y);
    }
    return;
  }

  task void handleTagDetected(){
    if(call RFIDController.readTag(0, tagBuf, MAX_TAG_BUF) == SUCCESS){
      call CB2.barPercent(3);
    }else {
      post handleTagDetected();
    }
    return;
  }

  //Reads the content of a RFID tag and sends that information to player.

  task void processTag(){
    uint16_t src = TOS_LOCAL_ADDRESS;
    memcpy((void *) tagMsg.data, (void *)&src, 2);
    memcpy((&tagMsg.data[2]), tagBuf, MAX_TAG_BUF);
    call CB2.barPercent(6);
    call HintTreasureSendMsg.send(TOS_BASE_NODE_ADDR, MAX_TAG_BUF + 2 , &tagMsg);
    return;
  }

  task void retransmit(){
    call HintTreasureSendMsg.send(TOS_BASE_NODE_ADDR, MAX_TAG_BUF + 2 , &tagMsg);
    return;
  }

  /**************** Standard Control ******************/
  command result_t StdControl.init(){
    call Navigation.init();
    call CB2.init();
    call RFIDController.init();
    return SUCCESS;
  }

  command result_t StdControl.start(){
    call RFIDTimer.start(TIMER_REPEAT, 3000);
    call CB2.barPercent(1);
    return SUCCESS;
  }

  command result_t StdControl.stop(){
    return SUCCESS;
  }

  event result_t RFIDTimer.fired(){
    //This should be done only if its in navigation mode
    if(state == IDLE || state == NAVIGATION){
      call CB2.barPercent(2);
      call RFIDController.findTags(1);
    }
    return SUCCESS;
  }

  /*************** Navigation ***********************/

  event void Navigation.moveDone(uint16_t lx, uint16_t ly){
      return;
  }


  /************* Message Handling ****************/
  event TOS_MsgPtr CmdReceiveMsg.receive(TOS_MsgPtr m) {
    uint8_t *ptr;
    if(state == IDLE || state == NAVIGATION){
      if(m->data[0] == ABORT_MSG){
	if(state == NAVIGATION){
	  call Navigation.abort();
	}
      }else if (m->data[0] == NAV_MSG){
	ptr = (uint8_t *) &x;
	(*ptr) = m->data[1];
	(*ptr) = m->data[2];
	ptr = (uint8_t *) &y;
	(*ptr) = m->data[3];
	(*ptr) = m->data[4];
	//post navigate();
      }
    }
    return m;
  }

  event result_t HintTreasureSendMsg.sendDone(TOS_MsgPtr m, result_t sendResult){
    if(sendResult == FAIL){
      //We need to retransmit
      call CB2.barPercent(7);
      post retransmit();
    }else{
      call CB2.barPercent(8);
      state = TAG_PROCESSED;
      post navigate();
    }
    return SUCCESS;
  }

  /*************** RFID Controller *****************/
  event result_t RFIDController.findTagsDone(uint8_t numTagsFound) {
    //TODO: This should be processed only if its in Navigation mode
    if (numTagsFound > 0) {
      if(state == NAVIGATION){
	call Navigation.abort();
      }
      state = TAG_DETECTED;
      post handleTagDetected();
    }
    return SUCCESS;
  }
  
 event result_t RFIDController.readTagDone(uint8_t numBytesRead) {
   if (numBytesRead > 0) {
     call CB2.barPercent(4);
     state = TAG_READ;
     post processTag();
   }
   call CB2.barPercent(5);
   return SUCCESS;
 }

 event result_t RFIDController.writeTagDone(bool isWriteSuccess) {
   return SUCCESS;
 }

}
