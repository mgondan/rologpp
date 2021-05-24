SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)
INCLUDES=-I"C:/Program Files/R/R-4.1.0/include" -I"C:\Users\matth\Documents\R\win-library\4.1\Rcpp\include" -I"C:\Users\matth\Documents\R\win-library\4.1\RInside\include"
LIBDIR=-L"C:/Program Files/R/R-4.1.0/bin/x64" -L"C:\Users\matth\Documents\R\win-library\4.1\RInside\lib\x64"
LIBS=-lR -llibRInside

all: $(SOBJ)

OBJ=rologpp.o

%.o: src/%.cpp
	swipl-ld $(INCLUDES) -shared -o rologpp src/$*.cpp $(LIBDIR) $(LIBS)

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)

check::

install:
	mv rologpp.$(SOEXT) $(PACKSODIR)
	cp `libgcc_s_seh-1.dll` $(PACKSODIR)
	cp `which libstdc++-6.dll` $(PACKSODIR)
	cp `which R.dll` $(PACKSODIR)
	cp `which Rblas.dll` $(PACKSODIR)
	cp `which Riconv.dll` $(PACKSODIR)
	cp `which Rlapack.dll` $(PACKSODIR)
	cp `which Rgraphapp.dll` $(PACKSODIR)
	cp `which Rinside.dll` $(PACKSODIR)

clean:
	rm -f $(OBJ)

distclean: clean
	rm -f $(SOBJ)
