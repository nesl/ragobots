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
 * @author Ilias Tsigkogiannis
 * @author David Lee
 */
/**
 * @brief Provides support for the IR Ranger
 *
 */

#include <ragobot_module.h>
#include <irranger.h>
#include <avr/signal.h>
#include <modules/cb2bus.h>
#include <hardware.h>
#include <led.h>


#define IRRANGER_TIMER 1

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// LOCAL VARIABLES
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#define SAMPLE_NUM 1
#define REST_PERIOD 5 //miliseconds
#define MIN_IR_LEVEL_PERIOD 35 //micro seconds
#define TIMEOUT_PERIOD 200

enum 
{
  MSG_IRRANGER_START = (MOD_MSG_START+0),
  MSG_DISTANCE_READ = (MOD_MSG_START+1)
};

enum {IR_IDLE, IR_START, IR_RETRY, IR_BUSY, IR_REST};

/**
* Following table is used to convert DEC (Distance Measuring Output) of IR ranger, actual
* physical distance in cm.
*/

//10 cm distances
#define CONVERSION_TBL_LEN 9
#define UNITDIV 10
static uint8_t decConvertor[CONVERSION_TBL_LEN] = { 190, 135, 107, 95, 87, 80, 77, 75, 0};


// 5cm distances (not so accurate)
//#define CONVERSION_TBL_LEN 22
//#define UNITDIV 5
//static uint8_t decConvertor[CONVERSION_TBL_LEN] = { 220, 190, 160, 135, 120, 107, 100, 95, 90, 87, 
//													83, 80, 78, 77, 76, 75, 72, 70, 67, 65, 62, 0};

/**
* Maintains state of the IR Ranger.
**/
typedef struct {
  uint8_t state;
  uint8_t target_pid;
  uint16_t total_distance;
  uint8_t samples;
} irranger_state_t;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// LOCAL FUNCTIONS
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

static inline void irranger_init();
static uint8_t convertToCm(uint8_t decVal);
static int8_t irranger_trigger(char* proto, uint8_t pid);

static int8_t module (void *state, Message *msg);

static mod_header_t mod_header SOS_MODULE_HEADER =
{
        mod_id: RAGOBOT_IRRANGER_PID,
        state_size: sizeof(irranger_state_t),
		num_timers : 1,
        num_sub_func: 0,
        num_prov_func: 1,
        module_handler: module,
        funct: {
		  {irranger_trigger, "cCv1", RAGOBOT_IRRANGER_PID, IRRANGER_TRIGGER_FID},
		       },
};

static int8_t module (void *state, Message *msg) 
{
  irranger_state_t *s = (irranger_state_t*) state;
  uint8_t distance; 
  MsgParam *p = (MsgParam*)(msg->data);

  switch(msg->type)
	{
	case MSG_INIT:
	  {
		s->state = IR_IDLE;
		s->target_pid = 0;
		irranger_init();		
		ker_timer_init(RAGOBOT_IRRANGER_PID, IRRANGER_TIMER, TIMER_ONE_SHOT);
		break;
	  }
	case MSG_DISTANCE_READ: //Successful distance read
	  {
		distance = p->byte;
		if(convertToCm(distance) > (s->total_distance)) 
		  {
			s->total_distance = convertToCm(distance);
		  }
		s->samples += 1;
		if(s->samples < SAMPLE_NUM)
		  {
			//Wait for a rest period before initiating another distance read
			ker_timer_start(RAGOBOT_IRRANGER_PID, IRRANGER_TIMER, REST_PERIOD);
		  }
		else
		  {
			s->state = IR_REST;
			
			post_short(s->target_pid, RAGOBOT_IRRANGER_PID, MSG_IRRANGER_FINISHED, s->total_distance, 0, 0);
			//Wait for a rest period before initiating another distance read
			ker_timer_start(RAGOBOT_IRRANGER_PID, IRRANGER_TIMER, REST_PERIOD);
		  }
		break;
	  }
	case MSG_TIMER_TIMEOUT:
	  {
		
		if(s->state == IR_START) //TIMEOUT CAUSED BY NO RESPONSE FROM THE IR RANGER
		  {
			ker_led(LED_YELLOW_TOGGLE);
			s->state = IR_RETRY; //Retry contacting the IR RANGER Later
			TOSH_SET_PW7_PIN();
			cbi(EIMSK, 4); //disable INT0[micax] (INT4[atmega128]) interrupt
			ker_timer_start(RAGOBOT_IRRANGER_PID, IRRANGER_TIMER, REST_PERIOD);
		  }
		else if(s->state == IR_BUSY)
		  {
			TOSH_CLR_PW7_PIN();
			sbi(EIMSK, 4); //Enable INT0[micax] (INT4[atmega128]) interrupt
		  }
		else if (s->state == IR_REST)
		  {
			s->state = IR_IDLE;
		  }
		else if (s->state == IR_RETRY) 
		  {
			s->state = IR_START;
			TOSH_CLR_PW7_PIN();
			sbi(EIFR, 4); 
			sbi(EIMSK, 4); //Enable INT0[micax] (INT4[atmega128]) interrupt
			ker_timer_start(RAGOBOT_IRRANGER_PID, IRRANGER_TIMER, TIMEOUT_PERIOD);
		  }
		
		break;
	  }			
	case MSG_FINAL:
	  {	
		break;
	  }
	}
  return SOS_OK;
}

