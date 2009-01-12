/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */
/*                                  tab:4
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
 */
/**
 * @author David Lee
 */
/**
 * @brief An application to test the RFID
 * 
 * When the pushbutton is pressed, the RFID reader reads the tag under it.
 *
 */

#include <ragobot_message_types.h>
#include <ragobot_module.h>
#include <modules/rfid.h>

enum {
  IDLE = 0,
  FINDTAG = 1,
  READTAG = 2, 
};

typedef struct{
  uint8_t pid;
  uint8_t state;
  rfid_data_t rfid_read_data;
  uint8_t rfid_write_data[4];
  uint8_t temp[4];
} app_state;

/**
 * Module state and ID declaration.
 * All modules should call the following to macros to help the linker add
 * module specific meta data to the resulting binary image.  Note that the
 * parameters may be different.
 */
DECL_MOD_STATE(app_state);
DECL_MOD_ID(DFLT_APP_ID1);

SOS_MODULE
int8_t module(void *state, Message *msg)
{
  app_state *s = (app_state*) state;
  MsgParam *p = (MsgParam*)(msg->data);

  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	 
	  if (ker_pushbutton_register(s->pid)==-EINVAL) {led_red_on();}
	  s->state = IDLE;
	  (s->rfid_write_data)[0] = 0x00;
	  (s->rfid_write_data)[1] = 0x00;
	  (s->rfid_write_data)[2] = 0x00;
	  (s->rfid_write_data)[3] = 0x00;
	  (s->rfid_read_data).data = s->rfid_write_data;
	  (s->rfid_read_data).datalen = 4;
	  break;
	}
  case MSG_TIMER_TIMEOUT:
	{
	  break;
	}
  case MSG_PUSHBUTTON_PRESSED:
	{
	  post_short(RAGOBOT_RFID_PID, s->pid, MSG_RFID_FINDTAGS, 1, 0, 0);
	  break;
	}
  case MSG_RFID_FINDTAGS_DONE:
	{
	  idtable_t *idtableptr = (idtable_t*) (msg->data);

	  memcpy((s->rfid_read_data).id, (idtableptr->ids)[0], MAXIDLENGTH);
	  post_long(RAGOBOT_RFID_PID, s->pid, MSG_RFID_WRITETAGS, sizeof(rfid_data_t), &(s->rfid_read_data), 0); 
	  break;
	  
	}
  case MSG_RFID_FINDTAGS_FAIL:
	{
	  led_red_toggle();
	  break;
	}
  case MSG_RFID_READTAGS_DONE:
	{
	  memcpy(s->temp, msg->data, 4);
	  led_yellow_toggle();
	  (s->rfid_write_data)[3] += 1;
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, (uint8_t)((s->temp)[3]), 0);
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
	   
	  break;
	}
  case MSG_RFID_READTAGS_FAIL:
	{
	  //led_red_toggle();
	  break;
	}	
  case MSG_RFID_WRITETAGS_DONE:
	{
	  post_long(RAGOBOT_RFID_PID, s->pid, MSG_RFID_READTAGS, sizeof(rfid_data_t), &(s->rfid_read_data), 0);
	  break;
	}
  case MSG_RFID_WRITETAGS_FAIL:
	{
	  led_red_toggle();
	  break;
	}	
  case MSG_FINAL:
	{
	  ker_timer_stop(s->pid, 0);
	  ker_pushbutton_deregister(s->pid);
	  break;
	}
  }
  
  return SOS_OK;
}

#ifndef _MODULE_
int8_t rfid_test_init()
{
  return ker_register_task(DFLT_APP_ID1, sizeof(app_state), module);
}
#endif
