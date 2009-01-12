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
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODSuisp OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * 
 */
/**
 * @brief    Ragobot uart driver stream
 * @author   David Lee
 *
 */

#include <ragobot_module.h>
#include <malloc.h> 
#include <uart_ragobot.h>
#include <avr/signal.h>

//! keep this value in power of two for speed purpose
#define UART_STREAM_QUEUE_SIZE 128
#define UART_STREAM_QUEUE_MASK 127

enum {
  UART_IDLE = 0, 
  UART_READBUSY = 1
};

typedef struct {
  uint8_t state; 
  uint8_t send_wr;
  uint8_t send_rd;
  uint8_t send_buf[UART_STREAM_QUEUE_SIZE];
  uint8_t *recv_buf;
  uint8_t recv_index; 
  uint8_t recv_size;
  uint8_t recv_pid; 
} uart_state_t;

static uart_state_t st0;
static uart_state_t st1;

static inline void serial_hardware_init();
static inline void serial_init();
static inline void serial_put(uint8_t d, uart_state_t *st);
static int8_t uart_write(char* proto, uint8_t pid, uint8_t port, uint8_t *data, uint8_t len, uint8_t flag);
static int8_t uart_read(char* proto, uint8_t pid, uint8_t port, uint8_t len);
static int8_t module (void *state, Message *msg);

static mod_header_t mod_header SOS_MODULE_HEADER =
{
        mod_id: RAGOBOT_UART_PID,
        state_size: 0,
		num_timers : 0,
        num_sub_func: 0,
        num_prov_func: 2,
        module_handler: module,
        funct: {
		  {uart_write, "cCC5", RAGOBOT_UART_PID, UART_WRITE_FID},
		  {uart_read, "cCC2", RAGOBOT_UART_PID, UART_READ_FID}
		       },
};

static int8_t module (void *state, Message *msg) 
{
  switch(msg->type)
	{
	case MSG_INIT:
	  {
		serial_hardware_init();
		serial_init();
	  }
	}
  return SOS_OK;
}

static inline void serial_init()
{
  st0.send_rd = 0;
  st0.send_wr = 0;
  st0.state = UART_IDLE;
  st1.send_rd = 0;
  st1.send_wr = 0;
  st1.state = UART_IDLE;
}

static inline void serial_hardware_init()
{
 	HAS_CRITICAL_SECTION;

	ENTER_CRITICAL_SECTION();

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
	UCSR0B = ((1 << RXEN) | (1 << TXEN));
	UCSR1B = ((1 << RXEN) | (1 << TXEN));
	LEAVE_CRITICAL_SECTION();
}

static inline void serial_put(uint8_t d, uart_state_t *st)
{
  st->send_buf[st->send_wr] = d;
  st->send_wr++;
  st->send_wr &= UART_STREAM_QUEUE_MASK;
  if(st->send_rd == st->send_wr) {
	HAS_CRITICAL_SECTION;
	ENTER_CRITICAL_SECTION();
	st->send_rd++;
	st->send_rd &= UART_STREAM_QUEUE_MASK;
	LEAVE_CRITICAL_SECTION();
  }
}

static int8_t uart_write(char* proto, uint8_t pid, uint8_t port, uint8_t *data, uint8_t len, uint8_t flag)
{
  uint8_t i;
  HAS_CRITICAL_SECTION;

  /** currently UART0 is not supported. It is used by SOS kernel. **/
  if (port == 0)
	{
	  return -EINVAL;
	} 

  if(len == 0) return -EINVAL;

  if (port == 0)
	{
	  /** UART0 currently not supported **/
	  /*	  for(i = 0; i < len; i++) {
		serial_put(data[i], &st0);
	  }
	  
	  if(flag_dym_alloc(flag)){
		ker_free(data);
	  }

	  ENTER_CRITICAL_SECTION();
	  if(uart0_is_disabled()) {
		uart0_setbyte(st0.send_buf[st0.send_rd]);
		st0.send_rd++;
		st0.send_rd &= UART_STREAM_QUEUE_MASK;
		uart0_enable_send();
	  }
	  LEAVE_CRITICAL_SECTION();
	  */
	}
  else if (port == 1)
	{
	  for(i = 0; i < len; i++) {
		serial_put(data[i], &st1);
	  }

	  if(flag_msg_release(flag)){
		ker_free(data);
	  }

	  ENTER_CRITICAL_SECTION();
	  if(uart1_is_disabled()){
		uart1_setbyte(st1.send_buf[st1.send_rd]);
		st1.send_rd++;
		st1.send_rd &= UART_STREAM_QUEUE_MASK;
		uart1_enable_send();
	  }
	  LEAVE_CRITICAL_SECTION();
	}
  return SOS_OK;
}

