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

//PHYS AND MAC LAYERS!
#define NUM__OF_CHANNELS 7
#define S0 0
#define S1 1
#define S2 2
#define S9 9

//Used to define the pulse widths of the various symbols in terms of #samples
#define SYM_0			6
#define SYM_0_MARGIN		1
#define SYM_1			4
#define SYM_1_MARGIN		1
#define SYM_START		2
#define SYM_START_MARGIN	1

//Used to communicate decoded symbols from IRISU to IRISL
#define QSYM_INVD	0
#define QSYM_0		1
#define QSYM_1		2
#define QSYM_START	3

#define DQ_PERIOD	1

//FUNCTIONS
extern void init_air();
extern void init_iris();
inline void air_get_channels();
inline void air_proc_channel(uint8_t);
extern void air_sample();
extern inline void air_dequeue();
inline uint8_t get_air_capture(void);
inline void set_air_capture(uint8_t newval);
inline void reset_sym_xfr(void);
void debug_transfer_sym(void);
void transfer_sym_debug(void);
void load_sym_xfr(uint8_t channel_num, uint8_t symbol);
void transfer_sym(void);

#endif
