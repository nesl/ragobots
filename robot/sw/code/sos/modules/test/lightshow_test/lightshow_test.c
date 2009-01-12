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
#include <modules/lightshow.h>
#include <modules/ragobot_mod_pid.h>

typedef struct{
  uint8_t pid;
  uint8_t state;
} app_state_t;

#ifndef _MODULE_
int8_t lightshow_test_module(void* state, Message *msg)
#else

DECL_MOD_STATE(app_state_t);
DECL_MOD_ID(DFLT_APP_ID0);

int8_t module(void *state, Message *msg)
#endif
{
  app_state_t *s = (app_state_t*) state;
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
	  
	  switch (s->state) {
	  case 0:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, DFLT_APP_ID0, MSG_LIGHTSHOW_DECKLIGHTS, ENABLE, 0, 0);
		  post_short(RAGOBOT_LIGHTSHOW_PID, DFLT_APP_ID0, MSG_LIGHTSHOW_START, 0, 0, 0);
		  break;
		}
	  case 1:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, DFLT_APP_ID0, MSG_LIGHTSHOW_BARGRAPH, ENABLE, 0, 0);
		  break;
		}
	  case 2:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, DFLT_APP_ID0, MSG_LIGHTSHOW_HEADLIGHTS, ENABLE, 0, 0);
		  break;
		}
	  case 3:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, DFLT_APP_ID0, MSG_LIGHTSHOW_DECKLIGHTS, DISABLE, 0, 0);
		  break;
		}
	  case 4:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, DFLT_APP_ID0, MSG_LIGHTSHOW_BARGRAPH, DISABLE, 0, 0);
		  break;
		}
	  case 5:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, DFLT_APP_ID0, MSG_LIGHTSHOW_HEADLIGHTS, DISABLE, 0, 0);
		  post_short(RAGOBOT_LIGHTSHOW_PID, DFLT_APP_ID0, MSG_LIGHTSHOW_BARGRAPH, ENABLE, 0, 0);
		  break;
		}
	  case 6:
	  default:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, DFLT_APP_ID0, MSG_LIGHTSHOW_BARGRAPH, DISABLE, 0, 0);
		  post_short(RAGOBOT_LIGHTSHOW_PID, DFLT_APP_ID0, MSG_LIGHTSHOW_STOP, 0, 0, 0);
		  break;
		}
	  }
	  s->state = (s->state + 1)%7;
	  break;
	}
  default:
	break;
  }
  
  return SOS_OK;
}

#ifndef _MODULE_
int8_t lightshow_test_init()
{
  return ker_register_task(DFLT_APP_ID0, sizeof(app_state_t), lightshow_test_module);
}
#endif
