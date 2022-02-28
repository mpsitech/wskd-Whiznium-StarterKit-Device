/**
	* \file CtrWskdIcicleState.cpp
	* state controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#include "CtrWskdIcicleState.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdIcicleState::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdIcicleState::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "get") return GET;

	return(0);
};

string CtrWskdIcicleState::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GET) return("get");

	return("");
};

void CtrWskdIcicleState::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcicleState
 ******************************************************************************/

CtrWskdIcicleState::CtrWskdIcicleState(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdIcicleState::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdIcicleState::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdIcicleState::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdIcicleState::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GET) cmd = getNewCmdGet();

	return cmd;
};

Cmd* CtrWskdIcicleState::getNewCmdGet() {
	Cmd* cmd = new Cmd(0x05, VecVCommand::GET, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVIcicleState", Par::VecVType::TIX, VecVWskdIcicleState::getTix, VecVWskdIcicleState::getSref, VecVWskdIcicleState::fillFeed);

	return cmd;
};

void CtrWskdIcicleState::get(
			uint8_t& tixVIcicleState
		) {
	Cmd* cmd = getNewCmdGet();

	if (unt->runCmd(cmd)) {
		tixVIcicleState = cmd->parsRet["tixVIcicleState"].getTix();
	} else {
		delete cmd;
		throw DbeException("error running get");
	};

	delete cmd;
};
