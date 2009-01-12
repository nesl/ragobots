/*
  #################################################################################
  # RAGOBOT:IRMAN MOTOR DEFINITIONS
  # ------------------------------------------------------------------------------
  # Defines pins, ports, and signals
  # 
  # APPLIES TO (Ragobot Part Numbers):
  # ------------------------------------------------------------------------------
  # RBTBDYC
  #
  # COPYRIGHT NOTICE
  # ------------------------------------------------------------------------------
  # "Copyright (c) 2000-2003 The Regents of the University  of California.
  # All rights reserved.
  # Permission to use, copy, modify, and distribute this software and its
  # documentation for any purpose, without fee, and without written agreement is
  # hereby granted, provided that the above copyright notice, the following
  # two paragraphs and the author appear in all copies of this software.
  # IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
  # DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
  # OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
  # CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  # THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
  # INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
  # AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
  # ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
  # PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
  #
  # DEVELOPED BY
  # ------------------------------------------------------------------------------
  # Jonathan Friedman, GSR
  # Networked and Embedded Systems Laboratory (NESL)
  # University of California, Los Angeles (UCLA)
  #
  # REVISION HISTORY
  # ------------------------------------------------------------------------------
  # <for dates and comments, see cvs>
  # Original by Jonathan Friedman, UCLA (jf@ee.ucla.edu) 		
  #################################################################################
*/
#ifndef motor_h
#define motor_h

//DEFINES
//MOTOR CONTROL
//Commands
#define M_FWD1	4 //100
#define M_FWD2	5 //101
#define M_FWD3	6 //110
#define M_FWD4	7 //111
#define M_STOP	0 //000
#define M_REV1	1 //001
#define M_REV3	2 //010
#define M_REV4	3 //011
		
//Speeds
#define set_speed(d) d //((d*255/100))
#define M_SPD1	190
#define M_SPD2	205
#define M_SPD3	225
#define M_SPD4	255

//I2C COMMAND PROTOCOL
//COMM PACKET BIT TAGS
#define TYPE1 		7
#define TYPE0 		6

//SPECIFIC TO MOTOR TYPE COMMAND
#define LEFT_DIR 	5
#define LEFT_SPD1 	4
#define LEFT_SPD0 	3
#define RIGHT_DIR 	2
#define RIGHT_SPD1 	1
#define RIGHT_SPD0 	0

//MOTOR CONTROL
//Signals
#define M_DIR_PORT	PORTB
#define M_DIR0		1
#define M_DIR1		2
#define M_PWM_PORT	PORTD
#define M_PWM_DDR       DDRD
#define M_PWM0		6
#define M_PWM1		5

//Hw_Cmds
#define M_PWM_EN TCCR0B = B8(00000101) //prescale 8MHz to 1MHz via 1024 divider
#define M_PWM_DISABLE TCCR0B = 0x00 //Shutoff Timer 0	

//Enable PWM output for Left Motor
#define M_PWM_OUTL_ENABLE TCCR0A = TCCR0A | 0xC0; M_PWM_EN
//Disable PWM output for Left Motor
//Note: Left comes before Right so it doesn't disable PWM in-case Right is using it.
#define M_PWM_OUTL_DISABLE TCCR0A = TCCR0A & 0x3F
//Enable PWM output for Right Motor 
#define M_PWM_OUTR_ENABLE TCCR0A = TCCR0A | 0x30; M_PWM_EN
//Disable PWM output for Right Motor
#define M_PWM_OUTR_DISABLE TCCR0A = TCCR0A & 0xCF
	
//FUNCTIONS
void init_motor();
void i2c_parse();
inline void move(uint8_t a, uint8_t b);

#endif
