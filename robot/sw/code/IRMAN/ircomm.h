/*
#################################################################################
# RAGOBOT:IRMAN INFRARED DEFINITIONS
# ------------------------------------------------------------------------------
# Defines pins, ports, and signals
# 
# APPLIES TO (Ragobot Part Numbers):
# ------------------------------------------------------------------------------
# RBTBDYC
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

#define ENABLE 0
#define DISABLE 1
#define TOGGLE 2

//IR CLIFF DETECTOR (ADC)
extern volatile uint16_t IRC0_THRESHOLD; 
extern volatile uint16_t IRC1_THRESHOLD;
#define SIZE_OF_SAMPLE_SET 8
#define IRC_MASK 0xFFFE
#define NUMSAMPLESTOIGNORE 10
	
//IR CLIFF DETECTOR States
enum {
  IRC_IDLE,
  IRC_CALIBRATE0_START,
  IRC_CALIBRATE0,
  IRC_CALIBRATE1_START,
  IRC_CALIBRATE1,
  IRC_READCHANNEL0,
  IRC_READCHANNEL1
};


//PHYS AND MAC LAYERS!
#define S0 0
#define S1 1
#define S2 2
#define S9 9

#define SYM_0		4
#define SYM_1		1
#define SYM_START	7
#define SYM_MARGIN  2

#define ircliff_detector_off() cbi(PORTD, 7)
#define ircliff_detector_on() sbi(PORTD, 7)
	
//FUNCTIONS
void init_irclock();
inline void reset_irclock(void);
inline void cntrl_irclock(uint8_t);
void init_ircliff();
void ircliff_low();
void ircliff_medium();
void ircliff_high();
void ircliff_off();
void ircliff_calibrate();
void ircliff_led_low();
void ircliff_led_medium();
void ircliff_led_high();
void ircliff_led_off();
void air_led_low();
void air_led_medium();
void air_led_high();
void air_led_off();
void air_led_fire();
void read_channel(uint8_t);

inline void blue_led_on();
inline void blue_led_off();
inline void ired_led_on();
inline void ired_led_off();
#endif
