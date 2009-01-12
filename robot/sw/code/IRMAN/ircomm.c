/*
  #################################################################################
  # RAGOBOT:IRMAN INFRARED COMMUNICATIONS/AVOIDANCE NETWORK STACK
  # ------------------------------------------------------------------------------
  # Controls and processes the IR sensors of IRMAN
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
  # <see CVS for additional comments and dates of revisions> 
  # Original by Jonathan Friedman, UCLA (jf@ee.ucla.edu)
  #################################################################################
*/

#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>
#include "irman.h"
#include "utilities.h"
#include "ircomm.h"
#include "eeprom1.h"


#define IRC0_THRESHOLD_ADDR 0x0000
#define IRC1_THRESHOLD_ADDR 0x0002

// Declare your global variables here


volatile uint32_t cliff0_data;
volatile uint16_t cliff0_val;
volatile uint32_t cliff1_data;
volatile uint16_t cliff1_val;

static uint8_t cliff_state; 

volatile uint16_t IRC0_THRESHOLD;
volatile uint16_t IRC1_THRESHOLD;

static volatile uint8_t i = 0;
static volatile uint8_t air_buffer = 0;




//----------------------------------------------------------------
//- IR CLOCK
//----------------------------------------------------------------

inline void reset_irclock(){
	
}

inline void start_irclock(){
	
}

inline void stop_irclock(){
	
}

inline void disable_output_irclock(){
  TCCR2A = B8(00100010); //OC2A=off,OC2B=clear on compare,Mode = CTC
}

inline void enable_output_irclock(){
  TCCR2A = B8(00010010); //OC2A=off,OC2B=toggle on compare,Mode = CTC
}

//This init routine actually begins operation (as soon as interrupts get enabled)
//LED_ENCODE is OC2B
void init_irclock() 
{
  cbi(PORTD, 3); //so that disabled OCR2B = 0 on output
  cbi(ASSR, 5); //clock from MCU mainline clock (8MHz)
  enable_output_irclock();
  TCCR2B = B8(00000001); //enable timer with 128 prescaler = 62.5kHz
  OCR2A = 98; //toggle after 12.5mS -> 25mS period = 40kHz freq
  TIMSK2 = B8(00000010); //enable OCR2B interrupt
  TIFR2;
  sbi(DDRD, 3); //OCR2B as output
}	





//----------------------------------------------------------------
//- IR CLIFF DETECTOR - CLAS SYSTEM
//----------------------------------------------------------------

//This init routine actually begins operation (as soon as interrupts get enabled)
void init_ircliff() 
{
  cliff_state = IRC_IDLE; //set the current cliff channel to 0
  
  //turn off cliff leds
  ircliff_off();

  //load the IRC_THRESHOLD from eeprom
  eeprom_read(IRC0_THRESHOLD_ADDR, (uint8_t*)(&IRC0_THRESHOLD), 2);
  eeprom_read(IRC1_THRESHOLD_ADDR, (uint8_t*)(&IRC1_THRESHOLD), 2);

  ADMUX = B8(01000110); //ADC6, Right adjust, AVCC-GND
	
  ADCSRA = B8(00111110); //disable, Use Interrupts, autotrigger, div64 clock = 125kHz = 9.6ksps
  ADCSRB = B8(00000000); //Free running mode
  DIDR0 = B8(00000001); //disable ADC0 digital input buffer (saves power)
  cliff0_data = 0;
  cliff1_data = 0;
}

void ircliff_calibrate ()
{
  ircliff_led_medium();
  cliff_state = IRC_CALIBRATE0;
  stall(0x000E);
  cliff0_data = 0;
  cliff1_data = 0;
  cliff0_val = 0;
  cliff1_val = 0;
  i = 0;
  ADCSRA = B8(11101110); //enable and Start, Use Interrupts, autotrigger, div64 clock = 125kHz = 9.6ksps
}

void ircliff_start() 
{
  cliff_state = IRC_READCHANNEL0;
  //cliff0_data = 0;
  //cliff1_data = 0;
  cliff0_val = 0;
  cliff1_val = 0;
  i = 0;
  ADCSRA = B8(11111110); //enable and Start, Use Interrupts, autotrigger, div64 clock = 125kHz = 9.6ksps
}

void ircliff_low()
{
  ircliff_led_low();
  ircliff_start();  
}

void ircliff_medium()
{
  ircliff_led_medium();
  ircliff_start();
}

void ircliff_high()
{
  ircliff_led_high();
  ircliff_start();
}

void ircliff_off()
{
  cliff_state = IRC_IDLE;
  ircliff_led_off();
  ADCSRA = B8(00101110); //disable ADC.
}

void ircliff_led_low()
{
  //Turn on cliff leds on low power
  //ICL_ENC: HIGH; ICH_ENC: LOW
  sbi(PORTB, 6);
  cbi(PORTB, 7);

  //Turn on cliff detector 
  ircliff_detector_on();
}

void ircliff_led_medium()
{
  //Turn on cliff leds on medium power
  //ICL_ENC: LOW; ICH_ENC: HIGH
  cbi(PORTB, 6);
  sbi(PORTB, 7);

  //Turn on cliff detector 
  ircliff_detector_on();
}

void ircliff_led_high()
{
  //Turn on cliff leds on High power
  //ICL_ENC: HIGH; ICH_ENC: HIGH
  sbi(PORTB, 6);
  sbi(PORTB, 7);

  //Turn on cliff detector 
  ircliff_detector_on();
}

void ircliff_led_off()
{
  //Turn off cliff leds
  //ICL_ENC: LOW; ICH_ENC: LOW
  cbi(PORTB, 6);
  cbi(PORTB, 7);

  //Turn off cliff detector 
  ircliff_detector_off();
}

/*



void air_led_low()
{
  PORTZ = PORTZ | B8(01000010);
  PORTZ = PORTZ & B8(11111010);
  load_CB4();	
}

void air_led_medium()
{
  PORTZ = PORTZ | B8(01000100);
  PORTZ = PORTZ & B8(11111100);
  load_CB4();
}

void air_led_high()
{
  PORTZ = PORTZ | B8(01000110);
  load_CB4();
}

//"weapon" led on HEAD module
void air_led_fire()
{
  PORTZ = PORTZ | B8(01000001);
  PORTZ = PORTZ & B8(11111001);
  load_CB4();
}

void air_led_off()
{
  PORTZ = PORTZ & B8(11111000);
  load_CB4();
}
*/

//----------------------------------------------------------------
//- PHYS/MAC LAYERS - AIR SYSTEM
//----------------------------------------------------------------
/*
void read_channel(uint8_t channel_num){
	static uint8_t p_state = S0;
	static uint8_t m_state = S0;
	static uint8_t z_count;
	static uint8_t b_count;
	static uint8_t d_buffer;
	uint8_t new_bit;
	new_bit = PORTI[channel_num] & _BV(CB3OUTPUT);
	switch (p_state){
		case S0: //Look for falling edge
			if (new_bit == 0x00){
				z_count = 0;
				p_state = S1;	
			}
			break;	
		case S1: //Count the zeros
			if (new_bit == 0x00){
				z_count++;
			}
			else {
				p_state = S2;	//if detected rising edge, counting is done (next state)
			}	
			break;
		case S2: //Counted zeros --> symbols; interpret symbols
			if ((z_count >= SYM_1) && (z_count <= SYM_1+SYM_MARGIN)){
				if (m_state == S1) {//in the middle of data capture
					d_buffer = d_buffer << 1;
					d_buffer = d_buffer & 0x01;
					b_count++;
					if (b_count >= 8) { //if this was last bit in byte go to new state
						m_state = S0;
						air_buffer = d_buffer; //return aquired byte
					}
				}
			}
			else if ((z_count >= SYM_0) && (z_count <= SYM_0+SYM_MARGIN)){
				if (m_state == S1) {//in the middle of data capture
					d_buffer = d_buffer << 1;
					b_count++;
					if (b_count >= 8) { //if this was last bit in byte go to new state
						m_state = S0;
						air_buffer = d_buffer; //return aquired byte
					}
				}
			}
			else if ((z_count >= SYM_START) && (z_count <= SYM_START+SYM_MARGIN)){
				b_count = 0;
				m_state = S1;
			}
			p_state = S0;
			break;
			
		default:
			p_state = S0;
			break;
	}
}
*/

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

SIGNAL(SIG_ADC)
{
  switch (cliff_state)
    {
    case IRC_READCHANNEL0: 
      {
	cliff0_val = (ADC & IRC_MASK); //(((uint16_t)ADCH)<<8) + (uint16_t)ADCL;
	cliff_state = IRC_READCHANNEL1;
	ADMUX = B8(01000111); //change ADC to sample ADC7, Left adjust, AVCC-GND 
	break;
      }
    case IRC_READCHANNEL1:
      {
	cliff1_val = (ADC & IRC_MASK);
	cliff_state = IRC_READCHANNEL0;
	ADMUX = B8(01000110); //change ADC to sample ADC6, Left adjust, AVCC-GND
	break;
      }
    case IRC_CALIBRATE0_START:
      {
	cliff0_val = ADC;
	if (i >= NUMSAMPLESTOIGNORE)
	  {
	    cliff_state = IRC_CALIBRATE0;
	  }
	else 
	  {
	    i += 1;
	  }      
	break;
      }

    case IRC_CALIBRATE1_START:
      {
	cliff1_val = ADC;
	if (i >= NUMSAMPLESTOIGNORE)
	  {
	    cliff_state = IRC_CALIBRATE1;
	  }
	else 
	  {
	    i += 1;
	  }      
	break;
      }
    case IRC_CALIBRATE0:
      {
	IRC0_THRESHOLD = ADC & IRC_MASK;
	cliff_state = IRC_CALIBRATE1;
	ADMUX = B8(01000111); //change ADC to sample ADC7, Left adjust, AVCC-GND
	i=0;
	break;
      } 
    case IRC_CALIBRATE1:
      {
	IRC1_THRESHOLD = ADC & IRC_MASK;
	ircliff_off();
	eeprom_write(IRC0_THRESHOLD_ADDR, (uint8_t*)(&IRC0_THRESHOLD), 2);
	eeprom_write(IRC1_THRESHOLD_ADDR, (uint8_t*)(&IRC1_THRESHOLD), 2);
	break;
      }
    } 
  
}
