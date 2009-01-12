
#INCLUDES = -I/usr/local/include -I/usr/include 

SOURCES	= tcp.c jacobi.c lubksb.c lob_scaat.c ludcmp.c mat_ops.c utils.c nrutil.c

OBJECTS = tcp.o jacobi.o lubksb.o lob_scaat.o ludcmp.o  mat_ops.o utils.o nrutil.o

#LIB = -lnsl -lsocket -lresolv -lm -lpthread 
LIB = -lm  

tcp: $(OBJECTS)
	gcc $(OBJECTS) -o tcp  $(LIB)

tcp.o: tcp.c
	gcc -c $(SOURCES)  $(INCLUDES)


clean:
	rm tcp.exe  $(OBJECTS)


