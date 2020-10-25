#!/bin/bash
# file checkout.sh
# checkout script for Wskd embedded system code, release fpgawskd_linux
# author Catherine Johnson
# date created: 17 Oct 2020
# modified: 17 Oct 2020

export set FPGAROOT=${WHIZROOT}/srcfpga

if [ $? -ne 0 ]; then
	exit
fi

if [ "$1" = "all" ]; then
	unts=("arty")
else
	unts=("$@")
fi;

for var in "${unts[@]}"
do
	cp checkin_"$var".sh $FPGAROOT/"$var"/checkin.sh
	if [ 0 == 1 ]; then
		cp ../../wskd/"$var"/*.ucf $FPGAROOT/"$var"/
		cp ../../wskd/"$var"/*.vhd $FPGAROOT/"$var"/
	else
		cp ../../wskd/"$var"/*.xdc $FPGAROOT/"$var"/"$var".srcs/constrs_1/imports/"$var"/
		cp ../../wskd/"$var"/*.vhd $FPGAROOT/"$var"/"$var".srcs/sources_1/imports/"$var"/
	fi
done

