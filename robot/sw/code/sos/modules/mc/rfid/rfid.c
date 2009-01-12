/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4: */
/*					
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
 * @author David Lee
 */
/**
 * @brief Provides control of a Skyetek M1/M1-mini RFID reader
 *
 */


#include <ragobot_module.h>
#include <modules/rfid.h>
#include "rfid_skyetek_m1.h"
#include <malloc.h>

#define RECEIVEBUFFERSIZE  64
#define MAXSENDPACKETSIZE  64
#define TIMEOUT            20

/* RFID State definitions */
enum { 
  IDLE,
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

/* RFID read state definitions */
enum {
  READSTX,
  READMSGLEN,
  READDATA
};


//-----------------------------------------------------------------------------
// TYPE DEFINITIONS
//-----------------------------------------------------------------------------
typedef struct {
  uint8_t state;   // state of this module
  uint8_t readstate; //state of reading the packet from the reader
  uint8_t pid;    //! RAGOBOT_RFID_PID
  uint8_t callingmodpid; // PID of the module that is calling this module
  idtable_t idtable;
  uint8_t packet [MAXSENDPACKETSIZE];
  uint8_t numfindtags;
  uint8_t* readdata;
  uint8_t readdatalen;
  uint8_t writedatalen;
} rfid_state;

static void crc_16 (uint8_t* packet, int length);
static void parsedata(rfid_state* state); 

//! Macros to assist the Perl Script
DECL_MOD_STATE(rfid_state);
DECL_MOD_ID(RAGOBOT_RFID_PID);

SOS_MODULE
int8_t module(void *state, Message *msg)
{
  rfid_state *s = (rfid_state*) state;
  MsgParam *p = (MsgParam*)(msg->data);
  rfid_data_t *d;

  switch (msg->type) {
	//-------------------------------------------------------------------------
	// KERNEL MESSAGE - INITIALIZE MODULE
	//-------------------------------------------------------------------------
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  s->state = IDLE;
	  return SOS_OK;
	}
  case MSG_RFID_FINDTAGS:
	{
	  if (s->state == WAITIDLE)
		{
		  if (p->byte == 1)
			{
			  s->state = WAITFINDTAGSSINGLE;
			  s->packet[2] = SEL_TAG; //FLAGS = find only 1 tag
			}
		  else
			{
			  s->state = WAITFINDTAGS;
			  s->packet[2] = SEL_TAG_INV; //FLAGS - find more than 1 tag
			}
		}
	  else if (s->state == IDLE)
		{ 
		  if (p->byte == 1)
			{
			  s->state = FINDTAGSSINGLE;
			  s->packet[2] = SEL_TAG; //FLAGS = find only 1 tag
			}
		  else
			{
			  s->state = FINDTAGS;
			   s->packet[2] = SEL_TAG_INV; //FLAGS - find more than 1 tag
			}
		}
	  else 
		{
		  post_short(s->callingmodpid, s->pid, MSG_RFID_FINDTAGS_FAIL, -EBUSY, 0, 0);
		  return -EBUSY;
		}
	  s->callingmodpid = msg->sid;
	  s->packet[0] = STX;
	  s->packet[1] = 0x05; //MSG_LEN = 5
	  
	  s->packet[3] = SELECT_TAG; //COMMAND = SELECT_TAG
	  s->packet[4] = AUTO_DETECT; //TAG_TYPE=AUTODETECT tag type
	  crc_16((s->packet)+1, 4); //calculate crc and place in packet[5] and packet[6]
	  (s->idtable).numids = 0;
	  s->numfindtags = p->byte;
	 
	  if ((s->state == FINDTAGS) || (s->state = FINDTAGSSINGLE))
		{
		  ker_serial_write(s->pid, 1, s->packet, 7, 0);
		  s->readstate = READSTX;
		  ker_serial_read(s->pid, 1, 1);
		}
	  return SOS_OK;
	}
  case MSG_RFID_READTAGS:
	{
	  uint8_t numblocks; 
	  
	  if (s->state == WAITIDLE)
		{
		  s->state = WAITREADTAGS;
		}
	  else if (s->state == IDLE)
		{
		  s->state = READTAGS;
		}
	  else
		{
		  post_short(s->callingmodpid, s->pid, MSG_RFID_READTAGS_FAIL, -EBUSY, 0, 0);
		  return -EBUSY;
		}
	  d = (rfid_data_t*)(msg->data);
	  
	  s->callingmodpid = msg->sid;

	  numblocks = (d->datalen) / 4;
	  if ((d->datalen) % 4 != 0)
		{
		  numblocks = numblocks + 1;
		}
	  s->packet[0] = STX;
	  s->packet[1] = 0x0F;
	  s->packet[2] = RW_TAG_TID;
	  s->packet[3] = READ_TAG;
	  memcpy ((s->packet)+4, d->id, 9);
	  s->packet[13] = 0x00;
	  s->packet[14] = numblocks; 
	  crc_16((s->packet)+1,14);
	  if (s->state == READTAGS)
		{
		  ker_serial_write(s->pid, 1, s->packet, 17, 0);
		  s->readstate = READSTX;
		  ker_serial_read(s->pid, 1, 1);
		}
	  return SOS_OK;
	}
  case MSG_RFID_WRITETAGS:
	{
	  uint8_t numblocks;
	  d = (rfid_data_t*)(msg->data);
	  if (s->state == IDLE)
		{
		  s->state = WRITETAGS;
		}
	  else if (s->state == WAITIDLE)
		{
		  s->state = WAITWRITETAGS;
		}
	  else if (d->datalen > (MAXSENDPACKETSIZE-MAXIDLENGTH-8))
		{
		  post_short(s->callingmodpid, s->pid, MSG_RFID_WRITETAGS_FAIL, -ENOMEM, 0, 0);
		  return -ENOMEM;
		} 
	  else
		{ 
		  post_short(s->callingmodpid, s->pid, MSG_RFID_WRITETAGS_FAIL, -EBUSY, 0, 0);
		  return -EBUSY;
		}
	  s->callingmodpid = msg->sid;
	  numblocks = d->datalen / 4;
	  if ((d->datalen % 4) != 0)
		{
		  numblocks = numblocks + 1;
		}
	  s->packet[0] = STX;
	  s->packet[1] = 0x0F + d->datalen;
	  s->packet[2] = RW_TAG_TID;
	  s->packet[3] = WRITE_TAG;
	  memcpy((s->packet)+4,d->id, MAXIDLENGTH);
	  s->packet[13] = 0x00;
	  s->packet[14] = numblocks;
	  memcpy((s->packet)+15, d->data, d->datalen);
	  crc_16((s->packet)+1, 0x0E + (d->datalen));
	  s->writedatalen = 17 + d->datalen;
	  if (s->state == WRITETAGS)
		{
		  ker_serial_write(s->pid, 1, s->packet, s->writedatalen, 0);
		  s->readstate = READSTX;
		  ker_serial_read(s->pid, 1, 1);
		}
	  return SOS_OK;
	}
  case MSG_TIMER_TIMEOUT:
	{
	  if (s->state == WAITIDLE) 
	 	{
		  s->state = IDLE;
		  return SOS_OK;
		}
	  else if (s->state == WAITFINDTAGS)
		{
		  s->state = FINDTAGS;
		  ker_serial_write(s->pid, 1, s->packet, 7, 0);		  
		}
	  else if (s->state == WAITFINDTAGSSINGLE)
		{
		   s->state = FINDTAGSSINGLE;
		   ker_serial_write(s->pid, 1, s->packet, 7, 0);		   
		}
	  else if (s->state == WAITREADTAGS)
		{
		  s->state = READTAGS;
		  ker_serial_write(s->pid, 1, s->packet, 17, 0);		  
		}
	  else if (s->state == WAITWRITETAGS)
		{
		  s->state = WRITETAGS;
		  ker_serial_write(s->pid, 1, s->packet, s->writedatalen, 0);		  
		}
	  s->readstate = READSTX;
	  ker_serial_read(s->pid, 1, 1);
	  return SOS_OK;
	}
  case MSG_UART1_READ_DONE:
	{
		if (s->readstate == READSTX) 
		  {
			if (*(msg->data) == STX)
			  {	
				s->readstate = READMSGLEN;
			  }
			ker_serial_read(s->pid, 1, 1);
		  } 
		else if (s->readstate == READMSGLEN)
		  {
			s->readstate = READDATA;
			s->readdatalen = *(msg->data); 
			ker_serial_read(s->pid, 1, *(msg->data));
		  }
		else if (s->readstate == READDATA)
		  {
			s->readdata = msg->data;
			post_short(s->pid, s->pid, MSG_RFID_PARSE_DATA, 0, 0, 0);
			return SOS_TAKEN;
		  }
		
		return SOS_OK;
	  }
  case MSG_RFID_PARSE_DATA:
	{
	  parsedata(s);
	}
  case MSG_FINAL:
	{
	  return SOS_OK;
	}
  default:
	return -EINVAL;
  }
}

