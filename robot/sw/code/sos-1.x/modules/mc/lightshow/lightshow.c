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
 * @brief A modules that uses the on board leds for a lightshow
 *
 * The decklights create a U pattern. On the 10-bit Light Bar, only one bar is
 * on at any point in time to create a "Knight Rider" effect. The 4 headlights
 * change colors from red, orange, and green at a rate 10x slower than other
 * leds.  
 */

#include <ragobot_module.h>
#include <fntable.h>
#include <modules/lightshow.h>

typedef struct{
  uint8_t decklights_state;
  uint8_t headlights_state;
  uint8_t bargraph_state;
  uint8_t light_state;
  uint8_t count;
} lightshow_state;

static int8_t module(void *state, Message *msg);

static mod_header_t mod_header SOS_MODULE_HEADER = {
	mod_id : RAGOBOT_LIGHTSHOW_PID,
	state_size : sizeof(lightshow_state),
    num_timers : 1,
	num_sub_func : 0,
	num_prov_func : 0,
	module_handler: module,
};

static int8_t module(void *state, Message *msg) {
  lightshow_state *s = (lightshow_state*) state;
  MsgParam *p = (MsgParam*)(msg->data);
  uint8_t decklights_count;
  uint8_t bargraph_count; 
  uint8_t headlights_count;
  uint16_t color = BLACK;
  switch (msg->type){
  case MSG_INIT:
	{
	  s->decklights_state = DISABLE; 
	  s->bargraph_state = DISABLE;
	  s->headlights_state = DISABLE;
	  s->light_state = DISABLE;
	  s->count = 0;
	  ker_timer_init(RAGOBOT_LIGHTSHOW_PID, 0, TIMER_REPEAT);
	  break;
	}
  case MSG_LIGHTSHOW_START: 
	{
	  if (s->light_state == DISABLE) 
		{
		  s->light_state = ENABLE;
		  ker_timer_start(RAGOBOT_LIGHTSHOW_PID, 0, 80);
		}
	  break;
	}
  case MSG_TIMER_TIMEOUT:
	{
	  if (s->decklights_state == ENABLE) 
		{
		  decklights_count = s->count % 10;
		  if (decklights_count == 0)
			{
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT3, OFF, 0, 0);  
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT2, ON, 0, 0);
			}
		  else if (decklights_count == 1 || decklights_count == 9)
			{
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT2, OFF, 0, 0);  
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT3, ON, 0, 0);
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT4, OFF, 0, 0);  
			}
		  else if (decklights_count == 2 || decklights_count == 8)
			{
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT3, OFF, 0, 0);  
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT4, ON, 0, 0);
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT5, OFF, 0, 0); 
			}
		  else if (decklights_count == 3 || decklights_count == 7)
			{
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT4, OFF, 0, 0);  
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT5, ON, 0, 0);
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT6, OFF, 0, 0); 
			}
		  else if (decklights_count == 4 || decklights_count == 6)
			{
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT5, OFF, 0, 0);  
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT6, ON, 0, 0);
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT1, OFF, 0, 0); 
			}
		  else if (decklights_count == 5)
			{
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT6, OFF, 0, 0);  
			  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_DECKLIGHT1, ON, 0, 0);
			}
		}
	  if (s->bargraph_state == ENABLE) 
		{
		  bargraph_count = s->count % 18;
		  if (bargraph_count < 10)
			post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_BARPOSITION, bargraph_count, 0, 0);
		  else 
			post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_BARPOSITION, 18-bargraph_count, 0, 0);
		}
	  
	  if (s->headlights_state == ENABLE)
		{
		  headlights_count = s->count % 8;
		  if (headlights_count == 0)
			color = BLACK;
		  else if  (headlights_count == 2)
			color = GREEN;
		  else if (headlights_count == 4)
			color = ORANGE;
		  else if (headlights_count == 6)
			color = RED;
		  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_HEADLIGHT, FRONT_LEFT, color, 0);
		  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_HEADLIGHT, FRONT_RIGHT, color, 0);
		  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_HEADLIGHT, BACK_LEFT, color, 0);
		  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_HEADLIGHT, BACK_RIGHT, color, 0); 
		}
	  post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_LIGHTSHOW_PID, MSG_LOAD, 0, 0, 0);
	  s->count += 1;
	  break;
	}
  case MSG_LIGHTSHOW_DECKLIGHTS:
	{
	  if (p->byte != ENABLE && p->byte != DISABLE)
		return -EINVAL;
	  s->decklights_state = p->byte;
	  break;
	}
  case MSG_LIGHTSHOW_HEADLIGHTS:
	{
	  if (p->byte != ENABLE && p->byte != DISABLE)
		return -EINVAL;
	  s->headlights_state = p->byte;
	  break;
	}
  case MSG_LIGHTSHOW_BARGRAPH:
	{
	  if (p->byte != ENABLE && p->byte != DISABLE)
		return -EINVAL;
	  s->bargraph_state = p->byte;
	  break;
	}
  case MSG_LIGHTSHOW_STOP: 
  case MSG_FINAL:
	{
	  if (s->light_state == ENABLE) 
		{
		  s->light_state = DISABLE;
		  ker_timer_stop(RAGOBOT_LIGHTSHOW_PID, 0);
		}
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
mod_header_ptr lightshow_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif
