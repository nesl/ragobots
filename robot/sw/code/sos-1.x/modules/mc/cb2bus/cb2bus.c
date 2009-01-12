/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4: */
/*   tab:4 */
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
 * @author Jonathan Friedman jf@ee.ucla.edu
 * @author David Lee (Ported to SOS and Modified for Rev. B)
 */
/**
 * @brief Provides Direct Access, Control of the Virtual Expansion Ports (CB2)
 * Also Provides High-Level Control over the Functions Attached to CB2
 */

 
#include <ragobot_module.h>
#include <fntable.h>
#include <hardware.h>
//-----------------------------------------------------------------------------
// TYPE DEFINITIONS
//-----------------------------------------------------------------------------
typedef struct {
  func_cb_ptr cb2bus_load;
  int8_t state;   // state of this module
  //! RAGOBOT CONFIGURATION BITS TO BE SHIFT OUT ONTO CB2
  //! If adding more shift registers to cb2, add another element to this.
  uint8_t config[4];
} cb2bus_state;

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : CB2 : PRIVATE FUNCTIONS : LOW-LEVEL
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//-----------------------------------------------------------------------------
// PRIVATE FUNCTIONS
//-----------------------------------------------------------------------------
static inline void CB2_init(cb2bus_state *s);
static inline void setColor(cb2bus_state *s, uint8_t pin1, uint8_t pin2, uint16_t color); 
static inline void decklight1(cb2bus_state *s, uint8_t cmd);
static inline void decklight2(cb2bus_state *s, uint8_t cmd);
static inline void decklight3(cb2bus_state *s, uint8_t cmd);
static inline void decklight4(cb2bus_state *s, uint8_t cmd);
static inline void decklight5(cb2bus_state *s, uint8_t cmd);
static inline void decklight6(cb2bus_state *s, uint8_t cmd);
static inline void cleardecklights(cb2bus_state *s, uint8_t cmd);
static inline void barPosition(cb2bus_state *s, uint8_t number);
static inline void barPercent(cb2bus_state *s, uint8_t number);
static inline void barBinary(cb2bus_state *s, uint16_t number);
static inline void headlight(cb2bus_state *s, uint8_t position, uint16_t color);
static int8_t module(void *start, Message *e);

static mod_header_t mod_header SOS_MODULE_HEADER = 
{
	mod_id : RAGOBOT_CB2BUS_PID,
	state_size : sizeof(cb2bus_state),
	num_timers: 1,
	num_sub_func : 1,
	num_prov_func : 0,
	module_handler: module,
	funct: {
	  {error_v, "vDC2", RAGOBOT_CB2BUS_HARDWARE_PID, CB2BUS_LOAD_FID},
	},  
};

