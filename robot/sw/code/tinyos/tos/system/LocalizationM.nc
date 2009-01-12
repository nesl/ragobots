// $Id: LocalizationM.nc,v 1.4 2004/10/12 20:01:29 parixit Exp $
// $Log: LocalizationM.nc,v $
// Revision 1.4  2004/10/12 20:01:29  parixit
// Modified for the iBadge Localization.
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

/**  * Implementats Localization.
 *
 * @author Parixit Aghera (parixit@ee.ucla.edu)
 **/ 

//TODO: improve the time to get the location by invoking the Compass 
//iBadge interface together. Make sure that one doesn't affect the other's operation.

includes Localization;
module LocalizationM{
  provides{
    interface Localization[uint8_t id];
    interface StdControl;
  }
  uses{
    interface Leds;
    interface HPLUART as UART;
    interface StdControl as UARTIntrCtr;
    interface Compass;
  }
}

implementation{
#define MAX_NODES 4
#define FRESHNESS_TIME 
#define MAX_REQS 10 
#define START_BYTE 0xFF

  uint8_t reqs[MAX_REQS] = {0,0,0,0,0,0,0,0,0,0};
  uint8_t reqFlag = 0;
  LocalizationInfo localizationInfo = {0,0,0,0}; 

  typedef enum{
    IDLE,
      SB1, //Start Byte 1 is received
      SB2, //Start Byte 2 is received
      X1,//First byte of X co-ordinate received
      X2,//Second byte of X co-ordinate received
      Y1,//First byte of Y co-ordinate received
      Y2 //Second byte of Y co-ordinate received	
      } IBState;

  IBState ibState;

  task void tellLocation()
    {
      uint8_t i;
      atomic ibState = IDLE;
      for(i = 0; i < MAX_REQS; i++){
	if(reqs[i] != 0){
	  signal Localization.location[i](&localizationInfo);
	  reqs[i] = 0;
	}
      }
      reqFlag = 0;

    }

  command result_t StdControl.init(){
    localizationInfo.id = TOS_LOCAL_ADDRESS;
    call UART.init();
    return SUCCESS;
  }

  command  result_t StdControl.start(){
    return SUCCESS;
  }

  command result_t StdControl.stop(){
    call UART.stop();
    return SUCCESS;
  }

  command  result_t Localization.getLocation[uint8_t id](){
    result_t returnVal;

    if(id < MAX_REQS){
      if(reqFlag == 0){
	call UARTIntrCtr.start();
      }
      reqFlag = 1;
      reqs[id] = 1;
      returnVal = SUCCESS;
    }else {
      returnVal = FAIL;
    }
    return returnVal;
  }

  default event result_t Localization.location[uint8_t id](LocalizationInfo *l){
    return SUCCESS;
  }

  async event result_t UART.putDone(){
    return SUCCESS;
  }

  async event result_t UART.get (uint8_t data){
    uint8_t *bytePtr;
    uint8_t eomFlag = 0; // End of Message Flag
    atomic{
    if(ibState == IDLE || ibState == SB1){
      if(data != START_BYTE){
	ibState = IDLE; //reset since the first or second byte is not as expected
      }else{
	switch(ibState){
	case IDLE:
	  ibState=SB1;
	  break;
	case SB1:
	  ibState=SB2;
	  break;
	default:
	  ibState = IDLE;
	}
      }
    }else{
      switch(ibState){
      case SB2: //Second start byte has been received.
	if(data == START_BYTE){
	  //Reset the state since we missed some data
	  ibState=IDLE;
	}else{
	  bytePtr= (uint8_t *)&localizationInfo.x;
	  (*bytePtr) = data;
	  ibState = X1;
	}
	break;
      case X1:
	if(data == START_BYTE){
	  //Reset the state since we missed some data
	  ibState=IDLE;
	}else{
	  bytePtr= (uint8_t *)&localizationInfo.x;
	  bytePtr++;
	  (*bytePtr) =data;
	  ibState = X2;
	}
	break;
      case X2:
	if(data == START_BYTE){
	  //Reset the state since we missed some data
	  ibState=IDLE;
	}else{
	  bytePtr= (uint8_t *)&localizationInfo.y;
	  (*bytePtr) = data;
	  ibState = Y1;
	}
	break;
      case Y1:
	if(data == START_BYTE){
	  //Reset the state since we missed some data
	  ibState=IDLE;
	}else{
	  bytePtr= (uint8_t *)&localizationInfo.y;
	  bytePtr++;
	  (*bytePtr) = data;
	  ibState = Y2;
	  eomFlag = 1;
	}
	break;
      default:
	ibState = IDLE;

      }
    }
    }
    if(eomFlag == 1){
      call UARTIntrCtr.stop(); //We don't need any more bytes from iBadge
      call Compass.getHeading();
    }

    return SUCCESS;
  }

  async event void Compass.heading(uint16_t dir){
    if(ibState == Y2){
      localizationInfo.o=dir;
      post tellLocation();
    }
    return;
  } 

}
