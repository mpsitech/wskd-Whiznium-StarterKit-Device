/**
	* \file CtrWskdArtyLaser.cpp
	* laser controller (implementation)
	* \author Catherine Johnson
	* \date created: 17 Oct 2020
	* \date modified: 17 Oct 2020
	*/

#include "CtrWskdArtyLaser.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdArtyLaser::VecVCommand
 ******************************************************************************/

utinyint CtrWskdArtyLaser::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "set") return SET;

	return(0);
};

string CtrWskdArtyLaser::VecVCommand::getSref(
			const utinyint tix
		) {
	if (tix == SET) return("set");

	return("");
};

void CtrWskdArtyLaser::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {SET};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyLaser
 ******************************************************************************/

CtrWskdArtyLaser::CtrWskdArtyLaser(
			UntWskd* unt
		) : CtrWskd(unt) {
};

utinyint CtrWskdArtyLaser::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdArtyLaser::getSrefByTixVCommand(
			const utinyint tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdArtyLaser::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdArtyLaser::getNewCmd(
			const utinyint tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();

	return cmd;
};

Cmd* CtrWskdArtyLaser::getNewCmdSet() {
	Cmd* cmd = new Cmd(0x04, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("l", Par::VecVType::USMALLINT);
	cmd->addParInv("r", Par::VecVType::USMALLINT);

	return cmd;
};

void CtrWskdArtyLaser::set(
			const usmallint l
			, const usmallint r
		) {
	Cmd* cmd = getNewCmdSet();

	cmd->parsInv["l"].setUsmallint(l);
	cmd->parsInv["r"].setUsmallint(r);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running set");
	};

	delete cmd;
};

