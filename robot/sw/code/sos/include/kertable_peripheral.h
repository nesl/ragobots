#ifndef _KERTABLE_PERIPHERAL_H_
#define _KERTABLE_PERIPHERAL_H_

#include <pushbutton.h>
#include <cb2bus_hardware.h>
#include <servos.h>
#include <hipri_int.h>
#include <one-wire.h>
#include <irranger.h>
#include <uart_ragobot.h>

#define SOS_MICA2_PERIPHERAL_KER_TABLE {                            \
        /* 0 = 64 */ (void*)ker_pushbutton_register,                \
        /* 1 = 65 */ (void*)ker_pushbutton_deregister,              \
        /* 2 = 66 */ (void*)ker_cb2bus_load,                        \
	/* 3 = 67 */ (void*)ker_servo_set_position,                 \
	/* 4 = 68 */ (void*)ker_hipri_int_register,                 \
	/* 5 = 69 */ (void*)ker_hipri_int_deregister,               \
	/* 6 = 70 */ (void*)ker_one_wire_write,                     \
	/* 7 = 71 */ (void*)ker_one_wire_read,                      \
	/* 8 = 72 */ (void*)ker_irranger_trigger,                   \
        /* 9 = 72 */ (void*)ker_serial_write,                       \
        /* 10 = 72 */ (void*)ker_serial_read,                       \
        /* 63 = 128 */ NULL,				            \
      }


#endif
