#!/bin/bash
# file checkin.sh
# checkin script for enclustra Mercury+ base board unit of Wskd embedded system code, release fpgawskd_any
# copyright: (C) 2017-2020 MPSI Technologies GmbH
# author: Alexander Wirthmueller (auto-generation)
# date created: 8 Jun 2022
# IP header --- ABOVE

if [ -z ${WHIZROOT+x} ]; then
	echo "WHIZROOT is not defined. It looks as if you didn't run a Whiznium initialization script beforehand."
	exit 1
fi

export set REPROOT=${WHIZDEVROOT}/rep

cp mpbb.srcs/constrs_1/imports/mpbb/*.xdc $REPROOT/wskd/wskd/mpbb/
cp mpbb.srcs/sources_1/imports/mpbb/*.vhd $REPROOT/wskd/wskd/mpbb/
