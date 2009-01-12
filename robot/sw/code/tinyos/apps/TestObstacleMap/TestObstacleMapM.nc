// $Id: TestObstacleMapM.nc,v 1.1 2004/05/24 08:24:02 parixit Exp $
// $Log: TestObstacleMapM.nc,v $
// Revision 1.1  2004/05/24 08:24:02  parixit
// Created. Workinng Version.
//
// Revision 1.4  2004/03/24 09:23:23  parixit
// Demo Version, Ignore previous version.
//
// Revision 1.2  2004/03/16 07:52:44  parixit
// Added motion control
//
// Revision 1.1  2004/03/15 09:33:05  parixit
//  First Version Created.
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
  * Implimentation of TestObstacleMap application.
  *
  * @author Parixit Aghera (parixit@ee.ucla.edu)
  **/ 

module TestObstacleMapM {
  provides interface StdControl;

  uses{
    interface ObstacleDetection;
    interface Leds;
    interface Timer;
    interface SendMsg;
  }
}

implementation {
  /**
   * Handles Obstacle Alarms. 
   */

#define SCAN_SPAN 180
#define SAFE_DIST 30 
#define SAFE_PERIOD 500
  uint8_t goodDist = 10;
  uint8_t numReading;
  uint8_t mapBuf[30];
  int8_t nextDist = 0;
  TOS_Msg msg;

  task void handleAbort()
  {
    call ObstacleDetection.getObstacleMap(10, mapBuf);
  }

  task void processMap(){
    uint8_t i;
    for(i=1; i < numReading-1; i++){
      msg.data[i] = mapBuf[i];
    }
    if(numReading == 0){
      call SendMsg.send(TOS_BCAST_ADDR, 1, &msg);
      call Leds.redToggle();
    }else{
      call 
	SendMsg.send(TOS_BCAST_ADDR, numReading, &msg);
      call Leds.greenToggle();
    }
    call ObstacleDetection.setObstacleAlarm(30, 100);
  }
  /**
   * Initializes all hardware and s/w components.
   *
   * @return Returns <code>SUCCESS</code> if hardware and s/w components 
   * are initialized, <code>FAIL</code> otherwise. 
   */
  command result_t  StdControl.init(){
    call Leds.init();
    return SUCCESS;
  }

  /**
   * Starts exploration.
   *
   * @return Returns <code>SUCCESS</code> if exploration starts without any problem,
   *  <code>FAIL</code> otherwise. 
   */
  command result_t StdControl.start(){
    call Leds.redOff();
    call Leds.greenOff();
    call Leds.yellowOff();
    //  call Timer.start(TIMER_REPEAT,20000);
    call ObstacleDetection.setObstacleAlarm(30, 100);
    return SUCCESS;
  }

  /**
   * Stops Exploration.
   *
   * @return Returns <code>SUCCESS</code> if exploration starts without any problem,
   *  <code>FAIL</code> otherwise. 
   */
  command result_t StdControl.stop(){
    return SUCCESS;
  }
  event void ObstacleDetection.obstacleMapReady(uint8_t dataPoint, uint8_t *mapBuffer){
    numReading = dataPoint;
    post processMap();
  }
  task void generateMap(){
    call ObstacleDetection.getObstacleMap(5, mapBuf);
  }
  event void ObstacleDetection.obstacleAlarm(){
    post generateMap();
    return;
  }
  event result_t Timer.fired(){
    call Leds.yellowToggle();
    call ObstacleDetection.getObstacleMap(5, mapBuf);
    return SUCCESS;
  }

  event result_t SendMsg.sendDone (TOS_MsgPtr tmsg, result_t success) {
    return SUCCESS;
  }

}
