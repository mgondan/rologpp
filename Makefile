SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)

ifeq ($(R_HOME),)
	R_PATH=''
else
	R_PATH='$(R_HOME)/bin/x64/'
endif
	
RCPPFLAGS=$(shell $(R_PATH)R CMD config --cppflags)
RLIBS=$(shell $(R_PATH)R CMD config --ldflags)
INCLUDES2=-I$(shell $(R_PATH)Rscript -e "cat(shQuote(system.file('include', package='Rcpp')))")
RINSIDECFLAGS=$(shell $(R_PATH)Rscript -e "RInside:::CFlags()")
RINSIDELIBS=$(shell $(R_PATH)Rscript -e "RInside:::LdFlags()")

CP=rologpp.$(SOEXT)

ifeq ($(SWIARCH),x64-win64)
	ifeq ($(R_PATH),'')
		RDLL="$(shell which R.dll)"
		RBLASSDLL="$(shell which Rblas.dll)"
		RGRAPHAPPDLL="$(shell which Rgraphapp.dll)"
		RICONVDLL="$(shell which Riconv.dll)"
		RLAPACKDLL="$(shell which Rlapack.dll)"
	else
		RDLL=$(R_PATH)R.dll
		RBLASSDLL=$(R_PATH)Rblas.dll
		RGRAPHAPPDLL=$(R_PATH)Rgraphapp.dll
		RICONVDLL=$(R_PATH)Riconv.dll
		RLAPACKDLL=$(R_PATH)Rlapack.dll
	endif

	CP+=$(RDLL) $(RBLASSDLL) $(RGRAPHAPPDLL) $(RICONVDLL) $(RLAPACKDLL)
endif

all: $(SOBJ)

OBJ=rologpp.o

ifeq ($(SWIARCH),x64-win64)
%.o: src/%.cpp
	swipl-ld -v $(RCPPFLAGS) $(INCLUDES2) $(RINSIDECFLAGS) -shared -o rologpp src/$*.cpp $(RLIBS) $(RINSIDELIBS)
	
	$(CXX) -D_REENTRANT -D__WINDOWS__ -D_WINDOWS -D__SWI_PROLOG__ $(CFLAGS) -c $(RCPPFLAGS) $(INCLUDES2) $(RINSIDECFLAGS) -o src/$*.o src/$*.cpp
	$(CXX) -o rologpp.$(SOEXT) -shared src/$*.o  $(RLIBS) $(RINSIDELIBS)
endif

ifeq ($(SWIARCH),x86_64-linux)
%.o: src/%.cpp
	$(CC) $(CFLAGS) $(RCPPFLAGS) $(INCLUDES2) $(RINSIDECFLAGS) $(LDSOFLAGS) -o $*.$(SOEXT) src/$*.cpp $(RLIBS) $(RINSIDELIBS)
endif

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)

install:
	cp $(CP) $(PACKSODIR)
	rm rologpp.$(SOEXT)

check::

clean:
	rm -f $(OBJ)
	rm rologpp.$(SOEXT)

distclean: clean
