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

#include <ragobot_module.h>
#include <modules/rfid.h>
#include <string.h>
#include <led.h>
#include <pushbutton.h>
#include <fntable.h>

enum {
  IDLE = 0,
  FINDTAG = 1,
  READTAG = 2, 
};

typedef struct{
  func_cb_ptr pushbutton_register;
  func_cb_ptr pushbutton_deregister;
  uint8_t pid;
  uint8_t state;
  rfid_data_t rfid_read_data;
  uint8_t rfid_write_data[4];
  uint8_t temp[4];
} app_state_t;


static int8_t module(void *state, Message *msg);

static mod_header_t mod_header SOS_MODULE_HEADER = {
	mod_id : DFLT_APP_ID0,
	state_size : sizeof(app_state_t),
	num_sub_func : 2,
	num_prov_func : 0,
	module_handler: module,
	funct: {
		  {error_8, "cCv1", RAGOBOT_PUSHBUTTON_PID, PUSHBUTTON_REGISTER_FID},
		  {error_8, "cCv1", RAGOBOT_PUSHBUTTON_PID, PUSHBUTTON_DEREGISTER_FID}
	},
};

static int8_t module(void *state, Message *msg)
{
  app_state_t *s = (app_state_t*) state;
  //MsgParam *p = (MsgParam*)(msg->data);

  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	 
	  if ((SOS_CALL(s->pushbutton_register, func_ri8u8_t, s->pid))==-EINVAL) 
		{
		  ker_led(LED_RED_ON);
		}
	  s->state = IDLE;
	  (s->rfid_write_data)[0] = 0x00;
	  (s->rfid_write_data)[1] = 0x00;
	  (s->rfid_write_data)[2] = 0x00;
	  (s->rfid_write_data)[3] = 0x00;
	  (s->rfid_read_data).data = s->rfid_write_data;
	  (s->rfid_read_data).datalen = 4;
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
	  ker_led(LED_RED_TOGGLE);
	  break;
	}
  case MSG_RFID_READTAGS_DONE:
	{
	  memcpy(s->temp, msg->data, 4);
	  ker_led(LED_YELLOW_TOGGLE);
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
	  ker_led(LED_RED_TOGGLE);
	  break;
	}	
  case MSG_FINAL:
	{
	  //ker_timer_stop(s->pid, 0);
	  SOS_CALL(s->pushbutton_register, func_ri8u8_t, s->pid);
	  break;
	}
  }
  
  return SOS_OK;
}

//-----------------------------------------------------------------------------
// APPLICATION INITIALIZATION
//-----------------------------------------------------------------------------
#ifndef _MODULE_
mod_header_ptr rfid_test_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif
