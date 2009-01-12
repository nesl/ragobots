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
# Modified by David Lee, UCLA	
#################################################################################
*/

#ifndef i2c_h
#define i2c_h

#define IRIS_ADDRESS	41
#define BCU_ADDRESS 	42
#define DDSC_ADDRESS 	48
#define ADC_ADDRESS		53
#define ALERT_ADDRESS	63

#define MAX_BUFFER_LEN 250

void init_I2C_slave();
inline uint8_t i2c_dequeue(void);
inline uint8_t i2c_count(void);

#endif
