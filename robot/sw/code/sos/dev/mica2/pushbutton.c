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
 *
 *
 */
/**
 * @author David Lee
 */
/**
 * @brief Provides support for the pushbutton 
 *
 * When the pushbutton is pressed, an external interrupt is generated. A 
 * message is sent to all modules that have registered to receive a message
 * when a pushbutton event has occurred.
 */

#include "mica2_peripheral.h"

#define MAXREGMOD  2  //the maximum number of modules that can register
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// LOCAL VARIABLES
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

static uint8_t registered_modules[MAXREGMOD];
static uint8_t numRegMod; //the number of registered modules
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// LOCAL FUNCTIONS
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
static void pushbutton_broadcast();

void pushbutton_init()
{
  //Set PE5 to an input pin
  cbi(DDRE, 5);
  cbi(PORTE, 5);

  //enable INT5
  sbi(EIMSK, 5);

  //generate interrupt on falling edge
  sbi(EICRB, 3);
  cbi(EICRB, 2);
} 

void pushbutton_broadcast()
{
  uint8_t i;
  for (i = 0; i < numRegMod; i++) 
	{
	  post_short(registered_modules[i], registered_modules[i], MSG_PUSHBUTTON_PRESSED, 0, 0, SOS_MSG_HIGH_PRIORITY);
	}
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//PUSHBUTTON INTERRUPT
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SIGNAL(SIG_INTERRUPT5) 
{
  pushbutton_broadcast();
} 

int8_t ker_pushbutton_register(uint8_t pid)
{
  if (numRegMod == MAXREGMOD) 
	{
	  return -EINVAL;
	}
  registered_modules[numRegMod] = pid;
  numRegMod += 1;
  return SOS_OK;
}
int8_t ker_pushbutton_deregister(uint8_t pid)
{
  uint8_t i;
  if (numRegMod == 0) 
	{
	  return -EINVAL;
	}
  // Find the pid in the table. If it is found, remove the pid, shrink the 
  // table and return SOS_OK. If not found, return -EINVAL
  for (i = 0; i < numRegMod; i++) 
	{
	  if (registered_modules[i] == pid) 
		{
		  for (i=i+1; i < numRegMod; i++) 
			{
			  registered_modules[i-1] = registered_modules[i];
			}
		  numRegMod--;
		  return SOS_OK;
		}  
	}
  return -EINVAL;
}
