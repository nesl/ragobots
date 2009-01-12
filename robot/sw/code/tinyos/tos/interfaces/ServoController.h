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
  *
  * @author parixit@ee.ucla.edu
  **/

#ifndef SERVOCONTROLLER_H
#define SERVOCONTROLLER_H

#define MAX_TURN 90 // Allowable maximum turn in one direction. This is servo motor dependant.

#define NEUTRAL_PULSE_WIDTH 1500 // Pulse width in mili seconds for servo's neutral position.

/*Change in pulsewidth to change the position of servo to 1 degree.
Here servo requires change of 900 micro seconds to change its position by 90 degree. Assumes that servo is at -90 degrees at 600 micro second pulse width and at +90 for 2400 micro second.
*/
#define PULSE_SENSITIVITY 10

// Time it takes counter to go from BOTTOM to MAX in usec
#define COUNTER_PERIOD 8888

#define CNT_RANGE 256
#endif
