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
 * @brief An application to test the hipri interrupt from IRMAN
 * 
 * When the hipri interrupt is received, the decklight1 led toggles
 *
 */

#include <ragobot_module.h>
#include <hipri_int.h>
#include <fntable.h>
#include <led.h>
#define ALERTREG_ADDRESS 0x3F //the i2c address of the alert register
typedef struct{
  func_cb_ptr hipri_int_register;
  func_cb_ptr hipri_int_deregister;
  uint8_t pid;
  uint8_t i2c_packet[1];
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
		  {error_8, "cCv1", RAGOBOT_HIPRI_INT_PID, HIPRI_INT_REGISTER_FID},
		  {error_8, "cCv1", RAGOBOT_HIPRI_INT_PID, HIPRI_INT_DEREGISTER_FID}
	},
};

static int8_t module(void *state, Message *msg)
{
  app_state_t *s = (app_state_t*) state;
  uint8_t *data;
  switch (msg->type){
  case MSG_INIT:
	{
	  s->pid = msg->did;
	  if ((SOS_CALL(s->hipri_int_register, func_ri8u8_t, s->pid))==-EINVAL) 
		{
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT6, ON, 0, 0);
		  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
		}
	  
	  ker_timer_init(s->pid, 0, TIMER_REPEAT);
	  ker_timer_start(s->pid, 0, 1000);	 
	  break;
	}
	
  case MSG_HIPRI_INT:
	{
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_DECKLIGHT1, TOGGLE, 0, 0);
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
	  //s->i2c_packet[0] = 0x00;
	  //while (ker_i2c_send_data(ALERTREG_ADDRESS, s->i2c_packet, sizeof(s->i2c_packet), s->pid) != SOS_OK);
	  break;
	}

  case MSG_TIMER_TIMEOUT:
	{
	  ker_led(LED_RED_TOGGLE);
	  s->i2c_packet[0] = 0x00;
	  while (ker_i2c_send_data(ALERTREG_ADDRESS, s->i2c_packet, sizeof(s->i2c_packet), s->pid) != SOS_OK);
	  //post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, PORTE, 0);
	  //post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
	  break;
	}
  case MSG_I2C_SEND_DONE:
	{
	  while ((ker_i2c_read_data(ALERTREG_ADDRESS, 1, s->pid)) != SOS_OK);
	  break;
	}
  case MSG_I2C_READ_DONE:
	{
	  data = (uint8_t*) msg->data;  
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, (uint16_t)data[0], 0);
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
	  ker_timer_start(s->pid, 0, 1000);	  
	  break;
	}
  case MSG_FINAL:
	{
	  ker_timer_stop(s->pid, 0);
	  SOS_CALL(s->hipri_int_deregister, func_ri8u8_t, s->pid);
	  break;
	}
  }
  
  return SOS_OK;
}

#ifndef _MODULE_
mod_header_ptr hipri_int_test_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif

