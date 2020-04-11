FC=gfortran

CFLAGS=-c -Wall -fPIC

MYLOC=/Users/hyzhou/Documents/Computer/Julia/JuliaCalls/JuliaCallsFortran/ex2

SHARED_LIB = libfoo.so

SOURCES=Modtest1.f90 Modtest2.f90
OBJECTS=$(SOURCES:.c=.o)

.f90.o:
	$(FC) $(CFLAGS) $< -o $@

lib: $(OBJECTS)
	$(FC) -o $(SHARED_LIB) $(OBJECTS) -shared -fPIC

main: $(OBJECTS)
	make lib
	$(FC) -c main.f90
	$(FC) -o test.exe $(SHARED_LIB) main.o $(OBJECTS)

clean:
	rm *.so *.mod *.o test.exe
