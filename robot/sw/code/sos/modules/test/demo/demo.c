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
 * @brief IPSN demo
 *
 */

#ifndef _MODULE_
#include <sos.h>
#include <info.h>
#else
#include <module.h>
#endif
#include <modules/ragobot_mod_pid.h>
//#include <mica2_peripheral.h>
#include <ragobot_module.h>
#include <pushbutton.h>
#include <servos.h>
#include <modules/cb2bus.h>
#include <modules/lightshow.h>
#include <modules/motorcontrol.h>
#include <irranger.h>

enum
{
	IRRANGER_TIMER = 0,
	MOTOR_TIMER = 1,

	SPEED_CHANGE_PKT = (MOD_MSG_START+0),
	DATA_TRANSMISSION = (MOD_MSG_START+1),
	MSG_REMOTE_PUSHBUTTON_PRESSED = (MOD_MSG_START+2),
	
	PAN_DEGREES_CHANGE = 20,
	
	IDLE = 0,
	MOVING = 1,
	SCANNING = 2,
	
	IRRANGER_TIMER_PERIOD = 512,
	MINIMUM_DISTANCE = 20,
};

// maybe they have to be added to servos.h
#define MAX_PAN 90 // Allowable maximum turn in one direction for PAN servo
#define MIN_PAN -90 // Allowable minimum turn in one direction for PAN servo
#define MAX_TILT 90 // Allowable maximum turn in one direction for PAN servo
#define MIN_TILT -20 // Allowable minimum turn in one direction for TILT servo

typedef struct
{
	uint8_t pid;
	uint8_t state;
	uint8_t temp_state;
	uint8_t temp_speed;
	uint8_t distance;
	int8_t panpos;
	int8_t tiltpos;
	int8_t pan_direction; //-1=going left and 1=going right
	int8_t move_direction;
	uint8_t max_distance;
	uint8_t current_speed;
	uint8_t measurements[(MAX_PAN - MIN_PAN)/PAN_DEGREES_CHANGE];
	uint8_t values_read;
} app_state_t;

#ifndef _MODULE_
int8_t demo_test_module(void* state, Message *msg)
#else

DECL_MOD_STATE(app_state_t);
DECL_MOD_ID(DFLT_APP_ID0);

