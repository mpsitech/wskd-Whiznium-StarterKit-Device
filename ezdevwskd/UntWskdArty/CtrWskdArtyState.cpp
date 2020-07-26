/**
	* \file CtrWskdArtyState.cpp
	* state controller (implementation)
	* \author Catherine Johnson
	* \date created: 16 May 2020
	* \date modified: 16 May 2020
	*/

#include "CtrWskdArtyState.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdArtyState::VecVCommand
 ******************************************************************************/

utinyint CtrWskdArtyState::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "get") return GET;

	return(0);
};

string CtrWskdArtyState::VecVCommand::getSref(
			const utinyint tix
		) {
	if (tix == GET) return("get");

	return("");
};

void CtrWskdArtyState::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {GET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyState
 ******************************************************************************/

CtrWskdArtyState::CtrWskdArtyState(
			UntWskd* unt
		) : CtrWskd(unt) {
};

utinyint CtrWskdArtyState::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdArtyState::getSrefByTixVCommand(
			const utinyint tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdArtyState::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdArtyState::getNewCmd(
			const utinyint tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GET) cmd = getNewCmdGet();

	return cmd;
};

Cmd* CtrWskdArtyState::getNewCmdGet() {
	Cmd* cmd = new Cmd(0x05, VecVCommand::GET, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVArtyState", Par::VecVType::TIX, VecVWskdArtyState::getTix, VecVWskdArtyState::getSref, VecVWskdArtyState::fillFeed);

	return cmd;
};

void CtrWskdArtyState::get(
			utinyint& tixVArtyState
		) {
	Cmd* cmd = getNewCmdGet();

	if (unt->runCmd(cmd)) {
		tixVArtyState = cmd->parsRet["tixVArtyState"].getTix();
	} else {
		delete cmd;
		throw DbeException("error running get");
	};

	delete cmd;
};

