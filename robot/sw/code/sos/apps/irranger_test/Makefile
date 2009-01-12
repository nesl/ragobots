
PROJ = irranger_test
RAGOBOTDIR = ../..

SRCS += cb2bus.c

include ../Makerules

%.o: $(RAGOBOTDIR)/modules/mc/cb2bus/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
