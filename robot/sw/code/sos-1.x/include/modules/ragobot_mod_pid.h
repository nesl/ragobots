/**
 * @file ragobot_mod_pid.h
 * @brief PID definition for application modules
 * @author Ram Kumar {ram@ee.ucla.edu}
 * @author David Lee
 * 
 */

#ifndef _RAGOBOT_MOD_PID_H
#define _RAGOBOT_MOD_PID_H

// A central place to register all the Ragobot specific driver module IDs
// The module IDs should be assigned relative to DEV_MOD_MIN_PID
// For example
// #define MAG_SENSOR_PID (DEV_MOD_MIN_PID + 2)
#define RAGOBOT_MOD_MIN_PID 	APP_MOD_MIN_PID + 64

enum {
  
  RAGOBOT_CB2BUS_HARDWARE_PID = (RAGOBOT_MOD_MIN_PID + 0),
  
  RAGOBOT_MAG_SENSOR_PID  = (RAGOBOT_MOD_MIN_PID + 1),
  
  RAGOBOT_COMPASS_PID  = 	(RAGOBOT_MOD_MIN_PID + 2),
  
  RAGOBOT_CB2BUS_PID =      (RAGOBOT_MOD_MIN_PID + 3),

  RAGOBOT_INERTIALSENSOR_PID =  (RAGOBOT_MOD_MIN_PID + 4),
  
  RAGOBOT_BATTERY_MONITOR_PID = (RAGOBOT_MOD_MIN_PID + 5),

  RAGOBOT_ONE_WIRE_PID = (RAGOBOT_MOD_MIN_PID + 6),
  
  RAGOBOT_LIGHTSHOW_PID = (RAGOBOT_MOD_MIN_PID + 7),

  RAGOBOT_MCONTROL_PID =  (RAGOBOT_MOD_MIN_PID + 8),
  
  RAGOBOT_IRRANGER_PID =  (RAGOBOT_MOD_MIN_PID + 9),

  RAGOBOT_UART_PID     =  (RAGOBOT_MOD_MIN_PID + 10),
  
  RAGOBOT_RFID_PID     =  (RAGOBOT_MOD_MIN_PID + 12), 

  RAGOBOT_PUSHBUTTON_PID = (RAGOBOT_MOD_MIN_PID + 13),
  
  RAGOBOT_SERVOS_PID = (RAGOBOT_MOD_MIN_PID + 14),
  
  RAGOBOT_HIPRI_INT_PID = (RAGOBOT_MOD_MIN_PID + 15)
};

#endif

