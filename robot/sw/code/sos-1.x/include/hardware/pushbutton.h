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

#ifndef _PUSHBUTTON_H
#define _PUSHBUTTON_H

//Table of Function IDs
enum 
  {
	/**
	 * @brief register module to receive message when pushbutton is pressed 
	 * @param uint8_t pid The PID of the module that wants to be registered
	 * @return int8_t SOS_OK if successful and -EINVAL if unsuccessful
	 */
	PUSHBUTTON_REGISTER_FID = 1, /*pushbutton_register*/

	/**
	 * @brief deregister module to stop it from receiving a message 
	 * @param uint8_t pid The PID of the module that wants to be deregistered
	 * @return int8_t SOS_OK if successful and -EINVAL if unsuccessful
	 */
	PUSHBUTTON_DEREGISTER_FID = 2 /*pushbutton_deregister*/
  };

//typedef int8_t (*func_ri8u8_t)(func_cb_ptr proto, uint8_t arg0);

#ifndef _MODULE_
mod_header_ptr pushbutton_get_header();
#endif 

#endif //_PUSHBUTTON_H
