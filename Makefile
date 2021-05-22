SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)

all: $(SOBJ)

OBJ=hello.o

%.o: src/%.c
	swipl-ld -shared -o rologpp src/$*.c

%.o: src/%.cpp
	swipl-ld -shared -o rologpp src/$*.cpp

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)

check::

install:
	cp rologpp.$(SOEXT) $(PACKSODIR)

clean:
	rm -f $(OBJ)

distclean: clean
	rm -f $(SOBJ)
