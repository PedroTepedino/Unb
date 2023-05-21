CC=g++
CFLAGS= -I -std=c++14
DEPS= decode.h bit.h hex.h
OBJS= decode.o

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

all: dbf2mysql blast 

dbf2mysql: dbf2mysql.cpp 
	$(CC) $(CFLAGS) -o $@ $^

blast: decompressor.cpp $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f ./dbf2mysql 
	rm -f ./blast
	rm -f ./*.o
