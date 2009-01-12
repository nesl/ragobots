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
 * @brief Provides Direct Access, Control of the Virtual Expansion Ports (CB2)
 * Also Provides High-Level Control over the Functions Attached to CB2
 */

#ifndef _MODULE_
#include <sos.h>
#include <mica2_peripheral.h>
#else 
#include <ragobot_module.h>
#endif

#include <modules/ragobot_mod_pid.h>
#include <modules/battery_monitor.h>
#include <timer_stub.h>

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
#define CONVERTTEMPERATUTE 0x44
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
  int8_t state;   // state of this module
  uint8_t pid;    // !RAGOBOT_BATTERY_MONITOR_PID
  uint8_t destpid; // The PID of the module that called this module
} batt_mon_state;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : CB2 : PRIVATE FUNCTIONS : LOW-LEVEL
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//! Macros to assist the Perl Script
#ifdef _MODULE_
DECL_MOD_STATE(batt_mon_state);
DECL_MOD_ID(RAGOBOT_BATTERY_MONITOR_PID);
#endif

#ifndef _MODULE_
int8_t battery_monitor_module(void *state, Message *msg)
#else
int8_t module(void *state, Message *msg)
#endif
{
  uint8_t command[3];
  uint8_t *status; 
  batt_mon_state *s = (batt_mon_state*) state;
  //MsgParam *p = (MsgParam*)(msg->data);

  switch (msg->type) {
	//-------------------------------------------------------------------------
	// KERNEL MESSAGE - INITIALIZE MODULE
	//-------------------------------------------------------------------------
  case MSG_INIT:
	{
	  s->state = IDLE;
	  s->pid = msg->did;
	  return SOS_OK;
	}
  case MSG_GET_VOLTAGE: 
	{
	  if (s->state != IDLE) 
		return -EBUSY;
	  s->state = READVOLTAGE;
	  s->destpid = msg->sid;
	  command[0] = SKIPROM;
	  command[1] = CONVERTVOLTAGE;
	  ker_one_wire_write(s->pid, command, 2);
	  //try to start timer for 10ms. If 10ms is shorter than the min interval, 
	  //set the timer interval to the min. interval 
	  if (TIMER_MIN_INTERVAL > 10) 
		{
		  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, TIMER_MIN_INTERVAL);
		}
	  else
		{
		  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, 10);
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
	  command[1] = CONVERTVOLTAGE;
	  ker_one_wire_write(s->pid, command, 2);
	  //try to start timer for 10ms. If 10ms is shorter than the min interval, 
	  //set the timer interval to the min. interval 
	  if (TIMER_MIN_INTERVAL > 10) 
		{
		  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, TIMER_MIN_INTERVAL);
		}
	  else
		{
		  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, 10);
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
	  ker_one_wire_read(s->pid, command, 1, 8);  
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
	  ker_one_wire_write(s->pid, command, 3);  
	  command[0] = SKIPROM;
	  command[1] = READSCRATCHPAD;
	  command[2] = 0x00;
	  ker_one_wire_read(s->pid, command, 3, 8); 
	  return SOS_OK;
	}
  case MSG_ONE_WIRE_READ_DONE:
	{
	  status = (uint8_t*) msg->data;
	  if (s->state == GETROMID)
		{
		  post_long(s->destpid, s->pid, MSG_GET_ROM_ID_DONE, msg->len, msg->data, SOS_MSG_DYM_MANAGED); 
		}
	  else if (s->state == READVOLTAGE)
		{ 
		  //if the conversion has not finished, try again later. Otherwise return the voltage.
		  if ((*status & 0x40) != 0)
			{
			  //retry reading from  battery monitor at min. interval 
			  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, TIMER_MIN_INTERVAL);
			}
		  else 
			{
			  post_short(s->destpid, s->pid, MSG_GET_VOLTAGE_DONE, 0, *((uint16_t*)(msg->data+3)), 0);
			}
		}
	  else if (s->state == READTEMPERATURE)
		{
		  //if the conversion has not finished, try again later. Otherwise return the temperature.
		  if ((*status & 0x10) != 0)
			{
			  //retry reading from  battery monitor at min. interval 
			  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, TIMER_MIN_INTERVAL);
			}
		  else 
			{
			  post_short(s->destpid, s->pid, MSG_GET_TEMPERATURE_DONE, 0, *((uint16_t*)(msg->data+1)), 0);
			}
		}
	  else if (s->state == READCURRENT)
		{
		  post_short(s->destpid, s->pid, MSG_GET_CURRENT_DONE, 0, *((uint16_t*)(msg->data+5)), 0);
		}
	  s->state = IDLE;
	  return SOS_TAKEN;
	}
  case MSG_TIMER_TIMEOUT:
	{
	  if(s->state == READVOLTAGE) 
		{
		  command[0] = SKIPROM;
		  command[1] = RECALLMEMORY;
		  command[2] = 0x00;
		  ker_one_wire_write(s->pid, command, 3); 
		  command[0] = SKIPROM;
		  command[1] = READSCRATCHPAD;
		  command[2] = 0x00;
		  ker_one_wire_read(s->pid, command, 3, 5);
		}
	  else if (s->state == READTEMPERATURE)
		{
		  command[0] = SKIPROM;
		  command[1] = RECALLMEMORY;
		  command[2] = 0x00;
		  ker_one_wire_write(s->pid, command, 3); 
		  command[0] = SKIPROM;
		  command[1] = READSCRATCHPAD;
		  command[2] = 0x00;
		  ker_one_wire_read(s->pid, command, 3, 3); 
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
int8_t battery_monitor_module_init()
{  
  return ker_register_task(RAGOBOT_BATTERY_MONITOR_PID, sizeof(batt_mon_state), battery_monitor_module);
}
#endif
