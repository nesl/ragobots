
PROJ = serial_test_app
RAGOBOTDIR = ../..

SRCS += cb2bus.c serial_test.c

include ../Makerules

%.o: $(RAGOBOTDIR)/modules/mc/cb2bus/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/test/serial_test/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@