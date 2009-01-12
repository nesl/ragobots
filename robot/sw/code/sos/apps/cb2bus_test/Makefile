
PROJ = cb2bus_test_app
RAGOBOTDIR = ../..

SRCS += cb2bus.c cb2bus_test.c

include ../Makerules


%.o: $(RAGOBOTDIR)/modules/mc/cb2bus/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/test/cb2bus_test/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@