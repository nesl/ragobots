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
#ifndef irman_ragobot_h
#define irman_ragobot_h

//System Speed
#define IRMAN_CLOCK 8000000 //8MHz Int RC
#define M_PWM_EN TCCR0B = B8(00000101) //prescale 8MHz to 1MHz via 1024 divider
#define M_PWM_DISABLE TCCR0B = 0x00 //Shutoff Timer 0

//MOTOR CONTROL
//Signals
#ifdef _B2_
	#define M_DIR_PORT	PORTB
	#define M_DIR0		1
	#define M_DIR1		2
	#define M_PWM_PORT	PORTD
	#define M_PWM0		6
	#define M_PWM1		5
#else
	//B1
	#define M_DIR_PORT	PORTB
	#define M_DIR0		0
	#define M_DIR1		1
	#define M_PWM_PORT	PORTD
	#define M_PWM0		6
	#define M_PWM1		5
#endif
//Hw_Cmds
#define M_PWM_OUTL sbi(TCCR0A, 7); M_PWM_EN
#define M_PWM_OUTL_DISABLE cbi(TCCR0A, 7) //Left comes before Right so it doesn't disable PWM in-case Right is using it.
#define M_PWM_OUTR sbi(TCCR0A, 5); M_PWM_EN
#define M_PWM_OUTR_DISABLE cbi(TCCR0A, 5)

//IR CLIFF
#define IRC_PORT	PORTC
#define IRC_IN		0


#endif
