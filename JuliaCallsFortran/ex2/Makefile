FC=gfortran

CFLAGS=-c -Wall -fPIC

MYLOC=/Users/hyzhou/Documents/Computer/Julia/JuliaCalls/JuliaCallsFortran/ex2

SHARED_LIB = libfoo.so

SOURCES=Modtest1.f90 Modtest2.f90
OBJECTS=$(SOURCES:.c=.o)

.c.o:
	$(FC) $(CFLAGS) $< -o $@

lib: $(OBJECTS)
	$(FC) -o $(SHARED_LIB) $(OBJECTS) -shared -fPIC

clean:
	rm *.so *.mod
