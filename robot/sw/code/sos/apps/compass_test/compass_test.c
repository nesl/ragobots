#include <sos.h>
#include <led.h>
#include <id.h>
#include <modules/ragobot_mod_pid.h>
#include <modules/magsensor.h>
#include <modules/compass.h>

typedef struct{
  readings data;
  uint8_t pid;
} app_state_t;

static int8_t app_handler(void *state, Message *msg)
{
	app_state_t *s = (app_state_t*) state;

	switch (msg->type)
	{

		case MSG_INIT:
		{
			s->pid = msg->did;
			s->data.x = 0;
			s->data.y = 50;
			s->data.z = 0;
			ker_timer_start(s->pid, 0, TIMER_ONE_SHOT, 100);	
			led_red_on();
			led_green_off();
			led_yellow_off();
			return SOS_OK;
		}

		case MSG_TIMER_TIMEOUT:
		{
			led_green_toggle();
			DEBUG("SENDING: x=%d y=%d z=%d\n", s->data.x, s->data.y, s->data.z);
			post_long(RAGOBOT_COMPASS_PID, s->pid, MSG_HEADING_READY, sizeof(readings), &(s->data), 0);
			return SOS_OK;
		}
		case MSG_FINAL:
		{
			return SOS_OK;
		}
		default: return SOS_OK;
	}
}

void sos_start(void){
  cb2bus_module_init();
  compass_init();
  ker_register_task(DFLT_APP_ID0, sizeof(app_state_t), app_handler);
}
