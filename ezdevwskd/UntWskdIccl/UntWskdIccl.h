/**
	* \file UntWskdIccl.h
	* Microchip PolarFire Soc Icicle kit unit (declarations)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 23 Oct 2021
	*/
// IP header --- ABOVE

#ifndef UNTWSKDICCL_H
#define UNTWSKDICCL_H

#include "Wskd.h"

#include "UntWskdIccl_vecs.h"

#include "CtrWskdIcclCamacq.h"
#include "CtrWskdIcclCamif.h"
#include "CtrWskdIcclFeatdet.h"
#include "CtrWskdIcclLaser.h"
#include "CtrWskdIcclPwmonif.h"
#include "CtrWskdIcclState.h"
#include "CtrWskdIcclStep.h"
#include "CtrWskdIcclTkclksrc.h"

// IP include.cust --- INSERT

/**
	* UntWskdIccl
	*/
class UntWskdIccl : public UntWskd {

public:
	static constexpr size_t sizeRxbuf = 37;
	static constexpr size_t sizeTxbuf = 38;

public:
	UntWskdIccl();
	~UntWskdIccl();

public:
	// IP vars.cust --- IBEGIN
	std::string path;
	int fd;

	bool histNotDump;
	std::vector<std::string> hist;
	// IP vars.cust --- IEND

public:
	CtrWskdIcclCamacq* camacq;
	CtrWskdIcclCamif* camif;
	CtrWskdIcclFeatdet* featdet;
	CtrWskdIcclLaser* laser;
	CtrWskdIcclPwmonif* pwmonif;
	CtrWskdIcclState* state;
	CtrWskdIcclStep* step;
	CtrWskdIcclTkclksrc* tkclksrc;

public:
	void init(const std::string& _path); // IP init --- RLINE
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

	Dbecore::Bufxf* getNewBufxfFlgbufFromFeatdet(const size_t reqlen, unsigned char* buf);
	void readFlgbufFromFeatdet(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfPvwabufFromCamacq(const size_t reqlen, unsigned char* buf);
	void readPvwabufFromCamacq(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfPvwbbufFromCamacq(const size_t reqlen, unsigned char* buf);
	void readPvwbbufFromCamacq(const size_t reqlen, unsigned char*& data, size_t& datalen);

};

#endif
