FC=mpif90

CFLAGS=-c -Wall -fPIC

SOURCES=ModMpiTest.f90
OBJECTS=$(SOURCES:.c=.o)

.f95.o:
	$(FC) $(CFLAGS) $< -o $@

lib: $(OBJECTS)
	$(FC) -o libmpitest.so $(OBJECTS) -shared -fPIC

clean:
	rm *.so *.mod
