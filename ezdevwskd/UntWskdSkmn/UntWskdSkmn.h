/**
	* \file UntWskdSkmn.h
	* MPSI starter kit mainboard unit (declarations)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#ifndef UNTWSKDSKMN_H
#define UNTWSKDSKMN_H

#include "Wskd.h"

#include "UntWskdSkmn_vecs.h"

#include "CtrWskdSkmnChrono.h"
#include "CtrWskdSkmnLaser.h"
#include "CtrWskdSkmnState.h"
#include "CtrWskdSkmnStep.h"

// IP include.cust --- INSERT

/**
	* UntWskdSkmn
	*/
class UntWskdSkmn : public UntWskd {

public:
	static constexpr unsigned int sizeRxbuf = 2;
	static constexpr unsigned int sizeTxbuf = 7;

public:
	UntWskdSkmn();
	~UntWskdSkmn();

public:
	// IP vars.cust --- INSERT

public:
	CtrWskdSkmnChrono* chrono;
	CtrWskdSkmnLaser* laser;
	CtrWskdSkmnState* state;
	CtrWskdSkmnStep* step;

public:
	void init(); // IP init --- LINE
	void term();

public:
	bool rx(unsigned char* buf, const size_t reqlen);
	bool tx(unsigned char* buf, const size_t reqlen);

	void flush();

public:
	Sbecore::utinyint getTixVControllerBySref(const std::string& sref);
	std::string getSrefByTixVController(const Sbecore::utinyint tixVController);
	void fillFeedFController(Sbecore::Feed& feed);

	Sbecore::utinyint getTixWBufferBySref(const std::string& sref);
	std::string getSrefByTixWBuffer(const Sbecore::utinyint tixWBuffer);
	void fillFeedFBuffer(Sbecore::Feed& feed);

	Sbecore::utinyint getTixVCommandBySref(const Sbecore::utinyint tixVController, const std::string& sref);
	std::string getSrefByTixVCommand(const Sbecore::utinyint tixVController, const Sbecore::utinyint tixVCommand);
	void fillFeedFCommand(const Sbecore::utinyint tixVController, Sbecore::Feed& feed);

	Dbecore::Bufxf* getNewBufxf(const Sbecore::utinyint tixWBuffer, const size_t reqlen, unsigned char* buf);
	Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVController, const Sbecore::utinyint tixVCommand);

};

#endif
