/*
#################################################################################
# RAGOBOT:IRMAN MOTOR DEFINITIONS
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
#ifndef motor_h
	#define motor_h

//DEFINES
	//MOTOR CONTROL
	//Commands
		#define M_FWD1	4 //100
		#define M_FWD2	5 //101
		#define M_FWD3	6 //110
		#define M_FWD4	7 //111
		#define M_STOP	0 //000
		#define M_REV1	1 //001
		#define M_REV3	2 //010
		#define M_REV4	3 //011
		
	//Speeds
		#define set_speed(d) d //((d*255/100))
		#define M_SPD1	160
		#define M_SPD2	190
		#define M_SPD3	215
		#define M_SPD4	255

	//I2C COMMAND PROTOCOL
	//COMM PACKET BIT TAGS
		#define TYPE1 		7
		#define TYPE0 		6

	//SPECIFIC TO MOTOR TYPE COMMAND
		#define LEFT_DIR 	5
		#define LEFT_SPD1 	4
		#define LEFT_SPD0 	3
		#define RIGHT_DIR 	2
		#define RIGHT_SPD1 	1
		#define RIGHT_SPD0 	0
		
//FUNCTIONS
	void init_motor();
	void move(uint8_t a, uint8_t b);
	void motor_parse(uint8_t cmd);

#endif
