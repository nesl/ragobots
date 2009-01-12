includes RemoteCtrlMsg;

configuration RemoteControl {
}
implementation {
  components Main, RemoteControlM, MotionControlC, GenericComm, LedsC;

  Main.StdControl -> RemoteControlM;
  RemoteControlM.MotionControl -> MotionControlC; 

//communication modules
  RemoteControlM.RFControl -> GenericComm;
  RemoteControlM.ReceiveMsg -> GenericComm.ReceiveMsg[AM_REMOTECTRLMSG];
  RemoteControlM.SendMsg -> GenericComm.SendMsg[AM_REMOTECTRLMSG];

//debugging
  RemoteControlM.Leds -> LedsC;
}
