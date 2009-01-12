/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */
//$Id: Compass.c,v 1.2 2005/03/03 01:19:26 ilias Exp $
//$Log: Compass.c,v $
//Revision 1.2  2005/03/03 01:19:26  ilias
//Updated magsensor
//
//Revision 1.1  2005/02/24 06:25:11  parixit
//Initial Version Created
//

/**
 * @file Compass.c
 * @brief The loadable module Compass.C
 * @author Parixit Aghera
 **/

/**
 * Provides heading of the robot. Uses ADC1 and ADC2 for getting compass readings.
 **/

#ifndef _MODULE_
#include <sos.h>
#else 
#include <module.h>
#endif
#include <modules/mod_pid.h>
#include "compass.h"


//-------------------------------------------------------------------------------------------------------
// MESSAGE DEFINITIONS
//-------------------------------------------------------------------------------------------------------
enum 
  {
    TASK_CALC_HEADING = (MOD_MSG_START+0);
  };

//-------------------------------------------------------------------------------------------------------
// I2C POT STATES
//-------------------------------------------------------------------------------------------------------
  enum{
    IDLE,
      WAITXY,
      GOTX_WAITY,
      GOTY_WAITX,
      GOTXY
  };


//-------------------------------------------------------------------------------------------------------
// FUNCTION POINTER IDENTIFIERS
//-------------------------------------------------------------------------------------------------------
enum
  {
	MAGX_GET_DATA_FID = 0,
	MAGY_GET_DATA_FID = 1
  };

//-------------------------------------------------------------------------------------------------------
// TYPE DEFINITIONS
//-------------------------------------------------------------------------------------------------------
typedef struct {
	uint8_t state;
	uint16_t x, y;
} compass_state;

typedef struct {
	uint16_t x;
	uint16_t y;
	uint16_t z;
} readings;

//! Macros to assist the Perl Script
#ifdef _MODULE_
DECL_MOD_STATE(compass_state);
DECL_MOD_ID(COMPASS_PID);
#endif

#ifndef _MODULE_
int8_t compass_module(void *state, Message *msg) SOS_DEV_SECTION;
static result_t getHeading() SOS_DEV_SECTION;
#else
static result_t getHeading() SOS_MODULE_FUNC;
#endif

#ifndef _MODULE_
int8_t compass_module(void *state, Message *msg)
#else
int8_t module(void *state, Message *msg)
#endif
{
  compass_state *s = (compass_state*)state;
  MsgParam *p = (MsgParam*)(msg->data);
  
  switch (msg->type){

	//--------------------------------------------------------------------------------------
	// KERNEL MESSAGE - DATA READY FROM ADC
	// MsgParam.byte = ADC PORT
	// MsgParam.word = ADC DATA
	//--------------------------------------------------------------------------------------
  case MSG_DATA_READY:
	{
	  uint16_t raw_data = p->word;

	  if (p->byte == SOS_ADC_COMPASS_X_PORT) {
	    
	    ker_adc_cont_stop(SOS_ADC_COMPASS_X_PORT);
	  } else if (p->byte == SOS_ADC_COMPASS_Y_PORT) {
	    
	    ker_adc_cont_stop(SOS_ADC_COMPASS_Y_PORT);
	    
	  }
	  break;
	}
	
	//--------------------------------------------------------------------------------------
	// KERNEL MESSAGE - INITIALIZE MODULE
	//--------------------------------------------------------------------------------------
  case MSG_INIT:
	{
	  char proto_string[4];
	  ker_adc_bindPort(SOS_ADC_COMPASS_X_PORT, SOSH_ACTUAL_COMPASS_X_PORT, COMPASS_PID);
	  ker_adc_bindPort(SOS_ADC_COMPASS_Y_PORT, SOSH_ACTUAL_COMPASS_Y_PORT, COMPASS_PID);
	  s->state = IDLE;
	  
	  proto_string[0] = 'c'; //Return Type
	  proto_string[1] = 'v'; //First parameter
	  proto_string[2] = 'v'; //Second Parameter
	  proto_string[3] = '0'; // Number of parameters
	  ker_register_fn(COMPASS_PID, COMPASS_HEADING_FID, proto_string, (fn_ptr_t)getHeading);
	  return SOS_OK;
	}

	//--------------------------------------------------------------------------------------
	// KERNEL MESSAGE - REMOVE MODULE
	//--------------------------------------------------------------------------------------
  case MSG_FINAL:
	{
	  proto_string[0] = 'c'; //Return Type
	  proto_string[1] = 'v'; //First parameter
	  proto_string[2] = 'v'; //Second Parameter
	  proto_string[3] = '0'; // Number of parameters
	  ker_deregister_fn(COMPASS_PID, COMPASS_HEADING_FID, proto_string, (fn_ptr_t)getHeading);
	  return SOS_OK;
	}

  default:
	return -EINVAL;
  }
  return SOS_OK;
}


//--------------------------------------------------------------------------------------
// DYNAMIC FUNCTIONS
//--------------------------------------------------------------------------------------
int8_t getHeading()
{
  compass_state *s = (compass_state *)ker_get_mod_state(COMPASS_PID);
  if(s->state==IDLE){
    s->state = WAITXY;
    ker_adc_cont_getData(SOS_ADC_COMPASS_X_PORT);
    ker_adc_cont_getData(SOS_ADC_COMPASS_Y_PORT);
    return SOS_OK;
  }else{
    return -EBUSY;
  }
}



//--------------------------------------------------------------------------------------
// APPLICATION INITIALIZATION
//--------------------------------------------------------------------------------------
#ifndef _MODULE_
int8_t compass_init()
{
  return ker_register_task(MAG_SENSOR_PID, sizeof(magsensor_state), magsensor_module);
}
#endif
