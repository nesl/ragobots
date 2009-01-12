
PROJ = compass_test
RAGOBOTDIR = ../..

SRCS += compass.c

include ../Makerules

%.o: $(RAGOBOTDIR)/modules/mc/compass/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
