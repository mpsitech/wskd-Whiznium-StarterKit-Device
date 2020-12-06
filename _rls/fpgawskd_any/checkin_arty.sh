#!/bin/bash
# file checkin.sh
# checkin script for Digilent Arty Z7 unit of Wskd embedded system code, release fpgawskd_any
# copyright: (C) 2017-2020 MPSI Technologies GmbH
# author: Catherine Johnson (auto-generation)
# date created: 6 Dec 2020
# IP header --- ABOVE

if [ -z ${WHIZROOT+x} ]; then
	echo "WHIZROOT is not defined. It looks as if you didn't run a Whiznium initialization script beforehand."
	exit 1
fi

export set REPROOT=${WHIZDEVROOT}/rep

cp arty.srcs/constrs_1/imports/arty/*.xdc $REPROOT/wskd/wskd/arty/
cp arty.srcs/sources_1/imports/arty/*.vhd $REPROOT/wskd/wskd/arty/
