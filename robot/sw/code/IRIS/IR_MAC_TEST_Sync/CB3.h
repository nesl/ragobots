/*
#################################################################################
# RAGOBOT:IRMAN CONTROL BUS 3 (CB3) DEFINITIONS
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

#ifndef __CB3__H__
#define __CB3__H__

//CB3PORTx & CB3DDRx must correspond
//SIGNAL PORTS
#define CB3PORTL	PORTB	//Load Signal Port
#define CB3PORTC	PORTB	//Clock Signal Port
#define CB3PORTD	PIND	//Data Out Signal Port
//DATA DIRECTION REGISTERS
#define CB3DDRL		DDRB	//Load Signal Data Direction Register
#define CB3DDRC		DDRB	//Clock "	"	"	"
#define CB3DDRD		DDRD	//Data Out "	"	"	"
//PIN DEFINITIONS
#define CB3LOAD 	4
#define CB3CLOCK 	5
#define CB3OUTPUT 	2 //PORTD!!!

extern volatile uint8_t PORTI[8];

void init_CB3();
void read_CB3();
#endif
