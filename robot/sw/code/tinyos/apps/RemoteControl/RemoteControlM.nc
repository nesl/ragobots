includes RemoteCtrlMsg;

module RemoteControlM 
{
  provides interface StdControl;
  uses {
    interface MotionControl;

    interface StdControl as RFControl;
    interface ReceiveMsg;
    interface SendMsg;

    //debugging
    interface Leds;
  }
}
implementation {

  TOS_Msg reply;

  command result_t StdControl.init() {
    call RFControl.init();
    call MotionControl.init();
    call Leds.init();
    return SUCCESS;
  }

  command result_t StdControl.start() {
    call RFControl.start();
    call Leds.greenToggle();
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    call RFControl.stop();
    return SUCCESS;
  }

  event TOS_MsgPtr ReceiveMsg.receive(TOS_MsgPtr m) {
    struct RemoteCtrlMsg* cmd; 
    
    cmd = (struct RemoteCtrlMsg*)(m->data);
    switch (cmd->movement) {
    case STOP:
      call MotionControl.abortMove();
    case MOVEFORWARD:
      call MotionControl.move((int8_t)cmd->amount);
      break;
    case MOVEBACKWARD:
      call MotionControl.move(0-((int8_t)cmd->amount));
      break;
    case TURNCLOCKWISE:
      call MotionControl.turnRobot(0-((int16_t)cmd->amount));
      break;
    case TURNCOUNTERCLOCKWISE:
      call MotionControl.turnRobot((int16_t)cmd->amount);
      break;
    }
    call Leds.redToggle();
    return m;
  }

  event result_t SendMsg.sendDone (TOS_MsgPtr msg, result_t success) {
    return SUCCESS;
  }

  event result_t MotionControl.moveDone() {
    return SUCCESS;
  }
  event result_t MotionControl.turnDone() {
    return SUCCESS;
  }    
    
  event result_t MotionControl.abortDone() {
    return SUCCESS;
  }

}
