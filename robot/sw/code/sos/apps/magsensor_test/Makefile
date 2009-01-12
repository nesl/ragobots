
PROJ = magsensor_app
RAGOBOTDIR = ../..

SRCS += magsensor.c cb2bus.c magsensor_test.c pushbutton_test.c

include ../Makerules

%.o: $(RAGOBOTDIR)/modules/mc/magsensor/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/mc/cb2bus/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/test/magsensor_test/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/test/pushbutton_test/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
