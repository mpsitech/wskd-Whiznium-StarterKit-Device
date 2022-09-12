/**
	* \file CtrWskdArtyTkclksrc.cpp
	* tkclksrc controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#include "CtrWskdArtyTkclksrc.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdArtyTkclksrc::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdArtyTkclksrc::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "gettkst") return GETTKST;
	else if (s == "settkst") return SETTKST;

	return(0);
};

string CtrWskdArtyTkclksrc::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETTKST) return("getTkst");
	else if (tix == SETTKST) return("setTkst");

	return("");
};

void CtrWskdArtyTkclksrc::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETTKST,SETTKST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyTkclksrc
 ******************************************************************************/

CtrWskdArtyTkclksrc::CtrWskdArtyTkclksrc(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdArtyTkclksrc::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdArtyTkclksrc::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdArtyTkclksrc::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdArtyTkclksrc::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETTKST) cmd = getNewCmdGetTkst();
	else if (tixVCommand == VecVCommand::SETTKST) cmd = getNewCmdSetTkst();

	return cmd;
};

Cmd* CtrWskdArtyTkclksrc::getNewCmdGetTkst() {
	Cmd* cmd = new Cmd(0x08, VecVCommand::GETTKST, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWskdArtyTkclksrc::getTkst(
			uint32_t& tkst
		) {
	Cmd* cmd = getNewCmdGetTkst();

	if (unt->runCmd(cmd)) {
		tkst = cmd->parsRet["tkst"].getUint32();
	} else {
		delete cmd;
		throw DbeException("error running getTkst");
	};

	delete cmd;
};

Cmd* CtrWskdArtyTkclksrc::getNewCmdSetTkst() {
	Cmd* cmd = new Cmd(0x08, VecVCommand::SETTKST, Cmd::VecVRettype::VOID);

	cmd->addParInv("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWskdArtyTkclksrc::setTkst(
			const uint32_t tkst
		) {
	Cmd* cmd = getNewCmdSetTkst();

	cmd->parsInv["tkst"].setUint32(tkst);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setTkst");
	};

	delete cmd;
};
