SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)
INCLUDES1=$(shell R CMD config --cppflags)
INCLUDES2=$(shell R --vanilla --silent --no-echo -e "cat(sprintf('-I\\\"%s/Rcpp/include\\\"', .libPaths()), collapse=' ')")
INCLUDES3=$(shell R --vanilla --silent --no-echo -e "cat(sprintf('-I\\\"%s/RInside/include\\\"', .libPaths()), collapse=' ')")
LIBS1=$(shell R CMD config --ldflags)
LIBS2=$(shell R --vanilla --silent --no-echo -e "cat(sprintf('-L\\\"%s/RInside/lib/x64\\\"', .libPaths()), collapse=' ')") -llibRInside
RINSIDEDLL=$(shell R --vanilla --silent --no-echo -e "cat(sprintf('\\\"%s/RInside/lib/x64/libRInside\\\"', .libPaths()), collapse=' ')")

all: $(SOBJ)

OBJ=rologpp.o

%.o: src/%.cpp
	swipl-ld $(INCLUDES1) $(INCLUDES2) $(INCLUDES3) -shared -o rologpp src/$*.cpp $(LIBS1) $(LIBS2)

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)

check::

install:
	mv rologpp.$(SOEXT) $(PACKSODIR)
	cp $(RINSIDEDIR).$(SOEXT) $(PACKSODIR)

clean:
	rm -f $(OBJ)

distclean: clean
	rm -f $(SOBJ)
