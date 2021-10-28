/**
	* \file CtrWskdUbdkState.cpp
	* state controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "CtrWskdUbdkState.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdUbdkState::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdUbdkState::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "get") return GET;

	return(0);
};

string CtrWskdUbdkState::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GET) return("get");

	return("");
};

void CtrWskdUbdkState::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdUbdkState
 ******************************************************************************/

CtrWskdUbdkState::CtrWskdUbdkState(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdUbdkState::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdUbdkState::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdUbdkState::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdUbdkState::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GET) cmd = getNewCmdGet();

	return cmd;
};

Cmd* CtrWskdUbdkState::getNewCmdGet() {
	Cmd* cmd = new Cmd(0x04, VecVCommand::GET, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVUbdkState", Par::VecVType::TIX, VecVWskdUbdkState::getTix, VecVWskdUbdkState::getSref, VecVWskdUbdkState::fillFeed);

	return cmd;
};

void CtrWskdUbdkState::get(
			uint8_t& tixVUbdkState
		) {
	Cmd* cmd = getNewCmdGet();

	if (unt->runCmd(cmd)) {
		tixVUbdkState = cmd->parsRet["tixVUbdkState"].getTix();
	} else {
		delete cmd;
		throw DbeException("error running get");
	};

	delete cmd;
};
