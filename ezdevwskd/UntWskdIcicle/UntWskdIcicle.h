/**
	* \file UntWskdIcicle.h
	* Microchip PolarFire Soc Icicle kit unit (declarations)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#ifndef UNTWSKDICICLE_H
#define UNTWSKDICICLE_H

#include "Wskd.h"

#include "UntWskdIcicle_vecs.h"

#include "CtrWskdIcicleCamacq.h"
#include "CtrWskdIcicleCamif.h"
#include "CtrWskdIcicleFeatdet.h"
#include "CtrWskdIcicleLaser.h"
#include "CtrWskdIcicleState.h"
#include "CtrWskdIcicleStep.h"
#include "CtrWskdIcicleTkclksrc.h"

// IP include.cust --- INSERT

/**
	* UntWskdIcicle
	*/
class UntWskdIcicle : public UntWskd {

public:
	static constexpr size_t sizeRxbuf = 8;
	static constexpr size_t sizeTxbuf = 7;

public:
	UntWskdIcicle();
	~UntWskdIcicle();

public:
	// IP vars.cust --- INSERT

public:
	CtrWskdIcicleCamacq* camacq;
	CtrWskdIcicleCamif* camif;
	CtrWskdIcicleFeatdet* featdet;
	CtrWskdIcicleLaser* laser;
	CtrWskdIcicleState* state;
	CtrWskdIcicleStep* step;
	CtrWskdIcicleTkclksrc* tkclksrc;

public:
	void init(); // IP init --- LINE
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
