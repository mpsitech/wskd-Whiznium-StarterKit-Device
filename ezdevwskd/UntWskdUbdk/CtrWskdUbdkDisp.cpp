/**
	* \file CtrWskdUbdkDisp.cpp
	* disp controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "CtrWskdUbdkDisp.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdUbdkDisp::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdUbdkDisp::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	return(0);
};

string CtrWskdUbdkDisp::VecVCommand::getSref(
			const uint8_t tix
		) {

	return("");
};

void CtrWskdUbdkDisp::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();
};

/******************************************************************************
 class CtrWskdUbdkDisp
 ******************************************************************************/

CtrWskdUbdkDisp::CtrWskdUbdkDisp(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdUbdkDisp::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdUbdkDisp::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdUbdkDisp::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdUbdkDisp::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	return cmd;
};