static int8_t module(void *state, Message *msg)
{
  cb2bus_state *s = (cb2bus_state*) state;
  MsgParam *p = (MsgParam*)(msg->data);

  switch (msg->type) {
	//-------------------------------------------------------------------------
	// KERNEL MESSAGE - INITIALIZE MODULE
	//-------------------------------------------------------------------------
  case MSG_INIT:
	{
	  CB2_init(s);
	  return SOS_OK;
	}
  case MSG_DECKLIGHT1: 
	{
	  
	  decklight1(s, p->byte);
	  return SOS_OK;
	}
  case MSG_DECKLIGHT2: 
	{
	  decklight2(s, p->byte);
	  return SOS_OK;
	}
  case MSG_DECKLIGHT3: 
	{
	  decklight3(s, p->byte);
	  return SOS_OK;
	}
  case MSG_DECKLIGHT4: 
	{
	  decklight4(s, p->byte);
	  return SOS_OK;
	}
  case MSG_DECKLIGHT5: 
	{
	  decklight5(s, p->byte);
	  return SOS_OK;
	}
  case MSG_DECKLIGHT6: 
	{
	  decklight6(s, p->byte);
	  return SOS_OK;
	}
  case MSG_CLEARDECKLIGHTS: 
  	{
	  cleardecklights(s, p->byte);
	  return SOS_OK;
	}
  case MSG_BARPOSITION:
	{
	  barPosition(s, p->byte);
	  return SOS_OK;
	}
  case MSG_BARPERCENT:
	{
	  barPercent(s, p->byte);
	  return SOS_OK;
	}
  case MSG_BARBINARY:
	{
	  barBinary(s, p->word);
	  return SOS_OK;
	}
  case MSG_HEADLIGHT:
	{
	  headlight(s, p->byte, p->word);
	  return SOS_OK;
	}
  case MSG_LOAD:
	{
	  SOS_CALL(s->cb2bus_load, func_vu8ptru8_t, s->config, sizeof(s->config));
	  return SOS_OK;
	}
  case MSG_SERVO_EN:
	{
	  if (p->byte == ENABLE) 
		sbi(s->config[3], 7);
	  else 
		cbi(s->config[3], 7);
	  return SOS_OK;
	}
  case MSG_MAG_RESET:
	{
	  cbi(s->config[3], 2);
	  SOS_CALL(s->cb2bus_load, func_vu8ptru8_t, s->config, sizeof(s->config));
	  TOSH_uwait(3000);
	 
	  sbi(s->config[3], 2);
	  SOS_CALL(s->cb2bus_load, func_vu8ptru8_t, s->config, sizeof(s->config)); 
	  return SOS_OK;
	}
  case MSG_MAG_EN:
	{
	  if (p->byte == ENABLE) 
		sbi(s->config[3], 3);
	  else 
		cbi(s->config[3], 3);
	  return SOS_OK;
	}
  case MSG_ACC_EN:
	{
	  if (p->byte == ENABLE) 
		sbi(s->config[3], 1);
	  else 
		cbi(s->config[3], 1);
	  return SOS_OK;
	}
  case MSG_CB2_IRIS:
	{
	  if ((p->byte) == LOW) 
		cbi(s->config[3], 6);
	  else if ((p->byte) == HIGH)
		sbi(s->config[3], 6); 
	  return SOS_OK;
	}
  case MSG_CB2_BCU:
	{
	  if ((p->byte) == LOW) 
		cbi(s->config[3], 5);
	  else if ((p->byte) == HIGH)
		sbi(s->config[3], 5); 
	  return SOS_OK;
	}
 case MSG_CB2_HEAD0:
	{
	  if ((p->byte) == LOW) 
		cbi(s->config[4], 7);
	  else if ((p->byte) == HIGH)
		sbi(s->config[4], 7); 
	  return SOS_OK;
	}
 case MSG_CB2_HEAD1:
	{
	  if ((p->byte) == LOW) 
		cbi(s->config[4], 6);
	  else if ((p->byte) == HIGH)
		sbi(s->config[4], 6); 
	  return SOS_OK;
	}
  case MSG_CB2_HEAD2:
	{
	  if ((p->byte) == LOW) 
		cbi(s->config[4], 5);
	  else if ((p->byte) == HIGH)
		sbi(s->config[4], 5); 
	  return SOS_OK;
	}
  case MSG_CB2_NECK0:
	{
	  if ((p->byte) == LOW) 
		cbi(s->config[4], 4);
	  else if ((p->byte) == HIGH)
		sbi(s->config[4], 4); 
	  return SOS_OK;
	}
	case MSG_CB2_NECK1:
	{
	  if ((p->byte) == LOW) 
		cbi(s->config[4], 3);
	  else if ((p->byte) == HIGH)
		sbi(s->config[4], 3); 
	  return SOS_OK;
	}
	case MSG_CB2_NECK2:
	{
	  if ((p->byte) == LOW) 
		cbi(s->config[4], 2);
	  else if ((p->byte) == HIGH)
		sbi(s->config[4], 2); 
	  return SOS_OK;
	}
	case MSG_CB2_FOOT0:
	{
	  if ((p->byte) == LOW) 
		cbi(s->config[4], 1);
	  else if ((p->byte) == HIGH)
		sbi(s->config[4], 1); 
	  return SOS_OK;
	}
  case MSG_CB2_FOOT1:
	{
	  if ((p->byte) == LOW) 
		cbi(s->config[4], 0);
	  else if ((p->byte) == HIGH)
		sbi(s->config[4], 0); 
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

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : CB2 : COMMANDS : LOW-LEVEL
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Initialize
void CB2_init(cb2bus_state *s) {  
  //CLEAR VIRTUAL PORTS
  s->config[0] = 0x00;
  s->config[1] = 0x00;
  s->config[2] = 0x00;
  s->config[3] = 0x04;
  s->config[4] = 0x00;
  
  //Load initial state
  SOS_CALL(s->cb2bus_load, func_vu8ptru8_t, s->config, sizeof(s->config));
  return;
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : CB2 : PRIVATE FUNCTIONS : HIGH-LEVEL
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void setColor(cb2bus_state *s, uint8_t pin1, uint8_t pin2, uint16_t color){
  switch (color){
  case GREEN:
	cbi(s->config[0], pin2);
	sbi(s->config[0], pin1);
	break;
  case ORANGE:
	sbi(s->config[0], pin1);
	sbi(s->config[0], pin2);
	break;
  case RED:
	sbi(s->config[0], pin2);			
	cbi(s->config[0], pin1);
	break;
  case BLACK:
  default:
	cbi(s->config[0], pin1);
	cbi(s->config[0], pin2);
  }
}
	
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : CB2 : COMMANDS : HIGH-LEVEL
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//Deck LED (mounted on Ragobot PCB)
//Valid commands: ON, OFF, TOGGLE
void decklight1(cb2bus_state *s, uint8_t cmd){
  switch (cmd) {
  default:
  case ON: 
	sbi(s->config[2], 2);
	break;
  case OFF:
	cbi(s->config[2], 2);
	break;
  case TOGGLE:
	tbi(s->config[2], 2);
	break;
  }	
}

//Deck LED (mounted on Ragobot PCB)
//Valid commands: ON, OFF, TOGGLE
void decklight2(cb2bus_state *s, uint8_t cmd){
  switch (cmd) {
  default:
  case ON: 
	sbi(s->config[2], 3);
	break;
  case OFF:
	cbi(s->config[2], 3);
	break;
  case TOGGLE:
	tbi(s->config[2], 3);
	break;
  }	
}
	
//Deck LED (mounted on Ragobot PCB)
//Valid commands: ON, OFF, TOGGLE
void decklight3(cb2bus_state *s, uint8_t cmd){
  switch (cmd) {
  default:
  case ON: 
	sbi(s->config[2], 4);
	break;
  case OFF:
	cbi(s->config[2], 4);
	break;
  case TOGGLE:
	tbi(s->config[2], 4);
	break;
  }	
}
	
//Deck LED (mounted on Ragobot PCB)
//Valid commands: ON, OFF, TOGGLE
void decklight4(cb2bus_state *s, uint8_t cmd){
  switch (cmd) {
  default:
  case ON: 
	sbi(s->config[2], 5);
	break;
  case OFF:
	cbi(s->config[2], 5);
	break;
  case TOGGLE:
	tbi(s->config[2], 5);
	break;
  }	
}
	
//Deck LED (mounted on Ragobot PCB)
//Valid commands: ON, OFF, TOGGLE
void decklight5(cb2bus_state *s, uint8_t cmd){
  switch (cmd) {
  default:
  case ON: 
	sbi(s->config[2], 6);
	break;
  case OFF:
	cbi(s->config[2], 6);
	break;
  case TOGGLE:
	tbi(s->config[2], 6);
	break;
  }	
}
	
//Deck LED (mounted on Ragobot PCB)
//Valid commands: ON, OFF, TOGGLE
void decklight6(cb2bus_state *s, uint8_t cmd){
  switch (cmd) {
  default:
  case ON: 
	sbi(s->config[2], 7);
	break;
  case OFF:
	cbi(s->config[2], 7);
	break;
  case TOGGLE:
	tbi(s->config[2], 7);
	break;
  }	
}

//Clear all decklights
void cleardecklights(cb2bus_state *s, uint8_t cmd){
    s->config[2] = s->config[2] & 0x03;	
}
	
//Controls Headlights (The tri-color LED's at the corners of the robot)
//Valid positions: FRONT_LEFT, FRONT_RIGHT, BACK_LEFT, BACK_RIGHT
//Valid colors: RED, GREEN, ORANGE, BLACK (off)
void headlight(cb2bus_state *s, uint8_t position, uint16_t color) {
  switch(position){
  case FRONT_LEFT:	
	setColor(s, 2, 3, color); //D8
	break;
  case FRONT_RIGHT:
	setColor(s, 0, 1, color); //D7
	break;
  case BACK_LEFT:
	setColor(s, 6, 7, color); //D10
	break;
  case BACK_RIGHT:		   //D9
  default:
	setColor(s, 4, 5, color);
  }
}
		
//LED Status Bar (10-Segment)
//Lights the single element corresponding to number.
//Valid numbers: 0-9 
void barPosition(cb2bus_state *s, uint8_t number){
  switch(number){
  case(0):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x01;
	break;
  case(1):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x02;
	break;
  case(2):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x04;
	break;
  case(3):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x08;
	break;
  case(4):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x10;
	break;
  case(5):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x20;
	break;
  case(6):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x40;
	break;
  case(7):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x80;
	break;
  case(8):
	sbi(s->config[2], 0);
	cbi(s->config[2], 1);
	s->config[1] = 0x00;
	break;
  case(9):
  default:
	cbi(s->config[2], 0);
	sbi(s->config[2], 1);
	s->config[1] = 0x00;
	break;
  }		
}
	
//LED Status Bar (10-Segment)
//Lights all the elements up to (number*10) as a percent.
//Example: For number==3, Lower 3 LED's illuminate == 30% of the bar
//Valid numbers: 0-10 
void barPercent(cb2bus_state *s, uint8_t number){
  
  switch(number){
  case(0):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x00;
	break;
  case(1):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x01;
	break;
  case(2):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x03;
	break;
  case(3):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x07;
	break;
  case(4):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x0F;
	break;
  case(5):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x1F;
	break;
  case(6):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x3F;
	break;
  case(7):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0x7F;
	break;
  case(8):
	s->config[2] = s->config[2] & 0xFC;
	s->config[1] = 0xFF;
	break;
  case(9):
	sbi(s->config[2], 0);
	cbi(s->config[2], 1);
	s->config[1] = 0xFF;
	break;
  case(10):
  default:
	sbi(s->config[2], 0);
	sbi(s->config[2], 1);
	s->config[1] = 0xFF;
	
  }		
}
	
//LED Status Bar (10-Segment)
//Displays unsigned number on the corresponding elements in binary (10-bit)
//Warning: THIS IS AN UNSIGNED 10BIT (LSB) DISPLAY, upper bits ignored
//Valid numbers: 0-1023
void barBinary(cb2bus_state *s, uint16_t number){
  //Deal with LSB of Light Bar		
  s->config[1] = (uint8_t)(number);

  //Deal with MSB
  number = number >> 8;
  number = number | 0xFFFC;
  s->config[2] = s->config[2] | 0x03;
  s->config[2] = s->config[2] & (uint8_t) number;
}

//-----------------------------------------------------------------------------
// APPLICATION INITIALIZATION
//-----------------------------------------------------------------------------
#ifndef _MODULE_
mod_header_ptr cb2bus_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif
