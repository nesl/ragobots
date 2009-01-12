/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */
/*                                  tab:4
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
 *
 */

/**
 * @author David Lee
 */

#ifndef _ONEWIRE_H
#define _ONEWIRE_H

//Table of Function IDs
enum
  {
	/**
	 * @brief Write data on the one wire bus with no read expected 
	 * @param uint8_t pid The pid of the module that requested the write
	 * @param uint8_t* data The packet that will be written on the one-wire bus
	 * @param uint8_t size The packet size (number of bytes) to write on the one-wire bus
	 * @return int8_t SOS_OK if successful and -EBUSY if unsuccessful
	 */
	ONE_WIRE_WRITE_FID = 1,
   

	/**
	 * @brief Write data on the one wire bus followed by a Read on the bus  
	 * @param uint8_t pid The pid of the module that requested the write
	 * @param uint8_t* write_data The packet that will be written on the one-wire bus
	 * @param uint8_t write_size The packet size (number of bytes) to write on the one-wire bus
	 * @param uint8_t read_size The packet size (number of bytes) to read on the one-wire bus 
	 * @return int8_t SOS_OK if successful and -EBUSY if unsuccessful
	 */
	
	ONE_WIRE_READ_FID = 2
  };

typedef int8_t (*func_ri8u8u8ptru8_t)(func_cb_ptr proto, uint8_t arg0, uint8_t* arg1, uint8_t arg2);

typedef int8_t (*func_ri8u8u8ptru8u8_t)(func_cb_ptr proto, uint8_t arg0, uint8_t* arg1, uint8_t arg2, uint8_t arg3);

#ifndef _MODULE_
mod_header_ptr one_wire_get_header();
#endif 

#endif //_ONE_WIRE_H
