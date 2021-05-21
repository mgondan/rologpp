all:
	$(CC) $(CFLAGS) hello.cpp
	$(LD) $(LDSOFLAGS) -o rologpp.$(SOEXT) hello.o
  
check:

distclean:
	rm *.o *.$(SOEXT) lib/$(SWIARCH)/*.$(SOEXT)

install:
	mkdir lib
	mkdir lib/$(SWIARCH)
	cp rologpp.$(SOEXT) lib/$(SWIARCH)
