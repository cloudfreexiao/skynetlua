CC=gcc
CFLAGS=-O2
LDFLAGS=-ldl -lm

all: lua example

lua: lua.c ../skynetlua.h
	$(CC) $(CFLAGS) -o lua lua.c $(LDFLAGS)

example: example.c ../skynetlua.h
	$(CC) $(CFLAGS) -o example example.c $(LDFLAGS)

test: all
	./example
	./lua -e "print 'hello world'"

clean:
	rm -f lua example *.exe