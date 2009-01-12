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

//STATE VARIABLES (VIRTUAL PORTS)
	uint8_t CB2STATE;
	uint8_t PORTW;
	uint8_t PORTX;
	uint8_t PORTY;
	uint8_t PORTZ;

//PIN & PORT DEFINITIONS
	#define CB2PORT		PORTC	//CB2PORT AND CB2DDR MUST MATCH!
	#define CB2DDR		DDRC
	#define CB2RESET 	3
	#define CB2CLOCK 	5
	#define CB2INPUT 	6
	#define CB2HSSELECT 4

//ADDTIONAL LED LINES
	#define LED_BAR_PORT	PORTG
	#define LED_BAR_DDR		DDRG
	#define LED_BAR_1		1
	#define LED_BAR_2		0
	#define LED_SPOTLIGHT	2

//TIMING
	#define clock_stall asm volatile("nop\n\t" "nop\n\t" "nop\n\t" : : )

//HELPER MACROS
	#define tbi(sfr, bit) (_SFR_BYTE(sfr) ^= _BV(bit))	

//EXPOSED FUNCTIONS
	//exposed through tinyOS only.
	
	
	
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : CB2 : HIGH-LEVEL HEADER FILE (if choose to split)
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
//LED CONDITIONS
	#define ON	0x00
	#define OFF 0x01
	#define TOGGLE 0x02
	
//HEADLIGHT NAMES
	#define FRONT_LEFT		0x00
	#define FRONT_RIGHT		0x01
	#define BACK_LEFT		0x02
	#define BACK_RIGHT		0x03
	
//LED COLORS
	#define GREEN		0x00
	#define RED			0x01
	#define BLACK		0x02
	#define ORANGE		0x03
	
	
#endif
