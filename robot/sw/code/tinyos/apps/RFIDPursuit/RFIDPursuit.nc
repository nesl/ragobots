// $Id: RFIDPursuit.nc,v 1.1 2004/06/15 10:28:59 Jonathan Exp $

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

/* 
 * @author Parixit Aghera
 */

configuration RFIDPursuit {}
implementation
{
  components Main, RFIDPursuitM, M1_RFIDControllerC, TimerC, LedsC, MotionControlC, CB2BusM, ObstacleDetectionC;
	//STDCONTROL
		Main.StdControl -> RFIDPursuitM;
		Main.StdControl -> TimerC;
		Main.StdControl -> M1_RFIDControllerC;
		Main.StdControl -> ObstacleDetectionC;
  		RFIDPursuitM.Timer -> TimerC.Timer[unique("Timer")];
  		
	//SENSING
		RFIDPursuitM.RFIDController -> M1_RFIDControllerC;
		RFIDPursuitM.ObstacleDetection -> ObstacleDetectionC;	
		
	//ACTUATION
  		RFIDPursuitM.MotionControl -> MotionControlC;
  
  	//ANNUNCIATION
  		RFIDPursuitM.Leds -> LedsC;
  		RFIDPursuitM.CB2 -> CB2BusM;
}
