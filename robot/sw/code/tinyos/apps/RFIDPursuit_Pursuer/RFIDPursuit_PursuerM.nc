// $Id: 

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

/* 
 * Evader, Pursuer Game Using a Bed of RFID Tags for Environmental
 * Message Passing and Navigation
 * 
 * @author Jonathan Friedman
 * @author Parixit Aghera
 * @author David Lee
 */

includes M1_RFIDControllerM;

module RFIDPursuit_PursuerM {
  provides {
    interface StdControl;
  }
  uses {
    interface MotionControl;
    interface RFIDController;
    interface ObstacleDetection;
    interface CB2Bus as CB2;
    interface Timer;
    interface Leds; 
  }
}

implementation {

  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // RAGOBOT : RFIDPursuit : VARIABLES AND INCLUDES
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
  //State Information
  uint8_t state;
  enum {
    MOVE_FIND,
    STOP_READ,
    DETERMINE_DIR, 
    TURN, 
    BACKUP, 
    OBSTACLE_DETECTED
  };
  uint8_t x_pos, y_pos;
  uint8_t x_last, y_last;
  uint8_t orientation;
#define NORTH	0x01
#define EAST	0x02
#define SOUTH	0x03
#define WEST	0x04
  int8_t direction;
#define LEFT	-85
#define RIGHT	85
  uint8_t inState;
  int8_t debug_dir;
	
  //CB2
#include "CB2BusM.h"
	
  //Obstacle Avoidance
#define BUFSIZE 8
  uint8_t buf[BUFSIZE];
#define SCAN_SPAN 180
#define SAFE_DIST 30 
#define SAFE_PERIOD 500
  uint8_t goodDist = 10;
  uint8_t numReading;
  uint8_t mapBuf[30];
  int8_t nextDist = 0;
#define OBSTACLE_THRESHOLD	30
#define OBSTACLE_PERIOD		200
	  	
  //Game Board Definitions
#define TOP_EDGE 7
#define LEFT_EDGE 1
#define RIGHT_EDGE 3
#define BOTTOM_EDGE 1
  
  
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // RAGOBOT : RFIDPursuit_Pursuer : APPLICATION HELPER FUNCTIONS
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  //Very Fast Psuedorandom Number Generator
  int8_t getRandom() {
    //get low 2 bits of OS counter [0,3] and align to [-1,2] scale
    return ((int8_t)(TCNT0 & 0x03))-1; 
  }
	
  //Check for WAIT before calling this function
  //Valid directions are LEFT, FORWARD, RIGHT
  int8_t predOrientation(int8_t orientation2, int8_t direction2){
    orientation2 = orientation2 + direction2;
    if (orientation2 > WEST) orientation2 = NORTH;
    if (orientation2 < NORTH) orientation2 = WEST;
    return orientation2;
  }
	
  //pass in x,y by reference
  void testMove(int8_t post_move_orientation, uint8_t* x, uint8_t* y){
    switch(post_move_orientation){
    case NORTH:
      y++;	
      break;
    case SOUTH:
      y--;
      break;
    case EAST:
      x++;
      break;
    case WEST:
      x--;
      break;
    }
  }

  //Return TRUE if x,y is on the board
  //Return FALSE is x,y is out of bounds
  uint8_t inBounds(uint8_t x, uint8_t y){
    if (x > RIGHT_EDGE) return FALSE;
    if (x < LEFT_EDGE) return FALSE;
    if (y > TOP_EDGE) return FALSE;
    if (y < BOTTOM_EDGE) return FALSE;
    return TRUE;
  }

  //orientation = current orientation (exposed)
  //direction (exposed)
  //x_pos, y_pos, x_last, y_last (exposed)
  task void nextPosition(){
    state = TURN;
    call CB2.barPercent(4); 
    switch (orientation) {
    case NORTH:
      if (buf[0] == NORTH) {
	call MotionControl.move(20);	
      }
      else if (buf[0] == EAST) {
	call MotionControl.turnRobot(RIGHT);
      }
      else if (buf[0] == SOUTH) {
	call MotionControl.turnRobot(RIGHT+RIGHT);
      }
      else if (buf[0] == WEST) {
	call MotionControl.turnRobot(LEFT);
      }
      else {
	call MotionControl.move(20);
      }
      break;
    case EAST:
      if (buf[0] == NORTH) {
	call MotionControl.turnRobot(LEFT);
      }
      else if (buf[0] == EAST) {
	call MotionControl.move(20);
      }
      else if (buf[0] == SOUTH) {
	call MotionControl.turnRobot(RIGHT);
      }
      else if (buf[0] == WEST) {
	call MotionControl.turnRobot(LEFT+LEFT);
      }
      else {
	call MotionControl.move(20);
      }
      break;
    case SOUTH:
      if (buf[0] == NORTH) {
	call MotionControl.turnRobot(LEFT+LEFT);	
      }
      else if (buf[0] == EAST) {
	call MotionControl.turnRobot(LEFT);
      }
      else if (buf[0] == SOUTH) {
	call MotionControl.move(20);
      }
      else if (buf[0] == WEST) {
	call MotionControl.turnRobot(RIGHT);
      }
      else {
	call MotionControl.move(20);
      }
      break;
    case WEST:
      if (buf[0] == NORTH) {
	call MotionControl.turnRobot(RIGHT);
      }
      else if (buf[0] == EAST) {
	call MotionControl.turnRobot(RIGHT+RIGHT);
      }
      else if (buf[0] == SOUTH) {
	call MotionControl.turnRobot(LEFT);
      }
      else if (buf[0] == WEST) {
	call MotionControl.move(20);
      }
      else {
	call MotionControl.move(20);
      }
      break;
    default:
      call MotionControl.move(20);
      break;
    }
    orientation = buf[0];
  }//nextPosition
		
	
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // RAGOBOT : RFIDPursuit_Pursuer : STANDARD CONTROL
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  command result_t StdControl.init() {
    debug_dir = LEFT;
    inState = FALSE;
    state = MOVE_FIND;
    x_pos = 1;
    y_pos = 1;
    x_last = 1;
    y_last = 1;
    orientation = NORTH;
    call MotionControl.init();
    call RFIDController.init();
    call CB2.init();
    call  Leds.init();
    return SUCCESS;
  }

  command result_t StdControl.start() {
    call Timer.start(TIMER_REPEAT, 400);
    call ObstacleDetection.setObstacleAlarm(OBSTACLE_THRESHOLD, OBSTACLE_PERIOD);
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    call Timer.stop();
    return SUCCESS;
  }



  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // RAGOBOT : RFIDPursuit_Pursuer : MOTION CONTROL
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  task void move(){
    call MotionControl.move(80);
    return;
  }
  task void abortMove(){
    call MotionControl.abortMove();
    return;
  }
  
  event result_t MotionControl.turnDone(){
    state = MOVE_FIND;
    call ObstacleDetection.setObstacleAlarm(OBSTACLE_THRESHOLD, OBSTACLE_PERIOD);
    return SUCCESS;
  }
 
  event result_t MotionControl.moveDone(){
    if (state == BACKUP) {
      state = STOP_READ;
    }
    else if (state == TURN) {
      state = MOVE_FIND;
    }
    else {
      call MotionControl.move(80);
    }
    return SUCCESS;
  }
 
  event result_t MotionControl.abortDone()
    {
      call RFIDController.readTag(0, buf, 8);
      return SUCCESS;
    }

  
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // RAGOBOT : RFIDPursuit_Pursuer : RFID INTERFACE
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  event result_t RFIDController.findTagsDone(uint8_t numTagsFound) {
    if (numTagsFound > 0) {
      post abortMove();
      state = STOP_READ;
      call CB2.decklight6(TOGGLE); 
    }
    else {
      call CB2.decklight3(TOGGLE);
    }
    return SUCCESS;
  }
  
  event result_t RFIDController.readTagDone(uint8_t numBytesRead) {
    if (numBytesRead > 0) {
      call Leds.redToggle();
      state = DETERMINE_DIR;
      post nextPosition();
    }
    else {
      call MotionControl.move(-1);
      state = BACKUP;
      call Leds.greenToggle(); 
    }
    return SUCCESS;
  }

  event result_t RFIDController.writeTagDone(bool isWriteSuccess) {
    return SUCCESS;
  }

 	
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // RAGOBOT : RFIDPursuit_Pursuer : OBSTACLE AVOIDANCE
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  	
  task void handleAbort(){
    call ObstacleDetection.getObstacleMap(10, mapBuf);
  }

  task void processMap(){
    uint8_t i;
    uint8_t angleInc = SCAN_SPAN/numReading;
    int8_t dir = 0;
    result_t temp;
    for(i=1; i < numReading-1; i++){
      if(mapBuf[i] >= goodDist && mapBuf[i-1] >= goodDist 
	 && mapBuf[i+1] >= goodDist){
	dir = i*angleInc - SCAN_SPAN/2;
	nextDist = mapBuf[i];
	break;
      }
    }
    if(dir != 0){
      call MotionControl.turnRobot(dir);
    }
  }
    
  event void ObstacleDetection.obstacleMapReady(uint8_t dataPoint, uint8_t *mapBuffer){
    numReading = dataPoint;
    post processMap();
  }
	
  task void generateMap(){
    call ObstacleDetection.getObstacleMap(5, mapBuf);
  }
	
  event void ObstacleDetection.obstacleAlarm(){
    atomic { state = OBSTACLE_DETECTED; }
    post abortMove();
    post generateMap();
    return;
  }


  
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // RAGOBOT : RFIDPursuit_Pursuer : STATE MACHINE (MAIN PROGRAM)
  //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 	
  event result_t Timer.fired() {
    switch(state){
    case MOVE_FIND:
      if (inState == FALSE){
	inState = TRUE;
	//	call CB2.barPercent(1);
	call MotionControl.move(80);
	//post move();
	call RFIDController.findTags(1);
	inState = FALSE;
      }
      break;
    case STOP_READ:
      if (inState == FALSE){
	inState = TRUE;
	//	call CB2.barPercent(2);
	call RFIDController.readTag(0, buf, BUFSIZE);
	inState = FALSE;
      }
      break;
    case DETERMINE_DIR:
      if (inState == FALSE){
	inState = TRUE;
	//call CB2.barPercent(4); 
	//post nextPosition();
	inState = FALSE;
      }
      break;
    case TURN:
      if (inState == FALSE){
	inState = TRUE;
	//	call CB2.barPercent(5);
	//CODE FOR STATE GOES HERE
	inState = FALSE;
      }
      break;
    case BACKUP:
      if (inState == FALSE){
	inState = TRUE;
	//	call CB2.barPercent(6);
	inState = FALSE;
      }
      break;
    case OBSTACLE_DETECTED:
      inState == TRUE;
      //  call CB2.barPercent(7);
      inState = FALSE;
      break;
    default:
      //  call CB2.barPercent(9);
      post abortMove();
    }
    return SUCCESS;
  }

}//implementation
