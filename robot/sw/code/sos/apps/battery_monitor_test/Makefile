
PROJ = battery_monitor_test_app
RAGOBOTDIR = ../..

SRCS += cb2bus.c battery_monitor.c battery_monitor_test.c

include ../Makerules


%.o: $(RAGOBOTDIR)/modules/mc/cb2bus/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/mc/battery_monitor/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/test/battery_monitor_test/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@