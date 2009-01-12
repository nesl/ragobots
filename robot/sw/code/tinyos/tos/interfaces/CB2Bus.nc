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
  *
  * @author Jonathan Friedman jf@ee.ucla.edu
  **/

interface CB2Bus {
	//LOW-LEVEL
		//INITIALIZE
  			command void init(); // Reset and initialize
  		//LOAD
  			command void load(); // Sets all registers
  	//HIGH-LEVEL
  		//HEAD LIGHTS
	  		command void headlightON(uint8_t position, uint8_t color); // Controls the Tri-color LED's in the corners (FAST UPDATE)
  			command void headlightOFF(uint8_t position);
  		//INDIVIDUAL LED'S
  			command void led0(uint8_t cmd); // First LED on light bar (FAST UPDATE)
  			command void led1(uint8_t cmd); // Last LED on light bar (FAST UPDATE)
  			command void spotlight(uint8_t cmd); //The spotlight on the servo (FAST UPDATE)
  		//LIGHT BAR
	  		command void barPosition(uint8_t input); // Turn on single LED on light bar
	  		command void barPercent(uint8_t input); // Turn on (input)*10 percent of the light bar
	  		command void barBinary(uint16_t input); // Display 10-bit unsigned number on light bar
	  	//DECK LIGHTS
	  		command void decklight1(uint8_t cmd);
	  		command void decklight2(uint8_t cmd);
	  		command void decklight3(uint8_t cmd);
	  		command void decklight4(uint8_t cmd);
	  		command void decklight5(uint8_t cmd);
	  		command void decklight6(uint8_t cmd);
	  		command void decklight7(uint8_t cmd);
	  		command void decklight8(uint8_t cmd);
	  	//EXTRA I/O LINES
			command void exp0(uint8_t cmd);
			command void exp1(uint8_t cmd);
	  		command void exp2(uint8_t cmd);
	  	//POWER CONTROL
	  		command void pwr5V(uint8_t cmd);
		  	command void pwrBatteryCharger(uint8_t cmd);
			command void pwrSensors(uint8_t cmd);
			command void pwrExpansion(uint8_t cmd);
			command void pwrServos(uint8_t cmd);
}
