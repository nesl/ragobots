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
 * @author David Lee
 */
/**
 * @brief Motorcontrol module
 * 
 * Provides motor control to drive the robot around
 */
 
#include <ragobot_module.h>
#include <hipri_int.h>
#include <modules/motorcontrol.h>
#include <fntable.h>

#define IRMAN_ADDRESS 42

typedef struct {
  func_cb_ptr hipri_int_register;
  func_cb_ptr hipri_int_deregister;
  func_cb_ptr hipri_int_reset;
  uint8_t speed;
} mcontrol_state_t;

static int8_t module(void *state, Message *msg);

static mod_header_t mod_header SOS_MODULE_HEADER = {
	mod_id : RAGOBOT_MCONTROL_PID,
	state_size : sizeof(mcontrol_state_t),
    num_timers : 0,
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
	mcontrol_state_t *s = (mcontrol_state_t*)state;
	MsgParam *p = (MsgParam*)(msg->data);

	switch (msg->type)
	{
		case MSG_INIT:
		{  
			s->speed = MOTOR_STOP;
			//register module to recieve hipri_int events
			SOS_CALL(s->hipri_int_register, func_ri8u8_t, RAGOBOT_MCONTROL_PID);
			return SOS_OK;
		}	
		
		case MSG_HIPRI_INT:
		  {
			s->speed = MOTOR_STOP;
			return SOS_OK;
		  }
		case MSG_CHANGE_SPEED:
		{
			switch(p->byte & MOTOR_CHANGE_MASK)
			{
				case LEFT_MOTOR_CHANGE:
				{
					s->speed = s->speed & CHANGE_LEFT_MASK;
					s->speed = s->speed | (p->byte & (~MOTOR_CHANGE_MASK));
					break;					
				}
				case RIGHT_MOTOR_CHANGE:
				{
					s->speed = s->speed & CHANGE_RIGHT_MASK;
					s->speed = s->speed | (p->byte & (~MOTOR_CHANGE_MASK));
					break;					
				}
				case BOTH_MOTOR_CHANGE:
				{
					s->speed = p->byte & (~MOTOR_CHANGE_MASK);
					break;
				}
				default:
				{
					s->speed = MOTOR_STOP;	
					break;				
				}
			}
			
			if (ker_i2c_send_data(IRMAN_ADDRESS, &s->speed, sizeof(s->speed), RAGOBOT_MCONTROL_PID) != SOS_OK)
			  {
				return -EBUSY;
			  }

			return SOS_OK;
			
		}
		case MSG_I2C_SEND_DONE:
		{
			return SOS_OK;
		}
		case MSG_FINAL:
		{
		  SOS_CALL(s->hipri_int_deregister, func_ri8u8_t, RAGOBOT_MCONTROL_PID);
		  return SOS_OK;
		}	
	
		default:
			return -EINVAL;
	}
	return SOS_OK;
}

//-----------------------------------------------------------------------------
// APPLICATION INITIALIZATION
//-----------------------------------------------------------------------------
#ifndef _MODULE_
mod_header_ptr mcontrol_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif
