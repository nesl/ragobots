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
 *
 * @author parixit@ee.ucla.edu
 **/

module DualMotorControllerM{
  provides{
    interface DualMotorControl;
  }
  uses{
    interface HPLUART as UART;
    interface Leds;
    interface Timer;
  }
}

implementation {

#define MIN_RESET_PERIOD 5 //Minimum number of microseconds required to reset controller
  MotorParams *currentParams;
  DMCState dmcState;

  void startCmd(){
    //Send the first byte
    call UART.put(MTR_CTR_START_BYTE);
    dmcState = START_SENT;
  }
  
  command result_t DualMotorControl.init(){
    uint8_t i;
    sbi(PORTC, 0); //set the reset line
    TOSH_uwait(MIN_RESET_PERIOD); // Wait for few micro seconds before pulling it low.
    cbi(PORTC, 0); // reset the motor controller by pulling it low.
    TOSH_uwait(MIN_RESET_PERIOD); // Keep it low for some time.
    sbi(PORTC, 0); //set it up to disable MC reset
    atomic{
      dmcState = IDLE;
    }
    // Need to wait 100 ms before sending out a command. after reseting. 
    //Do not use Timer. It might not have been initialized.
    for(i =0; i < 100; i++){
      TOSH_uwait(1000); 
    }
    call UART.init();
    //    call Timer.start(TIMER_ONE_SHOT, 2000); // Need to wait 100 ms before sending out a command. after reseting.
    return SUCCESS;
  }

  async command result_t DualMotorControl.changeMotorParams(MotorParams *params){
    result_t returnVal = SUCCESS;
    uint8_t lState = IDLE;
#ifdef DBG
    call Leds.yellowToggle();
#endif
    atomic{
      //Check the state
      if(dmcState != IDLE && dmcState != RESETED){
	returnVal = FAIL;
      }
      if(dmcState == RESETED){
	dmcState =  CMD_PENDING;
      }
      lState = dmcState;
      //Check arguments for valid values
      if((params->motorID >= NUM_MOTORS_SUPPORTED) || (params->speed > MAX_SPEED)) {
	returnVal = FAIL;
      }
    }
    if(returnVal == SUCCESS){
      currentParams = params;
      if(lState == IDLE){
	startCmd();
      }
    }
    return returnVal;
  }


  async event result_t UART.get (uint8_t data){
    return SUCCESS;
  }

  async event result_t UART.putDone () {
    //    call Leds.greenToggle();
    atomic {
      switch(dmcState){
      case START_SENT:
	//Send the second byte
	call UART.put(MTR_CTR_DEV_TYPE);
	dmcState = CTRID_SENT;
	break;

      case CTRID_SENT:
	//Send the third byte
	call UART.put(currentParams->motorID * 2 + currentParams->dir);
	dmcState = MOTORID_DIR_SENT;
	break;

      case MOTORID_DIR_SENT:
	//Send the fourth byte
	call UART.put(currentParams->speed);
	dmcState = SPEED_SENT;
	break;

      case SPEED_SENT:
	//Set the state to IDLE and signal completion of DMC command
	dmcState = IDLE;
	dbg(DBG_USR1, "Command sent. sending signal\n");
	signal DualMotorControl.motorParamsChanged(currentParams);
	break;
      case IDLE:
      case RESETED:
      case CMD_PENDING:
	break;
      }
    }
    return SUCCESS;
  }
	
  command void DualMotorControl.reset(){
    atomic{
    sbi(PORTC, 0); //set the reset line
    TOSH_uwait(MIN_RESET_PERIOD); // Wait for few micro seconds before pulling it low.
    cbi(PORTC, 0); // reset the motor controller by pulling it low.
    TOSH_uwait(MIN_RESET_PERIOD); // Keep it low for some time.
    sbi(PORTC, 0); //set it up to disable MC reset
    dmcState = RESETED;
    }
    call Timer.start(TIMER_ONE_SHOT, 100); // Need to wait 100 ms before sending out a command. after reseting.
  }
       
  event result_t Timer.fired(){
    call Timer.stop();
    //    call Leds.greenOn();
    atomic{
      if( dmcState == CMD_PENDING ){
	startCmd();
      }else{
	dmcState = IDLE;
	call Leds.yellowToggle();
	
      }
    }
    return SUCCESS;

  }
}
