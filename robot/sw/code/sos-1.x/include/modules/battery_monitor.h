/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */
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
 * @author David Lee
 **/

#ifndef __BATT_MON__H__
#define __BATT_MON__H__

//MESSAGE TYPES
enum 
{
 
  MSG_GET_VOLTAGE = (MOD_MSG_START+0),
  MSG_GET_TEMPERATURE = (MOD_MSG_START+1),
  MSG_GET_ROM_ID = (MOD_MSG_START+2),
  MSG_GET_CURRENT = (MOD_MSG_START+3),

  MSG_GET_ROM_ID_DONE = (MOD_MSG_START+10),
  MSG_GET_VOLTAGE_DONE = (MOD_MSG_START+11),
  MSG_GET_TEMPERATURE_DONE = (MOD_MSG_START+12),
  MSG_GET_CURRENT_DONE = (MOD_MSG_START+13)
};

#ifndef _MODULE_
mod_header_ptr battery_monitor_get_header();
#endif 

#endif //__BATT_MON__H__

