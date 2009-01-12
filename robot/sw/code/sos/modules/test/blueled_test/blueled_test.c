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
 * @brief An application to test the blue led
 * 
 * When the pushbutton is pressed, the blue led on the head unit toggles.
 *
 */

#include <ragobot_message_types.h>

#ifndef _MODULE_
#include <sos.h>
#else
#include <ragobot_module.h>
#endif 

#include <pushbutton.h>
#include <modules/ragobot_mod_pid.h>
#include <modules/cb2bus.h>

#define IRMAN_ADDRESS 42

enum {
  BLUE_OFF_IDLE = 0,
  BLUE_ON_IDLE = 2,
  BLUE_OFF_BUSY = 3,
  BLUE_ON_BUSY = 1
};

typedef struct{
  uint8_t pid;
  uint8_t state;
  uint8_t data;
} app_state;

#ifndef _MODULE_
int8_t blueled_test_module(void* state, Message *msg)
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
  uint8_t data[1];
  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  s->state = BLUE_OFF_IDLE;
	  if (ker_pushbutton_register(s->pid)==-EINVAL) {led_red_on();}
	  break;
	}
  case MSG_PUSHBUTTON_PRESSED:
	{
	  if (s->state == BLUE_OFF_IDLE)
		{
		  s->state = BLUE_ON_BUSY;
		  s->data = 0x41;
		  ker_i2c_send_data(IRMAN_ADDRESS, &(s->data), 1, s->pid);
		  led_yellow_toggle();
		}
	  else if (s->state == BLUE_ON_IDLE)
		{
		  s->state = BLUE_OFF_BUSY;
		  s->data = 0x40;
		  ker_i2c_send_data(IRMAN_ADDRESS, &(s->data), 1, s->pid);
		  led_yellow_toggle();
		}
	  break;
	}
  case MSG_I2C_SEND_DONE:
	{
	  if (s->state == BLUE_ON_BUSY)
		{
		  s->state = BLUE_ON_IDLE;
		  led_red_toggle();
		}
	  else if (s->state == BLUE_OFF_BUSY)
		{
		  s->state = BLUE_OFF_IDLE;
		  led_red_toggle();
		}
	  break;
	}
  case MSG_FINAL:
	{
	  ker_pushbutton_deregister(s->pid);
	  break;
	}
  }
  
  return SOS_OK;
}

#ifndef _MODULE_
int8_t blueled_test_init()
{
  return ker_register_task(DFLT_APP_ID1, sizeof(app_state), blueled_test_module);
}
#endif
