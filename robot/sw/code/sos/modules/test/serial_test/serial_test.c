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
 * @brief An application to test the pushbutton
 * 
 * When the pushbutton is pressed, the counter increments by one and the result
 * is displayed on the 10-bit Light Bar. The counter starts at 0.
 *
 */

#include <ragobot_message_types.h>

/*#ifndef _MODULE_
#include <sos.h>
#else
*/
#include <ragobot_module.h>
//#endif 
/*
#include <pushbutton.h>
#include <modules/ragobot_mod_pid.h>
#include <modules/cb2bus.h>
*/

#define numports 2
enum {
  IDLE = 0,
  INTRO = 1,
  OPTIONS = 2, 
  READ = 3
};

typedef struct{
  uint8_t pid;
  uint8_t state;
  uint8_t port;
} app_state;

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
{
  app_state *s = (app_state*) state;
  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  s->port = 1;
	  if (ker_pushbutton_register(s->pid)==-EINVAL) {led_red_on();}
	  s->state = OPTIONS;
	  ker_serial_write(s->pid, s->port, "*****WELCOME TO RAGOBOT V1.0*****\n\r", 35, 0);
	  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, 1000);
	  break;
	}
  case MSG_TIMER_TIMEOUT:
	{
	  if(s->state == OPTIONS) 
		{
		  s->state = READ;
		  ker_serial_write(s->pid, s->port, "Please Select From The Following Options:\n\r1. HELLO\n\r2. COOL\n\r", 62, 0);
		  if (ker_serial_read(s->pid, s->port, 1) != SOS_OK)
			led_yellow_on();
		}
	  break;
	}
  case MSG_UART1_READ_DONE:
	{
	  if (*(msg->data) == '1')
		{
		  ker_serial_write(s->pid, s->port, "> Hi, My name is Ragobot.\n\r", 27, 0);
		}
	  else if (*(msg->data) == '2')
		{
		  ker_serial_write(s->pid, s->port, "> Yes, Ragobots are cool!\n\r", 27, 0);
		}
	  else 
		{
		  ker_serial_write(s->pid, s->port, "> Invalid Selection. Please Try Again.\n\r", 40, 0);
		}
	  s->state = OPTIONS;
	  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, 1000);
	  break;
	}
  case MSG_PUSHBUTTON_PRESSED:
	{
	  s->port = (s->port + 1) % numports;
	  s->state = OPTIONS;
	  ker_serial_write(s->pid, s->port, "*****WELCOME TO RAGOBOT V1.0*****\n\r", 35, 0);
	  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, 1000);
	  break;
	}
  case MSG_FINAL:
	{
	  ker_timer_stop(s->pid, 0);
	  ker_pushbutton_deregister(s->pid);
	  break;
	}
  }
  
  return SOS_OK;
}

#ifndef _MODULE_
int8_t serial_test_init()
{
  return ker_register_task(DFLT_APP_ID1, sizeof(app_state), module);
}
#endif
