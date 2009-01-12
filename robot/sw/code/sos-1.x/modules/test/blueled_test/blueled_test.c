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


#include <ragobot_module.h>
#include <pushbutton.h>
#include <modules/cb2bus.h>
#include <fntable.h>
#include <led.h>

#define IRMAN_ADDRESS 42

enum {
  BLUE_OFF_IDLE = 0,
  BLUE_ON_IDLE = 2,
  BLUE_OFF_BUSY = 3,
  BLUE_ON_BUSY = 1
};

typedef struct{
  func_cb_ptr pushbutton_register;
  func_cb_ptr pushbutton_deregister;
  uint8_t pid;
  uint8_t state;
  uint8_t data;
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
  //uint8_t data[1];
  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  s->state = BLUE_OFF_IDLE;
	  if ((SOS_CALL(s->pushbutton_register, func_ri8u8_t, s->pid)) != SOS_OK) 
		{
		  ker_led(LED_RED_ON);
		}
	  break;
	}
  case MSG_PUSHBUTTON_PRESSED:
	{
	  if (s->state == BLUE_OFF_IDLE)
		{
		  s->state = BLUE_ON_BUSY;
		  s->data = 0x41;
		  ker_i2c_send_data(IRMAN_ADDRESS, &(s->data), 1, s->pid);
		  ker_led(LED_YELLOW_TOGGLE);
		}
	  else if (s->state == BLUE_ON_IDLE)
		{
		  s->state = BLUE_OFF_BUSY;
		  s->data = 0x40;
		  ker_i2c_send_data(IRMAN_ADDRESS, &(s->data), 1, s->pid);
		  ker_led(LED_YELLOW_TOGGLE);
		}
	  break;
	}
  case MSG_I2C_SEND_DONE:
	{
	  if (s->state == BLUE_ON_BUSY)
		{
		  s->state = BLUE_ON_IDLE;
		  ker_led(LED_RED_TOGGLE);
		}
	  else if (s->state == BLUE_OFF_BUSY)
		{
		  s->state = BLUE_OFF_IDLE;
		  ker_led(LED_RED_TOGGLE);
		}
	  break;
	}
  case MSG_FINAL:
	{
	  SOS_CALL(s->pushbutton_deregister, func_ri8u8_t, s->pid);
	  break;
	}
  }
  
  return SOS_OK;
}

#ifndef _MODULE_
mod_header_ptr blueled_test_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif
