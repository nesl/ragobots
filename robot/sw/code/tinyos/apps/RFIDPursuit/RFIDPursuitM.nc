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
 * @author David Lee
 * @author Parixit Aghera
 */

includes M1_RFIDControllerM;

module RFIDPursuitM {
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
			    WRITE_HINT, 
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
			#define LEFT	-1
			#define FORWARD	0
			#define RIGHT	1
			#define WAIT	2
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
		#define OBSTACLE_PERIOD		400
		uint8_t avoiding = FALSE;
	  
	//LED Light Show
		uint8_t LEDj = 0;
		uint8_t LEDlength = 0;
		uint8_t LEDrunning = FALSE;
		#define LEDSHOWSTOP 2
		
	//Game Board Definitions
		#define TOP_EDGE 7
		#define LEFT_EDGE 1
		#define RIGHT_EDGE 3
		#define BOTTOM_EDGE 1
  
  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : RFIDPursuit : APPLICATION HELPER FUNCTIONS
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
		//Allocate memory
			int8_t rndmGuess;
			int8_t rndmOrient;
		
		//Save Current Position as last valid, since we are about to move from here
			x_last = x_pos;
			y_last = y_pos;
			
		rndmGuess = getRandom();
		/*
		while(1){
			if (rndmGuess != WAIT){
				rndmOrient = predOrientation((int8_t)orientation, rndmGuess);
				testMove(rndmOrient, &x_pos, &y_pos);
				if (inBounds(x_pos, y_pos) == TRUE){
					//FOUND A GOOD NEW CONDITION!!!
					orientation = rndmOrient;	
					direction = rndmGuess;
					if(direction == LEFT)
						call CB2.headlightON(BACK_RIGHT, RED);
					else if(direction == FORWARD)
						call CB2.headlightON(BACK_RIGHT, GREEN);
					else if(direction == RIGHT)
						call CB2.headlightON(BACK_RIGHT, ORANGE);
						
					state = WRITE_HINT;
					return;
				}			
				else {
					//Reset and try again?
					x_pos = x_last;
					y_pos = y_last;
					rndmGuess++;
					if (rndmGuess >= WAIT) rndmGuess = LEFT;
				}
			}
			else {
				direction = WAIT;
				return; //WAIT direction
			}
		}//while 
		*/
		debug_dir++;
		if (debug_dir == WAIT) debug_dir = LEFT;
		direction = debug_dir;
		state = WRITE_HINT;
	}//nextPosition
	
	void ledLightShowStart(){
		LEDrunning = TRUE;
		LEDj = 0;
		LEDlength = 0;	
	}
	
	void ledLightShow(){
		if (LEDrunning == TRUE){
			LEDlength++;
			if (LEDlength == LEDSHOWSTOP) {
				//Test Headlights    
			    call CB2.headlightOFF(FRONT_LEFT);
			    call CB2.headlightOFF(FRONT_RIGHT);
			    call CB2.headlightOFF(BACK_LEFT);
			    call CB2.headlightOFF(BACK_RIGHT);
				//Test Deck Lights    
			    call CB2.decklight1(OFF);
			    call CB2.decklight2(OFF);
			    call CB2.decklight3(OFF);
			    call CB2.decklight4(OFF);
			    call CB2.decklight5(OFF);
			    call CB2.decklight6(OFF);
			    call CB2.decklight7(OFF);
			    call CB2.decklight8(OFF);
				//Test Spotlight    
		    	call CB2.spotlight(OFF);
				LEDrunning = FALSE;
				return;	
			}
			//Test Headlights    
			    call CB2.headlightON(FRONT_LEFT, LEDj);
			    call CB2.headlightON(FRONT_RIGHT, LEDj);
			    call CB2.headlightON(BACK_LEFT, LEDj);
			    call CB2.headlightON(BACK_RIGHT, LEDj++);
			    if (LEDj == 4) LEDj = 0;
			//Test Deck Lights    
			    call CB2.decklight1(TOGGLE);
			    call CB2.decklight2(TOGGLE);
			    call CB2.decklight3(TOGGLE);
			    call CB2.decklight4(TOGGLE);
			    call CB2.decklight5(TOGGLE);
			    call CB2.decklight6(TOGGLE);
			    call CB2.decklight7(TOGGLE);
			    call CB2.decklight8(TOGGLE);
			//Test Spotlight    
		    	call CB2.spotlight(TOGGLE);
	   }//if
	}	
    
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : RFIDPursuit : STANDARD CONTROL
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
	    call CB2.init();
	    call  Leds.init();
	    return SUCCESS;
	}

 	command result_t StdControl.start() {
	    call Timer.start(TIMER_REPEAT, 400);
	    //call MotionControl.move(80);
	    call ObstacleDetection.setObstacleAlarm(OBSTACLE_THRESHOLD, OBSTACLE_PERIOD);
	    return SUCCESS;
	}

	command result_t StdControl.stop() {
	    call Timer.stop();
	    return SUCCESS;
	}



//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : RFIDPursuit : MOTION CONTROL
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
	  	call CB2.headlightON(FRONT_RIGHT, RED);
		if (avoiding == FALSE)
   			state = MOVE_FIND;
   		else {
	   		//Obstacle Avoidance
	   		call CB2.headlightON(FRONT_RIGHT, GREEN);
	   		avoiding = FALSE;
	   		state = MOVE_FIND;
	   		inState = FALSE;
	    	call ObstacleDetection.setObstacleAlarm(OBSTACLE_THRESHOLD, OBSTACLE_PERIOD);
   		}
   return SUCCESS;
 }
 
 event result_t MotionControl.moveDone(){
	if (state == BACKUP) {
		state = STOP_READ;
	}
	else {
   	  call MotionControl.move(80);
	}
   return SUCCESS;
 }
 
 event result_t MotionControl.abortDone()
  {
  	call CB2.headlightON(BACK_LEFT, GREEN);
	if (avoiding == TRUE){
		call CB2.decklight4(TOGGLE);
	  	call MotionControl.turnRobot(30);
  	}
	else
    	call RFIDController.readTag(0, buf, 8);
    return SUCCESS;
  }

  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : RFIDPursuit : RFID INTERFACE
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
	     //call Leds.redToggle();
	     call CB2.barPercent(buf[0]);
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
		if (isWriteSuccess) {
			call CB2.decklight1(ON);
		}
		if (direction == LEFT) {
			call CB2.headlightON(FRONT_RIGHT, RED);
			state = TURN;
			call MotionControl.turnRobot(80);
		}
		else if (direction == RIGHT) {
			call CB2.headlightON(FRONT_RIGHT, ORANGE);
			state = TURN;
			call MotionControl.turnRobot(-80);
		}
		else {
			state = MOVE_FIND;
			call CB2.headlightON(FRONT_RIGHT, GREEN);
		}  
   		return SUCCESS;
 	}

 	
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : RFIDPursuit : OBSTACLE AVOIDANCE
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  	
	task void handleAbort(){
		//call ObstacleDetection.getObstacleMap(10, mapBuf);
	}

	task void processMap(){

	}
    
	event void ObstacleDetection.obstacleMapReady(uint8_t dataPoint, uint8_t *mapBuffer){
	    numReading = dataPoint;
	    post processMap();
	}
	
	task void generateMap(){
	    call ObstacleDetection.getObstacleMap(1, mapBuf);
	}
	
	event void ObstacleDetection.obstacleAlarm(){
		avoiding = TRUE;
		state = OBSTACLE_DETECTED;
		inState = FALSE;
		//ledLightShowStart();
		call MotionControl.abortMove();
		//post generateMap();
	    return;
	}


  
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// RAGOBOT : RFIDPursuit : STATE MACHINE (MAIN PROGRAM)
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 	
	event result_t Timer.fired() {
		call CB2.barPercent(state);
		ledLightShow();
		
		//DEBUG
				if(direction == LEFT)
					call CB2.headlightON(BACK_LEFT, RED);
				else if(direction == FORWARD)
					call CB2.headlightON(BACK_LEFT, GREEN);
				else if(direction == RIGHT)
					call CB2.headlightON(BACK_LEFT, ORANGE);
	  	switch(state){
	    case MOVE_FIND:
	    	if (inState == FALSE){
		    	inState = TRUE;
		    		//call CB2.barPercent(1);
	   			    call MotionControl.move(40);
			    	//post move();
			    	call RFIDController.findTags(1);
		      	inState = FALSE;
	      	}
	      	break;
		case STOP_READ:
			if (inState == FALSE){
				inState = TRUE;
					//call CB2.barPercent(2);
					call RFIDController.readTag(0, buf, BUFSIZE);
				inState = FALSE;
			}
			break;
		case DETERMINE_DIR:
			if (inState == FALSE){
				inState = TRUE;
					//call CB2.barPercent(3); 
			    	post nextPosition();
			    inState = FALSE;
		    }
	    	break;
		case WRITE_HINT:
			if (inState == FALSE){
				inState = TRUE;
					//call CB2.barPercent(4);
					if (buf[0] >= 0x0A) {
					 	buf[0] = 0x00;  
				 	}
				 	else {
					  buf[0] = buf[0] + 1;  
				 	} 
					call RFIDController.writeTag(0, buf, BUFSIZE);
				inState = FALSE;
			}
			break;
		case TURN:
			if (inState == FALSE){
				inState = TRUE;
				//call CB2.barPercent(5);
				//CODE FOR STATE GOES HERE
				inState = FALSE;
			}
			break;
		case BACKUP:
			if (inState == FALSE){
				inState = TRUE;
				//call CB2.barPercent(6);
				inState = FALSE;
			}
			break;
		case OBSTACLE_DETECTED:	
			if (inState == FALSE){
				inState = TRUE;
				//call CB2.barPercent(7);
				inState = FALSE;
			}
	    default:
	    	//call CB2.barPercent(9);
	     	post abortMove();
	    }
	    return SUCCESS;
	}

}//implementation
