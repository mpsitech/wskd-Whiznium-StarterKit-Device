/**
	* \file CtrWskdSkmnState.cpp
	* state controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#include "CtrWskdSkmnState.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdSkmnState::VecVCommand
 ******************************************************************************/

utinyint CtrWskdSkmnState::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "get") return GET;

	return(0);
};

string CtrWskdSkmnState::VecVCommand::getSref(
			const utinyint tix
		) {
	if (tix == GET) return("get");

	return("");
};

void CtrWskdSkmnState::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {GET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdSkmnState
 ******************************************************************************/

CtrWskdSkmnState::CtrWskdSkmnState(
			UntWskd* unt
		) : CtrWskd(unt) {
};

utinyint CtrWskdSkmnState::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdSkmnState::getSrefByTixVCommand(
			const utinyint tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdSkmnState::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdSkmnState::getNewCmd(
			const utinyint tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GET) cmd = getNewCmdGet();

	return cmd;
};

Cmd* CtrWskdSkmnState::getNewCmdGet() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::GET, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVSkmnState", Par::VecVType::TIX, VecVWskdSkmnState::getTix, VecVWskdSkmnState::getSref, VecVWskdSkmnState::fillFeed);

	return cmd;
};

void CtrWskdSkmnState::get(
			utinyint& tixVSkmnState
		) {
	Cmd* cmd = getNewCmdGet();

	if (unt->runCmd(cmd)) {
		tixVSkmnState = cmd->parsRet["tixVSkmnState"].getTix();
	} else {
		delete cmd;
		throw DbeException("error running get");
	};

	delete cmd;
};
