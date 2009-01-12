/*
#################################################################################
# RAGOBOT:IRMAN MOTOR CONTROLLER PROGRAM
# ------------------------------------------------------------------------------
# Controls motor drive and direction
# 
# APPLIES TO (Ragobot Part Numbers):
# ------------------------------------------------------------------------------
# RBTBDYB
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
# <see CVS for additional comments and dates of revisions> 
# Original by Jonathan Friedman, UCLA (jf@ee.ucla.edu)
#################################################################################
*/

#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>
#include "IRMAN_RAGOBOT.h"
#include "JONATHAN.h"
#include "MOTOR.h"

// Declare your global variables here

void init_motor(){
	sbi(DDRD,5); //PWM
	sbi(DDRD,6);	
	sbi(DDRB,0); //DIR
	sbi(DDRB,1);	
	//set for phase correct mode
	cbi(TCCR0A, 1);
	sbi(TCCR0A, 0);
}

void motor_parse(uint8_t cmd){
	if ((cmd & B8(11000000)) == 0x00){ //motor command type is B8(00xxxxxx)
		//motor command!
		move ( ((cmd & B8(00111000))>>3), (cmd & B8(00000111)) );
	} 
	//else ignore
}

#ifdef _B3_
	void move(uint8_t left, uint8_t right){
		
		switch (left){  //for LEFT case
		default:
		case (M_STOP):
			//disable PWM output
				M_PWM_OUTL_DISABLE;
			//force pin to stop
				cbi(M_PWM_PORT, M_PWM0);
		break;
		case (M_FWD1):
			//set direction
				cbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD1);
			//enable PWM output
				M_PWM_OUTL;
		break;	
		case (M_FWD2):
			//set direction
				cbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD2);
			//enable PWM output
				M_PWM_OUTL;
		break;
		case (M_FWD3):
			//set direction
				cbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD3);
			//enable PWM output
				M_PWM_OUTL;
		break;
		case (M_FWD4):
			//set direction
				cbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD4);
			//enable PWM output
				M_PWM_OUTL;
		break;
		case (M_REV1):
			//set direction
				sbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD1);
			//enable PWM output
				M_PWM_OUTL;
		break;	
		case (M_REV3):
			//set direction
				sbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD3);
			//enable PWM output
				M_PWM_OUTL;
		break;	
		case (M_REV4):
			//set direction
				sbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD4);
			//enable PWM output
				M_PWM_OUTL;
		break;	
		}
		
	//in RIGHT case for movement ones add:
	// TCCR0B = M_PWM_EN;
		switch (right){  //for RIGHT case
		default:
		case (M_STOP):
			//disable PWM output
				M_PWM_OUTR_DISABLE;
				if (bit_is_clear(TCCR0A, 7)) {M_PWM_DISABLE;};
							
			//force pin to stop
				cbi(M_PWM_PORT, M_PWM0);
		break;
		case (M_FWD1):
			//set direction
				sbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD1);
			//enable PWM output
				M_PWM_OUTR;
		break;	
		case (M_FWD2):
			//set direction
				sbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD2);
			//enable PWM output
				M_PWM_OUTR;
		break;
		case (M_FWD3):
			//set direction
				sbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD3);
			//enable PWM output
				M_PWM_OUTR;
		break;
		case (M_FWD4):
			//set direction
				sbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD4);
			//enable PWM output
				M_PWM_OUTR;
		break;
		case (M_REV1):
			//set direction
				cbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD1);
			//enable PWM output
				M_PWM_OUTR;
		break;	
		case (M_REV3):
			//set direction
				cbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD3);
			//enable PWM output
				M_PWM_OUTR;
		break;	
		case (M_REV4):
			//set direction
				cbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD4);
			//enable PWM output
				M_PWM_OUTR;
		break;	
		}
	}
#else
	void move(uint8_t left, uint8_t right){
		
		switch (left){  //for LEFT case
		default:
		case (M_STOP):
			//disable PWM output
				M_PWM_OUTL_DISABLE;
			//force pin to stop
				cbi(M_PWM_PORT, M_PWM0);
		break;
		case (M_FWD1):
			//set direction
				cbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD1);
			//enable PWM output
				M_PWM_OUTL;
		break;	
		case (M_FWD2):
			//set direction
				cbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD2);
			//enable PWM output
				M_PWM_OUTL;
		break;
		case (M_FWD3):
			//set direction
				cbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD3);
			//enable PWM output
				M_PWM_OUTL;
		break;
		case (M_FWD4):
			//set direction
				cbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD4);
			//enable PWM output
				M_PWM_OUTL;
		break;
		case (M_REV1):
			//set direction
				sbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD1);
			//enable PWM output
				M_PWM_OUTL;
		break;	
		case (M_REV3):
			//set direction
				sbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD3);
			//enable PWM output
				M_PWM_OUTL;
		break;	
		case (M_REV4):
			//set direction
				sbi(M_DIR_PORT, M_DIR0);
			//set PWM rate
				OCR0A = set_speed(M_SPD4);
			//enable PWM output
				M_PWM_OUTL;
		break;	
		}
		
	//in RIGHT case for movement ones add:
	// TCCR0B = M_PWM_EN;
		switch (right){  //for RIGHT case
		default:
		case (M_STOP):
			//disable PWM output
				M_PWM_OUTR_DISABLE;
				if (bit_is_clear(TCCR0A, 7)) {M_PWM_DISABLE;};
							
			//force pin to stop
				cbi(M_PWM_PORT, M_PWM0);
		break;
		case (M_FWD1):
			//set direction
				sbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD1);
			//enable PWM output
				M_PWM_OUTR;
		break;	
		case (M_FWD2):
			//set direction
				sbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD2);
			//enable PWM output
				M_PWM_OUTR;
		break;
		case (M_FWD3):
			//set direction
				sbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD3);
			//enable PWM output
				M_PWM_OUTR;
		break;
		case (M_FWD4):
			//set direction
				sbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD4);
			//enable PWM output
				M_PWM_OUTR;
		break;
		case (M_REV1):
			//set direction
				cbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD1);
			//enable PWM output
				M_PWM_OUTR;
		break;	
		case (M_REV3):
			//set direction
				cbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD3);
			//enable PWM output
				M_PWM_OUTR;
		break;	
		case (M_REV4):
			//set direction
				cbi(M_DIR_PORT, M_DIR1);
			//set PWM rate
				OCR0B = set_speed(M_SPD4);
			//enable PWM output
				M_PWM_OUTR;
		break;	
		}
	}
#endif