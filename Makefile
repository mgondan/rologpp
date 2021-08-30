SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)

R_HOME=/usr/lib/R
RCPPFLAGS=$(shell R CMD config --cppflags)
INCLUDES2=-I$(shell Rscript -e "cat(shQuote(system.file('include', package='Rcpp')))")

CP=rologpp.$(SOEXT)

RLIBS=-Wl,--export-dynamic -fopenmp -Wl,-Bsymbolic-functions -Wl,-z,relro -L/usr/lib/R/lib -lR -lpcre2-8 -llzma -lbz2 -lz -ltirpc -lrt -ldl -lm -licuuc -licui18n
RINSIDECFLAGS=$(shell Rscript -e "RInside:::CFlags()")
RINSIDELIBS=$(shell Rscript -e "RInside:::LdFlags()")

ifeq ($(SWIARCH),x64-win64)
	RDLL="$(shell which R.dll)"
	RBLASSDLL="$(shell which Rblas.dll)"
	RGRAPHAPPDLL="$(shell which Rgraphapp.dll)"
	RICONVDLL="$(shell which Riconv.dll)"
	RLAPACKDLL="$(shell which Rlapack.dll)"
	CP+=$(RDLL) $(RBLASSDLL) $(RGRAPHAPPDLL) $(RICONVDLL) $(RLAPACKDLL)
endif

all: $(SOBJ)

OBJ=rologpp.o

ifeq ($(SWIARCH),x64-win64)
%.o: src/%.cpp
	swipl-ld -v $(INCLUDES1) $(INCLUDES2) $(RINSIDECFLAGS) -shared -o rologpp src/$*.cpp $(RLIBS) $(RINSIDELIBS)
endif

ifeq ($(SWIARCH),x86_64-linux)
%.o: src/%.cpp
	$(CC) $(CFLAGS) $(RCPPFLAGS) $(INCLUDES2) $(RINSIDECFLAGS) $(LDSOFLAGS) -o $*.$(SOEXT) src/$*.cpp $(RLIBS) $(RINSIDELIBS)
endif

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)

check::

install:
	cp $(CP) $(PACKSODIR)

clean:
	rm -f $(OBJ)

distclean: clean
	rm -f $(SOBJ)
