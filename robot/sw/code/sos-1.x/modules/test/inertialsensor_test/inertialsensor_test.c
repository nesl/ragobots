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
 * @brief A module to test the inertial sensor module
 * 
 */

#include <ragobot_module.h>
#include <modules/inertialsensor.h>
#include <pushbutton.h>
#include <fntable.h>
#include <led.h>

//State definition
enum {
  IDLE,
  GET_READINGS,
  DISPLAY_MAGX,
  DISPLAY_MAGY,
  DISPLAY_MAGZ,
  DISPLAY_ACCX,
  DISPLAY_ACCY,
  DISPLAY_ACCZ
};

typedef struct{
  func_cb_ptr pushbutton_register;
  func_cb_ptr pushbutton_deregister;
  uint8_t pid;
  uint8_t state;
  uint16_t magx;
  uint16_t magy;
  uint16_t magz;
  uint16_t accx;
  uint16_t accy;
  uint16_t accz;
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
  uint16_t *data;
  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  s->state = IDLE;	  
	  SOS_CALL(s->pushbutton_register, func_ri8u8_t, s->pid);
	  break;
	}
  case MSG_PUSHBUTTON_PRESSED:
	{
	  switch (s->state) 
		{
		case IDLE:
		  {
			s->state = GET_READINGS;
			post_short(RAGOBOT_INERTIALSENSOR_PID, s->pid, MSG_GET_INERTIAL_READINGS, 0, 0, 0); 
			break;
		  } 
		case DISPLAY_MAGX:
		  {
			s->state = DISPLAY_MAGY;
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, s->magy, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
			break;
		  }
		case DISPLAY_MAGY:
		  {
			s->state = DISPLAY_MAGZ;
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, s->magz, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
			break;
		  }
		case DISPLAY_MAGZ:
		  {
			s->state = DISPLAY_ACCX;
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, s->accx, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
			break;
		  }
		case DISPLAY_ACCX:
		  {
			s->state = DISPLAY_ACCY;
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, s->accy, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
			break;
		  }
		case DISPLAY_ACCY:
		  {
			s->state = DISPLAY_ACCZ;
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, s->accz, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
			break;
		  }
		case DISPLAY_ACCZ:
		  {
			s->state = IDLE;
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, 0, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
			break;
		  }
		}
	  break;
	}	
  case MSG_GET_INERTIAL_READINGS_DONE:
	{
	  data = (uint16_t*) (msg->data);
	  s->magx = data[0];
	  s->magy = data[1];
	  s->magz = data[2];
	  s->accx = data[3];
	  s->accy = data[4];
	  s->accz = data[5];

	  s->state = DISPLAY_MAGX;
	  
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, s->magx, 0);
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
	  break;
	}
  case MSG_GET_INERTIAL_READINGS_FAIL:
	{
	  ker_led(LED_RED_TOGGLE);
	  s->state = IDLE;
	  break;
	}
  case MSG_FINAL:
	{
	  //deregister from pushbutton
	  SOS_CALL(s->pushbutton_deregister, func_ri8u8_t, s->pid);
	  break;
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
mod_header_ptr inertialsensor_test_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif

