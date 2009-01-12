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
#include "IRMAN_RAGOBOT.h"
#include "JONATHAN.h"
#include "IR_COMM.h"
#include "uart0.h"
void stk_ledon(uint8_t num);

// Declare your global variables here


volatile uint32_t cliff0_data;
volatile uint16_t cliff0_val;
volatile uint32_t cliff1_data;
volatile uint16_t cliff1_val;

volatile uint16_t IRC0_THRESHOLD;
volatile uint16_t IRC1_THRESHOLD;

static uint8_t air_capture;
static uint8_t q_level;
static uint8_t air_buffer[NUM__OF_CHANNELS];
static uint8_t p_state[NUM__OF_CHANNELS];
static uint8_t m_state[NUM__OF_CHANNELS];
static uint8_t z_count[NUM__OF_CHANNELS];
static uint8_t q_sym[7][4] = {{0x00,0x01,0x02,0x03},{0x00,0x04,0x05,0x06},{0x00,0x07,0x08,0x09},{0x00,0x0A,0x0B,0x0C},{0x00,0x01,0x02,0x03},{0x00,0x04,0x05,0x06},{0x00,0x07,0x08,0x09}};

void init_array(uint8_t* toinit, uint8_t size, uint8_t init_val){
	uint8_t i;
	for (i=0;i<size;i++){
		toinit[i] = init_val;
	}
}

void inline debug_pb(){
	while((PINC & B8(00001000)) != 0x00);	
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

//This init routine actually begins operation (as soon as interrupts get enabled)
//LED_ENCODE is OC2B
void init_irtx() 
{
	//TIMER 2: 40kHz 50% Square Wave Generator
		cbi(PORTD, 3); //so that disabled OCR2B = 0 on output
  		cbi(ASSR, 5); //clock from MCU mainline clock (16MHz)
  		enable_output_irclock();
  		TCCR2B = B8(00000001); //enable timer with no prescaler = 16MHz
  		OCR2A = 200; //toggle after 12.5mS -> 25mS period = 40kHz freq (16MHz clock)
  		TIMSK2 = B8(00000000); //no interrupts from this timer
  		TIFR2; //Timer interrupt flag register
  		sbi(DDRD, 3); //OCR2B as output
  		
  	//TIMER 1: Data encoding clock - pulse width determination
  		TCCR1A = B8(00000000); //Normal counter
  		TCCR1B = B8(00000100); //Divide by 256 (16MHz/256 = 62.5kHz)
  		TCCR1C = B8(00000000); //No force compare matches
  		
}		


//----------------------------------------------------------------
//- IR RING DETECTOR - AIR SYSTEM
//----------------------------------------------------------------

void air_led_low()
{

}

void air_led_medium()
{
 
}

void air_led_high()
{

}

//"weapon" led on HEAD module
void air_led_fire()
{
 
}

void air_led_off()
{
 
}


//----------------------------------------------------------------
//- PHYS/MAC LAYERS - AIR SYSTEM
//----------------------------------------------------------------

inline void air_init(){
	init_array(p_state, NUM__OF_CHANNELS, S0);
	init_array(m_state, NUM__OF_CHANNELS, S0);
	init_array(air_buffer, NUM__OF_CHANNELS, 0x00);
	q_level = 0x00; //all enqueue-ing begins at level 0
}

inline void air_get_symbols(){
	air_capture = PORTAIR;
	
	//DEBUG - clone channels
	if ((air_capture & _BV(0)) == 0x00) {
		air_capture = 0x00;
	}
	else {
		air_capture = 0xFF;
	}
	//stk_ledon(air_capture);
}
		
inline void air_proc_channel(uint8_t channel_num){
	uint8_t new_bit;
	new_bit = air_capture & _BV(channel_num);
	switch (p_state[channel_num]){

		case S0: //Look for rising edge (assuming inverter)
			if (new_bit != 0x00){
				z_count[channel_num] = 1; //found the first one (assumes inverter)
				p_state[channel_num] = S1;	
			}
			break;	
		
		case S1: //Count the ones (assuming inverter)
			if (new_bit != 0x00){
				if (z_count[channel_num] != 0xFF){ //error case of channel noise producing extended "white-out", do not roll-over count!
					z_count[channel_num]++;
				}
			}
			else {
				p_state[channel_num] = S2;	//if detected falling edge, counting is done (next state) (assumes inverter)
			}	
			break;

		case S2: //Counted ones --> symbols; interpret symbols (assuming inverter)
			if ((z_count[channel_num] >= SYM_1) && (z_count[channel_num] <= SYM_1+SYM_MARGIN)){
/*
				if (m_state[channel_num] == S1) {//in the middle of data capture
					d_buffer[channel_num] = d_buffer[channel_num] << 1; //data is transmitted MSb first
					d_buffer[channel_num] = d_buffer[channel_num] | B8(00000001); //set new bit to 1 (incoming)
					b_count[channel_num]++;
					if (b_count[channel_num] >= 8) { //if this was last bit in byte go to new state
						m_state[channel_num] = S0;
						air_buffer[channel_num] = d_buffer[channel_num]; //return acquired byte
					}
				}
*/
			}
			else if ((z_count[channel_num] >= SYM_0) && (z_count[channel_num] <= SYM_0+SYM_MARGIN)){
/*
				if (m_state[channel_num] == S1) {//in the middle of data capture
					d_buffer[channel_num] = d_buffer[channel_num] << 1;
					b_count[channel_num]++;
					if (b_count[channel_num] >= 8) { //if this was last bit in byte go to new state
						m_state[channel_num] = S0;
						air_buffer[channel_num] = d_buffer[channel_num]; //return aquired byte
					}
				}
*/
			}
			else if ((z_count[channel_num] >= SYM_START) && (z_count[channel_num] <= SYM_START+SYM_MARGIN)){
				//START!
				/*
				if (channel_num == 0){
					stk_ledon(LTS);
					LTS = LTS << 1;
					if (LTS == 0x00) LTS = 0x01;
					//debug_pb();
				}
				*/
/*
				b_count[channel_num] = 0;
				m_state[channel_num] = S1;
*/
			}
			p_state[channel_num] = S0;
			break;
			
		default:
			p_state[channel_num] = S0;
			break;
	}
}


//----------------------------------------------------------------
//- INTERRUPT SERVICE ROUTINES
//----------------------------------------------------------------

#define t400us 50   //40 //actually 336us
#define t150us 40 //16 //actually 156us
#define t200us 30 //actually 232us

#define t350us 32 //actually 336us


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
    enable_output_irclock();	
  }
}
