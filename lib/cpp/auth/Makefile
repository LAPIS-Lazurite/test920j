
CC=g++
CFLAGS=-Wall -Wextra -L. -lftd2xx -lpthread -ldl -lrt -Wl,-rpath /usr/local/lib

CFILES = auth.cpp
OUTPUT := $(CFILES:%.cpp=%)

all: $(TARGET)
	$(CC) $(CFILES) -o $(OUTPUT) $(CFLAGS)
	
clean:
	rm -f $(OUTPUT)
