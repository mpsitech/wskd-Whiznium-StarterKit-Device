/**
	* \file UntWskdMcvevp.h
	* Aries Cyclone V evaluation platform unit (declarations)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#ifndef UNTWSKDMCVEVP_H
#define UNTWSKDMCVEVP_H

#include "Wskd.h"

#include "UntWskdMcvevp_vecs.h"

// IP include.cust --- INSERT

/**
	* UntWskdMcvevp
	*/
class UntWskdMcvevp : public UntWskd {

public:
	static constexpr size_t sizeRxbuf = 2;
	static constexpr size_t sizeTxbuf = 7;

public:
	UntWskdMcvevp();
	~UntWskdMcvevp();

public:
	// IP vars.cust --- INSERT

public:
	void init(); // IP init --- LINE
	void term();

public:
	bool rx(unsigned char* buf, const size_t reqlen);
	bool tx(unsigned char* buf, const size_t reqlen);

	void flush();

public:
	uint8_t getTixVCommandBySref(const std::string& sref);
	std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	void fillFeedFCommand(Sbecore::Feed& feed);

	Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

};

#endif