int8_t module(void *state, Message *msg)
#endif
{
	app_state_t *s = (app_state_t*) state;
	MsgParam* p = (MsgParam*) msg->data;	
	
	switch (msg->type){
	case MSG_INIT:
	{
		led_yellow_on();
		s->pid = msg->did;
		s->state = IDLE;
		
		s->panpos = 0;
		s->tiltpos = 0;
		
		s->move_direction = 0;
		s->max_distance = 0;

		s->current_speed = MOTOR_STOP;

		ker_pushbutton_register(s->pid);

		if(ker_servo_set_position(PANSERVO, s->panpos) != SOS_OK)
		{
			led_red_on();
			break;
		}	

		if(ker_servo_set_position(TILTSERVO, s->tiltpos) != SOS_OK)
		{
			led_red_on();
			break;
		}	
		
		//if(ker_irranger_trigger(s->pid)==-EBUSY) {led_red_toggle();}
		return SOS_OK;		
	}
	case MSG_TIMER_TIMEOUT:
	{
		switch(p->byte)
		{
			
			case IRRANGER_TIMER:
			{
				if(ker_irranger_trigger(s->pid)==-EBUSY) {led_red_toggle();}
				return SOS_OK;
			}
			case MOTOR_TIMER:
			{
				s->current_speed = MOTOR_FULL_SPEED;
				post_short(RAGOBOT_MCONTROL_PID, s->pid, MSG_CHANGE_SPEED, MOTOR_FULL_SPEED, 0, 0);
				
				post_net(s->pid, s->pid, SPEED_CHANGE_PKT, sizeof(s->current_speed), &s->current_speed, 0, BCAST_ADDRESS);
				ker_timer_start(s->pid, IRRANGER_TIMER, TIMER_REPEAT, IRRANGER_TIMER_PERIOD);
				return SOS_OK;
			}
			default:
				return SOS_OK;
		}
	}
	case MSG_IRRANGER_FINISHED:
	{
		s->distance = p->byte;
		//post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, s->distance, 0);
		//post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);		
		switch(s->state)
		{
			case IDLE:
			{
				if(s->distance > MINIMUM_DISTANCE)
				{
					s->state = 	MOVING;
					post_short(RAGOBOT_MCONTROL_PID, s->pid, MSG_CHANGE_SPEED, MOTOR_FULL_SPEED, 0, 0);
					s->current_speed = MOTOR_FULL_SPEED;
					return SOS_OK;
				}
			}
			case MOVING:
			{
				if(s->distance <= MINIMUM_DISTANCE)
				{
					post_short(RAGOBOT_MCONTROL_PID, s->pid, MSG_CHANGE_SPEED, MOTOR_STOP, 0, 0);
					
					s->current_speed = MOTOR_STOP;
					post_net(s->pid, s->pid, SPEED_CHANGE_PKT, sizeof(s->current_speed), &s->current_speed, 0, BCAST_ADDRESS);
					ker_timer_stop(s->pid, IRRANGER_TIMER);
					
					s->state = SCANNING;
					
					s->move_direction = 0;
					s->max_distance = 0;
				
					s->panpos = MAX_PAN;
					if(ker_servo_set_position(PANSERVO, MAX_PAN) != SOS_OK)
						led_red_on();
					post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_BARGRAPH, ENABLE, 0, 0);
					post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_HEADLIGHTS, ENABLE, 0, 0);
					post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_DECKLIGHTS, ENABLE, 0, 0);
					post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_START, 0, 0, 0);
					
					if(ker_irranger_trigger(s->pid)==-EBUSY) 
					{
						led_red_toggle();
						post_short(s->pid, s->pid, MSG_IRRANGER_FINISHED, s->distance, 0, 0);
					}
					
				}
				
				return SOS_OK;
			}
			case SCANNING:
			{
				led_yellow_toggle();
				if ((s->distance > s->max_distance) && (s->distance > MINIMUM_DISTANCE))
				{
					s->max_distance = s->distance;
					s->move_direction = s->panpos;
				}
				
				if (s->panpos > MIN_PAN)
				{
					if(ker_irranger_trigger(s->pid)==-EBUSY) 
					{
						post_short(s->pid, s->pid, MSG_IRRANGER_FINISHED, s->distance, 0, 0);
						led_red_toggle();
					}
					else
					{
						s->panpos = (int8_t)(s->panpos - PAN_DEGREES_CHANGE);
						if(ker_servo_set_position(PANSERVO, s->panpos) != SOS_OK)
						{
							led_red_on();
							break;
						}
					}

					return SOS_OK;					
				}
				else
				{
					
					if (s->max_distance > 0)
					{
						s->panpos = 0;
						led_green_on();
						if(ker_servo_set_position(PANSERVO, (int8_t)0) != SOS_OK)
						{
							led_red_on();
							break;
						} 

						s->state = MOVING;
							
						if( s->move_direction < 0)
						{
							post_short(RAGOBOT_MCONTROL_PID, s->pid, MSG_CHANGE_SPEED, MOTOR_RIGHT_MAX, 0, 0);
							s->current_speed = RGT_FWD_MAX;
							ker_timer_start(s->pid, MOTOR_TIMER, TIMER_ONE_SHOT, -s->move_direction*12);
						}
						else
						{
							post_short(RAGOBOT_MCONTROL_PID, s->pid, MSG_CHANGE_SPEED, MOTOR_LEFT_MAX, 0, 0);
							s->current_speed = LFT_FWD_MAX;
							ker_timer_start(s->pid, MOTOR_TIMER, TIMER_ONE_SHOT, s->move_direction*12);
						}
						post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_DECKLIGHTS, DISABLE, 0, 0);
						post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_HEADLIGHTS, DISABLE, 0, 0);
						post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_BARGRAPH, DISABLE, 0, 0);
						post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_STOP, 0, 0, 0);	
						post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_BARGRAPH, DISABLE, 0, 0);
						post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_CLEARDECKLIGHTS, 0, 0, 0);
						post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, FRONT_LEFT, BLACK, 0);
						post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, FRONT_RIGHT, BLACK, 0);
						post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, BACK_LEFT, BLACK, 0);
						post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, BACK_RIGHT, BLACK, 0);
						post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, 0, 0);				
						post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
						s->move_direction = 0;
						s->max_distance = 0;
					}
					else
						led_red_on();
					break;
				}
			default: 
				break;
			}
		}
		return SOS_OK;		
	}
	case MSG_PUSHBUTTON_PRESSED:
	{
		switch(s->state)
		{
			case IDLE:
			{
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_SERVO_EN, ENABLE, 0, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_IRR_EN, ENABLE, 0, 0); 
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_5V_EN, ENABLE, 0, 0); 
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, 0, 0);				
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
				ker_timer_start(s->pid, IRRANGER_TIMER, TIMER_REPEAT, IRRANGER_TIMER_PERIOD);
				s->temp_speed = MOTOR_FULL_SPEED;
				post_net(s->pid, s->pid, MSG_REMOTE_PUSHBUTTON_PRESSED, sizeof(s->temp_speed), &s->temp_speed, 0, BCAST_ADDRESS);
				break;
			}
			case SCANNING:    //fall through
				if(ker_servo_set_position(PANSERVO, 0) != SOS_OK)
				{
					/* led_red_on(); */
					break;
				}	
				// continues to moving state
			case MOVING:
			{
				s->state = 	IDLE;
				post_short(RAGOBOT_MCONTROL_PID, s->pid, MSG_CHANGE_SPEED, MOTOR_STOP, 0, 0);
				s->current_speed = MOTOR_STOP;
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, FRONT_LEFT, BLACK, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, FRONT_RIGHT, BLACK, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, BACK_LEFT, BLACK, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, BACK_RIGHT, BLACK, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, 0, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);	
				post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_DECKLIGHTS, DISABLE, 0, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_CLEARDECKLIGHTS, 0, 0, 0);
				post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_STOP, 0, 0, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_SERVO_EN, DISABLE, 0, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_IRR_EN, DISABLE, 0, 0); 
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_5V_EN, DISABLE, 0, 0); 
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);

				ker_timer_stop(s->pid, IRRANGER_TIMER);
				post_net(s->pid, s->pid, MSG_REMOTE_PUSHBUTTON_PRESSED, sizeof(s->current_speed), &s->current_speed, 0, BCAST_ADDRESS);
				break;
			}
			default:
				return SOS_OK;
		}
		return SOS_OK;
	}
	case MSG_REMOTE_PUSHBUTTON_PRESSED:
	{
		switch(s->state)
		{
			case IDLE:
			{
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_SERVO_EN, ENABLE, 0, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_IRR_EN, ENABLE, 0, 0); 
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_5V_EN, ENABLE, 0, 0); 
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, 0, 0);				
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);
				ker_timer_start(s->pid, IRRANGER_TIMER, TIMER_REPEAT, IRRANGER_TIMER_PERIOD);
				break;
			}
			case SCANNING:    //fall through
				if(ker_servo_set_position(PANSERVO, 0) != SOS_OK)
				{
					/* led_red_on(); */
					break;
				}	
				// continues to moving state
			case MOVING:
			{
				s->state = 	IDLE;
				post_short(RAGOBOT_MCONTROL_PID, s->pid, MSG_CHANGE_SPEED, MOTOR_STOP, 0, 0);
				s->current_speed = MOTOR_STOP;
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, FRONT_LEFT, BLACK, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, FRONT_RIGHT, BLACK, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, BACK_LEFT, BLACK, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, BACK_RIGHT, BLACK, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, 0, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);	
				post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_DECKLIGHTS, DISABLE, 0, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_CLEARDECKLIGHTS, 0, 0, 0);
				post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_STOP, 0, 0, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_SERVO_EN, DISABLE, 0, 0);
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_IRR_EN, DISABLE, 0, 0); 
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_5V_EN, DISABLE, 0, 0); 
				post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);

				ker_timer_stop(s->pid, IRRANGER_TIMER);
				break;
			}
			default:
				return SOS_OK;
		}
		return SOS_OK;		
	}
	case SPEED_CHANGE_PKT:
	{
		//if all the robots have to stop, then they stop
		//afterwards each robot continues with its previous speed
		if(msg->data[0] == MOTOR_STOP)
		{
			post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_BARGRAPH, ENABLE, 0, 0);
			post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_HEADLIGHTS, ENABLE, 0, 0);
			post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_DECKLIGHTS, ENABLE, 0, 0);
			post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_START, 0, 0, 0);
			post_short(RAGOBOT_MCONTROL_PID, s->pid, MSG_CHANGE_SPEED, MOTOR_STOP, 0, 0);
		}
		else
		{
			post_short(RAGOBOT_MCONTROL_PID, s->pid, MSG_CHANGE_SPEED, s->current_speed, 0, 0);
			post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_DECKLIGHTS, DISABLE, 0, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, FRONT_LEFT, BLACK, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, FRONT_RIGHT, BLACK, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, BACK_LEFT, BLACK, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_HEADLIGHT, BACK_RIGHT, BLACK, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_BARBINARY, 0, 0, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_CLEARDECKLIGHTS, 0, 0, 0);
			post_short(RAGOBOT_LIGHTSHOW_PID, s->pid, MSG_LIGHTSHOW_STOP, 0, 0, 0);
			post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0);

		}		
		return SOS_OK;
	}
	case MSG_FINAL:
	{
		post_short(RAGOBOT_MCONTROL_PID, s->pid, MSG_CHANGE_SPEED, MOTOR_STOP, 0, 0);
		ker_timer_stop(s->pid, IRRANGER_TIMER);
		ker_timer_stop(s->pid, MOTOR_TIMER);
		return SOS_OK;
	}
	default:
		return SOS_OK;
	}
  
	return SOS_OK;
}

#ifndef _MODULE_
int8_t demo_test_init()
{
	return ker_register_task(DFLT_APP_ID0, sizeof(app_state_t), demo_test_module);
}
#endif
