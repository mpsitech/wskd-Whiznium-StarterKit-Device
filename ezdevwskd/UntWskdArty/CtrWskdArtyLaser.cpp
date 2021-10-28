/**
	* \file CtrWskdArtyLaser.cpp
	* laser controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#include "CtrWskdArtyLaser.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdArtyLaser::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdArtyLaser::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "set") return SET;

	return(0);
};

string CtrWskdArtyLaser::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == SET) return("set");

	return("");
};

void CtrWskdArtyLaser::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyLaser
 ******************************************************************************/

CtrWskdArtyLaser::CtrWskdArtyLaser(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdArtyLaser::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdArtyLaser::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdArtyLaser::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdArtyLaser::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWskdArtyLaser::getNewCmdSet() {
	Cmd* cmd = new Cmd(0x04, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("l", Par::VecVType::UINT16);
	cmd->addParInv("r", Par::VecVType::UINT16);

	return cmd;
};

void CtrWskdArtyLaser::set(
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
