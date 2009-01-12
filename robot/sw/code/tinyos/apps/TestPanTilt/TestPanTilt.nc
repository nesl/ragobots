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

includes TestPanTilt;

configuration TestPanTilt{
}
implementation {
  components Main, TimerC, TestPanTiltM, PanTiltControllerC, LedsC, GenericComm; 
  Main.StdControl -> TestPanTiltM.StdControl;
  
  TestPanTiltM.PTC -> PanTiltControllerC;
  TestPanTiltM.Timer -> TimerC.Timer[unique("Timer")];
  TestPanTiltM.Leds -> LedsC;
  TestPanTiltM.RFControl -> GenericComm;
  TestPanTiltM.RFReceiveMsg -> GenericComm.ReceiveMsg[AM_CALIBRATE];
}

