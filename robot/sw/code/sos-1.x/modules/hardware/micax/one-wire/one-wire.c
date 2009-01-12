/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */
/*                                  tab:4
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
 *
 */
/**
 * @author David Lee
 */
/**
 * @brief Provides support for a one-wire bus 
 *
 * 
 */

#include <ragobot_module.h>
#include <malloc.h>
#include <hardware.h>
#include <one-wire.h>

enum {
  PRESENCE = 0x00
};

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// LOCAL FUNCTIONS
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
static uint8_t start_comm();
static inline void write_zero();
static inline void write_one();
static void write_byte(uint8_t byte);
static uint8_t read_byte();
static inline void one_wire_init();

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// EXPOSED FUNCTIONS
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
static int8_t one_wire_write(char* proto, uint8_t pid, uint8_t* data, uint8_t size);

static int8_t one_wire_read(char* proto, uint8_t pid, uint8_t* write_data, uint8_t write_size, uint8_t read_size);

static int8_t module (void *state, Message *msg);

static mod_header_t mod_header SOS_MODULE_HEADER =
{
        mod_id: RAGOBOT_ONE_WIRE_PID,
        state_size: 0,
        num_sub_func: 0,
        num_prov_func: 2,
        module_handler: module,
        funct: {
		  {one_wire_write, "cCD3", RAGOBOT_ONE_WIRE_PID, ONE_WIRE_WRITE_FID},
		  {one_wire_read, "cCD4", RAGOBOT_ONE_WIRE_PID, ONE_WIRE_READ_FID}
		       },
};

static int8_t module (void *state, Message *msg) 
{
  switch(msg->type)
	{
	case MSG_INIT:
	  {
		one_wire_init();
	  }
	}
  return SOS_OK;
}

static int8_t one_wire_write(char* proto, uint8_t pid, uint8_t* data, uint8_t size)
{
  int i;
  
  if (start_comm() != PRESENCE) 
	{
	  return -EBUSY;
	}
  for (i = 0; i < size; i++) 
	{
	  write_byte(*(data+i));
	}
  post_short(pid, RAGOBOT_ONE_WIRE_PID, MSG_ONE_WIRE_SEND_DONE, 0, 0, 0);
  return SOS_OK;
}

static int8_t one_wire_read(char* proto, uint8_t pid, uint8_t* write_data, uint8_t write_size, uint8_t read_size)
{
  int i, j;
  uint8_t *read_data = (uint8_t*)ker_malloc(read_size, RAGOBOT_ONE_WIRE_PID);

  if(read_data == NULL)
	{
	  return -ENOMEM;
	}
  if (start_comm() != PRESENCE) 
	{
	  return -EBUSY;
	}
  //send command stored in write_data
  for (i = 0; i < write_size; i++) 
	{
	  write_byte(*(write_data+i));
	}
  //read data from the bus  
  for (j = 0; j < read_size; j++) 
	{
	  *(read_data+j) = read_byte();
	} 
  post_long(pid, RAGOBOT_ONE_WIRE_PID, MSG_ONE_WIRE_READ_DONE, read_size, read_data, SOS_MSG_RELEASE); 
  return SOS_OK;
}

static inline void one_wire_init()
{
  //Set PC1 to an input pin
  //cbi(DDRC, 1);
  DDRC = DDRC & 0xFD;
  //cbi(PORTC, 1);
  PORTC = PORTC & 0xFD;
} 

uint8_t start_comm() 
{
  	bool presence;
	// Set PW1 (atmega128: PC1) pin as output
	DDRC = DDRC | 0x02; 
	
	// Set the PW1 (atmega128: PC1) pin low for 480us
	//cbi(PORTC, 1);
	PORTC = PORTC & 0xFD;
	TOSH_uwait(480);

	// Set PW1 (atmega128: PC1) pin as an input
	//cbi(DDRC, 1);
	DDRC = DDRC & 0xFD;
	// Wait for presence pulse
	TOSH_uwait(60);					
	
	//Read the presence pin
	presence = PINC & 0x2;	
	TOSH_uwait(240);
	return presence;
} 

// It reads one byte from the one-wire interface 
uint8_t read_byte()
{
  int8_t i;
  uint8_t byte = 0;
  uint8_t readbit = 0;
  HAS_CRITICAL_SECTION;

  for (i = 0; i < 8; i++)
	{
	  ENTER_CRITICAL_SECTION();
	  // Set PW1 (atmega128: PC1) pin as output
	  //sbi(DDRC, 1); 
	  DDRC = DDRC | 0x02;
	  // Set the PW1 (atmega128: PC1) pin low for 1us
	  //cbi(PORTC, 1);
	  PORTC = PORTC & 0xFD;
	  TOSH_uwait(1);

	  // Set PW1 (atmega128: PC1) as an input and wait 14us
	  //cbi(DDRC, 1);
	  DDRC = DDRC & 0xFD;
	  TOSH_uwait(14);
	  
	  // Read PW1 (atmega128: PC1) pin
	  readbit = (PINC >> 1) & 0x01;
	  LEAVE_CRITICAL_SECTION();
	  // Put the bit in the correct place in byte
	  byte = byte | (readbit << i);
	  
	  TOSH_uwait(46);
	}
  return byte;
}

// It writes a zero to the line
void write_zero()
{
  HAS_CRITICAL_SECTION;

  ENTER_CRITICAL_SECTION();
  // Set PW1 (atmega128: PC1) pin as output
  //sbi(DDRC, 1); 
  DDRC = DDRC | 0x02;
  // Set the PW1 (atmega128: PC1) pin low for 60us
  //cbi(PORTC, 1);
  PORTC = PORTC & 0xFD;
  TOSH_uwait(60);

  // Release PW1 (atmega128: PC1) for 1us by setting it as an input
  //cbi(DDRC, 1);
  DDRC = DDRC & 0xFD;
  LEAVE_CRITICAL_SECTION();
  TOSH_uwait(2);
}

void write_one()
// It writes a zero to the line
{
  HAS_CRITICAL_SECTION;

  ENTER_CRITICAL_SECTION();
  // Set PW1 (atmega128: PC1) pin as output
  //sbi(DDRC, 1); 
  DDRC = DDRC | 0x02;
  // Set the PW1 (atmega128: PC1) pin low for 2us
  //cbi(PORTC, 1);
  PORTC = PORTC & 0xFD;
  TOSH_uwait(2);

  // Set PW1 (atmega128: PC1) pin high for 58us 
  //sbi(PORTC, 1);
  PORTC = PORTC | 0x02;
  TOSH_uwait(58);

  // Release PW1 (atmega128: PC1) for 1us by setting it as an input
  //cbi(DDRC, 1);
  DDRC = DDRC & 0xFD;
  LEAVE_CRITICAL_SECTION();
  TOSH_uwait(2);
}

void write_byte(uint8_t byte)
{
  int i;
  int bit;
  // Send each bit, LSB first, of byte
  for(i=0; i < 8; i++)					
	{
	  bit = byte & 0x1;
	  switch(bit)
		{
		case 0:			
		  write_zero();	
		  break;
		case 1:				
		  write_one();
		  break;
		}
	  byte = byte >> 1;
	}
}

#ifndef _MODULE_
mod_header_ptr one_wire_get_header()
{
  return sos_get_header_address(mod_header);
}
#endif

