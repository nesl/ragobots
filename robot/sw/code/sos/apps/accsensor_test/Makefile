
PROJ = accsensor_test
RAGOBOTDIR = ../..

SRCS += accsensor.c cb2bus.c

include ../Makerules

%.o: $(RAGOBOTDIR)/modules/mc/accsensor/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/mc/cb2bus/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
