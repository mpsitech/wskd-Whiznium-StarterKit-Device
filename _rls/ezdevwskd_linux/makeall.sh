#!/bin/bash
# file makeall.sh
# make script for Wskd device access library, release ezdevwskd_linux
# author Catherine Johnson
# date created: 6 Oct 2020
# modified: 6 Oct 2020

make DevWskd.h.gch
if [ $? -ne 0 ]; then
	exit
fi

make -j${NCORE}
if [ $? -ne 0 ]; then
	exit
fi

make install

