#!/bin/bash
# file makeall.sh
# make script for Wskd device access library, release ezdevwskd_mac
# author Catherine Johnson
# date created: 16 May 2020
# modified: 16 May 2020

make DevWskd.h.gch
if [ $? -ne 0 ]; then
	exit
fi

make -j${NCORE}
if [ $? -ne 0 ]; then
	exit
fi

make install

