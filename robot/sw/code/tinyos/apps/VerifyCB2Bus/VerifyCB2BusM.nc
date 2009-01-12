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
 * @author Parixit Aghera parixit@ee.ucla.edu
 * @author Jonathan Friedman jf@ee.ucla.edu
 **/


module VerifyCB2BusM {
  provides{
    interface StdControl;
  }
  uses{
    interface CB2Bus as CB2;
    interface Timer;
    interface Leds;
  }
}

implementation {
	#include "CB2BusM.h"
	
	uint16_t i = 0;
	uint8_t j = 0;

  command result_t StdControl.init(){
    call Leds.init();
    call CB2.init();
    return SUCCESS;
  }

  
  command result_t StdControl.start(){
	  call CB2.decklight1(ON);
	  call CB2.decklight3(ON);
	  call CB2.decklight5(ON);
	  call CB2.decklight7(ON);
    return call Timer.start(TIMER_REPEAT, 500);
  }

  command result_t StdControl.stop(){
    return call Timer.stop();
  }

  event result_t Timer.fired(){
    //Test Lightbar
		call CB2.barBinary(i++);
	    if (i == 0x0200) i = 0;
	//Test Headlights    
	    call CB2.headlightON(FRONT_LEFT, j);
	    call CB2.headlightON(FRONT_RIGHT, j);
	    call CB2.headlightON(BACK_LEFT, j);
	    call CB2.headlightON(BACK_RIGHT, j++);
	    if (j == 4) j = 0;
	//Test Deck Lights    
	    call CB2.decklight1(TOGGLE);
	    call CB2.decklight2(TOGGLE);
	    call CB2.decklight3(TOGGLE);
	    call CB2.decklight4(TOGGLE);
	    call CB2.decklight5(TOGGLE);
	    call CB2.decklight6(TOGGLE);
	    call CB2.decklight7(TOGGLE);
	    call CB2.decklight8(TOGGLE);
	//Test Spotlight    
    	call CB2.spotlight(TOGGLE);
    //Test Power Control
    	call CB2.pwr5V(ON);
    	call CB2.pwrBatteryCharger(ON);
    //STANDARD DEBUG
    	call Leds.redToggle();
    
    return SUCCESS;
  }
}

