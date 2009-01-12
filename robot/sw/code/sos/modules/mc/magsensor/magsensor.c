/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */
/**
 * @file magsensor.c
 * @brief The loadable compass module. Integrated with I2CPot
 * @author Ilias Tsigkogiannis
 * @author David Lee
 * @author Ram Kumar
 * @version 0.1
 **/

/**
 * The Magnetometer module provides two interfaces: MAGX and MAGY
 * The sensors can be accessed by the standard sensor API
 * Driver Functionality:
 * 1. Initializes the hardware and binds to the correct ADC port
 * 2. Provides the Gain adjust functionality
 * 3. Provides optional self-calibrate (By Simon 4/16/04)
 *    Uncomment MAGSENSOR_SELF_CALIBRATE in magsensor.h
 **/

#ifndef _MODULE_
#include <sos.h>
#else 
#include <module.h>
#endif
#include <modules/magsensor.h>
#include <modules/cb2bus.h>
#include <modules/ext_adc.h>
#include <modules/ragobot_mod_pid.h>
#include <led.h>

//-----------------------------------------------------------------------------
// TYPE DEFINITIONS
//-----------------------------------------------------------------------------
typedef struct {
  int8_t state;   // state of this module
  uint8_t pid;    //! RAGOBOT_MAG_SENSOR_PID
  uint8_t write_data[3]; 
  uint8_t sample_counter; // number of samples for direction calculation

  struct {
	uint16_t x;
	uint16_t y;
	uint16_t z;
  } readings; 
} magsensor_state;

enum
{
	UNINITIALIZED = 0,
	IDLE = 1,
	WORKING = 2,
};

//! Macros to assist the Perl Script
#ifdef _MODULE_
DECL_MOD_STATE(magsensor_state);
DECL_MOD_ID(RAGOBOT_MAG_SENSOR_PID);
#endif

#ifndef _MODULE_
int8_t magsensor_module(void *state, Message *msg)
#else
int8_t module(void *state, Message *msg)
#endif
{
	magsensor_state *s = (magsensor_state*)state;
	MsgParam *p = (MsgParam*)(msg->data);
  
	switch (msg->type){

	//-------------------------------------------------------------------------
	// KERNEL MESSAGE - INITIALIZE MODULE
	//-------------------------------------------------------------------------
	case MSG_INIT:
	{  
		s->pid = msg->did;
		
		s->state = UNINITIALIZED;
		s->sample_counter = 0;
		s->write_data[0] = TOS_EXT_ADC_ADDR | 0;
		s->write_data[1] = 0x0; //INTREF_AIN;   // Setup byte
		s->write_data[2] = SCAN_DOWN_TO_SGL | CHANNEL3;  // Configuration byte
		s->readings.x = 0x0;
		s->readings.y = 0x0;
		s->readings.z = 0x0;
		post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_MAG_SENSOR_PID, MSG_MAG_EN, ENABLE, 0, 0);
		post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_MAG_SENSOR_PID, MSG_LOAD, 0, 0, 0);

		if (ker_i2c_reserve(s->pid) != SOS_OK)
		{
			post_short(RAGOBOT_MAG_SENSOR_PID, RAGOBOT_MAG_SENSOR_PID, TSK_I2C_INIT, 0, 0, 0);
			return SOS_OK;
		}
		
		if(ker_i2c_send_data(s->write_data, 3) != SOS_OK)
		{
			ker_i2c_release(s->pid);
			post_short(RAGOBOT_MAG_SENSOR_PID, RAGOBOT_MAG_SENSOR_PID, TSK_I2C_INIT, 0, 0, 0);
			return -EBUSY;
		}		
		s->state = IDLE;

		return SOS_OK;
	}
	  
	  
	//-------------------------------------------------------------------------
	// INTERNAL MESSAGE - READ X, Y, Z VALUES FROM COMPASS
	//-------------------------------------------------------------------------
	case TSK_READ_COMPASS:
	{
		if(s->state == IDLE)
		{
			ker_led(LED_RED_ON);
			s->state = WORKING;
			if (ker_i2c_reserve(s->pid) != SOS_OK)
			{
				return -EBUSY;
			}
			if(ker_i2c_read_data( (uint8_t)(TOS_EXT_ADC_ADDR | 1), 8) != SOS_OK)
			{
				return -EBUSY;
			}
		}
		return SOS_OK;			
	}
	case MSG_I2C_SEND_DONE:
	{
		ker_led(LED_YELLOW_TOGGLE);
		if(ker_i2c_release(s->pid) != SOS_OK)
		{
			return -EPERM;	
		}
		return SOS_OK;
	}
	case MSG_I2C_READ_TASK:
	{
		if(s->state == WORKING)
		{
			// first byte is the ADC address. 2nd and 3rd bytes are channel 0. We want channels 1-3 (bytes 3-8)
			s->readings.x = (( ((uint8_t*)(msg->data))[3] & 0x3) << 8) + ( ((uint8_t*)(msg->data))[4]);
			s->readings.y = (( ((uint8_t*)(msg->data))[5] & 0x3) << 8) + ( ((uint8_t*)(msg->data))[6]);
			s->readings.z = (( ((uint8_t*)(msg->data))[7] & 0x3) << 8) + ( ((uint8_t*)(msg->data))[8]);
           
			if(ker_i2c_release(s->pid) != SOS_OK)
			{
				return -EPERM;	
			}
			
			post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_MAG_SENSOR_PID, MSG_BARBINARY, 0, s->readings.x, 0);
			post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_MAG_SENSOR_PID, MSG_LOAD, 0, 0, 0);	
			
			post_net(RAGOBOT_MAG_SENSOR_PID, RAGOBOT_MAG_SENSOR_PID, MSG_FINAL, sizeof(s->readings), &s->readings, 0, BCAST_ADDRESS);
			ker_led(LED_YELLOW_OFF);
			s->state = IDLE;
		}
		return SOS_OK;
	}
	case TSK_I2C_INIT:
	{
		if(s->state != UNINITIALIZED)
			return SOS_OK;
		
		if (ker_i2c_reserve(s->pid) != SOS_OK)
		{
			post_short(RAGOBOT_MAG_SENSOR_PID, RAGOBOT_MAG_SENSOR_PID, TSK_I2C_INIT, 0, 0, 0);
			return SOS_OK;
		}
		
		if(ker_i2c_send_data(s->write_data, 3) != SOS_OK)
		{
			ker_i2c_release(s->pid);
			post_short(RAGOBOT_MAG_SENSOR_PID, RAGOBOT_MAG_SENSOR_PID, TSK_I2C_INIT, 0, 0, 0);
			return -EBUSY;
		}		
		s->state = IDLE;
		return SOS_OK;
	}
	case MSG_FINAL:
	{
		return SOS_OK;
	}
	default:	
		return SOS_OK;
	}
}

//-----------------------------------------------------------------------------
// APPLICATION INITIALIZATION
//-----------------------------------------------------------------------------
#ifndef _MODULE_
int8_t magsensor_init()
{
  return ker_register_task(RAGOBOT_MAG_SENSOR_PID, sizeof(magsensor_state), magsensor_module);
}
#endif
