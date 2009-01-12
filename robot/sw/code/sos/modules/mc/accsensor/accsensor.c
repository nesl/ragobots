/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */
/**
 * @file magsensor.c
 * @author David Lee
 * @version 0.1
 **/

#ifndef _MODULE_
#include <sos.h>
#else 
#include <module.h>
#endif
#include <modules/accsensor.h>
#include <modules/cb2bus.h>
#include <modules/ext_adc.h>
#include <modules/ragobot_mod_pid.h>
//#include <led.h>

//-----------------------------------------------------------------------------
// TYPE DEFINITIONS
//-----------------------------------------------------------------------------
typedef struct {
  int8_t state;   // state of this module
  uint8_t pid;    // accsensor pid
  uint8_t write_data[1]; // extern adc address (write) , extern adc configuration (which channel and scan mode)
  uint8_t channel;
  uint16_t readings[2]; // x_reading, y_reading
  
} accsensor_state;

#define RETRY_TIMEOUT 500
enum {
  SEND_SETUP = 0,
  IDLE = 1,
  SCANNING = 2,
  READING = 3,
  RETRY_SEND_SETUP = 4,
  RETRY_SCAN = 5,
  RETRY_READ = 6 
};

enum {
  MSG_SCAN_CHANNEL = (MOD_MSG_START+0),
  MSG_ACC_READINGS = (MOD_MSG_START+1)
};

//! Macros to assist the Perl Script
#ifdef _MODULE_
DECL_MOD_STATE(accsensor_state);
DECL_MOD_ID(DFLT_APP_ID1);
#endif

