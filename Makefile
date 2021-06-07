SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)
INCLUDES1=$(shell R CMD config --cppflags)
INCLUDES2=-I$(shell R --slave -e "cat(shQuote(system.file('include', package='Rcpp')))")
INCLUDES3=-I$(shell R --slave -e "cat(shQuote(system.file('include', package='RInside')))")
LIBS1=$(shell R CMD config --ldflags)
LIBS2=-L$(shell R --slave -e "cat(shQuote(system.file('lib', package='RInside')))") -lRInside
LIBS3=-Wl,-rpath,$(shell R --slave -e "cat(shQuote(system.file('lib', package='RInside')))")
RDLL="$(shell which R.dll)"
RBLASSDLL="$(shell which Rblas.dll)"
RGRAPHAPPDLL="$(shell which Rgraphapp.dll)"
RICONVDLL="$(shell which Riconv.dll)"
RLAPACKDLL="$(shell which Rlapack.dll)"

all: $(SOBJ)

OBJ=rologpp.o

%.o: src/%.cpp
	swipl-ld $(INCLUDES1) $(INCLUDES2) $(INCLUDES3) -shared -o rologpp src/$*.cpp $(LIBS1) $(LIBS2) $(LIBS3)

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)

check::

install:
	mv rologpp.$(SOEXT) $(PACKSODIR)

inst:
	cp $(LIBS2) $(RDLL) $(RBLASSDLL) $(RGRAPHAPPDLL) $(RICONVDLL) $(RLAPACKDLL) $(PACKSODIR)

clean:
	rm -f $(OBJ)

distclean: clean
	rm -f $(SOBJ)
