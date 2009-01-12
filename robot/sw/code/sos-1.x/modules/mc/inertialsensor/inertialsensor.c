/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */
/**
 * @file inertialsensor.c
 * @author David Lee
 * @version 1.0
 * @brief To get readings from the onboard magnetometer and accelerometers
 **/

#include <ragobot_module.h>
#include <modules/inertialsensor.h>
#include <modules/cb2bus.h>
#include <modules/ext_adc.h>

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

//-----------------------------------------------------------------------------
// TYPE DEFINITIONS
//-----------------------------------------------------------------------------
typedef struct {
  int8_t state; // state of this module
  uint8_t mode; // mode of which inertial sensor to be read
  uint8_t callingpid;    // PID of the module that is calling this module
  uint8_t write_data[1]; // extern adc configuration (which channel and scan mode)
  uint16_t readings[6]; // 0=mag_x, 1=mag_y, 2=mag_z, 3=acc_x, 4=acc_y, 5=acc_z  
} inertialsensor_state_t;

static int8_t module(void *state, Message *msg);

static mod_header_t mod_header SOS_MODULE_HEADER = 
{
	mod_id : RAGOBOT_INERTIALSENSOR_PID,
	state_size : sizeof(inertialsensor_state_t),
    num_timers : 1,
	num_sub_func : 0,
	num_prov_func : 0,
	module_handler: module,
};

