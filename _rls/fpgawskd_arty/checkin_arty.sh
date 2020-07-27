#!/bin/bash
# file checkin.sh
# checkin script for Digilent Arty Z7 unit of Wskd embedded system code, release fpgawskd_arty
# author Catherine Johnson
# date created: 16 May 2020
# modified: 16 May 2020

export set REPROOT=${WHIZROOT}/srcrep

cp arty.srcs/constrs_1/imports/arty/*.xdc $REPROOT/wskd/wskd/arty/
cp arty.srcs/sources_1/imports/arty/*.vhd $REPROOT/wskd/wskd/arty/