static int8_t uart_read(char* proto, uint8_t pid, uint8_t port, uint8_t len)
{ 
  uart_state_t *st;
  
  /** currently UART0 is not supported. It is used by SOS kernel. **/
  if (port == 0)
	{
	  return -EINVAL;
	} 
  //select the correct port
  switch (port) 
	{
	case 0:
	  st = &st0;
	  break;
	case 1:
	  st = &st1;
	  break;
	default:
	  return -EINVAL;
	}
  
  st->recv_pid = pid; 
  if((st->state != UART_IDLE)) return -EBUSY;
  if(len == 0) return -EINVAL;
  st->recv_index = 0;
  st->recv_size = len;
  st->recv_buf = (uint8_t*)ker_malloc(len, RAGOBOT_UART_PID);
  if(st->recv_buf == NULL) 
	{
	  return -ENOMEM;
	}
  st->state = UART_READBUSY;
  if (port == 0) 
	{
	  /** UART0 currently not supported **/
	  //uart0_enable_recv();
	}
  else if (port == 1)
	{
	  uart1_enable_recv();
	}
  return SOS_OK;
}

/* ISR for transmittion */
//UART0 disabled for now. In use by SOS kernel
/*uart0_send_interrupt()
{
  if(st0.send_rd == st0.send_wr) 
	{
	  uart0_disable_send();
	  return;
	}
  
  uart0_setbyte(st0.send_buf[st0.send_rd]);
  st0.send_rd++;
  st0.send_rd &= UART_STREAM_QUEUE_MASK;
}

uart0_recv_interrupt()
{
  if (st0.state == UART_READBUSY)
	{
	  *(st0.recv_buf + st0.recv_index) = uart0_getbyte();
	  st0.recv_index += 1;
	  if (st0.recv_index == st0.recv_size) 
		{
		  uart0_disable_recv();
		  post_long(st0.recv_pid, RAGOBOT_UART_PID, MSG_UART0_READ_DONE, st0.recv_size, st0.recv_buf, SOS_MSG_RELEASE);
		  st0.state = UART_IDLE;
		}
	}
}
*/
uart1_send_interrupt()
{
  if(st1.send_rd == st1.send_wr) 
	{
	  uart1_disable_send();
	  return;
	}
  
  uart1_setbyte(st1.send_buf[st1.send_rd]);
  st1.send_rd++;
  st1.send_rd &= UART_STREAM_QUEUE_MASK;
}

uart1_recv_interrupt()
{
  
  if (st1.state == UART_READBUSY)
	{
	  *(st1.recv_buf + st1.recv_index) = uart1_getbyte();
	  st1.recv_index += 1;
	  if (st1.recv_index == st1.recv_size) 
		{
		  uart1_disable_recv();
		  post_long(st1.recv_pid, RAGOBOT_UART_PID, MSG_UART1_READ_DONE, st1.recv_size, st1.recv_buf, SOS_MSG_RELEASE);
		  st1.state = UART_IDLE;
		}
	}
}

#ifndef _MODULE_
mod_header_ptr uart_get_header()
{
  return sos_get_header_address(mod_header);
}
#endif
