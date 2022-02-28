/**
	* \file CtrWskdIcicleLaser.cpp
	* laser controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#include "CtrWskdIcicleLaser.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdIcicleLaser::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdIcicleLaser::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "set") return SET;

	return(0);
};

string CtrWskdIcicleLaser::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == SET) return("set");

	return("");
};

void CtrWskdIcicleLaser::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcicleLaser
 ******************************************************************************/

CtrWskdIcicleLaser::CtrWskdIcicleLaser(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdIcicleLaser::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdIcicleLaser::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdIcicleLaser::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdIcicleLaser::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWskdIcicleLaser::getNewCmdSet() {
	Cmd* cmd = new Cmd(0x04, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("l", Par::VecVType::UINT16);
	cmd->addParInv("r", Par::VecVType::UINT16);

	return cmd;
};

void CtrWskdIcicleLaser::set(
			const uint16_t l
			, const uint16_t r
		) {
	Cmd* cmd = getNewCmdSet();

	cmd->parsInv["l"].setUint16(l);
	cmd->parsInv["r"].setUint16(r);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running set");
	};

	delete cmd;
};
