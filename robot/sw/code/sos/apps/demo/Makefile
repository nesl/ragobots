
PROJ = demo_app
RAGOBOTDIR = ../..

SRCS += cb2bus.c motorcontrol.c demo.c lightshow.c

include ../Makerules

%.o: $(RAGOBOTDIR)/modules/mc/cb2bus/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/mc/motorcontrol/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/mc/lightshow/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/test/demo/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
