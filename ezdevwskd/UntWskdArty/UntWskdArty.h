/**
	* \file UntWskdArty.h
	* Digilent Arty Z7 unit (declarations)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#ifndef UNTWSKDARTY_H
#define UNTWSKDARTY_H

#include "Wskd.h"

#include "UntWskdArty_vecs.h"

#include "CtrWskdArtyCamacq.h"
#include "CtrWskdArtyCamif.h"
#include "CtrWskdArtyFeatdet.h"
#include "CtrWskdArtyLaser.h"
#include "CtrWskdArtyPwmonif.h"
#include "CtrWskdArtyState.h"
#include "CtrWskdArtyStep.h"
#include "CtrWskdArtyTkclksrc.h"

// IP include.cust --- INSERT

/**
	* UntWskdArty
	*/
class UntWskdArty : public UntWskd {

public:
	static constexpr size_t sizeRxbuf = 37;
	static constexpr size_t sizeTxbuf = 38;

public:
	UntWskdArty();
	~UntWskdArty();

public:
	// IP vars.cust --- IBEGIN
	std::string path;
	int fd;

	bool histNotDump;
	std::vector<std::string> hist;
	// IP vars.cust --- IEND

public:
	CtrWskdArtyCamacq* camacq;
	CtrWskdArtyCamif* camif;
	CtrWskdArtyFeatdet* featdet;
	CtrWskdArtyLaser* laser;
	CtrWskdArtyPwmonif* pwmonif;
	CtrWskdArtyState* state;
	CtrWskdArtyStep* step;
	CtrWskdArtyTkclksrc* tkclksrc;

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
