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
 * @author Parixit Aghera
 * @author David Lee (ported to sos)
 */
/**
 * @brief Provide control of the Pan and Tilt servos using the Micas
 *
 */

#include <ragobot_module.h>
#include <servos.h>

#define TIMER1_CNT_RANGE 65536 //The timer count range

#define MAX_PAN 90 // Allowable maximum turn in one direction for PAN servo
#define MIN_PAN -90 // Allowable minimum turn in one direction for PAN servo
#define MAX_TILT 90 // Allowable maximum turn in one direction for PAN servo
#define MIN_TILT -20 // Allowable minimum turn in one direction for TILT servo

#define TILT_OFFSET -65 //the offset mechanically prevents the servo from hitting other components on Ragobot upon startup. 
#define NEUTRAL_PULSE_WIDTH 1500 // Pulse width in mili seconds for servo's neutral position.

/*Change in pulsewidth to change the position of servo to 1 degree.
Here servo requires change of 900 micro seconds to change its position by 90 degree. Assumes that servo is at -90 degrees at 600 micro second pulse width and at +90 for 2400 micro second.
*/
#define PULSE_SENSITIVITY 10

// Time it takes counter to go from BOTTOM to MAX in usec
#define COUNTER_PERIOD 8888

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// LOCAL FUNCTIONS
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
static uint16_t calculateOCRVal(int8_t position);
static inline void servos_init();
static int8_t servo_set_position(char* proto, uint8_t motor_id, int8_t position);

static int8_t module (void *state, Message *msg);

static mod_header_t mod_header SOS_MODULE_HEADER =
{
        mod_id: RAGOBOT_SERVOS_PID,
        state_size: 0,
        num_sub_func: 0,
        num_prov_func: 1,
        module_handler: module,
        funct: {
		  {servo_set_position, "cCc2", RAGOBOT_SERVOS_PID, SERVOS_SET_POSITION_FID},
		       },
};

static int8_t module (void *state, Message *msg) 
{
  switch(msg->type)
	{
	case MSG_INIT:
	  {
		servos_init();
	  }
	}
  return SOS_OK;
}

static inline void servos_init()
{
  HAS_CRITICAL_SECTION;
  
  //Set timer as ICR1 non-inverted PWM on OC1A and OC1B with TOP=0xFF.
  //		outp(0xA1,TCCR1A);
  outp(0xA0,TCCR1A);
  //Set prescale select to CK/1 No prescaling.
  //outp(0x44,TCCR1B);
  outp(0x51,TCCR1B);
  ENTER_CRITICAL_SECTION();
  /*Set TOP value to 0xFFFF */
  ICR1 = 0xFFFF;

  /* Set OCR1A and OCR1B */
  OCR1A = calculateOCRVal(0 + TILT_OFFSET);
  OCR1B = calculateOCRVal(0);
  LEAVE_CRITICAL_SECTION();

  //Configure OC1A and OC1B to Output.
  sbi(DDRB,0x06);
  sbi(DDRB,0x05);

} 

	

/**
 * @brief Convert position of servo to a value of OCR register.
 * @param int8_t position The desired servo position
 * @return uint16_t The value that should be written into the OCR Registers
 */
static uint16_t calculateOCRVal(int8_t position)
{
  uint16_t OCRVal;
  uint32_t pulseWidth;
  pulseWidth = (uint32_t) (NEUTRAL_PULSE_WIDTH + (int16_t) position * PULSE_SENSITIVITY);
  OCRVal =(uint16_t) (((pulseWidth/2) * TIMER1_CNT_RANGE)/COUNTER_PERIOD);
  return OCRVal;
}


static int8_t servo_set_position(char* proto, uint8_t motor_id, int8_t position){
  /* Set OCR1A / OCR1B */
  if(motor_id == PANSERVO)
	{
	  //Check whether the rotation is within the range.
	  if((position > MAX_PAN) || (position < (MIN_PAN)))
		{
		  return -EINVAL;
		}
	  OCR1B = calculateOCRVal(position);
	}
  else if(motor_id == TILTSERVO)
	{
	  //Check whether the rotation is within the range.
	  if((position > MAX_TILT) || (position < (MIN_TILT)))
		{
		  return -EINVAL;
		}
	  //the offset prevents the servo from hitting other components upon
	  //startup.
	  OCR1A = calculateOCRVal(position + TILT_OFFSET);
	}
  else
	{
	  return -EINVAL;
	}
  return SOS_OK;
}

#ifndef _MODULE_
mod_header_ptr servos_get_header()
{
  return sos_get_header_address(mod_header);
}
#endif
