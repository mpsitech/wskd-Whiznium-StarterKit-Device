# file Makefile
# make file for Wskd device access library, release ezdevwskd_plnx (ubuntu cross-compilation)
# copyright: (C) 2016-2020 MPSI Technologies GmbH
# author: Alexander Wirthmueller (auto-generation)
# date created: 24 Dec 2021
# IP header --- ABOVE

BUILDROOT = ${WHIZSDKROOT}/build
LIBROOT = ${SYSROOT}${WHIZSDKROOT}/lib

CPP = ${TCHROOT}/arm-xilinx-linux-gnueabi-g++
CPPFLAGS = --sysroot=${SYSROOT} --sysroot=${SYSROOT} -std=c++11 -march=armv7-a -mthumb -mfpu=neon -mfloat-abi=hard -g -Wall -Os -pthread

STATLIB = ${TCHROOT}/arm-xilinx-linux-gnueabi-ar
STATLIBFLAGS = rcs

INCPATH = -I=$(BUILDROOT)
INCPATH += -I=${WHIZSDKROOT}/build -I=/usr/include -I=/usr/include/libxml2

PCHS = DevWskd.h.gch

OBJS = Wskd.o
OBJS +=
OBJS += UntWskdArty.o UntWskdArty_vecs.o CtrWskdArtyCamacq.o CtrWskdArtyCamif.o CtrWskdArtyFeatdet.o CtrWskdArtyLaser.o CtrWskdArtyState.o CtrWskdArtyStep.o CtrWskdArtyTkclksrc.o
OBJS += UntWskdCleb.o UntWskdCleb_vecs.o CtrWskdClebLaser.o CtrWskdClebState.o CtrWskdClebStep.o CtrWskdClebTkclksrc.o
OBJS += UntWskdIccl.o UntWskdIccl_vecs.o CtrWskdIcclCamacq.o CtrWskdIcclCamif.o CtrWskdIcclFeatdet.o CtrWskdIcclLaser.o CtrWskdIcclState.o CtrWskdIcclStep.o CtrWskdIcclTkclksrc.o
OBJS += UntWskdMcep.o UntWskdMcep_vecs.o
OBJS += UntWskdUbdk.o UntWskdUbdk_vecs.o CtrWskdUbdkChrono.o CtrWskdUbdkDisp.o CtrWskdUbdkLaser.o CtrWskdUbdkState.o CtrWskdUbdkStep.o

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
