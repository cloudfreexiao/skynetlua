CC=gcc
CFLAGS=-O2
LDFLAGS=-ldl -lm

all: lua example

lua: lua.c
	$(CC) $(CFLAGS) -o lua lua.c ../src/skynetlua.c  $(LDFLAGS) -I../src/

example: example.c
	$(CC) $(CFLAGS) -o example example.c ../src/skynetlua.c $(LDFLAGS) -I../src/

test: all
	./example
	./lua -e "print 'hello world'"

clean:
	rm -f lua example *.exe