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
 * @author Jonathan Friedman jf@ee.ucla.edu
 * @author David Lee (Ported to SOS and Modified for Rev. B)
 */
/**
 * @brief Provides Low-Level Control of the CB2BUS on Ragobot controlled by 
 * Micas.
 * 
 */

#include "mica2_peripheral.h"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// LOCAL FUNCTIONS
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
static void update_CB2_1B(uint8_t Outgoing);
static void reset_CB2();

void cb2bus_hardware_init() 
{
  //INIT HARDWARE PORTS
  sbi(CB2DDR, CB2RESET);
  sbi(CB2DDR, CB2CLOCK);
  sbi(CB2DDR, CB2INPUT);
  sbi(CB2DDR, CB2HSSELECT);
    
  //RESET BUS (SYNC STATE)
  sbi(CB2PORT, CB2RESET);
  return;
}

void ker_cb2bus_load(uint8_t vport[], int8_t size)
{
  int8_t i;
  if (size <= 0) 
	{
	  return;
	}
  //Reset Bus
  reset_CB2();
  //Enable Bus
  cbi(CB2PORT, CB2HSSELECT);
  //Shift Out Data	
  for(i = size-1; i >= 0; i--) 
	{
	  update_CB2_1B(vport[i]);
	}

  //Idle Clock Low		
  cbi(CB2PORT, CB2CLOCK);
  //Disable Bus & Update Outputs
  sbi(CB2PORT, CB2HSSELECT);
}  

/**
 *  @brief shift out one byte onto the cb2bus
 *  @param uint8_t Outgoing The byte that will be shifted out
 *  @return void
 */
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

/**
 *  @brief reset cb2bus registers
 */
void reset_CB2(){
  cbi(CB2PORT, CB2RESET);
  sbi(CB2PORT, CB2RESET);
}