void crc_16 (uint8_t* packet, int length) {
  int8_t i;
  int8_t j;
  uint16_t crc16 = 0x0000;			/* PRESET value */
  
  for (i = 0; i < length; i+=1) {	/* check each byte in the array */
	crc16 ^= packet[i];
	for (j = 0; j < 8; j+=1) {		/* test each bit in the bytes */
	  if (crc16 & 0x0001) {
		crc16 = crc16 >> 1;
		crc16 ^= 0x8408; 			/* POLYNOMIAL x^16 + x^12 + x^5 + 1 */  
	  }
	  else { 
		crc16 = crc16 >> 1;
	  }
	}
  }	            
  *(packet+length) = (uint8_t)(crc16 >> 8);
  *(packet+length+1) = (uint8_t)crc16;
}

void parsedata(rfid_state* s) 
{
  if (s->readdatalen == 0)
	{
	  return;
	}

  switch((s->readdata)[0])
	{
	case SEL_TAG_PASS:
      memcpy((s->idtable).ids[(s->idtable).numids], ((s->readdata)+1), 9);
      (s->idtable).numids += 1;
	  if ((s->idtable).numids == s->numfindtags) 
		{ 
		  post_long(s->callingmodpid, s->pid, MSG_RFID_FINDTAGS_DONE, sizeof(s->idtable), &(s->idtable), 0);
		}
	  else 
		{
		  s->readstate = READSTX;
		  ker_free(s->readdata);
		  ker_serial_read(s->pid, 1, 1);
		  return;
		}
      break;
      
    case SEL_TAG_FAIL:
	  {
		if ((s->idtable).numids == 0) 
		  {
			post_short(s->callingmodpid, s->pid, MSG_RFID_FINDTAGS_FAIL, 0, 0, 0);
		  }
		else 
		  {
			
			post_long(s->callingmodpid, s->pid, MSG_RFID_FINDTAGS_DONE, sizeof(s->idtable), &(s->idtable), 0);
		  }
	  }
      break;
	  
	case READ_TAG_PASS: 
	  {
		uint8_t* d;
		d = (uint8_t*) ker_malloc((s->readdatalen)-3, s->pid);		
		
		memcpy(d, s->readdata+1, (s->readdatalen)-3);
		post_long(s->callingmodpid, s->pid, MSG_RFID_READTAGS_DONE,(s->readdatalen)-3, d, SOS_MSG_DYM_MANAGED); 
		break;
	  }
	case READ_TAG_FAIL:
	  {
		post_short(s->callingmodpid, s->pid, MSG_RFID_READTAGS_FAIL, 0, 0, 0);
		break;
	  }
	case WRITE_TAG_PASS: 
	  {
		post_short(s->callingmodpid, s->pid, MSG_RFID_WRITETAGS_DONE,0, 0, 0); 
		break;
	  }
	case WRITE_TAG_FAIL:
	  {
		post_short(s->callingmodpid, s->pid, MSG_RFID_WRITETAGS_FAIL, 0, 0, 0);
		break;
	  }
    default:
	  if (s->state == FINDTAGS || s->state == FINDTAGSSINGLE)
		{
		  post_short(s->callingmodpid, s->pid, MSG_RFID_FINDTAGS_FAIL, 0, 0, 0);
		}
	  else if (s->state == READTAGS)
		{
		  post_short(s->callingmodpid, s->pid, MSG_RFID_READTAGS_FAIL, 0, 0, 0);
		}
	  else if (s->state == WRITETAGS)
		{
		  post_short(s->callingmodpid, s->pid, MSG_RFID_WRITETAGS_FAIL, 0, 0, 0);
		}
	}

  ker_free(s->readdata);
  //Wait for TIMEOUT until a new command can be sent to the reader
  s->state = WAITIDLE;
  //if timer fails to start, just return to IDLE. 
  if (ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, TIMEOUT) != SOS_OK)
	{
	  s->state = IDLE;
	}
}
//-----------------------------------------------------------------------------
// APPLICATION INITIALIZATION
//-----------------------------------------------------------------------------
#ifndef _MODULE_
int8_t rfid_module_init()
{  
  return ker_register_task(RAGOBOT_RFID_PID, sizeof(rfid_state), module);
}
#endif
