configuration Demo {
}
implementation {
  components DemoM, ServoController3M, PanTiltControllerC, Main, GenericComm, LedsC;

  Main.StdControl -> DemoM;

  DemoM.PanTiltController -> PanTiltControllerC;
  DemoM.ServoController -> ServoController3M;

//communication modules
  DemoM.RFControl -> GenericComm;
  DemoM.ReceiveMsg -> GenericComm.ReceiveMsg[5];
  DemoM.SendMsg -> GenericComm.SendMsg[5];

//debugging
  DemoM.Leds -> LedsC;
}
