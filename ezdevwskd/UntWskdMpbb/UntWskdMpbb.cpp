/**
	* \file UntWskdMpbb.cpp
	* enclustra Mercury+ base board unit (implementation)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 8 Jun 2022
	*/
// IP header --- ABOVE

#include "UntWskdMpbb.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

UntWskdMpbb::UntWskdMpbb() : UntWskd() {
	// IP constructor --- INSERT
};

UntWskdMpbb::~UntWskdMpbb() {
	if (initdone) term();
};

void UntWskdMpbb::init() { // IP init.hdr --- LINE

	// IP init.cust --- INSERT

	initdone = true;
};

void UntWskdMpbb::term() {
	// IP term.cust --- INSERT

	initdone = false;
};

bool UntWskdMpbb::rx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: receive data from device observing history / rxtxdump settings

	// IP rx --- INSERT

	return retval;
};

bool UntWskdMpbb::tx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: transmit data to device observing history / rxtxdump settings

	// IP tx --- INSERT

	return retval;
};

void UntWskdMpbb::flush() {
	// IP flush --- INSERT
};

uint8_t UntWskdMpbb::getTixVCommandBySref(
			const string& sref
		) {
	return VecVWskdMpbbCommand::getTix(sref);
};

string UntWskdMpbb::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVWskdMpbbCommand::getSref(tixVCommand);
};

void UntWskdMpbb::fillFeedFCommand(
			Feed& feed
		) {
	VecVWskdMpbbCommand::fillFeed(feed);
};

Cmd* UntWskdMpbb::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	return cmd;
};
