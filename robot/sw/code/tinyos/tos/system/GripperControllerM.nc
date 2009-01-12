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

module GripperControllerM {
  provides {
    interface StdControl;
    interface GripperController;
  }
  uses {
    interface ServoController;
  }
}
implementation {

  command result_t StdControl.init() {
    /*    //Make INT1 as input pin
    TOSH_CLR_INT1_PIN();
    TOSH_MAKE_INT1_INPUT();

    //Set interrupt on rising edge
    cbi(EIMSK, 4);
    EICRB = EICRB | 0x03;
    sbi(EIMSK, 4);*/

    return call ServoController.init();
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    return SUCCESS;
  }

  command result_t GripperController.grabObject() {
    return call ServoController.setPosition(GRIPPER_SERVO_ID, GRIPPER_GRAB_POSITION);
  }

  command result_t GripperController.releaseObject() {
    return call ServoController.setPosition(GRIPPER_SERVO_ID, GRIPPER_DROP_POSITION);
  }

  command uint16_t GripperController.getObjectType() {
    return currentObject;
  }

  /*  TOSH_SIGNAL(SIG_INTERRUPT5) {
    /*    uint8_t data;
    char prev = inp(SREG);

    //Read value from adc port
    cli();
    outp(adcport??, ADMUX);
    cbi(ADCSR, ADIF);
    sbi(ADCSR, ADEN);
    sbi(ADCSR, ADSC);

    //Check if data is ready
    while(1) {
      regADCSR = inp(ADCSR);
      if(!(regADSCR &0x40))
	break;
      TOSH_uwait(1000);
    }
    TOSH_uwait(1000);
    data = inw(ADCL);
    cbi(ADCSR, ADEN);
    sei();
    outp(prev, SREG);*/
    atomic currentObject = OBJECT_UNIDENTIFIED;
    //    signal async event objectGrabbed();
  }*/
}
