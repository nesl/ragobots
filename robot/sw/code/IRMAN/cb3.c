/*
#################################################################################
# RAGOBOT:IRMAN CONTROL BUS 3 (CB3) DRIVER
# ------------------------------------------------------------------------------
# Defines pins, ports, and signals
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
#include "cb3.h"
#include "utilities.h"

uint8_t CB2STATE;
volatile uint8_t PORTI[8];

void init_CB3(){
	uint8_t i;
	//INIT HARDWARE PORTS
		cbi(CB3PORTL,CB3LOAD);
		cbi(CB3PORTC,CB3CLOCK);
		sbi(CB3DDRL,CB3LOAD);
		sbi(CB3DDRC,CB3CLOCK);
		cbi(CB3DDRD,CB3OUTPUT); //OUTPUT *FROM* CB3; MCU INPUT	
	//CLEAR VIRTUAL PORTS
	for (i=0; i<8; i++){
		PORTI[i] = 0x00;
	}
}

//Shift it all in
inline void read_CB3_1B(){
	uint8_t i;
	//DATA COMES IN MSb FIRST
	for(i = 0;  i < 8; i++){
		//READ BIT
		//temp |= ((CB3PORTD & _BV(CB3OUTPUT)) >> (CB3OUTPUT)) << i;
		PORTI[7-i] = CB3PORTD;
		//CLOCK HIGH
		sbi(CB3PORTC,CB3CLOCK);
		//CLOCK LOW
		cbi(CB3PORTC,CB3CLOCK);
	}
}	

//ASSUME CB3PORTL.CB3LOAD = 0 PRIOR TO CALLING THIS FUNCTION
inline void read_CB3(){
	//CAPTURE DATA
		sbi(CB3PORTL,CB3LOAD);
	//SHIFT IN CAPTURED DATA
		read_CB3_1B();
	//LOAD LOW (clock is already low)
		cbi(CB3PORTL, CB3LOAD);
}
