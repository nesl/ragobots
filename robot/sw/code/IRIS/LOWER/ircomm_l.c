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
#include "ircomm_l.h"
#include "uart0.h"
#include "tp.h"
#include "i2c.h"

// Declare your global variables here

static uint8_t p_symbol[NUM__OF_CHANNELS];
static uint8_t p_state[NUM__OF_CHANNELS];
static uint8_t p_count[NUM__OF_CHANNELS];
static uint8_t p_data [NUM__OF_CHANNELS];
static uint8_t out_direction;

//----------------------------------------------------------------
//- INIT ROUTINES
//----------------------------------------------------------------

void init_array(uint8_t* toinit, uint8_t size, uint8_t init_val){
	uint8_t i;
	for (i=0;i<size;i++){
		toinit[i] = init_val;
	}
}

//reset the state machine logic that drives the byte assembly process
inline void init_iris_sm(void){
	init_array(p_symbol, NUM__OF_CHANNELS, SYM_INVD_Q);
	init_array(p_state, NUM__OF_CHANNELS, S0);
	init_array(p_data, NUM__OF_CHANNELS, 0);
	init_array(p_count, NUM__OF_CHANNELS, 0);
	out_direction = 0x00;
}

//physical pin setup take care of in init_mcu();
inline void init_iris(){
	iris_rx(OFF);
	iris_tx(OFF);
	iris_weapon(OFF);	
	init_iris_sm();
}

//This init routine actually begins operation (as soon as interrupts get enabled)
//LED_ENCODE is OC2B
void init_irtx(){
	//TIMER 2: 40kHz 50% Square Wave Generator
		cbi(PORTD, 3); //so that disabled OCR2B = 0 on output
  		cbi(ASSR, 5); //clock from MCU mainline clock (16MHz)
  		enable_output_irclock();
  		TCCR2B = B8(00000001); //enable timer with no prescaler = 16MHz
  		OCR2A = 200; //toggle after 12.5mS -> 25mS period = 40kHz freq (16MHz clock)
  		TIMSK2 = B8(00000010); //OC2A match interrupt enabled
  		TIFR2; //Timer interrupt flag register
  		sbi(DDRD, 3); //OCR2B as output  		
}		

//----------------------------------------------------------------
//- IR TRANSMISSION POWER ROUTING
//----------------------------------------------------------------

//enable/disable power to the IR receivers
//usage: iris_rx(ON) / iris_rx(OFF)
extern void iris_rx(uint8_t cmd){
	switch(cmd){
	case ON:
		sbi(PORTD, 7);
		break;
	case OFF:
		cbi(PORTD, 7);
		break;
	default:
		break;	
	}	
}

//Due to a bug the two control lines are shorted together. This precludes any power setting except HIGH from functioning.
extern void iris_tx(uint8_t cmd){
	switch(cmd){
	case LOW:
		//for future use		
		break;
	case MED:
		//for future use
		break;
	case HIGH:
		sbi(PORTC, 2);
		break;
	case OFF:
		//fall through to default
	default:
		//OFF
		cbi(PORTC, 2);
		cbi(PORTC, 1);	
	} //switch
}

extern void iris_weapon(uint8_t cmd){
	switch(cmd){
	case FIRE:
		sbi(PORTC, 0);
		break;
	case OFF:
		//fall through to default
	default:
		//OFF
		cbi(PORTC, 0);
	} //switch
}


//----------------------------------------------------------------
//- IR TRANSMISSION CLOCKS
//----------------------------------------------------------------

inline void reset_irclock(){
	
}

//NEW: jonathan
inline void start_irclock(){
	//8MHz:: OCR0A = 120; //1/8e6MHz * 8 (prescale) * OCR0A = period in seconds (for these values 8/8=1, so OCR0A = period in uS)
	//OCR0A = 180; //for 16MHz clock; 180= 90uS period
	OCR0A = 140; //for 16MHz clock; 100 = 50uS period; 140 = 70uS period
	OCR0B = 0x00; //min out the compare registers so that the interrupt flag register is easier for GCC to read (bits will always be 1 so TIFR0 = B4(0110) if no overflow)
	TCNT0 = 0xFF; //start with overflow flag set to make GCC processing of byte easier
	TCCR0A = B8(00000010); //CTC MODE, NO I/O BEHAVIORS
	TCCR0B = B8(00000010); //8MHZ CLOCK / 8 = 256uS PER PERIOD
}

//NEW: jonathan
inline void stop_irclock(){
	TCCR0B = B8(00000000); //NO CLOCK SOURCE = STOPPED
}

inline void disable_output_irclock(){
  TCCR2A = B8(00100010); //OC2A=off,OC2B=clear on compare,Mode = CTC
}

inline void enable_output_irclock(){
  TCCR2A = B8(00010010); //OC2A=off,OC2B=toggle on compare,Mode = CTC
}



//----------------------------------------------------------------
//- IRIS BYTE ASSEMBLY
//----------------------------------------------------------------

//unpack the byte into a single channel
//position range is 0-3
inline uint8_t iris_unpack(uint8_t position, uint8_t datain){
	datain = datain >> position;
	datain = datain & B8(00000011);
	return datain;
}

//unpack; xfr0 was received first
inline void iris_xfr_receive(uint8_t sym_xfr0, uint8_t sym_xfr1){
	p_symbol[6] = iris_unpack(2, sym_xfr0);
	p_symbol[5] = iris_unpack(1, sym_xfr0);
	p_symbol[4] = iris_unpack(0, sym_xfr0);
	p_symbol[3] = iris_unpack(3, sym_xfr1);
	p_symbol[2] = iris_unpack(2, sym_xfr1);
	p_symbol[1] = iris_unpack(1, sym_xfr1);
	p_symbol[0] = iris_unpack(0, sym_xfr1);
}

//the missing virtual state 1 from the diagram
inline void S1(uint8_t channel_num){
	//This code in here is the function of State S1 from the 
			//	diagram in my thesis (not a real state, but made 
			//	diagram easier to read)
			p_state[channel_num] = S2;
			p_count[channel_num] = 0;
			p_data[channel_num] = 0x00;
}

inline void S3(uint8_t channel_num){
	//This code in here is the function of State S3 from the diagram
			//	in my thesis.
			//COMPRESS AND REPORT!
			//mark direction
			sbi(out_direction, channel_num);
			p_state[channel_num] = S0; //reset for next byte
}

//process each channel
inline void iris_byte_assembly(uint8_t channel_num){
	switch(p_state[channel_num]){
	case S0:
		//LOOK FOR START SYMBOL
		if (p_symbol[channel_num] == SYM_START_Q){
			S1(channel_num);
		}
		break;
	
//	case S1: implemented as a function call above
	
	case S2:
		//COLLECT DATA BITS
		switch(p_symbol[channel_num]){
		
			case SYM_0_Q:
				//p_data[channel_num] is wiped to 0x00 during START detection
				//	this allows us to make the optimization of not testing or 
				//	writing the data byte now (since the bit position is already 0)
				//	just increase the bit pointer to indicate that we have seen 
				//	this valid bit already
				p_count[channel_num]++;	
				
				//END DETECTION (found valid data byte)
				if (p_count[channel_num] >= 8){
					S3(channel_num);
				}
				break;
			
			case SYM_1_Q:
				//write a 1 to the current bit position
				//remember that bits arrive MSb first, but count goes up
				//i.e. bit position 7 arrives first, when p_count = 0
				//so we need a bit of inversion logic here
				p_data[channel_num] |= (0x80 >> p_count[channel_num]);
				p_count[channel_num]++;	
				
				//END DETECTION (found valid data byte)
				if (p_count[channel_num] >= 8){
					S3(channel_num);
				}
				break;
			
			case SYM_START_Q:
				S1(channel_num);
				break;
			
			default: //SYM_INVALID_Q
				p_state[channel_num] = S0;
				break;
		}
		break;
		
	default:
		p_state[channel_num] = S0; //error recovery	
		break;
	}	
}


//----------------------------------------------------------------
//- INTERRUPT SERVICE ROUTINES
//----------------------------------------------------------------

//30 = 350uS

#define t400us 15   //40 //actually 336us
#define t200us 23 //actually 232us
#define t150us 14 //16 //actually 156us

//#define t350us 32 //actually 336us


SIGNAL(SIG_OUTPUT_COMPARE2A){
  static volatile uint8_t	cpp=0;
  static volatile uint8_t	active=t400us; 
  
  cpp++;
  if (cpp == active){
    disable_output_irclock();	
  }
  else if (cpp >= 80){  //should be 80
    cpp = 0;
    if (active == t400us) active=t150us;
    else if (active == t150us) active=t200us;
    else if (active == t200us) active=t400us; 
    active = t400us; //xxx
    enable_output_irclock();
    //tpl(TOGGLE);
    //disable_output_irclock();//xxx	
  }
}

//make sure that this interrupt is interruptable
//data0 was received first
inline void USRT_DATA_RX_ISR(uint8_t data0, uint8_t data1){
	uint8_t j;
	uint8_t processed;
	uint8_t matched;
	uint8_t k;

	//Receive & Unpack
		iris_xfr_receive(data0, data1);
	//Process Channels
		iris_byte_assembly(0);
		iris_byte_assembly(1);
		iris_byte_assembly(2);
		iris_byte_assembly(3);
		iris_byte_assembly(4);
		iris_byte_assembly(5);
		iris_byte_assembly(6);
		//iris_byte_assembly(7); //enable if you ever add the 7th channel
	//Check if any channels finished
		processed = out_direction;
		while (processed != 0x00){
			matched = 0x00;
			k = NUM__OF_CHANNELS+1;
			//somebody finished
			for(j=0;j<NUM__OF_CHANNELS;j++){
				if ((processed & _BV(j)) > 0){
					//channel j finished collecting data this cycle
					//check if other channels carry this data
					if (k > NUM__OF_CHANNELS){
						k = j; //lock data target
						matched |= _BV(k); //set bit for this channel in DIRECTION output
					}
					else {
						//found second or additional channel with the same data at the same time
						matched |= _BV(j); //set bit for this channel in DIRECTION output
					}
					processed &= ~(_BV(j)); //clear this channels bit to mark as seen
				}	
			}
			//enqueue matched data
			cli(); 	// CRITICAL SECTION!
					//		We mark this critical because it weighs on our analysis of the i2c
					//		outgoing data queue; Outgoing data is always two-byte aligned so we
					//		can use a mod2 function over the remaining bytes to be sent to infer
					//		that we are still in alignment.
				i2c_enqueue(matched);
				i2c_enqueue(p_data[k]);
			sei(); //END CRITICAL SECTION!
		}
	//Cleanup and Reset
		out_direction = 0x00;			
}
