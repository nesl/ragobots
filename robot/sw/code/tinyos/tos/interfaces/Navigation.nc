//$Id: Navigation.nc,v 1.1 2004/06/14 00:14:19 parixit Exp $
//$Log: Navigation.nc,v $
//Revision 1.1  2004/06/14 00:14:19  parixit
//This version performs adquate navigation. There is still a problem in Orientation and MotionControl. Orientation requires averaging the location information and MotionControl sometimer doesn't stop the turn. Also need to modify the DualMotorController to reset the controller initially.
//
//Revision 1.2  2004/03/15 09:40:19  parixit
//Updated LocalizationM to convert DEC reading to physical distance in cm.
//Localization has beeb updated by adding a return character at the end to avoid compilatio error.
//
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
  * @author Anitha Vijayakumar avijayak@ee.ucla.edu
  **/


interface Navigation{

  /**
   * Initialize the Navigation specific parameters.
   *
   * @return SUCCESS/FAIL.
   */
	command result_t init();



	/**
	 * Trigerrs the Navigation to move to the location.
 	 *
	 * @return SUCCESS/FAIL
 	 */
 	 command result_t moveTo(uint16_t x, uint16_t y);
	/**
	 * Trigerrs the Navigation to abort its movement.
 	 *
	 * @return SUCCESS/FAIL
 	 */
 	 command void abort();
	/**
	 * Trigerrs the Navigation to move to the location.
 	 *
	 * @return SUCCESS/FAIL
 	 */
 	event void moveDone(uint16_t x, uint16_t y);
}
