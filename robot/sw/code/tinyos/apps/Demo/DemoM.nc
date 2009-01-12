module DemoM {
  provides interface StdControl;
  uses {
    interface PanTiltController;

//gripper is controlled directly for simplicity
    interface ServoController;

//interfaces for radio communication
    interface StdControl as RFControl;
    interface ReceiveMsg;
    interface SendMsg;

//debugging
    interface Leds;
  }
}
implementation {

  enum {
    TILT_UP = 0,
    TILT_DOWN = 1,
    PAN_LEFT = 2,
    PAN_RIGHT = 3,
    GRIPPER_OPEN = 4,
    GRIPPER_CLOSE = 5,
    MOVE_FWD = 6,
    MOVE_BACK = 7,
    MOVE_LEFT = 8,
    MOVE_RIGHT = 9
  };

  TOS_Msg reply;
  int8_t tiltpos, panpos;

  command result_t StdControl.init() {
    call PanTiltController.init();
    call ServoController.init();
    call RFControl.init();
    call Leds.init();
    tiltpos = 0;
    panpos = 0;
    return SUCCESS;
  }

  command result_t StdControl.start() {
    call RFControl.start();
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    call RFControl.stop();
    return SUCCESS;
  }

  event TOS_MsgPtr ReceiveMsg.receive(TOS_MsgPtr m) {
    uint8_t cmd;
    uint8_t* pload;

    call Leds.redOn();
    //    pload = (void*)(m->data);
    cmd = (int8_t)(*(m->data));
    if(cmd==0) {
      call Leds.greenToggle();
    }
    switch (cmd) {
      case TILT_UP:
	tiltpos = tiltpos - 7;
	call PanTiltController.setTiltPosition(tiltpos, 10);
	call Leds.redOn();
	call Leds.greenOn();
	call Leds.yellowOn();
/*  	reply.data[0] = TILT; */
/*  	reply.data[1] = tiltpos; */
/*  	//call SendMsg.send(TOS_BCAST_ADDR, 2, &reply); */
	break;
      case TILT_DOWN:
	tiltpos = tiltpos + 7;
	call PanTiltController.setTiltPosition(tiltpos, 10);
	call Leds.redOn();
	call Leds.greenOn();
	call Leds.yellowOff();
/*  	reply.data[0] = TILT; */
/*  	reply.data[1] = tiltpos; */
/*  	call SendMsg.send(TOS_BCAST_ADDR, 2, &reply); */
	break;
      case PAN_LEFT:
	panpos = panpos + 7;
	call PanTiltController.setPanPosition(panpos, 10);
	call Leds.redOn();
	call Leds.greenOff();
	call Leds.yellowOn();
/*  	reply.data[0] = PAN; */
/*  	reply.data[1] = panpos; */
/*  	call SendMsg.send(TOS_BCAST_ADDR, 2, &reply); */
	break;
      case PAN_RIGHT:
	panpos = panpos - 7;
	call PanTiltController.setPanPosition(panpos, 10);
	call Leds.redOn();
	call Leds.greenOff();
	call Leds.yellowOff();
/*  	reply.data[0] = PAN; */
/*  	reply.data[1] = panpos; */
/*  	call SendMsg.send(TOS_BCAST_ADDR, 2, &reply); */
	break;
      case GRIPPER_OPEN:
	call ServoController.setPosition(0, 0);
	call Leds.redOff();
	call Leds.greenOn();
	call Leds.yellowOn();
/*  	reply.data[0] = GRIPPER; */
/*  	reply.data[1] = 1; //indicates gripper is open */
/*  	call SendMsg.send(TOS_BCAST_ADDR, 2, &reply); */
	break;
      case GRIPPER_CLOSE:
	call ServoController.setPosition(0, 80);
	call Leds.redOff();
	call Leds.greenOn();
	call Leds.yellowOff();
/*  	reply.data[0] = GRIPPER; */
/*  	reply.data[1] = 0; //indicates gripper is closed */
/*  	call SendMsg.send(TOS_BCAST_ADDR, 2, &reply); */
	break;
    }
    return m;
  }

  event result_t SendMsg.sendDone (TOS_MsgPtr msg, result_t success) {
    return SUCCESS;
  }

//PanTiltController events
  event void PanTiltController.panPositionChanged(int8_t currentPanPosition) {
  }

  event void PanTiltController.tiltPositionChanged(int8_t currentTiltPosition) {
  }
}
