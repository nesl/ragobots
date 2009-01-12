

configuration IRReceiverC {
	provides interface IRReceiver;
}

implementation {
    components IRReceiverM, LedsC;

    IRReceiver = IRReceiverM;
    IRReceiverM.Leds -> LedsC;
}

