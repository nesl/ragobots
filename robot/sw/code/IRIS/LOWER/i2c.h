/*
#################################################################################
# RAGOBOT:IRMAN I2C SERIAL DEFINITIONS
# ------------------------------------------------------------------------------
# Defines addresses, functions, and signals
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

#ifndef i2c_h
	#define i2c_h

//ADDRESS PROTOCOL
#define READ			1
#define WRITE			0

//ADDRESSES
#define GENERAL_ADDRESS	00
#define IRIS_ADDRESS	41
#define BCU_ADDRESS 	42
#define DDSC_ADDRESS 	48
#define ADC_ADDRESS		53
#define ALERT_ADDRESS	63

//STATES
#define IDLE			1
#define BUSY			2

//address to which IRIS should send data received over the air
#define IRIS_REPORTING_ADDRESS DDSC_ADDRESS

#define MAX_BUFFER_LEN 250
#define MAX_IBUFFER_LEN 10

//FUNCTIONS
void init_I2C();
inline void I2C_send();

inline void i2c_enqueue(uint8_t blah);
inline uint8_t i2c_dequeue(void);
inline uint8_t i2c_count(void);
void init_i2c_buffer(void);

inline void i2c_ienqueue(uint8_t blah);
inline uint8_t i2c_idequeue(void);
inline uint8_t i2c_icount(void);
void init_i2c_ibuffer(void);

#endif
