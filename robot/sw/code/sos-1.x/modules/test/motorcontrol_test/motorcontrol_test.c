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
 * @author David Lee
 */
/**
 * @brief An application to test the motorcontrol
 * 
 *
 */

#include <ragobot_module.h>
#include <modules/motorcontrol.h>
#include <modules/cb2bus.h>

#define MCONTROL_TEST_TIMER 1
#define TIMER_INTERVAL 2048

typedef struct{
	uint8_t pid;
	uint8_t state[5];
	uint8_t count;
} app_state_t;

static int8_t module(void *state, Message *msg);

static mod_header_t mod_header SOS_MODULE_HEADER = {
	mod_id : DFLT_APP_ID0,
	state_size : sizeof(app_state_t),
    num_timers : 1,
	num_sub_func : 0,
	num_prov_func : 0,
	module_handler: module,
};

static int8_t module(void *state, Message *msg)
{
	app_state_t *s = (app_state_t*) state;

	switch (msg->type)
	  {
	  case MSG_INIT:
		{
		  s->pid = msg->did;
		  s->count = 0;
		  s->state[0] = MOTOR_FULL_SPEED;
		  s->state[1] = RGT_REV_NORMAL;
		  s->state[2] = LFT_REV_NORMAL;
		  s->state[3] = LFT_STOP;
		  s->state[4] = RGT_STOP;
		  
		  ker_timer_init(s->pid, MCONTROL_TEST_TIMER, TIMER_REPEAT);
		  ker_timer_start(s->pid, MCONTROL_TEST_TIMER, TIMER_INTERVAL);
		  
		  break;
		}
	
	  case MSG_TIMER_TIMEOUT:
		{
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, s->state[s->count], 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		  post_short(RAGOBOT_MCONTROL_PID, s->pid, MSG_CHANGE_SPEED, s->state[s->count], 0, 0);
		  
		  s->count = (s->count+1) % 5;
		  break;
		}
		case MSG_FINAL:
		  {
			ker_timer_stop(s->pid, 0);
			break;
		  }
	  }
  
	return SOS_OK;
}

//-----------------------------------------------------------------------------
// APPLICATION INITIALIZATION
//-----------------------------------------------------------------------------
#ifndef _MODULE_
mod_header_ptr mcontrol_test_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif
