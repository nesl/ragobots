/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4: */
/*                  tab:4
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
 * @author David Lee
 * 
 **/

/**
 *  Refer to Maxim MAX1138 Datasheet 
 *
 */

#ifndef _EXTADC_H
#define _EXTADC_H

//I2C Address of MAX1138 ADC
enum {
  I2C_EXT_ADC_ADDR = 0x35
};

/** SETUP BYTE FORMAT 
 *  BIT | 7 | 6  |  5 | 4  | 3 |   2   | 1 |  0  | 
 *      |REG|SEL2|SEL1|SEL0|CLK|BIP/UNI|RST|  X  |
 */


/**
 *  SETUP definitions
 *  Must OR the CONFIGURATION with the CHANNEL to create the full command
 *  
 */
enum {
	/* Resets Setup Register */
	RESET_SETUP_REG = 0x82,
	/* External Clock */
	USE_EXT_CLOCK = 0x88,
	/* Bipolar mode */
	BIPOLAR_MODE = 0x84,
	/* Reference Voltage = Vdd, Analog input */
	VDD_AIN = 0x80,
	/* Reference Voltage = External, Reference input */
	EXTREF_REFIN = 0xA0,
	/* Reference Voltage = Internal, Analog input (internal reference state = always off)*/
	INTREF_AIN = 0xC0,
	/* Reference Voltage = Internal, Analog input (internal reference state = always on)*/
	INTREF_AIN_AUTOSHTDWN = 0xD0,
	/* Reference Voltage = Internal, Reference output (internal reference state = always off) */
	INTREF_REFOUT = 0xE0,
	/* Reference Voltage = Internal, Reference output (internal reference state = always off) */
	INTREF_REFOUT_AUTOSHTDWN = 0xF0
};


/** CONFIGURATION BYTE FORMAT 
 *  BIT | 7 |  6  |  5  | 4 | 3 | 2 | 1 |   0   | 
 *      |REG|SCAN1|SCAN0|CS3|CS2|CS1|CS0|SGL/DIF|
 */

/**
 *  CONFIGURATION definitions
 *  Must OR the CONFIGURATION with the CHANNEL to create the full command
 *  
 */
enum {
  /* Scans down from CHANNEL0 to the selected CHANNEL. DIFFERENTIAL MODE*/
  SCAN_DOWN_TO_DIF = 0x00,
  /* Converts the selected CHANNEL eight times. DIFFERENTIAL MODE */
  SCAN_EIGHT_SAMPLES_DIF = 0x20, 
  /* Scans up from CHANNEL6 to the selected CHANNEL. DIFFERENTIAL MODE*/
  SCAN_UP_TO_DIF = 0x40,
  /* Converts the selected CHANNEL once. DIFFERENTIAL MODE */
  SCAN_ONCE_DIF = 0x60,
  /* Scans down from CHANNEL0 to the selected CHANNEL. SINGLE-ENDED MODE*/
  SCAN_DOWN_TO_SGL = 0x01,
  /* Converts the selected CHANNEL eight times. SINGLE-ENDED MODE */
  SCAN_EIGHT_SAMPLES_SGL = 0x21, 
  /* Scans up from CHANNEL6 to the selected CHANNEL. SINGLE-ENDED MODE*/
  SCAN_UP_TO_SGL = 0x41,
  /* Converts the selected CHANNEL once. SINGLE-ENDED MODE */
  SCAN_ONCE_SGL = 0x61,
};

/**
 *  CHANNEL definitions
 */
enum {
  CHANNEL0 = 0x00,
  CHANNEL1 = 0x02, 
  CHANNEL2 = 0x04, 
  CHANNEL3 = 0x06, 
  CHANNEL4 = 0x08, 
  CHANNEL5 = 0x0A, 
  CHANNEL6 = 0x0C, 
  CHANNEL7 = 0x0E, 
  CHANNEL8 = 0x10, 
  CHANNEL9 = 0x12, 
  CHANNEL10 = 0x14, 
  CHANNEL11 = 0x16
};

//#ifndef _MODULE_
//int8_t magsensor_init(void) SOS_DEV_SECTION;
//int8_t photosensor_init(void) SOS_DEV_SECTION;
//int8_t sounder_init(void) SOS_DEV_SECTION;
//#endif


#endif // _EXTADC_H

