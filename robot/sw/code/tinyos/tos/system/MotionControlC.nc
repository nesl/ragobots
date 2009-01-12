/*                                                                      tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.
 * All rights reserved.
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
 * Implementation of MotionControl Interface
 *
 * @author Balaji Vasu (vbalaji@cs.ucla.edu)
 *
 */

configuration MotionControlC
{
  provides
  {
   interface MotionControl;
  }
}
implementation
{
  components MotionControlM, DualMotorControllerM, UART1M, LedsC, TimerC;
  MotionControl = MotionControlM; 

  DualMotorControllerM.UART -> UART1M;
  DualMotorControllerM.Leds -> LedsC;
  DualMotorControllerM.Timer -> TimerC.Timer[unique("Timer")];

  MotionControlM.DualMotorControl -> DualMotorControllerM;
  MotionControlM.mfTimer -> TimerC.Timer[unique("Timer")];
  MotionControlM.turnTimer -> TimerC.Timer[unique("Timer")];
 
  MotionControlM.Leds -> LedsC;
}


