/**
	* \file UntWskdMcvevp.cpp
	* Aries Cyclone V evaluation platform unit (implementation)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#include "UntWskdMcvevp.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

UntWskdMcvevp::UntWskdMcvevp() : UntWskd() {
	// IP constructor --- INSERT
};

UntWskdMcvevp::~UntWskdMcvevp() {
	if (initdone) term();
};

void UntWskdMcvevp::init() { // IP init.hdr --- LINE

	// IP init.cust --- INSERT

	initdone = true;
};

void UntWskdMcvevp::term() {
	// IP term.cust --- INSERT

	initdone = false;
};

bool UntWskdMcvevp::rx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: receive data from device observing history / rxtxdump settings

	// IP rx --- INSERT

	return retval;
};

bool UntWskdMcvevp::tx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: transmit data to device observing history / rxtxdump settings

	// IP tx --- INSERT

	return retval;
};

void UntWskdMcvevp::flush() {
	// IP flush --- INSERT
};

uint8_t UntWskdMcvevp::getTixVCommandBySref(
			const string& sref
		) {
	return VecVWskdMcvevpCommand::getTix(sref);
};

string UntWskdMcvevp::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVWskdMcvevpCommand::getSref(tixVCommand);
};

void UntWskdMcvevp::fillFeedFCommand(
			Feed& feed
		) {
	VecVWskdMcvevpCommand::fillFeed(feed);
};

Cmd* UntWskdMcvevp::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	return cmd;
};
