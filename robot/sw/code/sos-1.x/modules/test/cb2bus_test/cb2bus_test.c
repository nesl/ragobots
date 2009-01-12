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
 * @brief A module to test the cb2bus
 *
 * This application tests the cb2bus by turning on and off the leds. The 
 * decklights create a U pattern. On the 10-bit Light Bar, only one bar is
 * on at any point in time to create a "Knight Rider" effect. The 4 headlights
 * change colors from red, orange, and green at a rate 10x slower than other
 * leds.  
 */

#include <ragobot_module.h>

enum {
  TURNON_DECKLIGHT11 = 0,
  TURNON_DECKLIGHT21 = 1,
  TURNON_DECKLIGHT31 = 2,
  TURNON_DECKLIGHT41 = 3,
  TURNON_DECKLIGHT51 = 4,
  TURNON_DECKLIGHT61 = 5,
  TURNON_DECKLIGHT12 = 6,
  TURNON_DECKLIGHT22 = 7,
  TURNON_DECKLIGHT32 = 8,
  TURNON_DECKLIGHT42 = 9,
  TURNON_DECKLIGHT52 = 10,
  TURNON_DECKLIGHT62 = 11 
};

typedef struct{
  uint8_t pid;
  uint8_t state;
  uint16_t color;
  uint16_t barcount;
} app_state_t;

static int8_t module(void *start, Message *e);

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
  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  s->state = TURNON_DECKLIGHT21;
	  s->color = BLACK;
	  s->barcount = 0;
	  ker_timer_init(s->pid, 1, TIMER_REPEAT);
	  ker_timer_start(s->pid, 1, 80);
	  break;
	}

  case MSG_TIMER_TIMEOUT:
	{
	  
	  if (s->state == TURNON_DECKLIGHT21)
		{
		  s->state = TURNON_DECKLIGHT31;
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT3, OFF, 0, 0);  
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT2, ON, 0, 0);
		  
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		}
	  else if (s->state == TURNON_DECKLIGHT31)
		{
		  s->state = TURNON_DECKLIGHT41;
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT2, OFF, 0, 0);  
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT3, ON, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0,  0);
		}
	  else if (s->state == TURNON_DECKLIGHT41)
		{
		  s->state = TURNON_DECKLIGHT51;
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT3, OFF, 0, 0);  
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT4, ON, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		}
	  else if (s->state == TURNON_DECKLIGHT51)
		{
		  s->state = TURNON_DECKLIGHT61;
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT4, OFF, 0, 0);  
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT5, ON, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		}
	  else if (s->state == TURNON_DECKLIGHT61)
		{
		  s->state = TURNON_DECKLIGHT11;
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT5, OFF, 0, 0);  
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT6, ON, 0, 0);

		  
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, FRONT_RIGHT, s->color, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, FRONT_LEFT, s->color, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, BACK_RIGHT, s->color, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, BACK_LEFT, s->color, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		  s->color += 0x0001;
		  if (s->color > 0x0003) 
			{
			  s->color = 0x0000;
			}
		  
		}
	  else if (s->state == TURNON_DECKLIGHT11) 
		{
		  s->state = TURNON_DECKLIGHT62;
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT6, OFF, 0, 0);  
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT1, ON, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		}
	  else if (s->state == TURNON_DECKLIGHT62) 
		{
		  s->state = TURNON_DECKLIGHT52;
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT1, OFF, 0, 0);  
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT6, ON, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		}
	  else if (s->state==TURNON_DECKLIGHT52) 
		{
		  s->state = TURNON_DECKLIGHT42;
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT6, OFF, 0, 0);  
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT5, ON, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		}
	  else if (s->state==TURNON_DECKLIGHT42) 
		{
		  s->state = TURNON_DECKLIGHT32;
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT5, OFF, 0, 0);  
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT4, ON, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		}
	  else if (s->state==TURNON_DECKLIGHT32) 
		{
		  s->state = TURNON_DECKLIGHT21;
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT4, OFF, 0, 0);  
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT3, ON, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		}
   
	  if (s->barcount > 9)
	  	{
	  	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARPOSITION, (18 - s->barcount), 0, 0);
	  	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		}
	  else 
		{
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARPOSITION, s->barcount, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		}
	  
	  s->barcount += 0x01;
	  if (s->barcount >= 18) 
		{
		  s->barcount = 0;
	    }
	  
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
	  
	break;
	}
  default:
	break;
  }
  
  return SOS_OK;
}

#ifndef _MODULE_
mod_header_ptr cb2bus_test_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif

