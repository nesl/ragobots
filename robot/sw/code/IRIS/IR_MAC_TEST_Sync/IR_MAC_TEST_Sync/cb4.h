//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// VORATA CB2 Driver
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Jonathan Friedman, GSR
// Networked Embedded Systems Laboratory (NESL)
// University of California, Los Angeles (UCLA)
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#ifndef __CB2__H__
#define __CB2__H__


#define CB2PORT		PORTC	//MUST MATCH CB2PORT AND CB2DDR MUST MATCH!
#define CB2DDR		DDRC
#define CB2RESET 	1
#define CB2CLOCK 	3
#define CB2INPUT 	7 //PORTD!!!
#define CB2SELECT 	2

#define clock_stall asm volatile("nop\n\t" "nop\n\t" "nop\n\t" "nop\n\t": : )
#define svbi(PORT, PIN) (PORT != _BV(PIN))
#define cvbi(PORT, PIN) (PORT &= ~_BV(PIN))
#define tvbi(PORT, PIN) (PORT ^= _BV(PIN))

extern volatile uint8_t PORTZ;

void init_CB4();
void reset_CB4();
void load_CB4();

void ircliff_led_low();
void ircliff_led_medium();
void ircliff_led_high();
void ircliff_led_off();

#endif
