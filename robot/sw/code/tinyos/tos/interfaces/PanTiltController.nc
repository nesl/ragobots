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
  * @author advait@cs.ucla.edu
  **/

interface PanTiltController {

  /**
   * Initialize the Pan-Tilt Controller.
   *
   * @return SUCCESS/FAIL.
   */
  command result_t init();

  /**
   * Changes Pan.
   * @param position The target position (in degrees) of the pan servo. The
   *    servo cannot move to arbitrary positions. The positions it can move
   *    to depend on the servo used.
   * @param panLock The time in milliseconds to lock the pan servo.
   * @return SUCCESS if the pan servo can be moved
   *         FAIL if parameter is invalid.
   */
  command result_t setPanPosition(int8_t position, uint8_t panLock);

  /**
   * Changes Tilt.
   * @param position The target position (in degrees) of the tilt servo. The
   *    servo cannot move to arbitrary positions. The positions it can move
   *    to are stored servoCalibration array.
   * @param tiltLock The time in milliseconds to lock the tilt servo.
   * @return SUCCESS if the tilt servo can be moved
   *         FAIL if parameter is invalid.
   */
  command result_t setTiltPosition(int8_t position, uint8_t tiltLock);

  /**
   * The signal generated when the pan servo has finished its task.
   * @param panPosition The actual position that the pan servo has moved to.
   */
  event void panPositionChanged(int8_t panPosition);

  /**
   * The signal generated when the tilt servo has finished its task.
   * @param tiltPosition The actual position that the tilt servo has moved to.
   */
  event void tiltPositionChanged(int8_t tiltPosition);
}
