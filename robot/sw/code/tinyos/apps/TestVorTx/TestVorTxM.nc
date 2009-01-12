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
  * @author avijayak@ee.ucla.edu
  **/

includes TestVorTx;

module TestVorTxM {
	provides{
		interface StdControl;
	}
	uses{
		interface StdControl as RFControl;
 		interface PanTiltController as PTC;
		interface IRTransmitter; 
		interface Timer;
		interface Leds;
		interface SendMsg;
		interface ReceiveMsg;
	}
}

implementation {
#define MY_NODE_ID 1
#define OTHER_NODE_ID 2
#define MY_POS_X 0
#define MY_POS_Y 0

#define SERVER_ID 0
#define BROAD_CAST_ADDR 11
#define VOR_START_NODE 1
#define PAN_POSITION_INIT 90
#define PAN_POSITION_ON -90
#define RETRANS_PERIOD 2000
#define MSG_SIZE 9

	int8_t position;
	uint8_t state;
	struct TOS_Msg msg,retrans_msg;
	VOR_MSG vor;

	command result_t StdControl.init(){
	  call Leds.init();
          call RFControl.init();
	  call PTC.init();
          call IRTransmitter.init();
	
	  atomic state = VOR_IDLE;	
  	  position=PAN_POSITION_INIT;
		
	  vor.from_Id = MY_NODE_ID;
	  vor.to_Id = BROAD_CAST_ADDR;
	  vor.pos_x = MY_POS_X;
	  vor.pos_y = MY_POS_Y;
	  vor.msg_type = VOR_MSG_IDLE;
	  vor.elapsed_time = 0;
	  vor.angle =0;
	  vor.s_x =MY_POS_X;
	  vor.s_y =MY_POS_Y;
	
	  msg.addr=TOS_LOCAL_ADDRESS;
   	  msg.type=0x0a;
	  msg.group=0x7d;
	  msg.length=MSG_SIZE;
          msg.data[0]= vor.from_Id;
          msg.data[1]= vor.to_Id;
          msg.data[2]= vor.pos_x;
          msg.data[3]= vor.pos_y;
	  msg.data[4] = vor.msg_type;
	  msg.data[5] = vor.elapsed_time; 
	  msg.data[6] = vor.angle; 
	  msg.data[7] = vor.s_x; 
	  msg.data[8] = vor.s_y; 

	  return SUCCESS;
        }

	command result_t StdControl.start(){
	        call RFControl.start();
		
		if(MY_NODE_ID == VOR_START_NODE)
		   atomic state = VOR_START;

		call PTC.setPanPosition(PAN_POSITION_INIT,100);
		
		return SUCCESS;
	}

	command result_t StdControl.stop(){
        	call RFControl.stop();
		return call Timer.stop();
	}

	event result_t Timer.fired(){

	  if(state == OTHER_NODE_VOR)
	     return SUCCESS;

          call SendMsg.send(TOS_BCAST_ADDR,MSG_SIZE,&retrans_msg);
	
	  call Timer.start(TIMER_ONE_SHOT,RETRANS_PERIOD);

  	  return SUCCESS;
	}

	task void handle_vor(){
	
  	   switch(state)
	   {
	      case VOR_START:
		    atomic state = VOR_ONGOING;
		    vor.msg_type = VOR_MSG_START;
		    msg.data[4]=vor.msg_type;

       		    call IRTransmitter.IROn();
		    call SendMsg.send(TOS_BCAST_ADDR,MSG_SIZE,&msg);
		    call PTC.setPanPosition(PAN_POSITION_ON,100);
		    call Leds.greenOn();
	      break;
          case VOR_ONGOING:
		    atomic state = VOR_END;
		    vor.msg_type = VOR_MSG_END;
		    //Need to fill in elapsed time
		    msg.data[4] = vor.msg_type;
		    msg.data[5] = vor.elapsed_time;
		    retrans_msg = msg;

	 	    call IRTransmitter.IROff();
		    call SendMsg.send(TOS_BCAST_ADDR,MSG_SIZE,&msg);
		    call Timer.start(TIMER_ONE_SHOT,RETRANS_PERIOD);
		    call Leds.greenOn();
	      break;

	   }
	}

	event TOS_MsgPtr ReceiveMsg.receive(TOS_MsgPtr m) {

		VOR_MSG *pload = (VOR_MSG *)(m->data);

		if(pload->to_Id != MY_NODE_ID)
		{
			if(pload->to_Id != BROAD_CAST_ADDR) //Msg not for me
				return m;
		}
		call Leds.greenToggle();

		if(pload->from_Id == SERVER_ID) {
		   if(pload->msg_type == VOR_MSG_ABORT)  
			atomic state = VOR_ABORT;
		}

		if(pload->from_Id == OTHER_NODE_ID) {

		    switch(state) {
			case VOR_IDLE:
			case OTHER_NODE_VOR:

			  if(pload->msg_type == VOR_MSG_END) {
				atomic state = VOR_START;
				call PTC.setPanPosition(PAN_POSITION_INIT,100);
			 }
			 break;

			case VOR_END:
			  if(pload->msg_type == VOR_MSG_END) {
				atomic state = VOR_START;
				call PTC.setPanPosition(PAN_POSITION_INIT,100);
			   }
			   else{
			      atomic state = OTHER_NODE_VOR;
			}
			break;
		    }
		}

		return m;
	}

	event result_t SendMsg.sendDone(TOS_MsgPtr ptr,result_t success) {
		call Leds.redToggle();
		return SUCCESS;
	}

 	event void PTC.panPositionChanged(int8_t currentPanPosition) {
		post handle_vor();
        }	

	event void PTC.tiltPositionChanged(int8_t currentTiltPosition){
	}

}
