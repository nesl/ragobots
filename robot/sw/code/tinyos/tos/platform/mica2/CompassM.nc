// $Id: CompassM.nc,v 1.2 2005/02/26 06:32:29 parixit Exp $
// $Log: CompassM.nc,v $
// Revision 1.2  2005/02/26 06:32:29  parixit
// Modified to do heading calculations from ADC readings.
//
// Revision 1.1  2004/10/12 20:03:49  parixit
// Modified for compass based orientation system
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
  * Implements Compass interface.
  *
  * @author Parixit Aghera (parixit@ee.ucla.edu)
  **/ 

module CompassM{
  provides interface Compass;
  provides interface StdControl;

  uses {
    interface ADCControl;
    interface ADC as ADCX;
    interface ADC as ADCY;
    interface CB2Bus as CB2;
  }
}
implementation{
#include "compass.h"
#define MAX_CNT 20
#define PI 3.141592

  uint8_t state;
  uint8_t xCnt, yCnt; //Sample count. Counts number of sample averaged.
  uint16_t x, y; 
  //  float xsf = 1.0, ysf = 1.1202873, xoff=14.0, yoff=16.8;
  float xsf=1.0, ysf=1.274, xoff=34.0, yoff=-50.96;

  enum{
    IDLE,
      WAITXY,
      GOTX_WAITY,
      GOTY_WAITX,
      GOTXY
  };
  
  //Calculates heading and signals the heading to caller.
  task void calHeading(){
    uint8_t lState;
    uint16_t heading = 0, lx=0, ly=0;
    float xh =0, yh =0;
    atomic {
      lState = state;
      if(state == GOTXY){
	lx = x/xCnt;
	ly = y/yCnt;

	state = IDLE;
      }
    }
    if(lState == GOTXY){
	//Do the computation fir calculation the dir
	xh = ((float)lx-650)*xsf + xoff;
	yh = ((float)ly-650)*ysf + yoff;
	if(xh >0 ){
	  if(yh < 0){
	    heading = (uint16_t) ( (int16_t) -((atan(yh / xh) * 180.0) / PI));
	  }else{
	    heading = (uint16_t)(360 - (int16_t) ( (atan(yh / xh) * 180.0) / PI));
	  }
	}else if(xh == 0){
	  if(yh < 0)
	    heading = 90;
	  else
	    heading = 270;
	}else{ //xh < 0
	  heading = (uint16_t)(180 - (int16_t) ( (atan(yh / xh) * 180.0) / PI));
	}
	// FOLLOWING statements should be REMOVED when the compass in mounted in front with right direction of x and y (that is x pointing forward and y to right).
	heading = 360 - heading;  //Because The compass is mounted in back of robot and x and y axis are in opposite the direction 
	if(heading <= 180){
	  heading = heading + 180;
	}else{
	  heading = heading - 180;
	}
	if(heading == 360)
	  heading = 0;
	signal Compass.heading(lx,ly, heading);
    }else{
      return;
    }
  }

  command result_t StdControl.init(){
    call ADCControl.bindPort(TOS_ADC_COMPASS_X_PORT, TOSH_ACTUAL_COMPASS_X_PORT);
    call ADCControl.bindPort(TOS_ADC_COMPASS_Y_PORT, TOSH_ACTUAL_COMPASS_Y_PORT);
    atomic {
      state = IDLE;
    }
    return call ADCControl.init();
  }

  command  result_t StdControl.start(){
    //Set/Reset the compass using GPIO connection
    return SUCCESS;
  }

  command result_t StdControl.stop(){
    return SUCCESS;
  }

  command result_t Compass.getHeading(){
    result_t retVal = FAIL;
    atomic{
      if(state==IDLE){
	state = WAITXY;
	x = 0;
	y = 0;
	xCnt = 0;
	yCnt = 0;
	retVal = SUCCESS;
      }
    }
    if(retVal == SUCCESS){
      call ADCX.getContinuousData();
      call ADCY.getContinuousData();
    }
    return retVal;
  }

  async event result_t ADCX.dataReady(uint16_t data){
    result_t retVal = FAIL;
    atomic{
    switch(state){
    case WAITXY:
      x= x+data;
      xCnt++;
      if(xCnt == MAX_CNT){
	state = GOTX_WAITY;
      }else if(xCnt < MAX_CNT){
	retVal = SUCCESS;
      }else{
	//Reset the readings since something went wrong.
	x=data;
	xCnt = 1;
	retVal = SUCCESS;
      }
      break;
    case GOTY_WAITX:
      x= x+data;
      xCnt++;
      if(xCnt == MAX_CNT){
	state = GOTXY;
	post calHeading();
      }else if(xCnt < MAX_CNT){
	retVal = SUCCESS;
      }else{
	//Reset the readings since something went wrong.
	x=data;
	xCnt = 1;
	retVal = SUCCESS;
      }
      break;
    default:
      //Do nothing since you are not in right state
      state=IDLE;
    }
    }
    return retVal;
  }
  
  async event result_t ADCY.dataReady(uint16_t data){
    result_t retVal = FAIL;
    atomic{
    switch(state){
    case WAITXY:
      y= y+data;
      yCnt++;
      if(yCnt == MAX_CNT){
	state = GOTY_WAITX;
      }else if(yCnt < MAX_CNT){
	retVal = SUCCESS;
      }else{
	//Reset the readings since something went wrong.
	y=data;
	yCnt = 1;
	retVal = SUCCESS;
      }
      break;
    case GOTX_WAITY:
      y= y+data;
      yCnt++;
      if(yCnt == MAX_CNT){
	state = GOTXY;
	post calHeading();
      }else if(yCnt < MAX_CNT){
	retVal = SUCCESS;
      }else{
	//Reset the readings since something went wrong.
	y=data;
	yCnt = 1;
	retVal = SUCCESS;
      }
      break;
    default:
      //Do nothing since you are not in right state
      state=IDLE;
    }
    }
    return retVal;
  }
}
