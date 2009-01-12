/*
#################################################################################
# JONATHAN'S COLLECTION USEFUL UTILITIES (NOT NECESSARILY WRITTEN BY JONATHAN)
# ------------------------------------------------------------------------------
# A set of common macros and utilities that are useful
# 
# APPLIES TO (Ragobot Part Numbers):
# ------------------------------------------------------------------------------
# ALL
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
# Original by Jonathan Friedman, UCLA (jf@ee.ucla.edu) 		
#################################################################################
*/
#ifndef tp_h
	#define tp_h
	
	//must be defined to the same value
	#define	ON		1
	#define HIGH 	1
	
	///must be defined to the same value
	#define OFF		2
	#define LOW		2
	
	#define TOGGLE 	3
	
	inline void init_tp();
	inline void tpl(uint8_t cmd);
	inline void tp4(uint8_t cmd);
	inline void tp5(uint8_t cmd);
		
#endif
