CC=gcc

CFLAGS=-c -Wall -Werror -fpic

MYLOC=/Users/hyzhou/Documents/Computer/Julia/JuliaCalls/JuliaCallsC/ex2

SHARED_LIB = libfoo.so

SOURCES=foo.c
OBJECTS=$(SOURCES:.c=.o)

.c.o:
	$(CC) $(CFLAGS) $< -o $@

lib: $(OBJECTS)
	$(CC) -shared -o $(SHARED_LIB) $(OBJECTS)

test:
	$(CC) -L$(MYLOC) -Wall -o test main.c -lfoo

clean:
	rm *.so *.o test
