// $Id: ObstacleDetectionC.nc,v 1.2 2004/03/16 07:51:23 parixit Exp $
// $Log: ObstacleDetectionC.nc,v $
// Revision 1.2  2004/03/16 07:51:23  parixit
// Added code for debugging.:wq
//
// Revision 1.1  2004/03/15 09:34:17  parixit
// Created.
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
  * Configuration for ObstacleDetection interface implementation.
  *
  * @author Parixit Aghera (parixit@ee.ucla.edu)
  **/ 

configuration ObstacleDetectionC {
  provides {
    interface StdControl;
    interface ObstacleDetection;
  }
}
implementation{
  components ObstacleDetectionM, IRRangerM, PanTiltControllerC, TimerC, LedsC;
  StdControl = ObstacleDetectionM;

  ObstacleDetection = ObstacleDetectionM;
  ObstacleDetectionM.IRRanger -> IRRangerM;
  ObstacleDetectionM.PanTiltController -> PanTiltControllerC;
  ObstacleDetectionM.Timer -> TimerC.Timer[unique("Timer")];
  ObstacleDetectionM.Leds -> LedsC;
  
  IRRangerM.Timer -> TimerC.Timer[unique("Timer")];
  IRRangerM.Leds -> LedsC;
}
