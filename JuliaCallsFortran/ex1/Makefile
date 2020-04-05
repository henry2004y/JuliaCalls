FC=gfortran

CFLAGS=-c -Wall -fPIC

SOURCES=simplemodule.f95
OBJECTS=$(SOURCES:.c=.o)

.f95.o:
	$(FC) $(CFLAGS) $< -o $@

lib: $(OBJECTS)
	$(FC) -o simplemodule.so $(OBJECTS) -shared -fPIC

clean:
	rm *.so *.mod
