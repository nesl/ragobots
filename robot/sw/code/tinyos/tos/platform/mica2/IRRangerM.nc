//$Id: IRRangerM.nc,v 1.5 2004/05/24 08:18:19 parixit Exp $
//$Log: IRRangerM.nc,v $
//Revision 1.5  2004/05/24 08:18:19  parixit
//Removed call to Leds.
//
//Revision 1.4  2004/03/16 07:50:26  parixit
//Fixed the bug in module. IR Ranger was not doing conversion of DEC value.
//
//Revision 1.3  2004/03/15 09:40:19  parixit
//Updated IRRangerM to convert DEC reading to physical distance in cm.
//IRRanger has beeb updated by adding a return character at the end to avoid compilatio error.
//
/*									tab:4
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
 */

/**
 * IRRangerM implements driver for Sharp GP2D02 IR ranger device.
 * 
 * @author Parixit Aghera parixit@ee.ucla.edu
 **/

module IRRangerM{
  provides{
    interface IRRanger;
  }
  uses{
    interface Timer;
    interface Leds;
  }
}

implementation{
#define REST_PERIOD 2 //miliseconds
#define MIN_IR_LEVEL_PERIOD 35 //micro seconds
  enum {IR_IDLE, IR_BUSY, IR_REST};

  /**
   * Maintains state of the IR Ranger.
   **/
  uint8_t state;

  /**
   * Following table is used to convert DEC (Distance Measuring Output) of IR ranger, actual
   * physical distance in cm.
   */
#define CONVERSION_TBL_LEN 9
  uint8_t decConvertor[CONVERSION_TBL_LEN] = { 190, 135, 107, 95, 87, 80, 78, 75, 0};
        
  
  /**
   * Converts the DEC value received from IR ranger to physical distance.
   *
   * @return Returns physical distance from object.
   **/
  uint8_t convertToCm(uint8_t decVal){
    uint8_t i;
    //Implemented as lookup table. But need to define function for getting precise value.
    for(i=0; i < CONVERSION_TBL_LEN; i++){
      if(decVal > decConvertor[i]){
	return (i+1)*10; 
      }
    }
  }

  /**
   * Initializes I/O ports for IR Ranger.
   *
   * @return SUCCESS. It always returns SUCCESS.
   **/
  command result_t IRRanger.init(){
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

    atomic state = IR_IDLE;
    return SUCCESS;
  }

  /**
   * Triggers IR Ranger for measuring the distance.
   *
   * @return SUCCESS if IR Ranger is not in use, FAIL otherwise.
   **/
  command result_t IRRanger.getDistance(){
    uint8_t lstate;
    atomic lstate = state;
    if(lstate != IR_IDLE){
      return FAIL;
    }else {
      atomic state = IR_BUSY;
      TOSH_CLR_PW7_PIN();
      return SUCCESS;
    }
  }

  // Default implementation of the IRRanger.distance.
  //This will be executed when no compoenent is connected with this component.
  default async event void IRRanger.distance(uint8_t distance){

    return;
  }
  /**
   * INT0/INT4 handler. It reads the value from IR Ranger and converts to physical distance between object and IR Ranger.
   **/
  TOSH_SIGNAL(SIG_INTERRUPT4) {
    uint8_t i;
    uint8_t distance = 0;
    uint8_t lstate;
    atomic lstate = state;
    if(lstate == IR_BUSY){
      //  call Leds.greenToggle();
      TOSH_uwait(MIN_IR_LEVEL_PERIOD);
      for(i=0; i < 8; i++){
	//Provide clock to IR Ranger.
	TOSH_SET_PW7_PIN();
	TOSH_uwait(MIN_IR_LEVEL_PERIOD);
	TOSH_CLR_PW7_PIN();
	TOSH_uwait(MIN_IR_LEVEL_PERIOD);

	//Read the bit from pin
	distance = distance | TOSH_READ_INT0_PIN();

	//Shift the bits (except last) to make room for next bit to be read from pin.
	if(i!=7){
	  distance = distance << 1;
	}
      }

      //Set the output high
      TOSH_SET_PW7_PIN();
      atomic state = IR_REST;
      signal IRRanger.distance(convertToCm(distance));
      call Timer.start(TIMER_ONE_SHOT, REST_PERIOD);
    }
  }

  /**
   * Changes state from IR_REST to IR_IDLE
   *
   * @return SUCCESS always.
   **/
  event result_t Timer.fired(){
    atomic{
      if(state == IR_REST){
	state = IR_IDLE;
      }
    }
    return SUCCESS;
  }

}


