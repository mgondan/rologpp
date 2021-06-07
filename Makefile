SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)
INCLUDES1=$(shell R CMD config --cppflags)
INCLUDES2=-I$(shell R --slave -e "cat(shQuote(system.file('include', package='Rcpp')))")
INCLUDES3=-I$(shell R --slave -e "cat(shQuote(system.file('include', package='RInside')))")
LIBS1=$(shell R CMD config --ldflags)
RINSIDEQ=$(shell R --slave -e "cat(shQuote(paste(system.file(package='RInside'), list.files(pattern='libRInside.$(SOEXT)', path=system.file(package='RInside'), recursive=TRUE)[1], sep='/')))")
RINSIDEQQ=$(shell R --slave -e "cat(shQuote(paste(system.file(package='RInside'), list.files(pattern='libRInside.$(SOEXT)', path=system.file(package='RInside'), recursive=TRUE)[1], sep='/'), type='sh'))")
LIBS2=-L$(RINSIDEQ) -lRInside
LIBS3=-Wl,-rpath,"$(RINSIDEQ)"

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
	cp $(RDLL) $(RBLASSDLL) $(RGRAPHAPPDLL) $(RICONVDLL) $(RLAPACKDLL) $(PACKSODIR)

clean:
	rm -f $(OBJ)

distclean: clean
	rm -f $(SOBJ)
