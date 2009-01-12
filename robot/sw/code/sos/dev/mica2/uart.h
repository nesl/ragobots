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

#ifndef _SOS_UART_H
#define _SOS_UART_H


/**
 * @brief UART task
 */
extern void uart_hardware_init(void);
extern int uart_putchar(char c);
/**
 * @brief check uart frame error and data overrun error
 * @return no zero for error, zero for no error
 */
#define uart0_checkerror()          (UCSR0A & 0x18)
#define uart0_getbyte()             UDR0
#define uart0_setbyte(b)            UDR0 = (b)
#define uart0_recv_interrupt()      SIGNAL(SIG_UART0_RECV)
#define uart0_send_interrupt()      SIGNAL (SIG_UART0_DATA)
#define uart0_disable_recv()        UCSR0B &= ((unsigned char)~(1<<(RXCIE)))
#define uart0_enable_recv()         UCSR0B |= (1<<(RXCIE))
#define uart0_disable_send()        UCSR0B &= ((unsigned char)~(1<<(UDRIE)))
#define uart0_enable_send()         UCSR0B |= (1<<(UDRIE))
#define uart0_is_disabled()         ((UCSR0B & (1 << UDRIE)) == 0)

#define uart1_checkerror()          (UCSR1A & 0x18)
#define uart1_getbyte()             UDR1
#define uart1_setbyte(b)            UDR1 = (b)
#define uart1_recv_interrupt()      SIGNAL(SIG_UART1_RECV)
#define uart1_send_interrupt()      SIGNAL (SIG_UART1_DATA)
#define uart1_disable_recv()        UCSR1B &= ((unsigned char)~(1<<(RXCIE)))
#define uart1_enable_recv()         UCSR1B |= (1<<(RXCIE))
#define uart1_disable_send()        UCSR1B &= ((unsigned char)~(1<<(UDRIE)))
#define uart1_enable_send()         UCSR1B |= (1<<(UDRIE))
#define uart1_is_disabled()         ((UCSR1B & (1 << UDRIE)) == 0)

/*NOT IN USE ON THE RAGOBOT */
#define uart_checkerror()          (UCSR0A & 0x18)
#define uart_getbyte()             UDR0
#define uart_setbyte(b)            UDR0 = (b)
#define uart_recv_interrupt()      SIGNAL(SIG_UART0_RECV)
#define uart_send_interrupt()      SIGNAL (SIG_UART0_DATA)
#define uart_disable_recv()        UCSR0B &= ((unsigned char)~(1<<(RXCIE)))
#define uart_enable_recv()         UCSR0B |= (1<<(RXCIE))
#define uart_disable_send()        UCSR0B &= ((unsigned char)~(1<<(UDRIE)))
#define uart_enable_send()         UCSR0B |= (1<<(UDRIE))
#define uart_is_disabled()         ((UCSR0B & (1 << UDRIE)) == 0)
#endif // _SOS_UART_H


