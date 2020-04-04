CC=gcc

CFLAGS=-c -Wall -fPIC

#SOURCES=calc_mean.c
SOURCES=ctrace2d_single.c
OBJECTS=$(SOURCES:.c=.o)

.c.o:
	$(CC) $(CFLAGS) $< -o $@

lib: $(OBJECTS)
	$(CC) -shared -fPIC -o libtrace.so $(OBJECTS)

clean:
	rm -f *.o libtrace.so
