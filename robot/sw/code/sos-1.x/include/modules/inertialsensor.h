/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */
/*
 * Copyright (c) 2003 The Regents of the University of California.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above
 *    copyright notice, this list of conditions and the following
 *    disclaimer in the documentation and/or other materials provided
 *    with the distribution.
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgement:
 *       This product includes software developed by Networked &
 *       Embedded Systems Lab at UCLA
 * 4. Neither the name of the University nor that of the Laboratory
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */


//-----------------------------------------------------------------------------
// MESSAGE DEFINITIONS
//-----------------------------------------------------------------------------
enum {
  //Get Accelerometer Readings
  MSG_GET_ACC_READINGS = (MOD_MSG_START+0),
  MSG_GET_MAG_READINGS = (MOD_MSG_START+1),
  MSG_GET_INERTIAL_READINGS = (MOD_MSG_START+2),

  MSG_GET_ACC_READINGS_DONE = (MOD_MSG_START+7),
  MSG_GET_MAG_READINGS_DONE = (MOD_MSG_START+8), 
  MSG_GET_INERTIAL_READINGS_DONE = (MOD_MSG_START+9), 

  MSG_GET_ACC_READINGS_FAIL = (MOD_MSG_START+13),
  MSG_GET_MAG_READINGS_FAIL = (MOD_MSG_START+14), 
  MSG_GET_INERTIAL_READINGS_FAIL = (MOD_MSG_START+15), 
  
};


#define ACCSENSOR_ENABLE() post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_INERTIALSENSOR_PID, MSG_ACC_EN, ENABLE, 0, 0); post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_INERTIALSENSOR_PID, MSG_LOAD, 0, 0, 0) 
#define ACCSENSOR_DISABLE() post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_INERTIALSENSOR_PID, MSG_ACC_EN, DISABLE, 0, 0); post_short(RAGOBOT_CB2BUS_PID, s->pid, RAGOBOT_INERTIALSENSOR_PID, 0, 0, 0)

#define MAGSENSOR_ENABLE() post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_INERTIALSENSOR_PID, MSG_MAG_EN, ENABLE, 0, 0); post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_INERTIALSENSOR_PID, MSG_LOAD, 0, 0, 0) 
#define MAGSENSOR_DISABLE() post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_INERTIALSENSOR_PID, MSG_MAG_EN, DISABLE, 0, 0); post_short(RAGOBOT_CB2BUS_PID, s->pid, RAGOBOT_INERTIALSENSOR_PID, 0, 0, 0)

#define MAGSENSOR_RESET() post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_INERTIALSENSOR_PID, MSG_MAG_RESET, 0, 0, 0); post_short(RAGOBOT_CB2BUS_PID, RAGOBOT_INERTIALSENSOR_PID, MSG_LOAD, 0, 0, 0) 

#ifndef _MODULE_
mod_header_ptr inertialsensor_get_header();
#endif
