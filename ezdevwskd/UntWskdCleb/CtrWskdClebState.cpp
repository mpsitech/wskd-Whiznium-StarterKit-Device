/**
	* \file CtrWskdClebState.cpp
	* state controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 24 Dec 2021
	*/
// IP header --- ABOVE

#include "CtrWskdClebState.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdClebState::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdClebState::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "get") return GET;

	return(0);
};

string CtrWskdClebState::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GET) return("get");

	return("");
};

void CtrWskdClebState::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdClebState
 ******************************************************************************/

CtrWskdClebState::CtrWskdClebState(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdClebState::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdClebState::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdClebState::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdClebState::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GET) cmd = getNewCmdGet();

	return cmd;
};

Cmd* CtrWskdClebState::getNewCmdGet() {
	Cmd* cmd = new Cmd(0x02, VecVCommand::GET, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVClebState", Par::VecVType::TIX, VecVWskdClebState::getTix, VecVWskdClebState::getSref, VecVWskdClebState::fillFeed);

	return cmd;
};

void CtrWskdClebState::get(
			uint8_t& tixVClebState
		) {
	Cmd* cmd = getNewCmdGet();

	if (unt->runCmd(cmd)) {
		tixVClebState = cmd->parsRet["tixVClebState"].getTix();
	} else {
		delete cmd;
		throw DbeException("error running get");
	};

	delete cmd;
};
