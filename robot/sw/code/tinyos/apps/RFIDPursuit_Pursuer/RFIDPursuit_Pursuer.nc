// $Id: RFIDPursuit_Pursuer.nc,v 1.1 2004/11/09 09:36:56 davidlee Exp $

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
 * @author David Lee
 */

configuration RFIDPursuit_Pursuer {}
implementation
{
  components Main, RFIDPursuit_PursuerM, M1_RFIDControllerC, TimerC, LedsC, MotionControlC, CB2BusM, ObstacleDetectionC;
	//STDCONTROL
		Main.StdControl -> RFIDPursuit_PursuerM;
		Main.StdControl -> TimerC;
		//Main.StdControl -> M1_RFIDControllerC;
		Main.StdControl -> ObstacleDetectionC;
  		RFIDPursuit_PursuerM.Timer -> TimerC.Timer[unique("Timer")];
  		
	//SENSING
		RFIDPursuit_PursuerM.RFIDController -> M1_RFIDControllerC;
		RFIDPursuit_PursuerM.ObstacleDetection -> ObstacleDetectionC;	
		
	//ACTUATION
  		RFIDPursuit_PursuerM.MotionControl -> MotionControlC;
  
  	//ANNUNCIATION
  		RFIDPursuit_PursuerM.Leds -> LedsC;
  		RFIDPursuit_PursuerM.CB2 -> CB2BusM;
}
