// $Id: ObstacleDetectionM.nc,v 1.4 2004/10/23 22:16:22 parixit Exp $
// $Log: ObstacleDetectionM.nc,v $
// Revision 1.4  2004/10/23 22:16:22  parixit
// Cleaned up the state machines and modified the interfaces to avoid un-neccessary return values.
//
// Revision 1.3  2004/05/03 04:43:59  parixit
// Moved the code from events to tasks.
//
// Revision 1.2  2004/03/16 07:51:49  parixit
// Added code for debugging
//
// Revision 1.1  2004/03/15 09:34:17  parixit
// Created.
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
  * Implements ObstacleDetection interface.
  *
  * @author Parixit Aghera (parixit@ee.ucla.edu)
  **/ 

module ObstacleDetectionM{
  provides{
    interface ObstacleDetection;
    interface StdControl;
  }
  uses{
    interface IRRanger;
    interface PanTiltController;
    interface Timer;
    interface Leds;
  }
}
implementation{
  /*
   * Look for obstacle distance in current path at every lookupPeriod.
   */

#define  MIN_PERIOD 100 //Mili seconds
#define SCAN_SPAN 180 //in Degrees
#define MAX_ANGLE 90

  uint16_t lookupPeriod; //In miliseconds
  uint8_t minDist; // Min. distance of the obstable 
  uint8_t state = 0;
  int8_t angle;
  int8_t angleInc;
  uint8_t *map;
  uint8_t mapIndex;

  uint8_t distance;

  enum {OD_IDLE = 1, OD_CREATE_MAP, OD_ALARM_ONE_TIME, OD_ALARM, OD_MAP_COMPLETE};

  task void handleIRRanger(){
    result_t mapFlag = FAIL;
    atomic{
      if(state == OD_ALARM || state == OD_ALARM_ONE_TIME){
	if(distance < minDist){
	  state = OD_IDLE;
	  signal ObstacleDetection.obstacleAlarm();
	}
      }else if (state == OD_CREATE_MAP){
	map[mapIndex] = distance;
	mapIndex++;
	angle += angleInc;
	mapFlag = SUCCESS;
      }
    }
    if(mapFlag == SUCCESS){
      call PanTiltController.setPanPosition(angle,0);
    }
  }  

  task void handlePanPositionChange(){
    if(state == OD_CREATE_MAP){
      if(angle + angleInc < MAX_ANGLE){
	while(call IRRanger.getDistance()!= SUCCESS){
	  TOSH_uwait(1000); // Wait for 1 mili second if IR ranger is busy
	}
      }else{
	call PanTiltController.setPanPosition(0,0);
	atomic state = OD_MAP_COMPLETE;
      }
    }else if(state == OD_MAP_COMPLETE){
      signal ObstacleDetection.obstacleMapReady(mapIndex + 1, map);
      atomic state = OD_IDLE;
    }
  }

  command result_t StdControl.init(){
    call PanTiltController.init();
    call PanTiltController.setPanPosition(0,0);
    call PanTiltController.setTiltPosition(0,0);
    call IRRanger.init();
    // call Leds.init();
    // call Leds.yellowToggle();
    atomic state = OD_IDLE;
    return SUCCESS;
  }

  command result_t StdControl.start(){
    return SUCCESS;
  }

  command result_t StdControl.stop(){
    return SUCCESS;
  }

  command result_t ObstacleDetection.getObstacleMap(uint8_t dataPoint, uint8_t *mapBuffer){
    result_t returnVal = FAIL;
    atomic{
      if(state == OD_IDLE){
	angleInc = SCAN_SPAN/dataPoint;
	angle = -90;
	state = OD_CREATE_MAP;
	returnVal = SUCCESS;
	mapIndex = 0;
	map = mapBuffer;
      }
    }
    if(returnVal == SUCCESS){
      call PanTiltController.setTiltPosition(0,0);
      call PanTiltController.setPanPosition(angle, 0);
    }
    return returnVal;
  }

  command result_t ObstacleDetection.setObstacleAlarm(uint8_t dist, uint16_t period){
    result_t returnVal = FAIL;
    atomic{
      if(state == OD_IDLE){
	if(period == 0){ // User wants obstacle distance only once
	  state = OD_ALARM_ONE_TIME;
	  returnVal = SUCCESS;
	}else if(period < MIN_PERIOD ){
	  returnVal = FAIL;
	}else{
	  state = OD_ALARM;
	  minDist = dist;
	  lookupPeriod = period;
	  call Timer.start(TIMER_REPEAT, period);
	  returnVal = SUCCESS;
	}
      }else{
	returnVal = FAIL;
      }
    }
    if(returnVal == SUCCESS){
	  call IRRanger.getDistance();
    }
    return returnVal;
  }

  command result_t ObstacleDetection.turnOffAlarm(){
    result_t returnVal;
    atomic{
      if(state == OD_ALARM){
	call Timer.stop();
	returnVal = SUCCESS;
      }else{
	returnVal = FAIL;
      }
    }
    return returnVal;
  }

  event result_t Timer.fired(){
    //Time to check IR distance.
    call IRRanger.getDistance();
    return SUCCESS;
  }
 
  async event void IRRanger.distance(uint8_t dist){
    atomic distance = dist;
    post handleIRRanger();
    if(state == OD_ALARM){
      call Timer.stop(); 
    }
    return;
  }

  
  event void PanTiltController.panPositionChanged(int8_t position){
    post handlePanPositionChange();
  }

  event void PanTiltController.tiltPositionChanged(int8_t position){
  }
}
