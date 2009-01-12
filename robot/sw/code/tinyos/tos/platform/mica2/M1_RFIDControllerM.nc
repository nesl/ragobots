// $Id: M1_RFIDControllerM.nc,v 1.5 2004/10/23 22:17:58 parixit Exp $
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
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 * @author David Lee
 */



module M1_RFIDControllerM {
  provides {
    interface RFIDController;
  }
  uses {
    interface Leds;
    interface HPLUART as UART;
    interface Timer;
  }
}

implementation {
#include "M1_RFIDControllerM.h"
#define MAXNUMTAGS  	   5
#define MAXIDLENGTH        9
#define RECEIVEBUFFERSIZE  64
#define SENDPACKETSIZE     64
#define TIMEOUT            12   

/* RFID State definitions */
  enum { IDLE,
	 FINDTAGS,	
	 FINDTAGSSINGLE,
	 READTAGS,
	 WRITETAGS,
	 WAITIDLE,           /*IDLE state but the next command cannot be sent until the RFID timeout expires*/
	 WAITFINDTAGS,       /*FINDTAGS state but the next command cannot be sent until the RFID timeout expires*/
	 WAITFINDTAGSSINGLE, /*FINDTAGSSINGLE state but the next command cannot be sent until the RFID timeout expires*/
	 WAITREADTAGS,       /*READTAGS state but the next command cannot be sent until the RFID timeout expires*/
	 WAITWRITETAGS           /*WRITETAGS state but the next command cannot be sent until the RFID timeout expires*/
  };

  norace uint8_t packet[SENDPACKETSIZE]; 
  norace int8_t writeIndex;
  norace uint8_t receiveBuffer[RECEIVEBUFFERSIZE];
  norace uint8_t rfidState; 			/* Maintains the state of the RFID Reader */ 
  norace uint8_t readIndex;
  norace uint8_t IDtable[MAXNUMTAGS][MAXIDLENGTH]; 
  norace uint8_t idIndex;
  norace uint8_t *dbufptr;
  norace int dlength;
  norace bool isReadyForNewMsg;

  /**
   * Parse the response from the receive buffer on the serial port. 
   * 
   */
  task void parseResponse() {
    switch (receiveBuffer[1]) {
    case SEL_TAG_PASS: 
      memcpy(IDtable[idIndex], (receiveBuffer+2), 9);
      idIndex += 1;
      if (rfidState == FINDTAGSSINGLE) { 
	rfidState = WAITIDLE;
	call Timer.start(TIMER_ONE_SHOT, TIMEOUT);
	signal RFIDController.findTagsDone(1);
      }
      break;
      
    case SEL_TAG_FAIL:
      rfidState = WAITIDLE;
      call Timer.start(TIMER_ONE_SHOT, TIMEOUT);
      signal RFIDController.findTagsDone(idIndex);
      break;
      
    case READ_TAG_PASS:
      rfidState = WAITIDLE;
      call Timer.start(TIMER_ONE_SHOT, TIMEOUT);
      /* copy (msglen - 3) bytes of data from receive buffer to the 
	 data buffer from the beginning of the RESP_DATA field to the
	 end of it */
      if ((receiveBuffer[0]-3) < dlength) {
	memcpy(dbufptr, (receiveBuffer+2), receiveBuffer[0]-3);
	signal RFIDController.readTagDone(receiveBuffer[0]-3);  
	}
      else {
	memcpy(dbufptr, (receiveBuffer+2), dlength);
	signal RFIDController.readTagDone(dlength);
      }
      break;
      
    case READ_TAG_FAIL:
      rfidState = WAITIDLE;
      call Timer.start(TIMER_ONE_SHOT, TIMEOUT);
      signal RFIDController.readTagDone(0);
      break; 
      
    case WRITE_TAG_PASS:
      rfidState = WAITIDLE;
      call Timer.start(TIMER_ONE_SHOT, TIMEOUT);
      signal RFIDController.writeTagDone(TRUE);
      break;

    case WRITE_TAG_FAIL:
      rfidState = WAITIDLE;
      call Timer.start(TIMER_ONE_SHOT, TIMEOUT);
      signal RFIDController.writeTagDone(FALSE);
      break;
      
    default:
      if (rfidState == FINDTAGS) {
	rfidState = WAITIDLE;
	call Timer.start(TIMER_ONE_SHOT, TIMEOUT);
	signal RFIDController.findTagsDone(0);
      }
      else if (rfidState == READTAGS) {
	rfidState = WAITIDLE;
	call Timer.start(TIMER_ONE_SHOT, TIMEOUT);
	signal RFIDController.readTagDone(0);
      }
      else if (rfidState == WRITETAGS) {
	rfidState = WAITIDLE;
	call Timer.start(TIMER_ONE_SHOT, TIMEOUT);
	signal RFIDController.writeTagDone(FALSE);
      }
      else {
	rfidState = WAITIDLE;
	call Timer.start(TIMER_ONE_SHOT, TIMEOUT);
      }
      break;	 
    }
  }
  
  void crc_16 (int length) {
    int8_t i;
    int8_t j;
    uint16_t crc16 = 0x0000;			/* PRESET value */
    uint16_t temp;
    
    for (i = 0; i < length; i+=1) {	/* check each byte in the array */
      crc16 ^= packet[i];
      for (j = 0; j < 8; j+=1) {		/* test each bit in the bytes */
	if (crc16 & 0x0001) {
	  crc16 = crc16 >> 1;
	  crc16 ^= 0x8408; 			/* POLYNOMIAL x^16 + X^12 + x^5 + 1 */  
	}
	else { 
	  crc16 = crc16 >> 1;
	}
      }
    }	            
    temp = crc16 << 8;
    temp = temp | (crc16 >> 8);
    *((uint16_t *)(packet+length)) = temp;
  }

  /** 
   * When the Timer fires, the RFID is ready to accept new commands if there is already a command waiting
   * send the command. Otherwise, return to IDLE to state until a command is received from the user
   *
   */
  event result_t Timer.fired() {
    if (rfidState == WAITIDLE) {
      rfidState = IDLE;
    }
    else if (rfidState == WAITFINDTAGS) {
      rfidState = FINDTAGS;
      call UART.put(STX);
    }
    else if (rfidState == WAITFINDTAGSSINGLE) {
      rfidState = FINDTAGSSINGLE;
      call UART.put(STX);
    }
    else if (rfidState == WAITREADTAGS) {
      rfidState = READTAGS;
      call UART.put(STX);
    }
    else if (rfidState == WAITWRITETAGS) {
      rfidState = WRITETAGS;
      call UART.put(STX);
    }
    return SUCCESS;
  }

  async event result_t UART.get(uint8_t data) {
    atomic {
      if (isReadyForNewMsg && data == STX) { 
	readIndex = 0;
	isReadyForNewMsg = FALSE;
      }
      else if (readIndex < RECEIVEBUFFERSIZE) {
	receiveBuffer[readIndex] = data;
	readIndex += 1;
	/* if readIndex == msg length of packet, then parse response packet */
	if (readIndex >= (receiveBuffer[0]+1)) {
	  isReadyForNewMsg = TRUE;
	  post parseResponse();
        }
      }
    }
    return SUCCESS;
  }

  async event result_t UART.putDone() {
    atomic {
      if (writeIndex < (packet[0] + 1)) {
	call UART.put(packet[writeIndex]); 
	writeIndex = writeIndex + 1;  
        }
      }
    return SUCCESS;
  } 

  /**
   * Initialize the RFID reader.
   *
   * @return SUCCESS/FAIL.
   */
  command result_t RFIDController.init() {
    writeIndex = 0;
    readIndex = 0;
    idIndex = 0;
    rfidState = IDLE;   
    isReadyForNewMsg = TRUE;
    call UART.init();
    return SUCCESS;
  }

  /**
   * Tries to read a numTags number of tags. It returns 
   * FAIL if the numTags exceeds the maximum number of 
   * readable tags, or the reader is busy handling a 
   * a previous request. Otherwise, it returns SUCCESS.
   * @return SUCCESS/FAIL 
   */
  command result_t RFIDController.findTags(int8_t numTags) {
    
    if ((rfidState != IDLE && rfidState != WAITIDLE) || numTags > MAXNUMTAGS) {
      return FAIL;
    }

    if (rfidState == IDLE) {
      if (numTags == 1) {
	rfidState = FINDTAGSSINGLE;
	packet[1] = SEL_TAG;
      }
      else {
	rfidState = FINDTAGS;
	packet[1] = SEL_TAG_INV;
      }
    }
    else {
      if (numTags == 1) {
	rfidState = WAITFINDTAGSSINGLE;
	packet[1] = SEL_TAG;
      }
      else {
	rfidState = WAITFINDTAGS;
	packet[1] = SEL_TAG_INV;
      }
    }
    packet[0] = 0x05;
    packet[2] = SELECT_TAG;
    packet[3] = AUTO_DETECT;
    idIndex = 0;
    writeIndex = 0;
    crc_16(4);
    if (rfidState == FINDTAGS || rfidState == FINDTAGSSINGLE) { 
      call UART.put(STX);
    }
    return SUCCESS;
  }

  /**
   * Triggered by RFID reader when the tag ids are reader to be
   * read.
   * @param uint8_t numTagsFound tells how many tags were read
   * @param uint8_t** gives a table of the tag IDs read
   */
  default event result_t RFIDController.findTagsDone(uint8_t numTagsFound) {
    return SUCCESS;
  }

   /**
   * Returns the ID held in the array at idnum. The number of
   * available IDs are returned in the findTagsDone function.
   * Returns NULL if the idnum is a bad index. Returns a byte
   * array of the tag id if idnum is valid. 
   * @param uint8_t idnum is the index of the tag
   * @return a byte array of the tag id
   */
  command uint8_t* RFIDController.getIDs(uint8_t idnum) {
    if (idnum < MAXNUMTAGS) {
      return IDtable[idnum];
    }
    else {
      return NULL;
    }
  }
  
  /**
   * Tries to read the data stored on the tag with an id
   * from IDtable[idnum]. It returns FAIL if the reader is busy handling a 
   * a previous request. Otherwise, it returns SUCCESS.
   * @return SUCCESS/FAIL 
   */
 command result_t RFIDController.readTag(uint8_t idnum, void* bufptr, int length) {\
   uint8_t numblocks;    
 
   if (rfidState == IDLE) {
     rfidState = READTAGS;
   }
   else if (rfidState == WAITIDLE) {
     rfidState = WAITREADTAGS;
   }
   else {
     return FAIL;
   }

   if ((length % 4) != 0) {
     numblocks = length / 4 + 1;
   }
   else {
     numblocks = length / 4;
   }
   
   packet[0] = 0x0F;
   packet[1] = RW_TAG_TID;
   packet[2] = READ_TAG;
   memcpy (packet+3, IDtable[idnum], 9);
   packet[12] = 0x00;
   packet[13] = numblocks;
   idIndex = 0;
   writeIndex = 0;
   crc_16(14);
   dbufptr = (uint8_t*) bufptr;
   dlength = length;
   if (rfidState == READTAGS) {
     call UART.put(STX);
   }
 
   return SUCCESS; 
 }

  /**
   * Triggered by RFID reader when the tag data is read.
   * @param uint8_t numBytesRead is the number of bytes read
   */
 default event result_t RFIDController.readTagDone(uint8_t numBytesRead) {
   return SUCCESS;
 }

 /**
   * Tries to write the data stored to the tag with an id
   * from IDtable[idnum]. It returns FAIL if the reader is busy handling a 
   * a previous request. Otherwise, it returns SUCCESS.
   * @param uint8_t* ID is the pointer to ID byte array
   * @param void* bufptr is the pointer to the data being written
   * @param int length is the number of bytes to be written from the tag
   * @return SUCCESS/FAIL 
   */
 command result_t RFIDController.writeTag(uint8_t idnum, void* bufptr, int length) {
   uint8_t numblocks; 

   if (rfidState == IDLE) {
     rfidState = WRITETAGS;
   }
   else if (rfidState == WAITIDLE) {
     rfidState = WAITWRITETAGS;
   }
   else if (length > (SENDPACKETSIZE-16)) {
     return FAIL;
   }
   else {
     return FAIL;
   }

   if ((length % 4) != 0) {
     numblocks = length / 4 + 1;
   }
   else {
     numblocks = length / 4;
   }
   packet[0] = 0x0F + (uint8_t)length;
   packet[1] = RW_TAG_TID;
   packet[2] = WRITE_TAG;
   memcpy (packet+3, IDtable[idnum], 9);
   packet[12] = 0x00;
   packet[13] = numblocks;
   memcpy (packet+14, (uint8_t*) bufptr, length); 
   idIndex = 0;
   writeIndex = 0;
   crc_16(0x0E + (numblocks*4));
   if (rfidState == WRITETAGS) {
     call UART.put(STX);
   }
   return SUCCESS; 
 }

  /**
   * Triggered by RFID reader when the tag data is written.
   * @param uint8_t numBytesRead is the number of bytes written
   */
 default event result_t RFIDController.writeTagDone(bool isWriteSuccess) {
   return SUCCESS;
 }
}
