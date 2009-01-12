
PROJ = battery_monitor_test_app
RAGOBOTDIR = ../../..

SRCS += cb2bus_hardware.c pushbutton.c cb2bus.c one-wire.c battery_monitor.c
SRCS += battery_monitor_test.c

include ../../Makerules

vpath cb2bus_hardware.c $(RAGOBOTDIR)/modules/hardware/micax/cb2bus/
vpath pushbutton.c $(RAGOBOTDIR)/modules/hardware/micax/pushbutton/
vpath cb2bus.c $(RAGOBOTDIR)/modules/mc/cb2bus/
vpath one-wire.c $(RAGOBOTDIR)/modules/hardware/micax/one-wire/
vpath battery_monitor.c $(RAGOBOTDIR)/modules/mc/battery_monitor/
vpath battery_monitor_test.c $(RAGOBOTDIR)/modules/test/battery_monitor_test/
