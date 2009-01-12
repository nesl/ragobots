
PROJ = hipri_int_test_app
RAGOBOTDIR = ../..

SRCS += cb2bus.c hipri_int_test.c

include ../Makerules

%.o: $(RAGOBOTDIR)/modules/mc/cb2bus/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@
%.o: $(RAGOBOTDIR)/modules/test/hipri_int_test/%.c
	$(CC) -c $(CFLAGS) $(INCDIR) $< -o $@