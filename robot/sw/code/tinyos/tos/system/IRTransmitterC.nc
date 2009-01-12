

configuration IRTransmitterC {
	provides interface IRTransmitter;
}

implementation {
    components IRTransmitterM, LedsC;

    IRTransmitter = IRTransmitterM;
    IRTransmitterM.Leds -> LedsC;
}

