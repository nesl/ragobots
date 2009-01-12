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
 * @brief An application to test the servos
 * 
 * This application changes of the position of the selected servos in
 * increments of 10 degrees from -90 degrees to 90 degrees. Initially,
 * the application is set to control the PAN servo. If the user presses
 * the pushbutton, the application is set to control the TILT servo and
 * decklight 3 (D3) turns on to indicate this.  
 */

#include <ragobot_module.h>
#include <pushbutton.h>
#include <servos.h>
#include <fntable.h>
#include <led.h>

typedef struct{
  func_cb_ptr servos_set_position;
  func_cb_ptr pushbutton_register;
  func_cb_ptr pushbutton_deregister;
  uint8_t pid;
  uint8_t servo;
  int8_t pancount;
  int8_t tiltcount;
  uint8_t pancountdown;
  uint8_t tiltcountdown;
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
	  {error_8, "cCc2", RAGOBOT_SERVOS_PID, SERVOS_SET_POSITION_FID},
	  {error_8, "cCv1", RAGOBOT_PUSHBUTTON_PID, PUSHBUTTON_REGISTER_FID},
	  {error_8, "cCv1", RAGOBOT_PUSHBUTTON_PID, PUSHBUTTON_DEREGISTER_FID}
	},
};

static int8_t module(void *state, Message *msg){
  app_state_t *s = (app_state_t*) state;
  
  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  s->servo = PANSERVO;
	  s->pancount = 0;
	  s->tiltcount = 0;
	  s->pancountdown = 0;
	  s->tiltcountdown = 0;
	  SOS_CALL(s->pushbutton_register, func_ri8u8_t, s->pid);
	  post_short(RAGOBOT_CB2BUS_PID, DFLT_APP_ID0, MSG_SERVO_EN, ENABLE, 0, 0);
	  post_short(RAGOBOT_CB2BUS_PID, DFLT_APP_ID0, MSG_LOAD, 0, 0, 0);
	  ker_led(LED_GREEN_ON);
	  ker_timer_init(s->pid, 1, TIMER_REPEAT);
	  ker_timer_start(s->pid, 1, 1000);
	  break;
	}
	
  case MSG_TIMER_TIMEOUT:
	{
	  if (s->servo == TILTSERVO) 
		{
		  if(SOS_CALL(s->servos_set_position, func_u8i8_t, s->servo, s->tiltcount) != SOS_OK)
			{
			  ker_led(LED_RED_ON);
			  break;
			}
		  if (s->tiltcountdown == 0)
			{
			  s->tiltcount += 10;
			}
		  else
			{ 
			  s->tiltcount -=10;
			}
		  
		  if (s->tiltcount == 90)
			{
			  s->tiltcountdown = 1;
			}
		  else if (s->tiltcount == -20)
			{
			  s->tiltcountdown = 0;
			}
		  
		}
	  else if (s->servo == PANSERVO) 
		{
		  if(SOS_CALL(s->servos_set_position, func_u8i8_t, s->servo, s->pancount) != SOS_OK)
			{
			  ker_led(LED_RED_ON);
			  break;
			}
		  if (s->pancountdown == 0)
			{
			  s->pancount += 10;
			}
		  else
			{ 
			  s->pancount -=10;
			}
		
		  if (s->pancount == 90)
			{
			  s->pancountdown = 1;
			}
		  else if (s->pancount == -90)
			{
			  s->pancountdown = 0;
			}
		  
		}
	  break;
	  
	}
  case MSG_PUSHBUTTON_PRESSED:
	{
	  if (s->servo == PANSERVO)
		{
		  s->servo = TILTSERVO;
		  post_short(RAGOBOT_CB2BUS_PID, DFLT_APP_ID0, MSG_DECKLIGHT3, ON, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, DFLT_APP_ID0, MSG_LOAD, 0, 0, 0);
		}
	  else 
		{
		  s->servo = PANSERVO;
		  post_short(RAGOBOT_CB2BUS_PID, DFLT_APP_ID0, MSG_DECKLIGHT3, OFF, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, DFLT_APP_ID0, MSG_LOAD, 0, 0, 0);	
		}
	  break;
	}
  case MSG_FINAL:
	{
	  SOS_CALL(s->pushbutton_register, func_ri8u8_t, s->pid);
	  break;
	}
  default:
	break;
  }
  
  return SOS_OK;
}

#ifndef _MODULE_
mod_header_ptr servos_test_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif
