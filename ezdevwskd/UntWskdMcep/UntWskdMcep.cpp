/**
	* \file UntWskdMcep.cpp
	* Aries Cyclone V evaluation platform unit (implementation)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 23 Oct 2021
	*/
// IP header --- ABOVE

#include "UntWskdMcep.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

UntWskdMcep::UntWskdMcep() : UntWskd() {
	// IP constructor --- INSERT
};

UntWskdMcep::~UntWskdMcep() {
	if (initdone) term();
};

void UntWskdMcep::init() { // IP init.hdr --- LINE

	// IP init.cust --- INSERT

	initdone = true;
};

void UntWskdMcep::term() {
	// IP term.cust --- INSERT

	initdone = false;
};

bool UntWskdMcep::rx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: receive data from device observing history / rxtxdump settings

	// IP rx --- INSERT

	return retval;
};

bool UntWskdMcep::tx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: transmit data to device observing history / rxtxdump settings

	// IP tx --- INSERT

	return retval;
};

void UntWskdMcep::flush() {
	// IP flush --- INSERT
};

uint8_t UntWskdMcep::getTixVCommandBySref(
			const string& sref
		) {
	return VecVWskdMcepCommand::getTix(sref);
};

string UntWskdMcep::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVWskdMcepCommand::getSref(tixVCommand);
};

void UntWskdMcep::fillFeedFCommand(
			Feed& feed
		) {
	VecVWskdMcepCommand::fillFeed(feed);
};

Cmd* UntWskdMcep::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	return cmd;
};
