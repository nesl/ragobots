/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4: */
/*   tab:4 */
/*					
 * "Copyright (c) 2000-2003 The Regents of the University  of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 *
 * @author Jonathan Friedman jf@ee.ucla.edu
 * @author David Lee (Ported to SOS and Modified for Rev. B)
 */
/**
 * @brief Provides Direct Access, Low-Level Control of the CB2BUS on the 
 * Ragobot controlled by a Mica2
 */

#ifndef _CB2BUS_HARDWARE_H_
#define _CB2BUS_HARDWARE_H_

//PIN & PORT DEFINITIONS
#define CB2PORT		PORTC	//CB2PORT AND CB2DDR MUST MATCH!
#define CB2DDR		DDRC
#define CB2RESET 	3
#define CB2CLOCK 	5
#define CB2INPUT 	6
#define CB2HSSELECT     4

//TIMING
#define clock_stall asm volatile("nop\n\t" "nop\n\t" "nop\n\t" : : )

#ifndef _MODULE_
/**
 *  @brief initializes the Mica2 to support the cb2bus
 *  @return void
 */
void cb2bus_hardware_init() ;

/**
 *  @brief load the configuration onto the CB2Bus
 *  @param uint8_t vport The array of configuration bytes to be loaded
 *  @param uint8_t size The size of the vport array
 *  @return void
 */
extern void ker_cb2bus_load(uint8_t vport[], int8_t size) ;
#endif

#endif //_CB2BUS_HARDWARE_H_
