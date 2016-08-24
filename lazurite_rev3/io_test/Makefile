# which compiler
CC = gcc

SUBDIRS = \
		lib/cpp/bootmode\
		lib/cpp/reset\
		lib/cpp/bootwriter\
		lib/cpp/auth

all: subdirs

subdirs:
	for n in $(SUBDIRS); do $(MAKE) -C $$n || exit 1; done

clean:
	for n in $(SUBDIRS); do $(MAKE) -C $$n clean; done
	
