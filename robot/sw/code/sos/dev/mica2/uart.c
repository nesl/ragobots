/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */
/*
 * Copyright (c) 2003 The Regents of the University of California.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above
 *    copyright notice, this list of conditions and the following
 *    disclaimer in the documentation and/or other materials provided
 *    with the distribution.
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgement:
 *       This product includes software developed by Networked &
 *       Embedded Systems Lab at UCLA
 * 4. Neither the name of the University nor that of the Laboratory
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */

#include <sos.h>
/*
#if (defined USE_UART_STREAM || defined USE_UART_RAW_STREAM || defined SOS_USE_PRINTF)
#include <uart_stream.h> 
#else
#include <uart_stub.h>
#endif
*/
#include "uart.h"
#include <uart_ragobot.h>
/*
#if 0
#if defined SOS_USE_PRINTF 
int uart_putchar(char c){

	if (c == '\n') {
		char ret = '\r';
		ker_uart_send((uint8_t*)&ret, 1, 0); 
	}

	ker_uart_send((uint8_t*)&c, 1, 0);
	return 0;
}
#endif
#endif *//* #if 0 */
void uart_hardware_init(void){
	HAS_CRITICAL_SECTION;

	ENTER_CRITICAL_SECTION();

	//! UART0 will run at: 57.6kbps, N-8-1
	UBRR0H = 0;
	UBRR0L = 15;

	//! Set UART0 double speed
	UCSR0A = (1 << U2X);
	//! Set UART0 frame format: 8 data-bits, 1 stop-bit
	UCSR0C = ((1 << UCSZ1) | (1 << UCSZ0));

	//! UART1 will run at: 57.6kbps, N-8-1
	UBRR1H = 0;
	UBRR1L = 15;

	//! Set UART1 double speed
	UCSR1A = (1 << U2X);
	//! Set UART1 frame format: 8 data-bits, 1 stop-bit
	UCSR1C = ((1 << UCSZ1) | (1 << UCSZ0));

	/**
	 * Enable reciever and transmitter and their interrupts
	 * transmit interrupt will be disabled until there is 
	 * packet to send.
	 */
/*
#if 0
#if defined SOS_NIC || defined SOS_EMU || defined SOS_UART_MESSAGING
	UCSR0B = ((1 << RXCIE) | (1 << RXEN) | (1 << TXEN));
#endif

#if (defined USE_UART_STREAM || defined USE_UART_RAW_STREAM || defined SOS_USE_PRINTF)
	UCSR0B = (1 << TXEN);
	
#endif
#ifdef SOS_USE_PRINTF
	fdevopen(uart_putchar, NULL, 0);
#endif
#else*/  /* #if 0 */
	/*	UCSR0B = ((1 << RXCIE) | (1 << RXEN) | (1 << TXEN));
#endif *//* #if 0 */
	//UCSR0B = ((1 << RXCIE) | (1 << TXCIE) | (1 << RXEN) | (1 << TXEN));
	//UCSR1B = ((1 << RXCIE) | (1 << TXCIE) | (1 << RXEN) | (1 << TXEN));  
	UCSR0B = ((1 << RXEN) | (1 << TXEN));
	UCSR1B = ((1 << RXEN) | (1 << TXEN));
	LEAVE_CRITICAL_SECTION();
	//uart_init();
}



