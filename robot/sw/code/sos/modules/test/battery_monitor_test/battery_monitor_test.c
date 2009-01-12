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
 * @brief A module to test the lightshow module
 * 
 */

#include <ragobot_message_types.h>

#ifndef _MODULE_
#include <sos.h>
#else
#include <ragobot_module.h>
#endif 

#include <pushbutton.h>
#include <modules/cb2bus.h>
#include <modules/ragobot_mod_pid.h>
#include <modules/battery_monitor.h>

typedef struct{
  uint8_t pid;
  uint8_t state;
} app_state_t;

#ifndef _MODULE_
int8_t battery_monitor_test_module(void* state, Message *msg)
#else

DECL_MOD_STATE(app_state_t);
DECL_MOD_ID(DFLT_APP_ID0);

int8_t module(void *state, Message *msg)
#endif
{
  app_state_t *s = (app_state_t*) state;
  uint8_t *data;
  uint8_t id;
  MsgParam* p; 
  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  s->state = 0;	  
	  ker_pushbutton_register(s->pid);
	  break;
	}

  case MSG_PUSHBUTTON_PRESSED:
	{
	  post_short(RAGOBOT_BATTERY_MONITOR_PID, s->pid, MSG_GET_VOLTAGE, 0, 0, 0); 
	  break;
	}
  case MSG_GET_ROM_ID_DONE:
	{
	  id = *(((uint8_t*)msg->data)+1);
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, id, 0);
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
	  ker_free(msg->data);
	  return SOS_TAKEN;
	}
  case MSG_GET_CURRENT_DONE:
  case MSG_GET_TEMPERATURE_DONE:
  case MSG_GET_VOLTAGE_DONE:
	{
	  p = (MsgParam*)msg->data;
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, p->word, 0);
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
	  break;
	}
  case MSG_FINAL:
	{
	  ker_pushbutton_deregister(s->pid);
	}
  }
  
  return SOS_OK;
}

#ifndef _MODULE_
int8_t battery_monitor_test_init()
{
  return ker_register_task(DFLT_APP_ID0, sizeof(app_state_t), battery_monitor_test_module);
}
#endif
