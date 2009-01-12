/*
  #################################################################################
  # RAGOBOT:IRMAN INFRARED COMMUNICATIONS/AVOIDANCE NETWORK STACK
  # ------------------------------------------------------------------------------
  # Controls and processes the IR sensors of IRMAN
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
#include "JONATHAN.h"
#include "ircomm_u.h"
#include "uart0.h"
#include "tp.h"

// Declare your global variables here

static uint8_t air_capture;
static uint8_t q_level;
static uint8_t sym_xfr[2]; //used to tranfer pulsewidth->symbol data to IRISL
static uint8_t p_state[NUM__OF_CHANNELS];
static uint8_t z_count[NUM__OF_CHANNELS];


//----------------------------------------------------------------
//- INIT ROUTINES
//----------------------------------------------------------------

void init_array(uint8_t* toinit, uint8_t size, uint8_t init_val){
	uint8_t i;
	for (i=0;i<size;i++){
		toinit[i] = init_val;
	}
}

//logical state setup
inline void init_air(){
	init_array(p_state, NUM__OF_CHANNELS, S0);
	reset_sym_xfr();
	q_level = 0x00; //all enqueue-ing begins at level 0
}

//physical pin setup
inline void init_iris(){
	cbi(DDRB,0); //IR_RX_CHNL6 as input
	DDRC = 0x00; //IR_RX_CHNL[0-5] as inputs
}


//----------------------------------------------------------------
//- IRIS SIGNAL-TO-SYMBOL DECODER
//----------------------------------------------------------------

inline void air_get_channels(){
	air_capture = PINC | (PINB << 6); //This works because..
	//..PC6 will read as zero because fused to be reset line (i.e. GPIO is disabled); 
	//..PB0 is the 6th channel so left shift by 6 get is from 0 bit position to 6th position;
	//..PC7 is potentially corrupted, but we'll never analyze that bit so we don't care!
}

//return the air_Capture data for debugging
inline uint8_t get_air_capture(void){
	return air_capture;	
}

inline void set_air_capture(uint8_t newval){
	air_capture = newval;	
}
		
inline void air_proc_channel(uint8_t channel_num){
	uint8_t new_bit;
	new_bit = air_capture & _BV(channel_num);
	switch (p_state[channel_num]){
		
		//Look for rising edge (assuming inverter)
		case S0: 
			if (new_bit != 0x00){
				z_count[channel_num] = 1; //found the first one (assumes inverter)
				p_state[channel_num] = S1;	
			}
			break;	
		
		//Count the ones (assuming inverter)
		case S1: 
			if (new_bit != 0x00){
				if (z_count[channel_num] != 0xFF){ //error case of channel noise producing extended "white-out", do not roll-over count!
					z_count[channel_num]++;
				}
			}
			else {
				p_state[channel_num] = S2;	//if detected falling edge, counting is done (next state) (assumes inverter)
			}	
			break;
		
		//Counted ones --> symbols; interpret symbols (assuming inverter)
		case S2: 
			if ((z_count[channel_num] >= SYM_1) && (z_count[channel_num] <= SYM_1+SYM_1_MARGIN)){
				//FOUND LOGIC ONE
				load_sym_xfr(channel_num, QSYM_1);
			}
			else if ((z_count[channel_num] >= SYM_0) && (z_count[channel_num] <= SYM_0+SYM_0_MARGIN)){
				//FOUND LOGIC ZERO
				load_sym_xfr(channel_num, QSYM_0);
			}
			else if ((z_count[channel_num] >= SYM_START) && (z_count[channel_num] <= SYM_START+SYM_START_MARGIN)){
				//FOUND START
				load_sym_xfr(channel_num, QSYM_START);
			}
			p_state[channel_num] = S0;
			break;
			
		default:
			p_state[channel_num] = S0;
			break;
	}
}


//----------------------------------------------------------------
//- IRIS SYMBOL TRANSFER SYSTEM (IRISU-to-IRISL)
//----------------------------------------------------------------

//symbol is one of the QSYM values
void load_sym_xfr(uint8_t channel_num, uint8_t symbol){
	if 	(channel_num < 4){
		sym_xfr[0] = sym_xfr[0] | (symbol<<(channel_num*2));
	}
	else if (channel_num < NUM__OF_CHANNELS){
		sym_xfr[1] = sym_xfr[1] | (symbol<<((channel_num-4)*2));
	}
	//else do nothing
}

//transfer the sym_xfr queue to IRISL
//uses forced transfers which means that the UART buffer is assumed to be empty
//no safety checking is performed.
void transfer_sym(void){
	uart0_force_byte(sym_xfr[1]);	
	uart0_force_byte(sym_xfr[0]);	
	reset_sym_xfr();
}

void transfer_sym_debug(void){
	static uint8_t vector_counter = 0;
	vector_counter++;
	
	//vector_counter = 2; //xxx
	
	switch (vector_counter){
	case 1:
		//START
		send_byte_serial(0xFF);	
		send_byte_serial(0xFF);	
		break;
	case 2:
		//D0
		send_byte_serial(0x55);	
		send_byte_serial(0x55);	
		break;
	case 3:
		//D1
		send_byte_serial(0xAA);	
		send_byte_serial(0xAA);	
		break;
	case 4:
		//D1
		send_byte_serial(0xAA);	
		send_byte_serial(0xAA);	
		break;
	case 5:
		//D0
		send_byte_serial(0x55);	
		send_byte_serial(0x55);	
		break;
	case 6:
		//D1
		send_byte_serial(0xAA);	
		send_byte_serial(0xAA);	
		break;
	case 7:
		//D0
		send_byte_serial(0x55);	
		send_byte_serial(0x55);	
		break;
	case 8:
		//D1
		send_byte_serial(0xAA);	
		send_byte_serial(0xAA);	
		break;
	case 9:
		//D0
		send_byte_serial(0x55);	
		send_byte_serial(0x55);	
tpl(ON); //xxx
		break;
	default:
		if (vector_counter > 250) {
			vector_counter = 200;	
		}
	}
	reset_sym_xfr();
}
/*
void debug_transfer_sym(void){
	if ((sym_xfr[1] != 0x00) || (sym_xfr[0] != 0x00)){
		send_byte_serial('r');
		UART_send_BIN8(sym_xfr[1]);	
		send_byte_serial('-');
		UART_send_BIN8(sym_xfr[0]);	
		send_byte_serial(10);
		send_byte_serial(13);
	}
	reset_sym_xfr();
}
*/
//reset sym_xfr queue
inline void reset_sym_xfr(void){
	sym_xfr[1]=0x00;
	sym_xfr[0]=0x00;
}