static inline void irranger_init()
{
    //Set the PW7 as output pin. This is also done in hardware init. But we are doing this again for safety.
    TOSH_MAKE_PW7_OUTPUT();

    //Drive output to high by setting the bit.
    TOSH_SET_PW7_PIN();

    //Make INT0 as input pin.
    TOSH_CLR_INT0_PIN(); 
    TOSH_MAKE_INT0_INPUT();
    //Set the interrupt on rising edge
    cbi(EIMSK, 4); // disable flash in interrupt
    EICRB = EICRB | 0x03;
	//enable INT0[micax] interrupt only when ready to read from the IR RANGER
    return;	
} 

/**
 * Converts the DEC value received from IR ranger to physical distance.
 *
 * @return Returns physical distance from object.
 **/
static uint8_t convertToCm(uint8_t decVal)
{
	uint8_t i;

	//Implemented as lookup table. But need to define function for getting precise value.
	for(i=0; i < CONVERSION_TBL_LEN; i++)
	{
		if(decVal >= decConvertor[i])
		{
			return (i+1)*UNITDIV; 
		}
	}
	
	// Control should never reach here
	return 0;
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//IR RANGER INTERRUPT
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SIGNAL(SIG_INTERRUPT4) 
{
  uint8_t i;
  uint8_t distance = 0; 

  cbi(EIMSK, 4); //disable INT0[micax] (INT4[atmega128]) interrupt
  ker_timer_stop(RAGOBOT_IRRANGER_PID, IRRANGER_TIMER);
  
  TOSH_uwait(MIN_IR_LEVEL_PERIOD);
  for(i=0; i < 8; i++)
	{
	  //Provide clock to IR Ranger.
	  TOSH_SET_PW7_PIN();
	  TOSH_uwait(MIN_IR_LEVEL_PERIOD);
	  TOSH_CLR_PW7_PIN();
	  TOSH_uwait(MIN_IR_LEVEL_PERIOD);
	  
	  //Read the bit from pin
	  distance = distance | TOSH_READ_INT0_PIN();
	  
	  //Shift the bits (except last) to make room for next bit to be read from pin.
	  if(i < 7)
		{
		  distance = distance << 1;
		}
	}

  //Set the output high
  TOSH_SET_PW7_PIN();
  
  post_short(RAGOBOT_IRRANGER_PID, RAGOBOT_IRRANGER_PID, MSG_DISTANCE_READ, distance, 0, 0);
}
 

static int8_t irranger_trigger(char*proto, uint8_t pid)
{
  sos_module_t *m = ker_get_module(RAGOBOT_IRRANGER_PID);
  irranger_state_t *s = (irranger_state_t*)m->handler_state;
  
  if (s->state != IR_IDLE)
	{
	  return -EBUSY;
	}
  else
	{
	  s->state = IR_START;
	  s->total_distance = 0;
	  s->target_pid = pid;
	  s->samples = 0;
	  TOSH_CLR_PW7_PIN();
	  sbi(EIFR, 4); 
	  sbi(EIMSK, 4); //Enable INT0[micax] (INT4[atmega128]) interrupt
	  ker_timer_start(RAGOBOT_IRRANGER_PID, IRRANGER_TIMER, TIMEOUT_PERIOD);
	  return SOS_OK;
	}
}

#ifndef _MODULE_
mod_header_ptr irranger_get_header()
{
  return sos_get_header_address(mod_header);
}
#endif
