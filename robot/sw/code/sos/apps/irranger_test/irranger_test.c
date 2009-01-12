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
 * @brief An application to test the IR Ranger
 * 
 */

#include <sos.h>
#include <led.h>
#include <id.h>
#include <irranger.h>
#include <modules/ragobot_mod_pid.h>
#include <modules/cb2bus.h>
#include "mica2_peripheral.h"

#define IRRANGER_TIMER 1
#define  MSG_NOTHING MOD_MSG_START

typedef struct{
  uint8_t pid;
  uint16_t count;
  uint8_t distance;
} app_state_t;

static int8_t app_handler(void *state, Message *msg){
  app_state_t *s = (app_state_t*) state;
  MsgParam* p = (MsgParam*) msg->data;

  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  s->count = 0;
	  //testing IR Ranger
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_IRR_EN, ENABLE, 0, 0); 
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
	  ker_timer_start(s->pid, IRRANGER_TIMER, TIMER_REPEAT, 1024);
	  break;
	}
	case MSG_TIMER_TIMEOUT:
	{
	if(ker_irranger_trigger(DFLT_APP_ID0)==-EBUSY) {led_red_toggle();}
		return SOS_OK;
	}
	case MSG_IRRANGER_FINISHED:
	{
		s->distance = p->byte;
		//led_green_toggle();
		//s->count += 1;
		post_short(RAGOBOT_CB2BUS_PID, DFLT_APP_ID0, MSG_BARBINARY, 0, s->distance, 0);
		post_short(RAGOBOT_CB2BUS_PID, DFLT_APP_ID0, MSG_LOAD, 0, 0, 0);
		post_net(DFLT_APP_ID0, DFLT_APP_ID0, MSG_NOTHING, sizeof(s->distance), &s->distance, SOS_MSG_DYM_MANAGED,  BCAST_ADDRESS);
		return SOS_OK;
	}
	case MSG_NOTHING:
		
		return SOS_OK;
	default:
		break;
  }
  
  return SOS_OK;
}


void sos_start(void){
  cb2bus_module_init();
  ker_register_task(DFLT_APP_ID0, sizeof(app_state_t), app_handler);
}
