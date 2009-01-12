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

#ifndef DUALMOTORCONTROL_H
#define DUALMOTORCONTROL_H

#define NUM_MOTORS_SUPPORTED 2
#define MAX_SPEED 0x7F
#define MTR_CTR_START_BYTE 0x80
#define MTR_CTR_DEV_TYPE 0x00

typedef enum {
	BACKWARD =0,
	FORWARD
}Direction;

typedef enum{
	IDLE,
	START_SENT,
	CTRID_SENT,
	MOTORID_DIR_SENT,
	  SPEED_SENT,
	  RESETED,
	  CMD_PENDING
}DMCState;


typedef struct {
	uint8_t motorID;
	Direction dir;
	uint8_t speed;
}MotorParams;

#endif
