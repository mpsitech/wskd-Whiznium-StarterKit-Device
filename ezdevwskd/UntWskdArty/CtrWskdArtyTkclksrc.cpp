/**
	* \file CtrWskdArtyTkclksrc.cpp
	* tkclksrc controller (implementation)
	* \author Catherine Johnson
	* \date created: 17 Oct 2020
	* \date modified: 17 Oct 2020
	*/

#include "CtrWskdArtyTkclksrc.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdArtyTkclksrc::VecVCommand
 ******************************************************************************/

utinyint CtrWskdArtyTkclksrc::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "gettkst") return GETTKST;
	else if (s == "settkst") return SETTKST;

	return(0);
};

string CtrWskdArtyTkclksrc::VecVCommand::getSref(
			const utinyint tix
		) {
	if (tix == GETTKST) return("getTkst");
	else if (tix == SETTKST) return("setTkst");

	return("");
};

void CtrWskdArtyTkclksrc::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {GETTKST,SETTKST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyTkclksrc
 ******************************************************************************/

CtrWskdArtyTkclksrc::CtrWskdArtyTkclksrc(
			UntWskd* unt
		) : CtrWskd(unt) {
};

utinyint CtrWskdArtyTkclksrc::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdArtyTkclksrc::getSrefByTixVCommand(
			const utinyint tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdArtyTkclksrc::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdArtyTkclksrc::getNewCmd(
			const utinyint tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETTKST) cmd = getNewCmdGetTkst();
	else if (tixVCommand == VecVCommand::SETTKST) cmd = getNewCmdSetTkst();

	return cmd;
};

Cmd* CtrWskdArtyTkclksrc::getNewCmdGetTkst() {
	Cmd* cmd = new Cmd(0x07, VecVCommand::GETTKST, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tkst", Par::VecVType::UINT);

	return cmd;
};

void CtrWskdArtyTkclksrc::getTkst(
			uint& tkst
		) {
	Cmd* cmd = getNewCmdGetTkst();

	if (unt->runCmd(cmd)) {
		tkst = cmd->parsRet["tkst"].getUint();
	} else {
		delete cmd;
		throw DbeException("error running getTkst");
	};

	delete cmd;
};

Cmd* CtrWskdArtyTkclksrc::getNewCmdSetTkst() {
	Cmd* cmd = new Cmd(0x07, VecVCommand::SETTKST, Cmd::VecVRettype::VOID);

	cmd->addParInv("tkst", Par::VecVType::UINT);

	return cmd;
};

void CtrWskdArtyTkclksrc::setTkst(
			const uint tkst
		) {
	Cmd* cmd = getNewCmdSetTkst();

	cmd->parsInv["tkst"].setUint(tkst);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setTkst");
	};

	delete cmd;
};

