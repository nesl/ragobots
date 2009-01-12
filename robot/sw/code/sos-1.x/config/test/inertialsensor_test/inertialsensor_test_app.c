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
 */
/**
 * @author David Lee
 */
/**
 * @brief An application to test the accelerometers
 * Pushing the button does the following (all values are raw adc values)
 * 1) get the magnetometer and accelerometer values and display the 
 *    magnetometer x value.
 * 2) Display the magnetometer y value.
 * 3) Display the magnetometer z value.
 * 4) Display the accelerometer x value.
 * 5) Display the accelerometer y value.
 * 6) Display the accelerometer z value.
 * 7) Clear screen
 */

#include <sos.h>
#include <pushbutton.h>
#include <cb2bus_hardware.h>
#include <modules/cb2bus.h>
#include <modules/inertialsensor.h>
#include "../../../modules/test/inertialsensor_test/inertialsensor_test.h"

void sos_start(void)
{
  ker_register_module(cb2bus_hardware_get_header());
  ker_register_module(cb2bus_get_header());
  ker_register_module(pushbutton_get_header());
  ker_register_module(inertialsensor_get_header());
  ker_register_module(inertialsensor_test_get_header());
}
