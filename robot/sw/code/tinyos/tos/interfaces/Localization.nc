// $Id: Localization.nc,v 1.3 2004/10/23 22:21:53 parixit Exp $
// $Log: Localization.nc,v $
// Revision 1.3  2004/10/23 22:21:53  parixit
// Removed return types of events where it was not required.
//
// Revision 1.2  2004/06/14 00:14:19  parixit
// This version performs adquate navigation. There is still a problem in Orientation and MotionControl. Orientation requires averaging the location information and MotionControl sometimer doesn't stop the turn. Also need to modify the DualMotorController to reset the controller initially.
//
// Revision 1.1  2004/06/05 23:41:01  parixit
// Created
//
// Revision 1.1  2004/03/24 09:26:44  parixit
// *** empty log message ***
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
  *  Localization interface definition.
  *
  * @author Parixit Aghera (parixit@ee.ucla.edu)
  **/ 

includes Localization;

interface Localization {
  command  result_t getLocation();
  event void location(LocalizationInfo *l);
}
