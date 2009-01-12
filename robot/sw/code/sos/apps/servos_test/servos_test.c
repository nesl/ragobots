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

#include <sos.h>
#include <led.h>
#include <id.h>
#include <pushbutton.h>
#include <servos.h>
#include <modules/ragobot_mod_pid.h>
#include <modules/cb2bus.h>

typedef struct{
  uint8_t pid;
  uint8_t servo;
  int8_t pancount;
  int8_t tiltcount;
  uint8_t pancountdown;
  uint8_t tiltcountdown;
} app_state_t;

static int8_t app_handler(void *state, Message *msg){
  app_state_t *s = (app_state_t*) state;
  MsgParam* p = (MsgParam*) msg->data;

  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  s->servo = PANSERVO;
	  s->pancount = 0;
	  s->tiltcount = 0;
	  s->pancountdown = 0;
	  s->tiltcountdown = 0;
	  ker_pushbutton_register(DFLT_APP_ID0);
	  post_short(RAGOBOT_CB2BUS_PID, DFLT_APP_ID0, MSG_SERVO_EN, ENABLE, 0, 0);
	  post_short(RAGOBOT_CB2BUS_PID, DFLT_APP_ID0, MSG_LOAD, 0, 0, 0);
	  led_green_on();
	  ker_timer_start(DFLT_APP_ID0, 0, TIMER_REPEAT, 1000);
	  break;
	}
	
  case MSG_TIMER_TIMEOUT:
	{
	  if (s->servo == TILTSERVO) 
		{
		  if(ker_servo_set_position(s->servo, s->tiltcount) != SOS_OK)
			{
			  led_red_on();
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
		  if(ker_servo_set_position(s->servo, s->pancount) != SOS_OK)
			{
			  led_red_on();
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
  default:
	break;
  }
  
  return SOS_OK;
}


void sos_start(void){
  cb2bus_module_init();
  ker_register_task(DFLT_APP_ID0, sizeof(app_state_t), app_handler);
}
