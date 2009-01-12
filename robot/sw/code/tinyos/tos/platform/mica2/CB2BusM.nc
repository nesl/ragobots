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
  * Provides Direct Access, Low-Level Control of the Virtual Expansion Ports (CB2)
  * Also Provides High-Level Control over the Functions Attached to CB2
  * @author Jonathan Friedman jf@ee.ucla.edu
  **/



module CB2BusM {
  provides {
    interface CB2Bus;
  }
}
implementation{
#include "CB2BusM.h"
#include "binaryconv.h"

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : CB2 : PRIVATE FUNCTIONS : LOW-LEVEL
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	//Shift out 1 Byte
	void update_CB2_1B(uint8_t Outgoing){
		
		uint8_t i, temp;
		
		for(i = 0;  i <= 7; i++){
			//clock low
			cbi(CB2PORT, CB2CLOCK); 
		
			//set data bit
			temp = Outgoing;
			temp &= 0x80;
			if (temp == 0x80) {
				sbi(CB2PORT, CB2INPUT);
			}
			else {
				cbi(CB2PORT, CB2INPUT);		
			}
			//tbi(CB2PORT, CB2INPUT);
			Outgoing = Outgoing << 1;
			
			//clock high
			sbi(CB2PORT, CB2CLOCK);
		}
	}
	
	void reset_CB2(){
	    cbi(CB2PORT, CB2RESET);
		sbi(CB2PORT, CB2RESET);
	}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : CB2 : COMMANDS : LOW-LEVEL
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	//Initialize
	command void CB2Bus.init() {
		//INIT HARDWARE PORTS
			sbi(CB2DDR, CB2RESET);
			sbi(CB2DDR, CB2CLOCK);
			sbi(CB2DDR, CB2INPUT);
			sbi(CB2DDR, CB2HSSELECT);
			
		//INIT EXTRA "HIGH-LEVEL" PINS
			cbi(LED_BAR_PORT, LED_BAR_1); //default to off
			cbi(LED_BAR_PORT, LED_BAR_2);
			cbi(LED_BAR_PORT, LED_SPOTLIGHT);
			sbi(LED_BAR_DDR, LED_BAR_1); //set led pin drivers as outputs
			sbi(LED_BAR_DDR, LED_BAR_2);
			sbi(LED_BAR_DDR, LED_SPOTLIGHT);
			
		
		//CLEAR VIRTUAL PORTS
			PORTW = 0x00;
			PORTX = 0x00;
			PORTY = 0x00;
			PORTZ = 0x00;
		
		//RESET BUS (SYNC STATE)
			sbi(CB2PORT, CB2RESET);
	    return;
	}
	
	//Loads the CB2 Registers with Virtual Port Data
	command void CB2Bus.load(){
		//Reset Bus
	    	reset_CB2();
		//Enable Bus
			cbi(CB2PORT, CB2HSSELECT);
		//Shift Out Data	
			update_CB2_1B(PORTZ);
			update_CB2_1B(PORTY);
			update_CB2_1B(PORTX);
			update_CB2_1B(PORTW);
		//Idle Clock Low		
			cbi(CB2PORT, CB2CLOCK);
		//Disable Bus & Update Outputs
			sbi(CB2PORT, CB2HSSELECT);
	}  

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : CB2 : PRIVATE FUNCTIONS : HIGH-LEVEL
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	void setColor(uint8_t pin1, uint8_t pin2, uint8_t color){
		switch (color){
			case GREEN:
				cbi(PORTW, pin2);
				sbi(PORTW, pin1);
				break;
			case ORANGE:
				sbi(PORTW, pin1);
				sbi(PORTW, pin2);
				break;
			case RED:
				sbi(PORTW, pin2);			
				cbi(PORTW, pin1);
				break;
			case BLACK:
			default:
				cbi(PORTW, pin1);
				cbi(PORTW, pin2);
		}
	}
	
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : CB2 : COMMANDS : HIGH-LEVEL
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	//Controls Top LED on status bar
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.led0(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(LED_BAR_PORT, LED_BAR_1);
			break;
			case OFF:
				cbi(LED_BAR_PORT, LED_BAR_1);
			break;
			case TOGGLE:
				tbi(LED_BAR_PORT, LED_BAR_1);
			break;
		}	
	}

	//Controls Bottom LED on status bar
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.led1(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(LED_BAR_PORT, LED_BAR_2);
			break;
			case OFF:
				cbi(LED_BAR_PORT, LED_BAR_2);
			break;
			case TOGGLE:
				tbi(LED_BAR_PORT, LED_BAR_2);
			break;
		}	
	}
	
	//Blue Spotlight LED (mounted on observation layer)
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.spotlight(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(LED_BAR_PORT, LED_SPOTLIGHT);
			break;
			case OFF:
				cbi(LED_BAR_PORT, LED_SPOTLIGHT);
			break;
			case TOGGLE:
				tbi(LED_BAR_PORT, LED_SPOTLIGHT);
			break;
		}	
	}
	
	//Deck LED (mounted on Ragobot PCB)
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.decklight1(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTY, 7);
			break;
			case OFF:
				cbi(PORTY, 7);
			break;
			case TOGGLE:
				tbi(PORTY, 7);
			break;
		}	
		call CB2Bus.load();
	}
	
	//Deck LED (mounted on Ragobot PCB)
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.decklight2(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTY, 6);
			break;
			case OFF:
				cbi(PORTY, 6);
			break;
			case TOGGLE:
				tbi(PORTY, 6);
			break;
		}	
		call CB2Bus.load();
	}
	
	//Deck LED (mounted on Ragobot PCB)
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.decklight3(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTY, 5);
			break;
			case OFF:
				cbi(PORTY, 5);
			break;
			case TOGGLE:
				tbi(PORTY, 5);
			break;
		}	
		call CB2Bus.load();
	}
	
	//Deck LED (mounted on Ragobot PCB)
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.decklight4(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTY, 4);
			break;
			case OFF:
				cbi(PORTY, 4);
			break;
			case TOGGLE:
				tbi(PORTY, 4);
			break;
		}	
		call CB2Bus.load();
	}
	
	//Deck LED (mounted on Ragobot PCB)
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.decklight5(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTY, 3);
			break;
			case OFF:
				cbi(PORTY, 3);
			break;
			case TOGGLE:
				tbi(PORTY, 3);
			break;
		}	
		call CB2Bus.load();
	}
	
	//Deck LED (mounted on Ragobot PCB)
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.decklight6(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTY, 2);
			break;
			case OFF:
				cbi(PORTY, 2);
			break;
			case TOGGLE:
				tbi(PORTY, 2);
			break;
		}	
		call CB2Bus.load();
	}
	
	//Deck LED (mounted on Ragobot PCB)
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.decklight7(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTY, 1);
			break;
			case OFF:
				cbi(PORTY, 1);
			break;
			case TOGGLE:
				tbi(PORTY, 1);
			break;
		}	
		call CB2Bus.load();
	}
	
	//Deck LED (mounted on Ragobot PCB)
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.decklight8(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTY, 0);
			break;
			case OFF:
				cbi(PORTY, 0);
			break;
			case TOGGLE:
				tbi(PORTY, 0);
			break;
		}	
		call CB2Bus.load();
	}
	
	
	//Controls Headlights (The tri-color LED's at the corners of the robot)
	//Valid positions: FRONT_LEFT, FRONT_RIGHT, BACK_LEFT, BACK_RIGHT
	//Valid colors: RED, GREEN, ORANGE, BLACK (off)
	command void CB2Bus.headlightON(uint8_t position, uint8_t color){
		switch(position){
		case FRONT_LEFT:	
			setColor(4, 5, color); //D3
			break;
		case FRONT_RIGHT:
			setColor(0, 1, color); //D1
			break;
		case BACK_LEFT:
			setColor(6, 7, color); //D4
			break;
		case BACK_RIGHT:			//D2
		default:
			setColor(2, 3, color);
		}
		call CB2Bus.load();
	}
	
	//Controls Headlights (The tri-color LED's at the corners of the robot)
	//Valid positions: FRONT_LEFT, FRONT_RIGHT, BACK_LEFT, BACK_RIGHT
	command void CB2Bus.headlightOFF(uint8_t position){
		switch(position){
		case FRONT_LEFT:	
			setColor(4, 5, BLACK); //D3
			break;
		case FRONT_RIGHT:
			setColor(0, 1, BLACK); //D1
			break;
		case BACK_LEFT:
			setColor(6, 7, BLACK); //D4
			break;
		case BACK_RIGHT:			//D2
		default:
			setColor(2, 3, BLACK);
		}	
		call CB2Bus.load();
	}
	
	
	//LED Status Bar (10-Segment)
	//Lights the single element corresponding to number.
	//Valid numbers: 0-9 
	command void CB2Bus.barPosition(uint8_t number){
		switch(number){
		case(0):
			call CB2Bus.led0(ON);
			PORTX = B8(00000000);
			call CB2Bus.led1(OFF);
			break;
		case(1):
			call CB2Bus.led0(OFF);
			PORTX = B8(00000001);
			call CB2Bus.led1(OFF);
			break;
		case(2):
			call CB2Bus.led0(OFF);
			PORTX = B8(00000010);
			call CB2Bus.led1(OFF);
			break;
		case(3):
			call CB2Bus.led0(OFF);
			PORTX = B8(00000100);
			call CB2Bus.led1(OFF);
			break;
		case(4):
			call CB2Bus.led0(OFF);
			PORTX = B8(00001000);
			call CB2Bus.led1(OFF);
			break;
		case(5):
			call CB2Bus.led0(OFF);
			PORTX = B8(00010000);
			call CB2Bus.led1(OFF);
			break;
		case(6):
			call CB2Bus.led0(OFF);
			PORTX = B8(00100000);
			call CB2Bus.led1(OFF);
			break;
		case(7):
			call CB2Bus.led0(OFF);
			PORTX = B8(01000000);
			call CB2Bus.led1(OFF);
			break;
		case(8):
			call CB2Bus.led0(OFF);
			PORTX = B8(10000000);
			call CB2Bus.led1(OFF);
			break;
		case(9):
		default:
			call CB2Bus.led0(OFF);
			PORTX = B8(00000000);
			call CB2Bus.led1(ON);
		}		
		call CB2Bus.load();
	}
	
	//LED Status Bar (10-Segment)
	//Lights all the elements up to (number*10) as a percent.
	//Example: For number==3, Lower 3 LED's illuminate == 30% of the bar
	//Valid numbers: 0-10 
	command void CB2Bus.barPercent(uint8_t number){
			switch(number){
		case(0):
			call CB2Bus.led0(OFF);
			PORTX = 0x00;
			call CB2Bus.led1(OFF);
		case(1):
			call CB2Bus.led0(ON);
			PORTX = B8(00000000);
			call CB2Bus.led1(OFF);
			break;
		case(2):
			call CB2Bus.led0(ON);
			PORTX = B8(00000001);
			call CB2Bus.led1(OFF);
			break;
		case(3):
			call CB2Bus.led0(ON);
			PORTX = B8(00000011);
			call CB2Bus.led1(OFF);
			break;
		case(4):
			call CB2Bus.led0(ON);
			PORTX = B8(00000111);
			call CB2Bus.led1(OFF);
			break;
		case(5):
			call CB2Bus.led0(ON);
			PORTX = B8(00001111);
			call CB2Bus.led1(OFF);
			break;
		case(6):
			call CB2Bus.led0(ON);
			PORTX = B8(00011111);
			call CB2Bus.led1(OFF);
			break;
		case(7):
			call CB2Bus.led0(ON);
			PORTX = B8(00111111);
			call CB2Bus.led1(OFF);
			break;
		case(8):
			call CB2Bus.led0(ON);
			PORTX = B8(01111111);
			call CB2Bus.led1(OFF);
			break;
		case(9):
			call CB2Bus.led0(ON);
			PORTX = B8(11111111);
			call CB2Bus.led1(OFF);
			break;
		case(10):
		default:
			call CB2Bus.led0(ON);
			PORTX = B8(11111111);
			call CB2Bus.led1(ON);
		}		
		call CB2Bus.load();
	}
	
	//LED Status Bar (10-Segment)
	//Displays unsigned number on the corresponding elements in binary (10-bit)
	//Warning: THIS IS AN UNSIGNED 10BIT (LSB) DISPLAY, upper bits ignored
	//Valid numbers: 0-1023
	command void CB2Bus.barBinary(uint16_t number){
		//Deal with Low Bit
			if ((number & 0x0001) == 0x0000)
				call CB2Bus.led0(OFF);	
			else
				call CB2Bus.led0(ON);
		//Deal with Light Bar		
			PORTX = (uint8_t)(number >> 1);
		//Deal with High Bit
			if ((number & 0x0200) == 0x0000)
				call CB2Bus.led1(OFF);	
			else
				call CB2Bus.led1(ON);
			call CB2Bus.load();
	}
	
	
	//Extra I/O Pins (Available on Ragobot JAL Expansion Headers)
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.exp0(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTZ, 5);
			break;
			case OFF:
				cbi(PORTZ, 5);
			break;
			case TOGGLE:
				tbi(PORTZ, 5);
			break;
		}	
		call CB2Bus.load();
	}
	
	//Extra I/O Pins (Available on Ragobot JAL Expansion Headers)
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.exp1(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTZ, 6);
			break;
			case OFF:
				cbi(PORTZ, 6);
			break;
			case TOGGLE:
				tbi(PORTZ, 6);
			break;
		}	
		call CB2Bus.load();
	}
	
	//Extra I/O Pins (Available on Ragobot JAL Expansion Headers)
	//Valid commands: ON, OFF, TOGGLE
	command void CB2Bus.exp2(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTZ, 7);
			break;
			case OFF:
				cbi(PORTZ, 7);
			break;
			case TOGGLE:
				tbi(PORTZ, 7);
			break;
		}	
		call CB2Bus.load();
	}
	
	//POWER CONTROL: 5V SUPPLY
	//Valid commands: ON, OFF
	command void CB2Bus.pwr5V(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				cbi(PORTZ, 0);
			break;
			case OFF:
				sbi(PORTZ, 0);
			break;
		}	
		call CB2Bus.load();
	}
	
	//POWER CONTROL: BATTERY CHARGER
	//Valid commands: ON, OFF
	command void CB2Bus.pwrBatteryCharger(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTZ, 1);
			break;
			case OFF:
				cbi(PORTZ, 1);
			break;
		}	
		call CB2Bus.load();
	}
	
	//POWER CONTROL: SENSOR RAIL
	//Valid commands: ON, OFF
	command void CB2Bus.pwrSensors(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTZ, 2);
			break;
			case OFF:
				cbi(PORTZ, 2);
			break;
		}	
		call CB2Bus.load();
	}
	
	//POWER CONTROL: EXPANSION RAIL
	//Valid commands: ON, OFF
	command void CB2Bus.pwrExpansion(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTZ, 3);
			break;
			case OFF:
				cbi(PORTZ, 3);
			break;
		}	
		call CB2Bus.load();
	}
	
	//POWER CONTROL: SERVO RAIL
	//Valid commands: ON, OFF
	command void CB2Bus.pwrServos(uint8_t cmd){
		switch (cmd) {
			default:
			case ON: 
				sbi(PORTZ, 4);
			break;
			case OFF:
				cbi(PORTZ, 4);
			break;
		}	
		call CB2Bus.load();
	}
	
} //implementation
