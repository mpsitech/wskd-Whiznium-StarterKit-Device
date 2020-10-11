/**
	* \file CtrWskdSkmnStep.cpp
	* step controller (implementation)
	* \author Catherine Johnson
	* \date created: 6 Oct 2020
	* \date modified: 6 Oct 2020
	*/

#include "CtrWskdSkmnStep.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdSkmnStep::VecVCommand
 ******************************************************************************/

utinyint CtrWskdSkmnStep::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "moveto") return MOVETO;
	else if (s == "set") return SET;
	else if (s == "zero") return ZERO;

	return(0);
};

string CtrWskdSkmnStep::VecVCommand::getSref(
			const utinyint tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == MOVETO) return("moveto");
	else if (tix == SET) return("set");
	else if (tix == ZERO) return("zero");

	return("");
};

void CtrWskdSkmnStep::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {GETINFO,MOVETO,SET,ZERO};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdSkmnStep::VecVState
 ******************************************************************************/

utinyint CtrWskdSkmnStep::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "move") return MOVE;

	return(0);
};

string CtrWskdSkmnStep::VecVState::getSref(
			const utinyint tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == MOVE) return("move");

	return("");
};

void CtrWskdSkmnStep::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {IDLE,MOVE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdSkmnStep
 ******************************************************************************/

CtrWskdSkmnStep::CtrWskdSkmnStep(
			UntWskd* unt
		) : CtrWskd(unt) {
};

utinyint CtrWskdSkmnStep::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdSkmnStep::getSrefByTixVCommand(
			const utinyint tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdSkmnStep::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdSkmnStep::getNewCmd(
			const utinyint tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::MOVETO) cmd = getNewCmdMoveto();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();
	else if (tixVCommand == VecVCommand::ZERO) cmd = getNewCmdZero();

	return cmd;
};

Cmd* CtrWskdSkmnStep::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(0x04, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWskdSkmnStep::VecVState::getTix, CtrWskdSkmnStep::VecVState::getSref, CtrWskdSkmnStep::VecVState::fillFeed);
	cmd->addParRet("angle", Par::VecVType::USMALLINT);

	return cmd;
};

void CtrWskdSkmnStep::getInfo(
			utinyint& tixVState
			, usmallint& angle
		) {
	Cmd* cmd = getNewCmdGetInfo();

	if (unt->runCmd(cmd)) {
		tixVState = cmd->parsRet["tixVState"].getTix();
		angle = cmd->parsRet["angle"].getUsmallint();
	} else {
		delete cmd;
		throw DbeException("error running getInfo");
	};

	delete cmd;
};

Cmd* CtrWskdSkmnStep::getNewCmdMoveto() {
	Cmd* cmd = new Cmd(0x04, VecVCommand::MOVETO, Cmd::VecVRettype::VOID);

	cmd->addParInv("angle", Par::VecVType::USMALLINT);

	return cmd;
};

void CtrWskdSkmnStep::moveto(
			const usmallint angle
		) {
	Cmd* cmd = getNewCmdMoveto();

	cmd->parsInv["angle"].setUsmallint(angle);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running moveto");
	};

	delete cmd;
};

Cmd* CtrWskdSkmnStep::getNewCmdSet() {
	Cmd* cmd = new Cmd(0x04, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("ccwNotCw", Par::VecVType::_BOOL);
	cmd->addParInv("speed", Par::VecVType::UTINYINT);

	return cmd;
};

void CtrWskdSkmnStep::set(
			const bool rng
			, const bool ccwNotCw
			, const utinyint speed
		) {
	Cmd* cmd = getNewCmdSet();

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["ccwNotCw"].setBool(ccwNotCw);
	cmd->parsInv["speed"].setUtinyint(speed);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running set");
	};

	delete cmd;
};

Cmd* CtrWskdSkmnStep::getNewCmdZero() {
	Cmd* cmd = new Cmd(0x04, VecVCommand::ZERO, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWskdSkmnStep::zero(
		) {
	Cmd* cmd = getNewCmdZero();

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running zero");
	};

	delete cmd;
};

