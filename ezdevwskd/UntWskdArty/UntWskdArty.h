/**
	* \file UntWskdArty.h
	* Digilent Arty Z7 unit (declarations)
	* \author Catherine Johnson
	* \date created: 17 Oct 2020
	* \date modified: 17 Oct 2020
	*/

#ifndef UNTWSKDARTY_H
#define UNTWSKDARTY_H

#include "Wskd.h"

#include "UntWskdArty_vecs.h"

#include "CtrWskdArtyCamacq.h"
#include "CtrWskdArtyCamif.h"
#include "CtrWskdArtyFeatdet.h"
#include "CtrWskdArtyLaser.h"
#include "CtrWskdArtyState.h"
#include "CtrWskdArtyStep.h"
#include "CtrWskdArtyTkclksrc.h"

// IP include.cust --- INSERT

/**
	* UntWskdArty
	*/
class UntWskdArty : public UntWskd {

public:
	static constexpr unsigned int sizeRxbuf = 6;
	static constexpr unsigned int sizeTxbuf = 8;

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
	Sbecore::utinyint getTixVControllerBySref(const std::string& sref);
	std::string getSrefByTixVController(const Sbecore::utinyint tixVController);
	void fillFeedFController(Sbecore::Xmlio::Feed& feed);

	Sbecore::utinyint getTixWBufferBySref(const std::string& sref);
	std::string getSrefByTixWBuffer(const Sbecore::utinyint tixWBuffer);
	void fillFeedFBuffer(Sbecore::Xmlio::Feed& feed);

	Sbecore::utinyint getTixVCommandBySref(const Sbecore::utinyint tixVController, const std::string& sref);
	std::string getSrefByTixVCommand(const Sbecore::utinyint tixVController, const Sbecore::utinyint tixVCommand);
	void fillFeedFCommand(const Sbecore::utinyint tixVController, Sbecore::Xmlio::Feed& feed);

	Dbecore::Bufxf* getNewBufxf(const Sbecore::utinyint tixWBuffer, const size_t reqlen, unsigned char* buf);
	Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVController, const Sbecore::utinyint tixVCommand);

	Dbecore::Bufxf* getNewBufxfFlgbufFromFeatdet(const size_t reqlen, unsigned char* buf);
	void readFlgbufFromFeatdet(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfPvwabufFromCamacq(const size_t reqlen, unsigned char* buf);
	void readPvwabufFromCamacq(const size_t reqlen, unsigned char*& data, size_t& datalen);

	Dbecore::Bufxf* getNewBufxfPvwbbufFromCamacq(const size_t reqlen, unsigned char* buf);
	void readPvwbbufFromCamacq(const size_t reqlen, unsigned char*& data, size_t& datalen);

};

#endif



