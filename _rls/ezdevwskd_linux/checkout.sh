# file checkout.sh
# checkout script for Wskd device access library sources, release ezdevwskd_linux
# author Catherine Johnson
# date created: 6 Oct 2020
# modified: 6 Oct 2020

export set SRCROOT=${WHIZROOT}/src

mkdir $SRCROOT/ezdevwskd

cp makeall.sh $SRCROOT/ezdevwskd/

cp Makefile $SRCROOT/ezdevwskd/

cp ../../ezdevwskd/*.h $SRCROOT/ezdevwskd/
cp ../../ezdevwskd/*.cpp $SRCROOT/ezdevwskd/

cp ../../ezdevwskd/UntWskdArty/*.h $SRCROOT/ezdevwskd/
cp ../../ezdevwskd/UntWskdArty/*.cpp $SRCROOT/ezdevwskd/

cp ../../ezdevwskd/UntWskdSkmn/*.h $SRCROOT/ezdevwskd/
cp ../../ezdevwskd/UntWskdSkmn/*.cpp $SRCROOT/ezdevwskd/

