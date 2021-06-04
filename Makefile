SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)
INCLUDES1=$(shell R CMD config --cppflags)
INCLUDES2=-I$(shell R --no-echo -e "cat(shQuote(system.file('include', package='Rcpp')))")
INCLUDES3=-I$(shell R --no-echo -e "cat(shQuote(system.file('include', package='RInside')))")
INCLUDES4=-I$(shell R --no-echo -e "cat(system.file('include', package='Rcpp'))")/../../RInside/include
LIBS1=$(shell R CMD config --ldflags)
LIBS2=$(shell R --no-echo -e "cat(shQuote(system.file('lib/x64/libRInside.dll', package='RInside')))")
LIBS3=$(shell R --no-echo -e "cat(shQuote(system.file('include', package='Rcpp')))")/../../RInside/lib/x64/libRInside.dll
RDLL="$(shell which R.dll)"
RBLASSDLL="$(shell which Rblas.dll)"
RGRAPHAPPDLL="$(shell which Rgraphapp.dll)"
RICONVDLL="$(shell which Riconv.dll)"
RLAPACKDLL="$(shell which Rlapack.dll)"

all: $(SOBJ)

OBJ=rologpp.o

%.o: src/%.cpp
	swipl-ld $(INCLUDES1) $(INCLUDES2) $(INCLUDES3) $(INCLUDES4) -shared -o rologpp src/$*.cpp $(LIBS1) $(LIBS2) $(LIBS3)

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)

check::

install:
	mv rologpp.$(SOEXT) $(PACKSODIR)
	cp $(LIBS2) $(RDLL) $(RBLASSDLL) $(RGRAPHAPPDLL) $(RICONVDLL) $(RLAPACKDLL) $(PACKSODIR)

clean:
	rm -f $(OBJ)

distclean: clean
	rm -f $(SOBJ)
