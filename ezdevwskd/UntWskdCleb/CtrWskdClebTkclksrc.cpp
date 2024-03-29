/**
	* \file CtrWskdClebTkclksrc.cpp
	* tkclksrc controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 24 Dec 2021
	*/
// IP header --- ABOVE

#include "CtrWskdClebTkclksrc.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdClebTkclksrc::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdClebTkclksrc::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "gettkst") return GETTKST;
	else if (s == "settkst") return SETTKST;

	return(0);
};

string CtrWskdClebTkclksrc::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETTKST) return("getTkst");
	else if (tix == SETTKST) return("setTkst");

	return("");
};

void CtrWskdClebTkclksrc::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETTKST,SETTKST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdClebTkclksrc
 ******************************************************************************/

CtrWskdClebTkclksrc::CtrWskdClebTkclksrc(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdClebTkclksrc::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdClebTkclksrc::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdClebTkclksrc::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdClebTkclksrc::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETTKST) cmd = getNewCmdGetTkst();
	else if (tixVCommand == VecVCommand::SETTKST) cmd = getNewCmdSetTkst();

	return cmd;
};

Cmd* CtrWskdClebTkclksrc::getNewCmdGetTkst() {
	Cmd* cmd = new Cmd(0x04, VecVCommand::GETTKST, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWskdClebTkclksrc::getTkst(
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

Cmd* CtrWskdClebTkclksrc::getNewCmdSetTkst() {
	Cmd* cmd = new Cmd(0x04, VecVCommand::SETTKST, Cmd::VecVRettype::VOID);

	cmd->addParInv("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWskdClebTkclksrc::setTkst(
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
