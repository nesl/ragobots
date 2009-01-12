/* -*- Mode: C; tab-width:4 -*- */
/* ex: set ts=4 shiftwidth=4 softtabstop=4 cindent: */

/**
 * @brief Application to test the magsensor
 * @author David Lee
 */

#include <sos.h>
#include <led.h>
#include <id.h>
#include <modules/ragobot_mod_pid.h>
#include <modules/magsensor.h>
#include <modules/CB2Bus.h>
#include "../../modules/test/pushbutton_test/pushbutton_test.h"
#include "../../modules/test/magsensor_test/magsensor_test.h"

void sos_start(void){
  cb2bus_module_init();
  pushbutton_test_init();
  magsensor_init();
  magsensor_test_init();
}
