#ifndef _MODULE_
#include <sos.h>
#else 
#include <module.h>
#endif
#include <modules/magsensor.h>
#include <modules/compass.h>
#include <modules/ragobot_mod_pid.h>
#include <math.h>

#ifdef _MODULE_
DECL_MOD_STATE(compass_state);
DECL_MOD_ID(RAGOBOT_COMPASS_PID);
#endif

#ifndef _MODULE_
int8_t compass_module(void *state, Message *msg)
#else
int8_t module(void *state, Message *msg)
#endif
{
  compass_state *s = (compass_state*)state;
  
  switch (msg->type)
  {
  	case MSG_INIT:
	{
		s->pid = msg->did;
		return SOS_OK;
	}
	case MSG_GET_HEADING:
	{
		post_short(RAGOBOT_MAG_SENSOR_PID, RAGOBOT_COMPASS_PID, TSK_READ_COMPASS, 0, 0, 0);
		return SOS_OK;		
	}
	case MSG_HEADING_READY:
	{
	    uint16_t heading = 0;
	    //  float xsf = 1.0, ysf = 1.1202873, xoff=14.0, yoff=16.8;
	    float xsf=1.0, ysf=1.274, xoff=34.0, yoff=-50.96;
	    float xh = 0, yh = 0;
	    
	    readings * dir = (readings *) msg->data;
	    
	    s->x = dir->x;
	    s->y = dir->y;
	    s->z = dir->z;
	
		//Do the computation for the direction
		xh = ((float)dir->x-650)*xsf + xoff;
		yh = ((float)dir->y-650)*ysf + yoff;
		if(xh >0 )
		{
	  		if(yh < 0)
	  		{
	    		heading = (uint16_t) ( (int16_t) -((atan(yh / xh) * 180.0) / PI));
	  		}
	  		else
	  		{
	    		heading = (uint16_t)(360 - (int16_t) ( (atan(yh / xh) * 180.0) / PI));
	  		}
	  	}
	  	else if(xh == 0)
	  	{
	  	if(yh < 0)
			heading = 90;
		else
	    	heading = 270;
		}
		else //xh < 0
		{ 
	  		heading = (uint16_t)(180 - (int16_t) ( (atan(yh / xh) * 180.0) / PI));
		}
		
		DEBUG("CALCULATED: x=%d y=%d z=%d => heading = %d\n", s->x, s->y, s->z, heading);
		
		return SOS_OK;
    }
    default: return SOS_OK;
  }
} 

#ifndef _MODULE_
int8_t compass_init()
{
  return ker_register_task(RAGOBOT_COMPASS_PID, sizeof(compass_state), compass_module);
}
#endif
