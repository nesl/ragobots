includes PanTiltController;

configuration PanTiltControllerC {
  provides interface PanTiltController;
}
implementation {
  components TimerC, PanTiltControllerM, ServoController1M;

  PanTiltController = PanTiltControllerM;

  PanTiltControllerM.PanTiltServos -> ServoController1M;
  PanTiltControllerM.PanLockedTimer -> TimerC.Timer[unique("Timer")];
  PanTiltControllerM.PanBusyTimer -> TimerC.Timer[unique("Timer")];
  PanTiltControllerM.TiltLockedTimer -> TimerC.Timer[unique("Timer")];
  PanTiltControllerM.TiltBusyTimer -> TimerC.Timer[unique("Timer")];
}