#ifndef _MODULE_
int8_t accsensor_module(void *state, Message *msg)
#else
int8_t module(void *state, Message *msg)
#endif
{
  accsensor_state *s = (accsensor_state*)state;
  uint8_t *data;
  switch (msg->type){

	//-------------------------------------------------------------------------
	// Called from kernel to init the module
	// Arguments: none
	//-------------------------------------------------------------------------
  case MSG_INIT:
	{  
	  s->pid = msg->did;
	  s->state = SEND_SETUP;
	  s->channel = CHANNEL4; //CHANNEL4 = ACC X. CHANNEL5 = ACCY.
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_ACC_EN, ENABLE, 0, 0); // enable accelerometers
	  post_short(RAGOBOT_CB2BUS_PID, s->pid, MSG_LOAD, 0, 0, 0); 
	  s->write_data[0] = INTREF_AIN_AUTOSHTDWN;
	  if (ker_i2c_send_data(I2C_EXT_ADC_ADDR, s->write_data, 1, s->pid) != SOS_OK) 
			{ 
			  //if i2c bus busy, retry later.
			  s->state = RETRY_SEND_SETUP;
			  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, RETRY_TIMEOUT);
			}
	  return SOS_OK;
	}

	//-------------------------------------------------------------------------
	// Restart timer timeout called from timer to rehandle exception
	// Arguments: none
	//-------------------------------------------------------------------------

  case MSG_TIMER_TIMEOUT:
	{ 
	  if (s->state == IDLE)
		{
		  s->state = SCANNING;
		  //s->write_data[0] = SCAN_EIGHT_SAMPLES_SGL | s->channel; //scan 8 samples of a single channel 
		  s->write_data[0] = SCAN_ONCE_SGL | s->channel;
		  if (ker_i2c_send_data(I2C_EXT_ADC_ADDR, s->write_data, 1, s->pid) != SOS_OK) 
			{ 
			  //if i2c bus busy, retry later.
			  s->state = RETRY_SCAN;
			  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, RETRY_TIMEOUT);
			}
		}
	  else if (s->state == RETRY_SEND_SETUP)
	  	{
		  s->state = SEND_SETUP;
		  if (ker_i2c_send_data(I2C_EXT_ADC_ADDR, s->write_data, 1, s->pid) != SOS_OK) 
			{ 
			  //if i2c bus busy, retry later.
			  s->state = RETRY_SEND_SETUP;
			  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, RETRY_TIMEOUT);
			}
		}
	  else if (s->state == RETRY_SCAN) 
		{
		  s->state = SCANNING;
		  if (ker_i2c_send_data(I2C_EXT_ADC_ADDR, s->write_data, 1, s->pid) != SOS_OK) 
			{ 
			  //if i2c bus busy, retry later.
			  s->state = RETRY_SCAN;
			  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, RETRY_TIMEOUT);
			}
		}
	  else if (s->state == RETRY_READ) 
		{
		  s->state = READING;
		  if ((ker_i2c_read_data(I2C_EXT_ADC_ADDR, 6, s->pid)) != SOS_OK) // read 6 bytes
			{
			  //if i2c bus is busy, then wait until it is free.
			  s->state = RETRY_READ;
			  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, RETRY_TIMEOUT);
			}
		}
	  return SOS_OK;
	}

	//-------------------------------------------------------------------------
	// post_long function to initialate scanning channels
	// Arguments: data, adcscan struct
	//-------------------------------------------------------------------------
  case MSG_SCAN_CHANNEL:
	{	  
	  s->state = SCANNING;
	  //s->write_data[0] = SCAN_EIGHT_SAMPLES_SGL | s->channel; //scan 8 samples of a single channel 
	  s->write_data[0] = SCAN_ONCE_SGL | s->channel;
	  if (ker_i2c_send_data(I2C_EXT_ADC_ADDR, s->write_data, 1, s->pid) != SOS_OK) 
		{ 
		  //if i2c bus busy, retry later.
		  s->state = RETRY_SCAN;
		  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, RETRY_TIMEOUT);
		}
	  return SOS_OK;
	}

	//-------------------------------------------------------------------------
	// called from lower level after sending is done
	// we send command to read data back
	// Arguments: none
	//-------------------------------------------------------------------------
  case MSG_I2C_SEND_DONE:
	{
	  if (s->state == SEND_SETUP)
		{
		  post_short(s->pid, s->pid, MSG_SCAN_CHANNEL, 0, 0, 0); //start processing
		}
	  else if (s->state == SCANNING) 
		{
		  s->state = READING;
		  if ((ker_i2c_read_data(I2C_EXT_ADC_ADDR, 2, s->pid)) != SOS_OK) // read 16 bytes
			{
			  //if i2c bus is busy, then wait until it is free.
			  s->state = RETRY_READ;
			  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, RETRY_TIMEOUT);
			}	  
		}
	  return SOS_OK;			
	}
	//-------------------------------------------------------------------------
	// post_long function, data is back from lower level
	// we store the data and signal up
	// Arguments: data, the second and third byte is the first adc value
	//-------------------------------------------------------------------------

  case MSG_I2C_READ_DONE:
	{
	  data = (uint8_t*) msg->data; //(((uint8_t*)(msg->data)) + 1); // the first byte is something else
	  if (msg->len == 2)
		{
		  if (s->channel == CHANNEL4) 
			{
			  s->readings[0] = (((uint16_t)(data[0] & 0x03)) << 8) | (uint16_t) (data[1] & 0xFC);
			  //s->readings[0] = (data[0] + data[1] + data[2] + data[3] + 
			  //					data[4] + data[5] + data[6] + data[7]);
		  //s->readings[0] = (s->readings[0] / 8) & 0x03FF;
			  s->channel = CHANNEL5;
			  post_short(s->pid, s->pid, MSG_SCAN_CHANNEL, 0, 0, 0);
			}
		  else 
			{
			  s->readings[1] = (((uint16_t)(data[0] & 0x03)) << 8) | (uint16_t) (data[1] & 0xFC);
			  //s->readings[1] = (data[0] + data[1] + data[2] + data[3] + 
			  //					data[4] + data[5] + data[6] + data[7]);
			  //s->readings[1] = (s->readings[1] / 8) & 0x03FF;
			  s->channel = CHANNEL4;
			  post_net(s->pid, s->pid, MSG_ACC_READINGS, 4, s->readings, SOS_MSG_SENDDONE, BCAST_ADDRESS);
			}
		}
	
	  return SOS_OK;
	}
  case MSG_PKT_SENDDONE:
	{
	  s->state = IDLE;
	  ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, RETRY_TIMEOUT);
	  return SOS_OK;
	}
  case MSG_FINAL:
  default:
	{
	  return SOS_OK;
	}
  }
}

//-----------------------------------------------------------------------------
// APPLICATION INITIALIZATION
//-----------------------------------------------------------------------------
#ifndef _MODULE_
int8_t accsensor_init()
{
  return ker_register_task(DFLT_APP_ID1, sizeof(accsensor_state), accsensor_module);
}
#endif
