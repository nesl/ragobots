
PROJ = rfid_test_app
RAGOBOTDIR = ../../..

SRCS += cb2bus_hardware.c pushbutton.c cb2bus.c uart_ragobot.c rfid.c rfid_test.c

include ../../Makerules

vpath cb2bus_hardware.c $(RAGOBOTDIR)/modules/hardware/micax/cb2bus/
vpath pushbutton.c $(RAGOBOTDIR)/modules/hardware/micax/pushbutton/
vpath cb2bus.c $(RAGOBOTDIR)/modules/mc/cb2bus/
vpath uart_ragobot.c $(RAGOBOTDIR)/modules/hardware/micax/uart1/
vpath rfid.c $(RAGOBOTDIR)/modules/mc/rfid/
vpath rfid_test.c $(RAGOBOTDIR)/modules/test/rfid_test/