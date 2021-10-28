/**
	* \file CtrWskdUbdkChrono.cpp
	* chrono controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "CtrWskdUbdkChrono.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdUbdkChrono::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdUbdkChrono::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "gethhst") return GETHHST;
	else if (s == "sethhst") return SETHHST;

	return(0);
};

string CtrWskdUbdkChrono::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETHHST) return("getHhst");
	else if (tix == SETHHST) return("setHhst");

	return("");
};

void CtrWskdUbdkChrono::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETHHST,SETHHST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdUbdkChrono
 ******************************************************************************/

CtrWskdUbdkChrono::CtrWskdUbdkChrono(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdUbdkChrono::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdUbdkChrono::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdUbdkChrono::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdUbdkChrono::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETHHST) cmd = getNewCmdGetHhst();
	else if (tixVCommand == VecVCommand::SETHHST) cmd = getNewCmdSetHhst();

	return cmd;
};

Cmd* CtrWskdUbdkChrono::getNewCmdGetHhst() {
	Cmd* cmd = new Cmd(0x01, VecVCommand::GETHHST, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("hhst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWskdUbdkChrono::getHhst(
			uint32_t& hhst
		) {
	Cmd* cmd = getNewCmdGetHhst();

	if (unt->runCmd(cmd)) {
		hhst = cmd->parsRet["hhst"].getUint32();
	} else {
		delete cmd;
		throw DbeException("error running getHhst");
	};

	delete cmd;
};

Cmd* CtrWskdUbdkChrono::getNewCmdSetHhst() {
	Cmd* cmd = new Cmd(0x01, VecVCommand::SETHHST, Cmd::VecVRettype::VOID);

	cmd->addParInv("hhst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWskdUbdkChrono::setHhst(
			const uint32_t hhst
		) {
	Cmd* cmd = getNewCmdSetHhst();

	cmd->parsInv["hhst"].setUint32(hhst);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setHhst");
	};

	delete cmd;
};
