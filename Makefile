SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)
INCLUDES1=`R CMD config --cppflags`
INCLUDES2=`R --vanilla --silent --no-echo -e "cat(sprintf('-I\"%s\"/Rcpp/include', .libPaths()), collapse=' ')"`
INCLUDES3=`R --vanilla --silent --no-echo -e "cat(sprintf('-I\"%s\"/RInside/include', .libPaths()), collapse=' ')"`
LIBS=`R CMD config --ldflags`
LIBS+=`R --vanilla --silent --no-echo -e "cat(sprintf('-L\"%s\"/RInside/lib/x64', .libPaths()), collapse=' ')"` -llibRInside

all: $(SOBJ)

OBJ=rologpp.o

%.o: src/%.cpp
	swipl-ld $(INCLUDES1) $(INCLUDES2) $(INCLUDES3) -shared -o rologpp src/$*.cpp $(LIBS)

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)

check::

install:
	mv rologpp.$(SOEXT) $(PACKSODIR)

clean:
	rm -f $(OBJ)

distclean: clean
	rm -f $(SOBJ)