static int8_t module(void *state, Message *msg)
{
  inertialsensor_state_t *s = (inertialsensor_state_t*)state;
  uint8_t *data;
  switch (msg->type){

  case MSG_INIT:
	{  	 
	  s->state = SEND_SETUP; 
	  ACCSENSOR_ENABLE();
	  MAGSENSOR_ENABLE();
	  s->write_data[0] = INTREF_AIN_AUTOSHTDWN;
	  ker_timer_init(RAGOBOT_INERTIALSENSOR_PID, 0, TIMER_ONE_SHOT);
	  MAGSENSOR_RESET();
	  if (ker_i2c_send_data(I2C_EXT_ADC_ADDR, s->write_data, 1, RAGOBOT_INERTIALSENSOR_PID) != SOS_OK) 
			{ 
			  //if i2c bus busy, retry later.
			  s->state = RETRY_SEND_SETUP;
			  ker_timer_start(RAGOBOT_INERTIALSENSOR_PID, 0, RETRY_TIMEOUT);
			}
	  return SOS_OK;
	}

	//-------------------------------------------------------------------------
	// Restart timer timeout called from timer to rehandle exception
	// Arguments: none
	//-------------------------------------------------------------------------

  case MSG_TIMER_TIMEOUT:
	{ 
	  if (s->state == RETRY_SEND_SETUP)
	  	{
		  s->state = SEND_SETUP;
		  if (ker_i2c_send_data(I2C_EXT_ADC_ADDR, s->write_data, 1, RAGOBOT_INERTIALSENSOR_PID) != SOS_OK) 
			{ 
			  //if i2c bus busy, retry later.
			  s->state = RETRY_SEND_SETUP;
			  ker_timer_start(RAGOBOT_INERTIALSENSOR_PID, 0, RETRY_TIMEOUT);
			}
		}
	  else if (s->state == RETRY_SCAN) 
		{
		  s->state = SCANNING;
		  if (ker_i2c_send_data(I2C_EXT_ADC_ADDR, s->write_data, 1, RAGOBOT_INERTIALSENSOR_PID) != SOS_OK) 
			{ 
			  //if i2c bus busy, retry later.
			  s->state = RETRY_SCAN;
			  ker_timer_start(RAGOBOT_INERTIALSENSOR_PID, 0, RETRY_TIMEOUT);
			}
		}
	  else if (s->state == RETRY_READ) 
		{
		  s->state = READING;
		  if ((ker_i2c_read_data(I2C_EXT_ADC_ADDR, 6, RAGOBOT_INERTIALSENSOR_PID)) != SOS_OK) // read 6 bytes
			{
			  //if i2c bus is busy, then wait until it is free.
			  s->state = RETRY_READ;
			  ker_timer_start(RAGOBOT_INERTIALSENSOR_PID, 0, RETRY_TIMEOUT);
			}
		}
	  return SOS_OK;
	}
  case MSG_GET_ACC_READINGS:
	{
	  if (s->state != IDLE)
		{ 
		  return -EBUSY;
		}
	  s->state = SCANNING;
	  s->mode = MSG_GET_ACC_READINGS;
	  s->callingpid = msg->sid;
	  s->write_data[0] = SCAN_UP_ZERO_TO_SGL | CHANNEL5;
	  if (ker_i2c_send_data(I2C_EXT_ADC_ADDR, s->write_data, 1, RAGOBOT_INERTIALSENSOR_PID) != SOS_OK) 
		{ 
		  //if i2c bus busy, retry later.
		  s->state = RETRY_SCAN;
		  ker_timer_start(RAGOBOT_INERTIALSENSOR_PID, 0, RETRY_TIMEOUT);
		}
	  return SOS_OK;
	}
  case MSG_GET_MAG_READINGS:
	  {
		if (s->state != IDLE)
		  { 
			return -EBUSY;
		  }
		s->state = SCANNING;
		s->mode = MSG_GET_MAG_READINGS;
		s->callingpid = msg->sid;
		s->write_data[0] = SCAN_UP_ZERO_TO_SGL | CHANNEL5;
		if (ker_i2c_send_data(I2C_EXT_ADC_ADDR, s->write_data, 1, RAGOBOT_INERTIALSENSOR_PID) != SOS_OK) 
		  { 
			//if i2c bus busy, retry later.
			s->state = RETRY_SCAN;
			ker_timer_start(RAGOBOT_INERTIALSENSOR_PID, 0, RETRY_TIMEOUT);
		  }
		return SOS_OK;
	  }
  case MSG_GET_INERTIAL_READINGS:
	{
	  if (s->state != IDLE)
		{ 
		  return -EBUSY;
		}
	  s->state = SCANNING;
	  s->mode = MSG_GET_INERTIAL_READINGS;
	  s->callingpid = msg->sid;
	  s->write_data[0] = SCAN_UP_ZERO_TO_SGL | CHANNEL5;
	  if (ker_i2c_send_data(I2C_EXT_ADC_ADDR, s->write_data, 1, RAGOBOT_INERTIALSENSOR_PID) != SOS_OK) 
		{ 
		  //if i2c bus busy, retry later.
		  s->state = RETRY_SCAN;
		  ker_timer_start(RAGOBOT_INERTIALSENSOR_PID, 0, RETRY_TIMEOUT);
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
		  s->state = IDLE;
		}
	  else if (s->state == SCANNING) 
		{
		  s->state = READING;
		  if ((ker_i2c_read_data(I2C_EXT_ADC_ADDR, 12, RAGOBOT_INERTIALSENSOR_PID)) != SOS_OK) // read 12 bytes
			{
			  //if i2c bus is busy, then wait until it is free.
			  s->state = RETRY_READ;
			  ker_timer_start(RAGOBOT_INERTIALSENSOR_PID, 0, RETRY_TIMEOUT);
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
	  s->state = IDLE;
	  data = (uint8_t*) msg->data; //(((uint8_t*)(msg->data)) + 1); // the first byte is something else
	  if (msg->len != 12)
		{
		  if (s->mode == MSG_GET_ACC_READINGS)
			{
			  post_short(s->callingpid, RAGOBOT_INERTIALSENSOR_PID, MSG_GET_ACC_READINGS_FAIL, 0, 0, 0);
			}
		  else if (s->mode == MSG_GET_MAG_READINGS)
			{
			  post_short(s->callingpid, RAGOBOT_INERTIALSENSOR_PID, MSG_GET_MAG_READINGS_FAIL, 0, 0, 0);
			}
		  else if (s->mode == MSG_GET_INERTIAL_READINGS)
			{
			  post_long(s->callingpid, RAGOBOT_INERTIALSENSOR_PID, MSG_GET_INERTIAL_READINGS_DONE, sizeof(s->readings), s->readings, 0);
			}
		  
		  return SOS_OK;
		}

	  s->readings[0] = (((uint16_t)(data[0] & 0x03)) << 8) | (uint16_t) (data[1]);
	  s->readings[1] = (((uint16_t)(data[2] & 0x03)) << 8) | (uint16_t) (data[3]);
	  s->readings[2] = (((uint16_t)(data[4] & 0x03)) << 8) | (uint16_t) (data[5]);
	  s->readings[3] = (((uint16_t)(data[6] & 0x03)) << 8) | (uint16_t) (data[7] & 0xFC);
	  s->readings[4] = (((uint16_t)(data[8] & 0x03)) << 8) | (uint16_t) (data[9] & 0xFC);
	  s->readings[5] = (((uint16_t)(data[10] & 0x03)) << 8) | (uint16_t) (data[11] & 0xFC);
		
	  if (s->mode == MSG_GET_ACC_READINGS)
		{
		  post_long(s->callingpid, RAGOBOT_INERTIALSENSOR_PID, MSG_GET_ACC_READINGS_DONE, 6, (s->readings)+3, 0);
		}
	  else if (s->mode == MSG_GET_MAG_READINGS)
		{
		  post_long(s->callingpid, RAGOBOT_INERTIALSENSOR_PID, MSG_GET_MAG_READINGS_DONE, 6, s->readings, 0);
		}
	  else if (s->mode == MSG_GET_INERTIAL_READINGS)
		{
		  post_long(s->callingpid, RAGOBOT_INERTIALSENSOR_PID, MSG_GET_INERTIAL_READINGS_DONE, sizeof(s->readings), s->readings, 0);
		}
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
mod_header_ptr inertialsensor_get_header()
{
    return sos_get_header_address(mod_header);
}
#endif

