SOBJ=$(PACKSODIR)/rologpp.$(SOEXT)

all: $(SOBJ)

OBJ=hello.o

%.o: src/%.c
	$(CC) $(CFLAGS) -c src/$*.c

%.o: src/%.cpp
	$(CXX) $(CFLAGS) -c src/$*.cpp

$(SOBJ): $(OBJ)
	mkdir -p $(PACKSODIR)
	$(CC) $(LDSOFLAGS) -o $@ $(OBJ) $(SWISOLIB)

check::

install::

clean:
	rm -f $(OBJ)

distclean: clean
	rm -f $(SOBJ)
