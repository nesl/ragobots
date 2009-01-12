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
 * @brief An application to test the motorcontrol
 * 
 *
 */

#ifndef _MODULE_
#include <sos.h>
#else
#include <ragobot_module.h>
#endif 

#include <modules/motorcontrol.h>
#include <modules/ragobot_mod_pid.h>
#include <modules/cb2bus.h>

#define MCONTROL_TEST_TIMER 1
#define TIMER_INTERVAL 2048

typedef struct{
	uint8_t pid;
	uint8_t state[5];
	uint8_t count;
} app_state;

#ifndef _MODULE_
int8_t motorcontrol_test_module(void* state, Message *msg)
#else 
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
#endif
{
	app_state *s = (app_state*) state;
	MsgParam *p = (MsgParam*)(msg->data);

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
	  
			ker_timer_start(s->pid, MCONTROL_TEST_TIMER, TIMER_REPEAT, TIMER_INTERVAL);
	  
	  		break;
		}
	
		case MSG_TIMER_TIMEOUT:
		{
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

#ifndef _MODULE_
int8_t motorcontrol_test_init()
{
	return ker_register_task(DFLT_APP_ID1, sizeof(app_state), motorcontrol_test_module);
}
#endif
