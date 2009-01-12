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
 * @author Ilias Tsigkogiannis
 */
/**
 * @brief An application to test the IR Ranger
 * 
 */

#include <ragobot_module.h>
#include <fntable.h>
#include <led.h>
#include <irranger.h>

#define IRRANGER_TIMER 1
#define  MSG_NOTHING MOD_MSG_START

typedef struct{
  func_cb_ptr irranger_trigger;
  func_cb_ptr pushbutton_register;
  uint8_t pid;
  uint16_t count;
  uint8_t distance;
} app_state_t;

static int8_t module(void *state, Message *msg);

static mod_header_t mod_header SOS_MODULE_HEADER = {
	mod_id : DFLT_APP_ID0,
	state_size : sizeof(app_state_t),
	num_timers : 1,
	num_sub_func : 2,
	num_prov_func : 0,
	module_handler: module,
	funct: {
	  {error_8, "cCv1", RAGOBOT_IRRANGER_PID, IRRANGER_TRIGGER_FID},
	  {error_8, "cCv1", RAGOBOT_PUSHBUTTON_PID, PUSHBUTTON_REGISTER_FID}
	}
};

static int8_t module(void *state, Message *msg)
{
  app_state_t *s = (app_state_t*) state;
  MsgParam* p = (MsgParam*) msg->data;

  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  s->count = 0;
	  //testing IR Ranger
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_IRR_EN, ENABLE, 0, 0); 
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
	  if ((SOS_CALL(s->pushbutton_register, func_ri8u8_t, s->pid))==-EINVAL) 
		{
		  ker_led(LED_RED_TOGGLE);
		}
	  ker_timer_init(s->pid, IRRANGER_TIMER, TIMER_REPEAT);
	  ker_timer_start(s->pid, IRRANGER_TIMER, 1024);
	  break;
	}
  case MSG_PUSHBUTTON_PRESSED:
  case MSG_TIMER_TIMEOUT:
	{
	  if ((SOS_CALL(s->irranger_trigger, func_ri8u8_t, s->pid)) != SOS_OK)
		{
		  ker_led(LED_RED_TOGGLE);
		}
	  break;
	}
  case MSG_IRRANGER_FINISHED:
	{
	  s->distance = p->byte;
	  ker_led(LED_GREEN_TOGGLE);
	  //s->count += 1;
	  post_short(RAGOBOT_CB2BUS_PID, DFLT_APP_ID0, MSG_BARBINARY, 0, s->distance, 0);
	  post_short(RAGOBOT_CB2BUS_PID, DFLT_APP_ID0, MSG_LOAD, 0, 0, 0);
	  //post_net(DFLT_APP_ID0, DFLT_APP_ID0, MSG_NOTHING, sizeof(s->distance), &s->distance, SOS_MSG_DYM_MANAGED,  BCAST_ADDRESS);
	  break;
	}
  }
  return SOS_OK;
}

#ifndef _MODULE_
mod_header_ptr irranger_test_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif

