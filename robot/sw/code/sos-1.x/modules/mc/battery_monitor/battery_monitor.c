/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */
/*					
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
 *
 */
/** 
 * @author David Lee
 */
/**
 * @brief Provides Control of DS2438Z Battery Monitor
 */


#include <ragobot_module.h>
#include <one-wire.h>
#include <modules/battery_monitor.h>
#include <fntable.h>

//ROM FUNCTION COMMANDS
#define READROM   0x33
#define MATCHROM  0x55
#define SKIPROM   0xCC
#define SEARCHROM 0xF0

//MEMORY COMMAND FUNCTIONS
#define WRITESCRATCHPAD    0x4E
#define READSCRATCHPAD     0xBE
#define COPYSCRATCHPAD     0x48
#define RECALLMEMORY       0xB8
#define CONVERTTEMPERATURE 0x44
#define CONVERTVOLTAGE     0xB4

enum {
  IDLE = 0,
  READVOLTAGE = 1,
  READTEMPERATURE = 2,
  GETROMID = 3,
  READCURRENT = 4
};

//-----------------------------------------------------------------------------
// TYPE DEFINITIONS
//-----------------------------------------------------------------------------
typedef struct {
  func_cb_ptr one_wire_write;
  func_cb_ptr one_wire_read;
  int8_t state;   // state of this module
  uint8_t destpid; // The PID of the module that called this module
  uint8_t *data;
} batt_mon_state_t;

static int8_t module(void *start, Message *e);

static mod_header_t mod_header SOS_MODULE_HEADER = {
	mod_id : RAGOBOT_BATTERY_MONITOR_PID,
	state_size : sizeof(batt_mon_state_t),
    num_timers : 1,
	num_sub_func : 2,
	num_prov_func : 0,
	module_handler: module,
	funct: {
	  {error_8, "cCD3", RAGOBOT_ONE_WIRE_PID, ONE_WIRE_WRITE_FID},
	  {error_8, "cCD4", RAGOBOT_ONE_WIRE_PID, ONE_WIRE_READ_FID}
	},
};

static int8_t module(void *state, Message *msg)
{
  uint8_t command[3];
  uint8_t *status; 
  batt_mon_state_t *s = (batt_mon_state_t*) state;

  switch (msg->type) {
	//-------------------------------------------------------------------------
	// KERNEL MESSAGE - INITIALIZE MODULE
	//-------------------------------------------------------------------------
  case MSG_INIT:
	{
	  s->state = IDLE;
	  ker_timer_init(RAGOBOT_BATTERY_MONITOR_PID, 1, TIMER_ONE_SHOT);
	  return SOS_OK;
	}
  case MSG_GET_VOLTAGE: 
	{
	 
	  if (s->state != IDLE) 
		{
		  return -EBUSY;
		}
	  s->state = READVOLTAGE;
	  s->destpid = msg->sid;
	  command[0] = SKIPROM;
	  command[1] = CONVERTVOLTAGE;
	  SOS_CALL(s->one_wire_write, func_ri8u8u8ptru8_t, RAGOBOT_BATTERY_MONITOR_PID, command, 2);
	  //try to start timer for 10ms. If 10ms is shorter than the min interval, 
	  //set the timer interval to the min. interval 
	  if (TIMER_MIN_INTERVAL > 10) 
		{
		  ker_timer_start(RAGOBOT_BATTERY_MONITOR_PID, 1, TIMER_MIN_INTERVAL);
		}
	  else
		{
		  ker_timer_start(RAGOBOT_BATTERY_MONITOR_PID, 1, 10);
		} 
	  return SOS_OK;
	}
  case MSG_GET_TEMPERATURE: 
	{
	  if (s->state != IDLE) 
		return -EBUSY;
	  s->state = READTEMPERATURE;
	  s->destpid = msg->sid;
	  command[0] = SKIPROM;
	  command[1] = CONVERTTEMPERATURE;
	  SOS_CALL(s->one_wire_write, func_ri8u8u8ptru8_t, RAGOBOT_BATTERY_MONITOR_PID, command, 2);
	  //try to start timer for 10ms. If 10ms is shorter than the min interval, 
	  //set the timer interval to the min. interval 
	  if (TIMER_MIN_INTERVAL > 10) 
		{
		  ker_timer_start(RAGOBOT_BATTERY_MONITOR_PID, 1, TIMER_MIN_INTERVAL);
		}
	  else
		{
		  ker_timer_start(RAGOBOT_BATTERY_MONITOR_PID, 1, 10);
		} 
	  return SOS_OK;
	}
  case MSG_GET_ROM_ID: 
	{
	  if (s->state != IDLE) 
		return -EBUSY;
	  s->state = GETROMID;
	  s->destpid = msg->sid;
	  command[0] = READROM;
	  SOS_CALL(s->one_wire_read, func_ri8u8u8ptru8u8_t, RAGOBOT_BATTERY_MONITOR_PID, command, 1, 8);
	  return SOS_OK;
	}
  case MSG_GET_CURRENT:
	{
	  if (s->state != IDLE) 
		return -EBUSY;
	  s->state = READCURRENT;
	  s->destpid = msg->sid;
	  command[0] = SKIPROM;
	  command[1] = RECALLMEMORY;
	  command[2] = 0x00;
	  SOS_CALL(s->one_wire_write, func_ri8u8u8ptru8_t, RAGOBOT_BATTERY_MONITOR_PID, command, 3);
	  command[0] = SKIPROM;
	  command[1] = READSCRATCHPAD;
	  command[2] = 0x00;
	  SOS_CALL(s->one_wire_read, func_ri8u8u8ptru8u8_t, RAGOBOT_BATTERY_MONITOR_PID, command, 3, 8);
	  return SOS_OK;
	}
  case MSG_ONE_WIRE_READ_DONE:
	{
	  status = (uint8_t*) msg->data;
	  if (s->state == GETROMID)
		{
		  s->data = ker_msg_take_data(RAGOBOT_BATTERY_MONITOR_PID, msg);
		  post_long(s->destpid, RAGOBOT_BATTERY_MONITOR_PID, MSG_GET_ROM_ID_DONE, msg->len, s->data, SOS_MSG_RELEASE); 
		}
	  else if (s->state == READVOLTAGE)
		{ 
		  //if the conversion has not finished, try again later. Otherwise return the voltage.
		  if ((*status & 0x40) != 0)
			{
			  //retry reading from  battery monitor at min. interval 
			  ker_timer_start(RAGOBOT_BATTERY_MONITOR_PID, 1, TIMER_MIN_INTERVAL);
			}
		  else 
			{
			  post_short(s->destpid, RAGOBOT_BATTERY_MONITOR_PID, MSG_GET_VOLTAGE_DONE, 0, *((uint16_t*)(msg->data+3)), 0);
			}
		}
	  else if (s->state == READTEMPERATURE)
		{
		  //if the conversion has not finished, try again later. Otherwise return the temperature.
		  if ((*status & 0x10) != 0)
			{
			  //retry reading from  battery monitor at min. interval 
			  ker_timer_start(RAGOBOT_BATTERY_MONITOR_PID, 1, TIMER_MIN_INTERVAL);
			}
		  else 
			{
			  post_short(s->destpid, RAGOBOT_BATTERY_MONITOR_PID, MSG_GET_TEMPERATURE_DONE, 0, *((uint16_t*)(msg->data+1)), 0);
			}
		}
	  else if (s->state == READCURRENT)
		{
		  post_short(s->destpid, RAGOBOT_BATTERY_MONITOR_PID, MSG_GET_CURRENT_DONE, 0, *((uint16_t*)(msg->data+5)), 0);
		}
	  s->state = IDLE;
	  return SOS_OK;
	}
  case MSG_TIMER_TIMEOUT:
	{
	  if(s->state == READVOLTAGE) 
		{
		  command[0] = SKIPROM;
		  command[1] = RECALLMEMORY;
		  command[2] = 0x00;
		  
		  SOS_CALL(s->one_wire_write, func_ri8u8u8ptru8_t, RAGOBOT_BATTERY_MONITOR_PID, command, 3);
   
		  command[0] = SKIPROM;
		  command[1] = READSCRATCHPAD;
		  command[2] = 0x00;
		  SOS_CALL(s->one_wire_read, func_ri8u8u8ptru8u8_t, RAGOBOT_BATTERY_MONITOR_PID, command, 3, 5);
		}
	  else if (s->state == READTEMPERATURE)
		{
		  command[0] = SKIPROM;
		  command[1] = RECALLMEMORY;
		  command[2] = 0x00;
		  SOS_CALL(s->one_wire_write, func_ri8u8u8ptru8_t, RAGOBOT_BATTERY_MONITOR_PID, command, 3);
		  command[0] = SKIPROM;
		  command[1] = READSCRATCHPAD;
		  command[2] = 0x00;
		  SOS_CALL(s->one_wire_read, func_ri8u8u8ptru8u8_t, RAGOBOT_BATTERY_MONITOR_PID, command, 3, 3);
		}
	  return SOS_OK;
	}
  case MSG_FINAL:
	{
	  return SOS_OK;
	}
  default:
	return -EINVAL;
  }
}

//-----------------------------------------------------------------------------
// APPLICATION INITIALIZATION
//-----------------------------------------------------------------------------
#ifndef _MODULE_
mod_header_ptr battery_monitor_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif

