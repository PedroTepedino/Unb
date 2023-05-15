CC=g++
CFLAGS= -I -std=c++14

all: dbf2mysql blast

dbf2mysql: dbf2mysql.cpp
	$(CC) $(CFLAGS) -o $@ $^

blast: decompressor.cpp
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f ./dbf2mysql 
	rm -f ./blast
	rm -f ./*.o
