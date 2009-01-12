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

#ifndef _HIPRI_INT_H
#define _HIPRI_INT_H

enum {
  IRMAN_INTERRUPT = 0x00, /* Interrupt from IRMAN */
  PROC_INTERRUPT = 0x01 /* Interrupt from processor on Nerve board */
};

/**
 * @brief init function to setup HIPRI_INT input and IRMAN_HI input
 */
void hipri_int_init() ;

#ifndef _MODULE_
/**
 * @brief register module to receive message when a HIPRI_INT is received 
 * @param uint8_t pid The PID of the module that wants to be registered
 * @return int8_t SOS_OK if successful and -EINVAL if unsuccessful
 */
extern int8_t ker_hipri_int_register(uint8_t pid) ;

/**
 * @brief deregister module to stop it from receiving a message 
 * @param uint8_t pid The PID of the module that wants to be deregistered
 * @return int8_t SOS_OK if successful and -EINVAL if unsuccessful
 */
extern int8_t ker_hipri_int_deregister(uint8_t pid) ;

#endif

#endif //_HIPRI_INT_H
