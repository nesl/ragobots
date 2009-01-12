/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */

/**
 * @brief Application to test the magsensor
 * @author David Lee
 */

#ifndef _MODULE_
#include <sos.h>
#else
#include <ragobot_module.h>
#endif 

#include <modules/ragobot_mod_pid.h>
#include <modules/magsensor.h>
#include <modules/CB2Bus.h>

typedef struct{
	uint8_t pid;
} app_state_t;

#ifndef _MODULE_
int8_t magsensor_test_module(void* state, Message *msg)
#else 
DECL_MOD_STATE(app_state_t);
DECL_MOD_ID(DFLT_APP_ID0);

int8_t module(void *state, Message *msg)
#endif
{
	app_state_t *s = (app_state_t*) state;
	MsgParam* p = (MsgParam*) msg->data;
  
	switch (msg->type)
	{	
		case MSG_INIT:
		{
			s->pid = msg->did;
			ker_timer_start(s->pid, 0, TIMER_REPEAT, 1024);	
			break;
		}

		case MSG_TIMER_TIMEOUT:
		{
			post_short(RAGOBOT_MAG_SENSOR_PID, DFLT_APP_ID0, TSK_READ_COMPASS, 0, 0, 0);
			break;
		}

		default:
			break;
	}
  
	return SOS_OK;
}

#ifndef _MODULE_
int8_t magsensor_test_init(void)
{
	return ker_register_task(DFLT_APP_ID0, sizeof(app_state_t), magsensor_test_module);
}
#endif
