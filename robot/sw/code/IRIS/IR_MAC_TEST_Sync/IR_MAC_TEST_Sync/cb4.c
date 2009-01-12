//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// VORATA CB2 Driver
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Jonathan Friedman, GSR
// Networked Embedded Systems Laboratory (NESL)
// University of California, Los Angeles (UCLA)
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#include <inttypes.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>
#include "jonathan.h"
#include "cb4.h"

uint8_t CB2STATE;
volatile uint8_t PORTZ;


//----------------------------------------------------------------
//- CB4 OPERATION FUNCTIONS
//----------------------------------------------------------------

void init_CB4(){
		
  //INIT HARDWARE PORTS
  sbi(CB2PORT, CB2RESET);
  sbi(CB2DDR, CB2RESET);
  sbi(CB2DDR, CB2CLOCK);
  sbi(DDRD, CB2INPUT);
  sbi(CB2DDR, CB2SELECT);
	
  //CLEAR VIRTUAL PORTS
  PORTZ = 0x00;
}

void reset_CB4(){
  cbi(CB2PORT, CB2RESET);
#ifndef _B2_
  clock_stall;
#endif
  sbi(CB2PORT, CB2RESET);
}

//Shift it all out
void update_CB2_1B(uint8_t Outgoing){
	
  uint8_t i, temp;
	
  for(i = 0;  i <= 7; i++){
    //clock low
    cbi(CB2PORT, CB2CLOCK); 
	
    //set data bit
    temp = Outgoing;
    temp &= 0x80;
    if (temp == 0x80) {
      sbi(PORTD, CB2INPUT);
    }
    else {
      cbi(PORTD, CB2INPUT);		
    }
		
    Outgoing = Outgoing << 1;
		
    //clock high
    sbi(CB2PORT, CB2CLOCK);
#ifndef _B2_
    clock_stall;
#endif
  }
}

void load_CB4(){
  reset_CB4();
	
  cbi(CB2PORT, CB2SELECT);
	
  update_CB2_1B(PORTZ);
#ifndef _B2_
  clock_stall;
#endif
  cbi(CB2PORT, CB2CLOCK);
#ifndef _B2_
  clock_stall;
#endif
  sbi(CB2PORT, CB2SELECT);
}
