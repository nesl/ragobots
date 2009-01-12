/*
  #################################################################################
  # RAGOBOT:IRMAN I2C SERIAL MODULE
  # ------------------------------------------------------------------------------
  # Implements buffering and bus management of the TWI unit onboard IRMAN
  # 
  # APPLIES TO (Ragobot Part Numbers):
  # ------------------------------------------------------------------------------
  # RBTBDYB
  #
  # COPYRIGHT NOTICE
  # ------------------------------------------------------------------------------
  # "Copyright (c) 2000-2003 The Regents of the University  of California.
  # All rights reserved.
  # Permission to use, copy, modify, and distribute this software and its
  # documentation for any purpose, without fee, and without written agreement is
  # hereby granted, provided that the above copyright notice, the following
  # two paragraphs and the author appear in all copies of this software.
  # IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
  # DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
  # OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
  # CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  # THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
  # INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
  # AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
  # ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
  # PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
  #
  # DEVELOPED BY
  # ------------------------------------------------------------------------------
  # Jonathan Friedman, GSR
  # Networked and Embedded Systems Laboratory (NESL)
  # University of California, Los Angeles (UCLA)
  #
  # REVISION HISTORY
  # ------------------------------------------------------------------------------
  # <for dates and comments, see cvs>
  # Original by Jonathan Friedman, UCLA (jf@ee.ucla.edu) 		
  #################################################################################
*/

#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>
#include "irman.h"
#include "utilities.h"
#include "i2c.h"
#include "uart0.h"

volatile uint8_t i2c_buffer = 0xFF;

void init_I2C_slave()
{
  TWCR = B8(01000101); //control register
  TWAR = (IRMAN_ADDRESS <<1) + 1; //address register (disable broadcast receive)
  TWAMR = 0x00; //address mask register (use entire address space)
}

//we respond to general call and specific address call the same way

SIGNAL(SIG_TWI){
  //if (TWSR != 0x60) while(1);
  if (TWSR == 0x60 || TWSR == 0x70){
    //general call or I'm specifically being addressed	
    TWCR = B8(10000101); //receive and NACK (i.e. end of data payload after 1 byte rx)
  }
  else if (TWSR == 0x88 || TWSR == 0x98){
    //receive byte
    i2c_buffer = TWDR;
    //switch to the no-longer addressed slave mode (waiting on new bus transfer to address me)
    TWCR = B8(11000101);
  }
  else {
    //if error or unrecognized bus condition, abort current transfer and await next packet
    //switch to the no-longer addressed slave mode (waiting on new bus transfer to address me)
    TWCR = B8(11000101);
  }	
} //signal(SIG_2WIRE_SERIAL)
