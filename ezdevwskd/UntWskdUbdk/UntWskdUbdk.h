/**
	* \file UntWskdUbdk.h
	* SiLabs EFM8UB10 Development Kit unit (declarations)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#ifndef UNTWSKDUBDK_H
#define UNTWSKDUBDK_H

#include "Wskd.h"

#include "UntWskdUbdk_vecs.h"

#include "CtrWskdUbdkChrono.h"
#include "CtrWskdUbdkDisp.h"
#include "CtrWskdUbdkLaser.h"
#include "CtrWskdUbdkState.h"
#include "CtrWskdUbdkStep.h"

// IP include.cust --- IBEGIN
#ifdef __linux__
	#include <fcntl.h>
	#include <errno.h>
	#include <stdio.h>
	#include <string.h>
	#include <termios.h>
	#include <unistd.h>

	#include <linux/serial_core.h>
	#include <sys/ioctl.h>
#endif
// IP include.cust --- IEND

/**
	* UntWskdUbdk
	*/
class UntWskdUbdk : public UntWskd {

public:
	static constexpr size_t sizeRxbuf = 6;
	static constexpr size_t sizeTxbuf = 7;

public:
	UntWskdUbdk();
	~UntWskdUbdk();

public:
	// IP vars.cust --- IBEGIN
	std::string path;
	unsigned int bpsRx;
	unsigned int bpsTx;

	int fd;
	// IP vars.cust --- IEND

public:
	CtrWskdUbdkChrono* chrono;
	CtrWskdUbdkDisp* disp;
	CtrWskdUbdkLaser* laser;
	CtrWskdUbdkState* state;
	CtrWskdUbdkStep* step;

public:
	void init(const std::string& _path, const unsigned int _bpsRx, const unsigned int _bpsTx); // IP init --- RLINE
	void term();

public:
	bool rx(unsigned char* buf, const size_t reqlen);
	bool tx(unsigned char* buf, const size_t reqlen);

	void flush();

public:
	uint8_t getTixVControllerBySref(const std::string& sref);
	std::string getSrefByTixVController(const uint8_t tixVController);
	void fillFeedFController(Sbecore::Feed& feed);

	uint8_t getTixWBufferBySref(const std::string& sref);
	std::string getSrefByTixWBuffer(const uint8_t tixWBuffer);
	void fillFeedFBuffer(Sbecore::Feed& feed);

	uint8_t getTixVCommandBySref(const uint8_t tixVController, const std::string& sref);
	std::string getSrefByTixVCommand(const uint8_t tixVController, const uint8_t tixVCommand);
	void fillFeedFCommand(const uint8_t tixVController, Sbecore::Feed& feed);

	Dbecore::Bufxf* getNewBufxf(const uint8_t tixWBuffer, const size_t reqlen, unsigned char* buf);
	Dbecore::Cmd* getNewCmd(const uint8_t tixVController, const uint8_t tixVCommand);

};

#endif
