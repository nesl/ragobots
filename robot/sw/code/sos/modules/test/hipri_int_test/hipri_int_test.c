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
 * @brief An application to test the hipri interrupt from IRMAN
 * 
 * When the hipri interrupt is received, the decklight1 led toggles
 *
 */

#include <ragobot_message_types.h>

#ifndef _MODULE_
#include <sos.h>
#else
#include <ragobot_module.h>
#endif 

#include <hipri_int.h>
#include <modules/ragobot_mod_pid.h>
#include <modules/cb2bus.h>

typedef struct{
  uint8_t pid;
} app_state;

#ifndef _MODULE_
int8_t hipri_int_test_module(void* state, Message *msg)
#else 
/**
 * Module state and ID declaration.
 * All modules should call the following to macros to help the linker add
 * module specific meta data to the resulting binary image.  Note that the
 * parameters may be different.
 */
DECL_MOD_STATE(app_state);
DECL_MOD_ID(DFLT_APP_ID1);

int8_t module(void *state, Message *msg)
#endif
{
  app_state *s = (app_state*) state;
  
  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  if (ker_hipri_int_register(s->pid)==-EINVAL) 
		{
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT6, ON, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		}
	  break;
	}
	
  case MSG_HIPRI_INT:
	{
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT1, TOGGLE, 0, 0);
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
	  break;
	}
  case MSG_FINAL:
	{
	  ker_timer_stop(s->pid, 0);
	  ker_hipri_int_deregister(s->pid);
	  break;
	}
  }
  
  return SOS_OK;
}

#ifndef _MODULE_
int8_t hipri_int_test_init()
{
  return ker_register_task(DFLT_APP_ID1, sizeof(app_state), hipri_int_test_module);
}
#endif
