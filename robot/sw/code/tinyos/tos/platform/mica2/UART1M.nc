// $Id: UART1M.nc,v 1.3 2004/03/14 04:42:13 advait Exp $

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
 *
 * Authors:		Jason Hill, David Gay, Philip Levis, Phil Buonadonna, Parixit Aghera
 * Date last modified:  $Revision: 1.3 $
 * Revision History
 * -----------------
 *  Parixit Aghera: Changed the speed of UART to 9Kbps. Dual Motor Controller was missing commands at 
 * 19 kbps.
 *
 */

// The hardware presentation layer. See hpl.h for the C side.
// Note: there's a separate C side (hpl.h) to get access to the avr macros

// The model is that HPL is stateless. If the desired interface is as stateless
// it can be implemented here (Clock, FlashBitSPI). Otherwise you should
// create a separate component


/**
 * @author Jason Hill
 * @author David Gay
 * @author Philip Levis
 * @author Phil Buonadonna
 * @author Parixit Aghera // Modified the baudrate for dual serial motor controller.
 */

module UART1M {
  provides interface HPLUART as UART;

}
implementation
{
  async command result_t UART.init() {

    // UART will run at:

	// Set 9 Kbps. Refer to AVR manual for Clki/o = 7MHz.
	outp(0,UBRR1H);
	outp(47, UBRR1L);

	// Set UART single speed by turning off U2X1 and MPCM1
	outp(0,UCSR1A);

	// Set frame format: 8 data-bits, 1 stop-bit
	outp(((1 << UCSZ1) | (1 << UCSZ0)) , UCSR1C);

	// Enable reciever and transmitter and their interrupts
	outp(((1 << RXCIE) | (1 << TXCIE) | (1 << RXEN) | (1 << TXEN)) ,UCSR1B);

    return SUCCESS;
  }

  async command result_t UART.stop() {
      outp(0x00, UCSR1A);
      outp(0x00, UCSR1B);
      outp(0x00, UCSR1C);
      return SUCCESS;
  }

  default async event result_t UART.get(uint8_t data) { return SUCCESS; }
  TOSH_SIGNAL(SIG_UART1_RECV) {
    if (inp(UCSR1A) & (1 << RXC))
      signal UART.get(inp(UDR1));
  }

  default async event result_t UART.putDone() { return SUCCESS; }
#ifdef ENABLE_UART_DEBUG
#warning "UART Interrups Redirected"
#else
  TOSH_INTERRUPT(SIG_UART1_TRANS) {
    signal UART.putDone();
  }
#endif

  async command result_t UART.put(uint8_t data) {
    outp(data, UDR1);
    sbi(UCSR1A, TXC);
    return SUCCESS;
  }
}
