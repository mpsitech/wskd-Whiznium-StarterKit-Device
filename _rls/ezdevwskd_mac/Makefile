# file Makefile
# make file for Wskd device access library, release ezdevwskd_mac
# author Catherine Johnson
# date created: 16 May 2020
# modified: 16 May 2020

SRCROOT = ${WHIZROOT}/src
LIBROOT = ${WHIZROOT}/lib

CPP = g++
CPPFLAGS = -std=c++11 -g -Wall -Os -pthread

STATLIB = ar
STATLIBFLAGS = rcs

INCPATH = -I$(SRCROOT)
INCPATH += -I${WHIZROOT}/src -I/usr/local/include/libxml2

PCHS = DevWskd.h.gch

OBJS = Wskd.o
OBJS +=
OBJS += UntWskdArty.o UntWskdArty_vecs.o CtrWskdArtyCamacq.o CtrWskdArtyCamif.o CtrWskdArtyFeatdet.o CtrWskdArtyLaser.o CtrWskdArtyState.o CtrWskdArtyStep.o CtrWskdArtyTkclksrc.o
OBJS += UntWskdSkmn.o UntWskdSkmn_vecs.o CtrWskdSkmnChrono.o CtrWskdSkmnLaser.o CtrWskdSkmnState.o CtrWskdSkmnStep.o

LIB = libezdevwskd

.SUFFIXES: .h .h.gch .cpp

.h.h.gch :
	$(CPP) $(CPPFLAGS) $(INCPATH) -o $@ -c $<

.cpp.o:
	$(CPP) $(CPPFLAGS) $(INCPATH) -o $@ -c $<

all:	$(LIB)

$(LIB):	$(PCHS) $(OBJS)
	$(STATLIB) $(STATLIBFLAGS) $(LIB).a $(OBJS)
	rm -f *.o

install:
	mv $(LIB).a $(LIBROOT)/

clean: 
	rm -f *.gch
	rm -f *.o

