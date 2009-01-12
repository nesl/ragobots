//$Id: IRRanger.nc,v 1.2 2004/03/15 09:40:19 parixit Exp $
//$Log: IRRanger.nc,v $
//Revision 1.2  2004/03/15 09:40:19  parixit
//Updated IRRangerM to convert DEC reading to physical distance in cm.
//IRRanger has beeb updated by adding a return character at the end to avoid compilatio error.
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
  * IRRangerM implements driver for Sharp GP2D02 IR ranger device.
  *
  * @author parixit@ee.ucla.edu
  **/

interface IRRanger{

  /**
   * Initialize the IR Ranger Device specific parameters.
   *
   * @return SUCCESS/FAIL.
   */
	command result_t init();


	/**
	 * Trigerrs the IR Ranger to measure the distance.
 	 *
	 * @return SUCCESS/FAIL
 	 */
 	 command result_t getDistance();

	/**
 	  * Triggerred by hardware interrupt.
	  * @param uint8_t gives distance from a surface.
	  *
 	  */
	async event void distance(uint8_t distance);

}
