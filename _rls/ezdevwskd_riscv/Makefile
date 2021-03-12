# file Makefile
# make file for Wskd device access library, release ezdevwskd_riscv (ubuntu cross-compilation)
# copyright: (C) 2016-2020 MPSI Technologies GmbH
# author: Alexander Wirthmueller (auto-generation)
# date created: 20 Feb 2021
# IP header --- ABOVE

BUILDROOT = ${WHIZSDKROOT}/build
LIBROOT = ${SYSROOT}${WHIZSDKROOT}/lib

CPP = ${TCHROOT}/riscv64-oe-linux-g++
CPPFLAGS = --sysroot=${SYSROOT} --sysroot=${SYSROOT} -std=c++11 -fstack-protector-strong -g -Wall -Os -pthread

STATLIB = ${TCHROOT}/riscv64-oe-linux-ar
STATLIBFLAGS = rcs

INCPATH = -I=$(BUILDROOT)
INCPATH += -I=${WHIZSDKROOT}/build -I=/usr/include/libxml2

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
