// $Id: VerifyM1_rfid.nc,v 1.2 2004/10/14 11:12:15 davidlee Exp $

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
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
/* 
 * @author David Lee
 */

configuration VerifyM1_rfid {}
implementation
{
  components Main, VerifyM1_rfidM, M1_RFIDControllerC, TimerC, LedsC, UART0M;

  Main.StdControl -> VerifyM1_rfidM;
  Main.StdControl -> TimerC;
  
  VerifyM1_rfidM.RFIDController -> M1_RFIDControllerC;
  VerifyM1_rfidM.Timer -> TimerC.Timer[unique("Timer")];
  VerifyM1_rfidM.Leds -> LedsC;
  
  /*(
  M1_RFIDControllerM.Leds -> LedsC;
  M1_RFIDControllerM.UART -> UART0M;
  M1_RFIDControllerM.Timer -> TimerC.Timer[unique("Timer")];
  */
}
