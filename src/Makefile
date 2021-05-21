all:
  $CC $(CFLAGS) hello.cpp
  $LD $(LDSOFLAGS) -o rologpp.$(SOEXT) hello.o
  
check:

install:
  mkdir ../lib
  mkdir ../lib/$(SWIARCH)
  cp rologpp.$(SOEXT) ../lib/$(SWIARCH)
