SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)

all: $(SOBJ)

OBJ=hello.o

%.o: src/%.c
	swipl-ld -o $(SOBJ) src/$*.c

%.o: src/%.cpp
	swipl-ld -o $(SOBJ) src/$*.c

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)

check::

install::

clean:
	rm -f $(OBJ)

distclean: clean
	rm -f $(SOBJ)
