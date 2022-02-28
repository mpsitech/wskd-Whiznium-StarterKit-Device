# file checkout.sh
# checkout script for Wskd device access library sources, release ezdevwskd_ubuntu
# copyright: (C) 2017-2020 MPSI Technologies GmbH
# author: Alexander Wirthmueller (auto-generation)
# date created: 24 Dec 2021
# IP header --- ABOVE

if [ -z ${WHIZROOT+x} ]; then
	echo "WHIZROOT is not defined. It looks as if you didn't run a Whiznium initialization script beforehand."
	exit 1
fi

export set BUILDROOT=${WHIZSDKROOT}/build

mkdir $BUILDROOT/ezdevwskd

cp makeall.sh $BUILDROOT/ezdevwskd/

cp Makefile $BUILDROOT/ezdevwskd/

cp ../../ezdevwskd/*.h $BUILDROOT/ezdevwskd/
cp ../../ezdevwskd/*.cpp $BUILDROOT/ezdevwskd/

cp ../../ezdevwskd/UntWskdArty/*.h $BUILDROOT/ezdevwskd/
cp ../../ezdevwskd/UntWskdArty/*.cpp $BUILDROOT/ezdevwskd/

cp ../../ezdevwskd/UntWskdCleb/*.h $BUILDROOT/ezdevwskd/
cp ../../ezdevwskd/UntWskdCleb/*.cpp $BUILDROOT/ezdevwskd/

cp ../../ezdevwskd/UntWskdIccl/*.h $BUILDROOT/ezdevwskd/
cp ../../ezdevwskd/UntWskdIccl/*.cpp $BUILDROOT/ezdevwskd/

cp ../../ezdevwskd/UntWskdMcep/*.h $BUILDROOT/ezdevwskd/
cp ../../ezdevwskd/UntWskdMcep/*.cpp $BUILDROOT/ezdevwskd/

cp ../../ezdevwskd/UntWskdUbdk/*.h $BUILDROOT/ezdevwskd/
cp ../../ezdevwskd/UntWskdUbdk/*.cpp $BUILDROOT/ezdevwskd/
