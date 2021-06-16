SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)
INCLUDES1=$(shell R CMD config --cppflags)
INCLUDES2=-I$(shell Rscript -e "cat(shQuote(system.file('include', package='Rcpp')))")
INCLUDES3=-I$(shell Rscript -e "cat(shQuote(system.file('include', package='RInside')))")
LIBS1=$(shell R CMD config --ldflags)

CP=rologpp.$(SOEXT)
ifeq ($(SWIARCH),x86_64-linux)
	RINSIDEQ=$(shell Rscript -e "cat(shQuote(dirname(paste(system.file(package='RInside'), list.files(pattern='libRInside.$(SOEXT)', path=system.file(package='RInside'), recursive=TRUE)[1], sep='/'))))")
endif

ifeq ($(SWIARCH),x64-win64)
	RINSIDEQ=$(shell Rscript -e "cat(shQuote(dirname(paste(system.file(package='RInside'), grep('x64/RInside.$(SOEXT)', list.files(path=system.file(package='RInside'), recursive=TRUE), value=TRUE), sep='/'))))")
	RDLL="$(shell which R.dll)"
	RBLASSDLL="$(shell which Rblas.dll)"
	RGRAPHAPPDLL="$(shell which Rgraphapp.dll)"
	RICONVDLL="$(shell which Riconv.dll)"
	RLAPACKDLL="$(shell which Rlapack.dll)"
	CP+=$(RDLL) $(RBLASSDLL) $(RGRAPHAPPDLL) $(RICONVDLL) $(RLAPACKDLL)
endif

LIBS2=-L$(RINSIDEQ) -lRInside
LIBS3=-Wl,-rpath,'$(RINSIDEQ)'

all: $(SOBJ)

OBJ=rologpp.o

%.o: src/%.cpp
	swipl-ld $(INCLUDES1) $(INCLUDES2) $(INCLUDES3) -shared -o rologpp src/$*.cpp $(LIBS1) $(LIBS2) $(LIBS3)

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)

check::

install:
	cp $(CP) $(PACKSODIR)

clean:
	rm -f $(OBJ)

distclean: clean
	rm -f $(SOBJ)
