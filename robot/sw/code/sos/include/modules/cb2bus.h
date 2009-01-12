//$Id: 
//$Log:

/*									tab:4
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
 * Global Exposure of Low-Level Virtual Expansion Ports (CB2)
 * @author Jonathan Friedman  jf@ee.ucla.edu
 **/

#ifndef __CB2__H__
#define __CB2__H__

//MESSAGE TYPES
enum 
{
  /* The following turns on/off/toggle the corresponding decklight
   * on the Ragobot. It takes a short message in which byte is set
   * be ON, OFF, or TOGGLE.
   */
  MSG_DECKLIGHT1 = (MOD_MSG_START+0),
  MSG_DECKLIGHT2 = (MOD_MSG_START+1),
  MSG_DECKLIGHT3 = (MOD_MSG_START+2),
  MSG_DECKLIGHT4 = (MOD_MSG_START+3),
  MSG_DECKLIGHT5 = (MOD_MSG_START+4),
  MSG_DECKLIGHT6 = (MOD_MSG_START+5),
 
  MSG_BARPOSITION = (MOD_MSG_START+6),
  MSG_BARPERCENT = (MOD_MSG_START+7),
  MSG_BARBINARY = (MOD_MSG_START+8),
  
  /* The following turns on/off the corresponding headlight
   * on the Ragobot. It takes a short message in which byte is set
   * be FRONT_LEFT, FRONT_RIGHT, BACK_LEFT, BACK_RIGHT. word is set
   * to a color (GREEN,RED,ORANGE, or BLACK(off)). 
   */
  MSG_HEADLIGHT = (MOD_MSG_START+9),

  /* The following turns loads the CB2bus with the new configuration.
   * It takes a short message with no other arguments. 
   */
  MSG_LOAD = (MOD_MSG_START+10),

  MSG_SERVO_EN = (MOD_MSG_START+11),
  MSG_IRR_EN = (MOD_MSG_START+12),
//MSG_BC_EN = (MOD_MSG_START+13),
  MSG_MAG_RESET = (MOD_MSG_START+14),
  MSG_MAG_EN = (MOD_MSG_START+15),
  MSG_ACC_EN = (MOD_MSG_START+16),
  MSG_5V_EN = (MOD_MSG_START+17),
  MSG_RFID_RESET = (MOD_MSG_START+18),
  
  MSG_CLEARDECKLIGHTS = (MOD_MSG_START+19),
};

//HELPER MACROS
#define tbi(sfr, bit) (_SFR_BYTE(sfr) ^= _BV(bit))

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : CB2 : HIGH-LEVEL HEADER FILE (if choose to split)
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
//LED CONDITIONS

#define  ON     0x00
#define  OFF    0x01
#define  TOGGLE 0x02

	
//HEADLIGHT NAMES
#define FRONT_LEFT		0x00
#define FRONT_RIGHT		0x01
#define BACK_LEFT		0x02
#define BACK_RIGHT		0x03
	
//LED COLORS
#define BLACK		0x00
#define GREEN		0x01
#define ORANGE		0x02
#define RED		0x03

//CONDITIONS FOR ENABLING COMPONENTS
#define DISABLE    0x00
#define ENABLE     0x01
	
int8_t cb2bus_module_init();	
#endif
