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
 * @brief Motorcontrol module
 * 
 *
 */
 
#ifndef _MODULE_
#include <sos.h>
#else 
#include <module.h>
#endif
#include <modules/ragobot_mod_pid.h>
#include <modules/cb2bus.h>
#include <modules/motorcontrol.h>

#ifndef _MODULE_
int8_t mcontrol_module(void *state, Message *msg)
#else
/**
 * Module state and ID declaration.
 */

DECL_MOD_STATE(mcontrol_state);
DECL_MOD_ID(RAGOBOT_MCONTROL_PID);

SOS_MODULE
int8_t module(void *state, Message *msg)
#endif
{
	mcontrol_state *s = (mcontrol_state*)state;
	MsgParam *p = (MsgParam*)(msg->data);

	switch (msg->type)
	{
		case MSG_INIT:
		{  
			s->pid = msg->did;
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
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, s->speed, 0);				
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);

			if(ker_i2c_send_data( IRMAN_ADDRESS, &s->speed, sizeof(s->speed), s->pid) != SOS_OK)
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
			return SOS_OK;
		}	
	
		default:
			return -EINVAL;
	}
	return SOS_OK;
}
	
#ifndef _MODULE_
int8_t motorcontrol_init()
{
  return ker_register_task(RAGOBOT_MCONTROL_PID, sizeof(mcontrol_state), mcontrol_module);
}
#endif
