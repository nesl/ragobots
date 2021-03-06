#ifndef _MOTORCONTROL_H_
#define _MOTORCONTROL_H_

#define MSG_CHANGE_SPEED (MOD_MSG_START+0)
#define WRITE 1

#define MOTOR_CHANGE_MASK	0xC0
#define LEFT_MOTOR_CHANGE	0x80
#define RIGHT_MOTOR_CHANGE	0x40
#define BOTH_MOTOR_CHANGE	0xC0

#define CHANGE_RIGHT_MASK	0x38
#define CHANGE_LEFT_MASK	0x7
#define DATA_MASK			0x3F

#define RGT_STOP			0x40
#define RGT_REV_CREEP		0x41
#define RGT_REV_NORMAL		0x42
#define RGT_REV_MAX			0x43
#define RGT_FWD_CREEP		0x44
#define RGT_FWD_CAUTIOUS	0x45
#define RGT_FWD_NORMAL		0x46
#define RGT_FWD_MAX			0x47

#define LFT_STOP			0x80
#define LFT_REV_CREEP		0x88
#define LFT_REV_NORMAL		0x90
#define LFT_REV_MAX			0x98
#define LFT_FWD_CREEP		0xA0
#define LFT_FWD_CAUTIOUS	0xA8
#define LFT_FWD_NORMAL		0xB0
#define LFT_FWD_MAX			0xB8

#define MOTOR_STOP		RGT_STOP | LFT_STOP
#define MOTOR_FULL_SPEED	RGT_FWD_MAX | LFT_FWD_MAX
#define MOTOR_FULL_REVERSE	RGT_REV_MAX | LFT_REV_MAX
#define MOTOR_RIGHT_MAX		RGT_FWD_MAX | LFT_REV_MAX
#define MOTOR_LEFT_MAX		RGT_REV_MAX | LFT_FWD_MAX
#define MOTOR_RIGHT_SLIGHT	RGT_FWD_NORMAL | LFT_FWD_MAX
#define MOTOR_LEFT_SLIGHT	RGT_FWD_MAX | LFT_FWD_NORMAL
#define MOTOR_RIGHT_NORMAL	RGT_FWD_CAUTIOUS | LFT_FWD_MAX
#define MOTOR_LEFT_NORMAL	RGT_FWD_MAX | LFT_FWD_CAUTIOUS

#ifndef _MODULE_
mod_header_ptr mcontrol_get_header();
#endif

#endif
