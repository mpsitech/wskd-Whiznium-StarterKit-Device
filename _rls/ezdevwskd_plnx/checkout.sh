# file checkout.sh
# checkout script for Wskd device access library sources, release ezdevwskd_plnx(ubuntu cross-compilation)
# copyright: (C) 2017-2020 MPSI Technologies GmbH
# author: Catherine Johnson (auto-generation)
# date created: 6 Dec 2020
# IP header --- ABOVE

if [ -z ${WHIZROOT+x} ]; then
	echo "WHIZROOT is not defined. It looks as if you didn't run a Whiznium initialization script beforehand."
	exit 1
fi

export set BUILDROOT=${SYSROOT}${WHIZSDKROOT}/build

mkdir $BUILDROOT/ezdevwskd

cp makeall.sh $BUILDROOT/ezdevwskd/

cp Makefile $BUILDROOT/ezdevwskd/

cp ../../ezdevwskd/*.h $BUILDROOT/ezdevwskd/
cp ../../ezdevwskd/*.cpp $BUILDROOT/ezdevwskd/

cp ../../ezdevwskd/UntWskdArty/*.h $BUILDROOT/ezdevwskd/
cp ../../ezdevwskd/UntWskdArty/*.cpp $BUILDROOT/ezdevwskd/

cp ../../ezdevwskd/UntWskdSkmn/*.h $BUILDROOT/ezdevwskd/
cp ../../ezdevwskd/UntWskdSkmn/*.cpp $BUILDROOT/ezdevwskd/
