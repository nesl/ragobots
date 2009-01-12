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
 * IR Transmitter from Panasonic LN51L
 * 
 * @author Anitha Vijayakumar avijayak@ee.ucla.edu
 **/

module IRReceiverM{
  provides{
    interface IRReceiver;
  }
  uses{
    interface Leds;
  }
}

implementation{

  command result_t IRReceiver.init(){

  //Set PE6, the hipri_int, to an input pin
  cbi(DDRE, 6);
  cbi(PORTE, 6);

  //enable INT6
  sbi(EIMSK, 6);

  //generate interrupt on rising edge
  sbi(EICRB, 5);
  sbi(EICRB, 4);

  //Set PG2, the irman_hi signal to an input pin. 
  cbi(DDRG, 2);
  cbi(PORTG, 2);

  //Set PC0, the irman_reset signal to input. 
  cbi(DDRC, 0);
  cbi(PORTC, 0);

    return SUCCESS;
  }

  task void signal_received_signal()
  {
    signal IRReceiver.received_signal();
  }

  TOSH_SIGNAL(SIG_INTERRUPT6) {
	post  signal_received_signal();


  }
   
}


