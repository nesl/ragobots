// $Id: Explorer.nc,v 1.3 2004/03/24 09:11:17 parixit Exp $
// $Log: Explorer.nc,v $
// Revision 1.3  2004/03/24 09:11:17  parixit
// Demo version.
//
// Revision 1.2  2004/03/16 07:52:44  parixit
// Added motion control
//
// Revision 1.1  2004/03/15 09:33:05  parixit
//  First Version Created.
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
  * Explorer application is used to explore a terrain in random fashion. 
  * This application demonstrate ragobot's capability of IR sensing, Pan & Tilt
  * servos, and motion control.
  * @author Parixit Aghera (parixit@ee.ucla.edu)
  **/ 

configuration Explorer {
}
implementation {
  components Main, ExplorerM, ObstacleDetectionC, TimerC, LedsC, MotionControlC;

  Main.StdControl -> ExplorerM;
  Main.StdControl -> TimerC;
  Main.StdControl -> ObstacleDetectionC;

  //  ExplorerM.NavigationControl -> NavigationControlM;
  ExplorerM.ObstacleDetection -> ObstacleDetectionC;
  ExplorerM.Timer -> TimerC.Timer[unique("Timer")];
  ExplorerM.Leds -> LedsC;
  ExplorerM.MotionControl -> MotionControlC;
}
