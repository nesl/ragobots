//$id: $
// $Log: NavigationM.nc,v $
// Revision 1.10  2004/10/23 22:16:22  parixit
// Cleaned up the state machines and modified the interfaces to avoid un-neccessary return values.
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
 * Implements Navigation.
 *
 * @author Anitha Vijayakumar avijayak@ee.ucla.edu
 * @author Parixit Aghera parixit@ee.ucla.edu
 *
 **/ 

includes Localization;
module NavigationM{
  provides{
    interface Navigation;
  }
  uses{
    interface Localization;
    interface ObstacleDetection;
    interface MotionControl;
    interface Leds;
    interface Timer ;
    interface Orient;
  }
}

implementation{
#define PROXIMITY 30
#define OPEN_DIST   40
#define INCR_DIST   30
#define MAP_RESOLUTION 10
#define SCAN_SPAN 180
#define MAP_ENTRIES SCAN_SPAN/MAP_RESOLUTION 
#define INCR_ANGLE  SCAN_SPAN/MAP_ENTRIES
#define SAFE_DIST 30
#define SAFE_PERIOD 1000

  typedef enum{
    IDLE,
      NAVIGATING,
      ORIENTING,
      MOVING,
      OBS_DETECT,
      OBS_AVOID,
      ABORT
      }NAV_STATE;
  
  uint8_t state;
  uint16_t move_distance,dest_x,dest_y,obs_x,obs_y;
  uint8_t map[MAP_ENTRIES];
  float oAngle;
  TOS_Msg debugMsg;
  LocalizationInfo location;

  result_t checkAfterMove();

  command result_t Navigation.init() {
    atomic state = IDLE;
    dest_x =0;
    dest_y =0;
    obs_x =0;

    call MotionControl.init();
    return SUCCESS;
  }

  void moveToLocation(uint16_t x,uint16_t y)
    {
      if(state == NAVIGATING || state == MOVING){
	int32_t d_x ;
	int32_t d_y ;
	float hyp;
	uint16_t dist;

	d_x = (int16_t)x - (int16_t)location.x;
	d_y = (int16_t)y - (int16_t)location.y; 
	hyp = sqrt((float) (d_x * d_x + d_y*d_y));
	hyp = abs(hyp);
	dist =(uint16_t) (hyp/5);

	if(dist < INCR_DIST)
	  move_distance = dist;
	else
	  move_distance = INCR_DIST;

	if(abs(d_x) < abs(d_y))
	  {
	    oAngle = asin((float) d_y/hyp);
	    oAngle = oAngle * (180/3.14);
	    if(x < location.x)
	      oAngle = 180 - oAngle;
	    if(oAngle < 0)
	      oAngle = 360 + oAngle;
	  }
	else
	  {
	    oAngle = acos((float) d_x/hyp);
	    oAngle = oAngle * (180/3.14);
	    if(y<location.y)
	      oAngle = 360 - oAngle;
	  }

/* 	if(state == IDLE) */
/* 	  { */
/* 	    atomic state = DEST_MOVE; */
/* 	  } */
/* 	else if(state == OBS_AVOID) */
/* 	  { */
/* 	    obs_x = x; */
/* 	    obs_y = y; */
/* 	  } */
	state = ORIENTING;
	call Orient.orient((uint16_t ) oAngle);
      }
      return;
    }

  task void handleGotLocalization(){
    if(state == NAVIGATING){
      moveToLocation(dest_x,dest_y);
    }else if(state == MOVING){
      checkAfterMove();
    }
    return;
  }


  task void handleMoveDone(){
    if(state == MOVING){
      call Timer.start(TIMER_ONE_SHOT,700);
    }
    return;
  }

  result_t checkAfterMove(){
    if(state == MOVING){
      if((abs(location.x -dest_x) < PROXIMITY) && 
	 (abs(location.y - dest_y) < PROXIMITY))
	{
	  atomic state = IDLE;
	  call ObstacleDetection.turnOffAlarm();
	  signal Navigation.moveDone(location.x, location.y);
	  return SUCCESS; 
	} else{
	  moveToLocation(dest_x,dest_y);
	}
/*       if(state == OBS_AVOID) */
/* 	{ */
/* 	  if((location.x == obs_x) && (location.y == obs_y)) */
/* 	    { */
/* 	      atomic state = DEST_MOVE; */
/* 	      obs_x = obs_y = 0; */
/* 	      moveToLocation(dest_x,dest_y); */
/* 	    } */
/* 	  else */
/* 	    moveToLocation(obs_x,obs_y); */
/* 	} */
    }
    return SUCCESS;
  }

 
  /*Orient state */ 
  command result_t  Navigation.moveTo(uint16_t x, uint16_t y){
    if(state == IDLE){ 
      dest_x = x;
      dest_y = y;
      state = IDLE;
      state = NAVIGATING;
      call Localization.getLocation();
      return SUCCESS;   
    }else {
      return FAIL;
    } 
  }

  command void Navigation.abort(){
    if(state == MOVING){
      call ObstacleDetection.turnOffAlarm();
      call MotionControl.abortMove();
    }else if(state == ORIENTING){
      call Orient.abort();
    }
    state = IDLE;
  }

    task void handleOriented(){
      if(state == ORIENTING){
	state = MOVING;
	call ObstacleDetection.setObstacleAlarm(SAFE_DIST, SAFE_PERIOD);
	call MotionControl.move((int8_t)move_distance);
      }
      return;
    }

    task void handleOrientFailed(){
      if(state == ORIENTING){
	call Orient.orient((uint16_t ) oAngle);
      }
      return;
    }

    task void handleObstacleAlarm(){
      if(state == OBS_DETECT){
	call ObstacleDetection.getObstacleMap(MAP_RESOLUTION,(uint8_t*)map);
      }
    }
    task void processMap()
      {
	uint8_t i ;
	uint16_t distance=0,angle;
	float x,y;
     
	for(i=0;i<MAP_ENTRIES;i++)
	  {
	    if(map[i] > OPEN_DIST)
	      {
		distance = map[i];
		break;
	      }
	  }  

	if(distance == 0)
	  {
	    /*Handle this case where there is no open
	      distance  maybe C shaped obstacle */
	    return;
	  }

	angle = i * MAP_RESOLUTION -SCAN_SPAN/2;
     
	x = cos(angle) * distance;
	y = sin(angle) * distance;

	call Leds.greenToggle();

	atomic state = OBS_AVOID;

	moveToLocation((uint16_t)x,(uint16_t)y);
      }

    event void ObstacleDetection.obstacleMapReady(uint8_t dataPoint, uint8_t *mapBuffer){
      post processMap();
    }

    event void ObstacleDetection.obstacleAlarm(){
      if(state == MOVING){
	call MotionControl.abortMove();
	call Orient.abort();
	post handleObstacleAlarm();
      }
    }

    event result_t Timer.fired(){
      call Localization.getLocation();
      return SUCCESS;
    }

    event void MotionControl.turnDone(){
      return;
    }

    event void MotionControl.moveDone(){
      post handleMoveDone();
      return;
    }

    event void Orient.oriented(uint16_t dir){
      post handleOriented();
      return;
    }

    event void Orient.orientFailed(uint16_t dir){
      post handleOrientFailed();
      return;
    }

    event void Localization.location(LocalizationInfo *l){
      location.id = l->id;
      location.x = l->x;
      location.y = l->y;
      location.o = l->o;
      post handleGotLocalization();
      return;
    }
  }
