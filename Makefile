SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)
INCLUDES=`R CMD config --cppflags`
INCLUDES+=`R --vanilla --silent --no-echo -e "cat(sprintf('-I\"%s\"/Rcpp/include', .libPaths()), collapse=' ')"`
INCLUDES+=`R --vanilla --silent --no-echo -e "cat(sprintf('-I\"%s\"/RInside/include', .libPaths()), collapse=' ')"`
LIBS=`R CMD config --ldflags` -L"C:\Users\matth\Documents\R\win-library\4.1\RInside\lib\x64"
LIBS+=`R --vanilla --silent --no-echo -e "cat(sprintf('-I\"%s\"/RInside/lib/x64', .libPaths()), collapse=' ')"` -llibRInside

all: $(SOBJ)

OBJ=rologpp.o

%.o: src/%.cpp
	swipl-ld $(INCLUDES) -shared -o rologpp src/$*.cpp $(LIBS)

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)

check::

install:
	mv rologpp.$(SOEXT) $(PACKSODIR)

clean:
	rm -f $(OBJ)

distclean: clean
	rm -f $(SOBJ)
