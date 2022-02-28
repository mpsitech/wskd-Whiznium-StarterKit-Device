/**
	* \file CtrWskdIcicleTkclksrc.cpp
	* tkclksrc controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#include "CtrWskdIcicleTkclksrc.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdIcicleTkclksrc::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdIcicleTkclksrc::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "gettkst") return GETTKST;
	else if (s == "settkst") return SETTKST;

	return(0);
};

string CtrWskdIcicleTkclksrc::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETTKST) return("getTkst");
	else if (tix == SETTKST) return("setTkst");

	return("");
};

void CtrWskdIcicleTkclksrc::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETTKST,SETTKST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcicleTkclksrc
 ******************************************************************************/

CtrWskdIcicleTkclksrc::CtrWskdIcicleTkclksrc(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdIcicleTkclksrc::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdIcicleTkclksrc::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdIcicleTkclksrc::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdIcicleTkclksrc::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETTKST) cmd = getNewCmdGetTkst();
	else if (tixVCommand == VecVCommand::SETTKST) cmd = getNewCmdSetTkst();

	return cmd;
};

Cmd* CtrWskdIcicleTkclksrc::getNewCmdGetTkst() {
	Cmd* cmd = new Cmd(0x07, VecVCommand::GETTKST, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWskdIcicleTkclksrc::getTkst(
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

Cmd* CtrWskdIcicleTkclksrc::getNewCmdSetTkst() {
	Cmd* cmd = new Cmd(0x07, VecVCommand::SETTKST, Cmd::VecVRettype::VOID);

	cmd->addParInv("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWskdIcicleTkclksrc::setTkst(
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
