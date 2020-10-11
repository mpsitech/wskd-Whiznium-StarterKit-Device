/**
	* \file CtrWskdArtyStep.cpp
	* step controller (implementation)
	* \author Catherine Johnson
	* \date created: 6 Oct 2020
	* \date modified: 6 Oct 2020
	*/

#include "CtrWskdArtyStep.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdArtyStep::VecVCommand
 ******************************************************************************/

utinyint CtrWskdArtyStep::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "moveto") return MOVETO;
	else if (s == "set") return SET;
	else if (s == "zero") return ZERO;

	return(0);
};

string CtrWskdArtyStep::VecVCommand::getSref(
			const utinyint tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == MOVETO) return("moveto");
	else if (tix == SET) return("set");
	else if (tix == ZERO) return("zero");

	return("");
};

void CtrWskdArtyStep::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {GETINFO,MOVETO,SET,ZERO};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyStep::VecVState
 ******************************************************************************/

utinyint CtrWskdArtyStep::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "move") return MOVE;

	return(0);
};

string CtrWskdArtyStep::VecVState::getSref(
			const utinyint tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == MOVE) return("move");

	return("");
};

void CtrWskdArtyStep::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {IDLE,MOVE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyStep
 ******************************************************************************/

CtrWskdArtyStep::CtrWskdArtyStep(
			UntWskd* unt
		) : CtrWskd(unt) {
};

utinyint CtrWskdArtyStep::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdArtyStep::getSrefByTixVCommand(
			const utinyint tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdArtyStep::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdArtyStep::getNewCmd(
			const utinyint tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::MOVETO) cmd = getNewCmdMoveto();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();
	else if (tixVCommand == VecVCommand::ZERO) cmd = getNewCmdZero();

	return cmd;
};

Cmd* CtrWskdArtyStep::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(0x06, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWskdArtyStep::VecVState::getTix, CtrWskdArtyStep::VecVState::getSref, CtrWskdArtyStep::VecVState::fillFeed);
	cmd->addParRet("angle", Par::VecVType::USMALLINT);

	return cmd;
};

void CtrWskdArtyStep::getInfo(
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

Cmd* CtrWskdArtyStep::getNewCmdMoveto() {
	Cmd* cmd = new Cmd(0x06, VecVCommand::MOVETO, Cmd::VecVRettype::VOID);

	cmd->addParInv("angle", Par::VecVType::USMALLINT);
	cmd->addParInv("Tstep", Par::VecVType::UTINYINT);

	return cmd;
};

void CtrWskdArtyStep::moveto(
			const usmallint angle
			, const utinyint Tstep
		) {
	Cmd* cmd = getNewCmdMoveto();

	cmd->parsInv["angle"].setUsmallint(angle);
	cmd->parsInv["Tstep"].setUtinyint(Tstep);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running moveto");
	};

	delete cmd;
};

Cmd* CtrWskdArtyStep::getNewCmdSet() {
	Cmd* cmd = new Cmd(0x06, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("ccwNotCw", Par::VecVType::_BOOL);
	cmd->addParInv("Tstep", Par::VecVType::UTINYINT);

	return cmd;
};

void CtrWskdArtyStep::set(
			const bool rng
			, const bool ccwNotCw
			, const utinyint Tstep
		) {
	Cmd* cmd = getNewCmdSet();

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["ccwNotCw"].setBool(ccwNotCw);
	cmd->parsInv["Tstep"].setUtinyint(Tstep);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running set");
	};

	delete cmd;
};

Cmd* CtrWskdArtyStep::getNewCmdZero() {
	Cmd* cmd = new Cmd(0x06, VecVCommand::ZERO, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWskdArtyStep::zero(
		) {
	Cmd* cmd = getNewCmdZero();

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running zero");
	};

	delete cmd;
};

