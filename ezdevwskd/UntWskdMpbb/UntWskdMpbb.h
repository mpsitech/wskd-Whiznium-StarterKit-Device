/**
	* \file UntWskdMpbb.h
	* enclustra Mercury+ base board unit (declarations)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 8 Jun 2022
	*/
// IP header --- ABOVE

#ifndef UNTWSKDMPBB_H
#define UNTWSKDMPBB_H

#include "Wskd.h"

#include "UntWskdMpbb_vecs.h"

// IP include.cust --- INSERT

/**
	* UntWskdMpbb
	*/
class UntWskdMpbb : public UntWskd {

public:
	static constexpr size_t sizeRxbuf = 2;
	static constexpr size_t sizeTxbuf = 7;

public:
	UntWskdMpbb();
	~UntWskdMpbb();

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
