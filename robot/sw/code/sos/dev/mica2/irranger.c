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
 */
/**
 * @brief Provides support for the IR Ranger
 *
 */

#include "mica2_peripheral.h"
#include "modules/ragobot_mod_pid.h"
#include <modules/cb2bus.h>

#define IRRANGER_TIMER 1
#define IRRANGER_TIMEOUT_TIMER 2
#define IRRANGER_RETRY_TIMER 3
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// LOCAL VARIABLES
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#define SAMPLE_NUM 10
#define REST_PERIOD 5 //miliseconds
#define MIN_IR_LEVEL_PERIOD 35 //micro seconds
#define TIMEOUT_PERIOD 200
enum {IR_IDLE, IR_BUSY, IR_REST};

/**
* Maintains state of the IR Ranger.
**/
static uint8_t state;
static uint8_t target_pid;
static uint8_t distance;
static uint16_t total_distance;
static uint8_t samples;

/**
* Following table is used to convert DEC (Distance Measuring Output) of IR ranger, actual
* physical distance in cm.
*/

//10 cm distances
#define CONVERSION_TBL_LEN 9
#define UNITDIV 10
static uint8_t decConvertor[CONVERSION_TBL_LEN] = { 190, 135, 107, 95, 87, 80, 77, 75, 0};


// 5cm distances (not so accurate)
// #define CONVERSION_TBL_LEN 22
// #UNITDIV 5
//static uint8_t decConvertor[CONVERSION_TBL_LEN] = { 220, 190, 160, 135, 120, 107, 100, 95, 90, 87, 
//													83, 80, 78, 77, 76, 75, 72, 70, 67, 65, 62, 0};

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// LOCAL FUNCTIONS
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

inline int8_t irranger_mod_init();

void irranger_init()
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
    sbi(EIMSK, 4);

    state = IR_IDLE;
    target_pid = 0;
    
    irranger_mod_init();
    return;	
} 

static void irranger_reply(uint8_t distance)
{
	post_short(target_pid, RAGOBOT_IRRANGER_PID, MSG_IRRANGER_FINISHED, distance, 0, 0);
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
	ker_timer_stop(RAGOBOT_IRRANGER_PID, IRRANGER_TIMEOUT_TIMER);
	//distance = 0;
	//ker_led(LED_GREEN_TOGGLE);	
	if(state == IR_BUSY)
	{
		//ker_led(LED_YELLOW_TOGGLE);
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
			if(i!=7)
			{
				distance = distance << 1;
			}
		}

		//Set the output high
		TOSH_SET_PW7_PIN();
		state = IR_REST;
		
		ker_timer_start(RAGOBOT_IRRANGER_PID, IRRANGER_TIMER, TIMER_ONE_SHOT, REST_PERIOD);
    }
} 

int8_t ker_irranger_trigger(uint8_t pid)
{
	if (state != IR_IDLE)
		return -EBUSY;
	else
	{
		total_distance = 0;
		state = IR_BUSY;
		target_pid = pid;
		samples = 1;
		TOSH_CLR_PW7_PIN();
		ker_timer_start(RAGOBOT_IRRANGER_PID, IRRANGER_TIMEOUT_TIMER, TIMER_ONE_SHOT, TIMEOUT_PERIOD);
		return SOS_OK;
	}
     
}

int8_t irranger_handler(void *mod_state, Message *msg)
{
	MsgParam *p = (MsgParam*)(msg->data);		
	switch (msg->type) 
	{
		case MSG_INIT:
		{
			return SOS_OK;
		}
		case MSG_TIMER_TIMEOUT:
		{
			switch(p->byte)
			{
				case IRRANGER_TIMER:
				{
					if(state == IR_REST)
					{
						if(convertToCm(distance) > total_distance)
							total_distance = convertToCm(distance);
						samples++;
						if(samples < SAMPLE_NUM)
						{
							state = IR_BUSY;
							TOSH_CLR_PW7_PIN();
							return SOS_OK;
						}
						else
						{
							state = IR_IDLE;
							irranger_reply(total_distance);	
						}
					}
					return SOS_OK;
				}
				
				case IRRANGER_TIMEOUT_TIMER:
				{
					TOSH_SET_PW7_PIN();
					ker_timer_start(RAGOBOT_IRRANGER_PID, IRRANGER_RETRY_TIMER, TIMER_ONE_SHOT, REST_PERIOD);
					ker_led(LED_RED_ON);
					return SOS_OK;	
				}
				case IRRANGER_RETRY_TIMER:
				{
					TOSH_CLR_PW7_PIN();
					ker_led(LED_GREEN_ON);
					return SOS_OK;
				}
			}
			return SOS_OK;

		}
		case MSG_FINAL:
		{	
			return SOS_OK;
		}
		default:
		{	
			return SOS_OK;
		}
	}
}

inline int8_t irranger_mod_init()
{
   return ker_register_task(RAGOBOT_IRRANGER_PID, 0, irranger_handler);
}
