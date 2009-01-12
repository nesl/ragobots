
PROJ = motorcontrol_app
RAGOBOTDIR = ../..

SRCS += cb2bus.c motorcontrol.c motorcontrol_test.c

include ../Makerules

%.o: $(RAGOBOTDIR)/modules/mc/cb2bus/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/mc/motorcontrol/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/test/motorcontrol_test/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
