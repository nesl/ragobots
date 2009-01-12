/*
#################################################################################
# RAGOBOT:IRMAN HARDWARE DEFINITIONS
# ------------------------------------------------------------------------------
# Defines pins, ports, and signals (anything hardware specific)
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
# -----------------------------------------------------------------------------
# Jonathan Friedman, GSR
# Networked and Embedded Systems Laboratory (NESL)
# University of California, Los Angeles (UCLA)
#
# David Lee, GSR
# Networked and Embedded Systems Laboratory (NESL)
# University of California, Los Angeles (UCLA)
#
# REVISION HISTORY
# -----------------------------------------------------------------------------
# <for dates and comments, see cvs>
# Original by Jonathan Friedman, UCLA (jf@ee.ucla.edu)
# 5/23/2005 Added support for IRMAN_HI signal 		
###############################################################################
*/
#ifndef bcu_ragobot_h
#define bcu_ragobot_h

//System Speed
#define IRMAN_CLOCK 8000000 //8MHz Int RC


/**
 * @brief interrupt helpers
 */
#define HAS_CRITICAL_SECTION       register uint8_t _prev_
#define ENTER_CRITICAL_SECTION()   _prev_ = SREG & 0x80; cli()
#define LEAVE_CRITICAL_SECTION()   if(_prev_) sei()
#define ENABLE_INTERRUPT()         sei()
#define DISABLE_INTERRUPT()        cli()



//IR CLIFF
#define IRC_PORT	PORTC
#define IRC_IN		0

#define clear_irman_hi() PORTB = PORTB & 0xFE
#define set_irman_hi() PORTB = PORTB | 0x01
#define testled_off() PORTB = PORTB & 0xFE
#define testled_on() PORTB = PORTB | 0x01
#define testled_toggle() if (!(PORTB&0x01))PORTB |= 0x01; else PORTB &= 0xFE;

enum {
  ROBOT_STOP, 
  ROBOT_MOVE
};

uint8_t robot_state; 

void stall(uint16_t limit);

#endif

