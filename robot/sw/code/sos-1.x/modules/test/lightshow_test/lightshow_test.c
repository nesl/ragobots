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

#include <ragobot_module.h>
#include <modules/lightshow.h>
#include <pushbutton.h>
#include <fntable.h>

typedef struct{
  func_cb_ptr pushbutton_register;
  func_cb_ptr pushbutton_deregister;
  uint8_t pid;
  uint8_t state;
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
  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  s->state = 0;	  
	  SOS_CALL(s->pushbutton_register, func_ri8u8_t, s->pid);
	  break;
	}

  case MSG_PUSHBUTTON_PRESSED:
	{
	  switch (s->state) {
	  case 0:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_DECKLIGHTS, ENABLE, 0, 0);
		  post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_START, 0, 0, 0);
		  break;
		}
	  case 1:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_BARGRAPH, ENABLE, 0, 0);
		  break;
		}
	  case 2:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_HEADLIGHTS, ENABLE, 0, 0);
		  break;
		}
	  case 3:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_DECKLIGHTS, DISABLE, 0, 0);
		  break;
		}
	  case 4:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_BARGRAPH, DISABLE, 0, 0);
		  break;
		}
	  case 5:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_HEADLIGHTS, DISABLE, 0, 0);
		  post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_BARGRAPH, ENABLE, 0, 0);
		  break;
		}
	  case 6:
	  default:
		{
		  post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_BARGRAPH, DISABLE, 0, 0);
		  post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_STOP, 0, 0, 0);
		  break;
		}
	  }
	  s->state = (s->state + 1)%7;
	  break;
	}
  case MSG_FINAL:
	{
	  //deregister from pushbutton
	  SOS_CALL(s->pushbutton_register, func_ri8u8_t, s->pid);
	  break;
	}
  default:
	break;
  }
  
  return SOS_OK;
}

//-----------------------------------------------------------------------------
// APPLICATION INITIALIZATION
//-----------------------------------------------------------------------------
#ifndef _MODULE_
mod_header_ptr lightshow_test_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif

