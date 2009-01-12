/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4: */
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
/** 
 * @brief Header file for Ragobot specific modules
 * 
 * This is the only file that module writer for Ragobot should include.
 *
 */

#ifndef _RAGOBOT_MODULE_H_
#define _RAGOBOT_MODULE_H_

#include <ragobot_message_types.h>
//#include <pushbutton.h>
#include <modules/ragobot_mod_pid.h>
#include <modules/cb2bus.h>
//#include <uart_ragobot.h>

#include <module.h>

/**
 * Register module to receive message when pushbutton is pressed
 */
typedef int8_t (*ker_pushbutton_register_t)(uint8_t pid);
static inline int8_t ker_pushbutton_register(uint8_t pid) {
  ker_pushbutton_register_t func = (ker_pushbutton_register_t)pgm_read_word(0x8c+128+0);
  return func(pid);
}

/**
 * Unregister module to receive message when pushbutton is pressed
 */
static inline int8_t ker_pushbutton_deregister(uint8_t pid) {
  ker_pushbutton_register_t func = (ker_pushbutton_register_t)pgm_read_word(0x8c+128+2);
  return func(pid);
}

/**
 * Load cb2bus with configuration bytes in vport
 */
typedef void (*ker_cb2bus_load_t)(uint8_t vport[], uint8_t size);
static inline void ker_cb2bus_load(uint8_t vport[], uint8_t size) {
  ker_cb2bus_load_t func = (ker_cb2bus_load_t)pgm_read_word(0x8c+128+4);
  return func(vport, size);
}

/**
 * Set the position of a servo
 */
typedef int8_t (*ker_servo_set_position_t)(uint8_t motor_id, int8_t position);
static inline int8_t ker_servo_set_position(uint8_t motor_id, int8_t position){
  ker_servo_set_position_t func = (ker_servo_set_position_t)pgm_read_word(0x8c+128+6);
  return func(motor_id, position);
}

/**
 * Register module to receive message when a HIPRI_INT interrupts is received
 */
typedef int8_t (*ker_hipri_register_t)(uint8_t pid);
static inline int8_t ker_hipri_int_register(uint8_t pid) {
  ker_hipri_register_t func = (ker_hipri_register_t)pgm_read_word(0x8c+128+8);
  return func(pid);
}

/**
 * Unregister module to receive message when a HIPRI_INT interrupt is received
 */
static inline int8_t ker_hipri_int_deregister(uint8_t pid) {
  ker_hipri_register_t func = (ker_hipri_register_t)pgm_read_word(0x8c+128+10);
  return func(pid);
}

/**
 * Write a packet on the one-wire bus and no read afterwards
 */
typedef int8_t (*ker_one_wire_write_t)(uint8_t pid, uint8_t* data, uint8_t size);
static inline int8_t ker_one_wire_write(uint8_t pid, uint8_t* data, uint8_t size) {
  ker_one_wire_write_t func = (ker_one_wire_write_t)pgm_read_word(0x8c+128+12);
  return func(pid, data, size);
}

/**
 * Write a packet on the one-wire bus with a read afterwards
 */
typedef int8_t (*ker_one_wire_read_t)(uint8_t pid, uint8_t* write_data, uint8_t write_size, uint8_t read_size);
static inline int8_t ker_one_wire_read(uint8_t pid, uint8_t* write_data, uint8_t write_size, uint8_t read_size) {
  ker_one_wire_read_t func = (ker_one_wire_read_t)pgm_read_word(0x8c+128+14);
  return func(pid, write_data, write_size, read_size);
}

/**
 * Request for distance from IR Ranger
 */
static inline int8_t ker_irranger_trigger(uint8_t pid) {
	ker_hipri_register_t func = (ker_hipri_register_t)pgm_read_word(0x8c+128+16);
	return func(pid);
}

/**
 * Write a packet on the serial ports
 */
typedef int8_t (*ker_serial_write_t)(uint8_t pid, uint8_t port, uint8_t *data, uint8_t len, uint8_t flag);
static inline int8_t ker_serial_write(uint8_t pid, uint8_t port, uint8_t *data, uint8_t len, uint8_t flag) {
  ker_serial_write_t func = (ker_serial_write_t)pgm_read_word(0x8c+128+18);
  return func(pid, port, data, len, flag);
}

/**
 * Read a packet on the serial ports
 */
typedef int8_t (*ker_serial_read_t)(uint8_t pid, uint8_t port, uint8_t len);
static inline int8_t ker_serial_read(uint8_t pid, uint8_t port, uint8_t len) {
  ker_serial_read_t func = (ker_serial_read_t)pgm_read_word(0x8c+128+20);
  return func(pid, port, len);
}
#endif
