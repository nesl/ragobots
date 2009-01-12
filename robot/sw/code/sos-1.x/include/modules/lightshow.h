//$Id: 
//$Log:

/*									tab:4
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
 * Global Exposure of Low-Level Virtual Expansion Ports (CB2)
 * @author Jonathan Friedman  jf@ee.ucla.edu
 **/

#ifndef __LIGHTSHOW__H__
#define __LIGHTSHOW__H__

#include <modules/cb2bus.h>

//MESSAGE TYPES
enum 
{
  //Start the light show
  MSG_LIGHTSHOW_START = (MOD_MSG_START+0),
  //Stop the light show at its current state.
  MSG_LIGHTSHOW_STOP = (MOD_MSG_START+1),
  //ENABLE/DISABLE decklights
  MSG_LIGHTSHOW_DECKLIGHTS = (MOD_MSG_START+2),
  //ENABLE/DISABLE headlights
  MSG_LIGHTSHOW_HEADLIGHTS = (MOD_MSG_START+3),
  //ENABLE/DISABLE bargraph
  MSG_LIGHTSHOW_BARGRAPH = (MOD_MSG_START+4)
};

//CONDITIONS FOR ENABLING COMPONENTS
#define DISABLE    0x00
#define ENABLE     0x01

#ifndef _MODULE_
mod_header_ptr lightshow_get_header();
#endif

#endif
