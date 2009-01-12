/*
#################################################################################
# RAGOBOT:IRMAN INFRARED DEFINITIONS
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
#ifndef ircomm_h
#define ircomm_h

extern volatile uint16_t cliff0_val;
extern volatile uint16_t cliff1_val;

//IR MODULATION CLOCK
#define CLOCK_STOPH 0x00	//48 = 600us
#define CLOCK_STOPL 48

#define PERIOD_ACTIVE 72  //37 = 600us
#define PERIOD_REST 126	//63 = 1000us

#define	LOW		4
#define MED		6
#define HIGH	2
#define FIRE	7
#define OFF		3

//PHYS AND MAC LAYERS!
#define NUM__OF_CHANNELS 7

#define SYM_0		6
#define SYM_1		4
#define SYM_START	2
#define SYM_MARGIN  1

#define SYM_INVD_Q	0
#define SYM_0_Q		1
#define SYM_1_Q		2
#define SYM_START_Q	3

	//States
		#define S0	0
		#define S2	2

	
//FUNCTIONS

	//clock
	void init_irclock();
	inline void reset_irclock(void);
	inline void start_irclock();
	inline void stop_irclock();
	inline void disable_output_irclock();
	inline void enable_output_irclock();
	
	//ISR
	inline void USRT_DATA_RX_ISR(uint8_t data0, uint8_t data1);
		
	//power ctrl
	extern void iris_tx(uint8_t cmd);
	extern void iris_weapon(uint8_t cmd);
	extern void iris_rx(uint8_t cmd);
	
	//init
	void init_iris();
	void init_irtx();

#endif
