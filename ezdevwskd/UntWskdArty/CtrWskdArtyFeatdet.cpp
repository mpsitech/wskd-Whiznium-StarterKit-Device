/**
	* \file CtrWskdArtyFeatdet.cpp
	* featdet controller (implementation)
	* \author Catherine Johnson
	* \date created: 6 Oct 2020
	* \date modified: 6 Oct 2020
	*/

#include "CtrWskdArtyFeatdet.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdArtyFeatdet::VecVCommand
 ******************************************************************************/

utinyint CtrWskdArtyFeatdet::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "set") return SET;
	else if (s == "getinfo") return GETINFO;
	else if (s == "getcornerinfo") return GETCORNERINFO;
	else if (s == "setcorner") return SETCORNER;
	else if (s == "setthd") return SETTHD;
	else if (s == "triggerthd") return TRIGGERTHD;

	return(0);
};

string CtrWskdArtyFeatdet::VecVCommand::getSref(
			const utinyint tix
		) {
	if (tix == SET) return("set");
	else if (tix == GETINFO) return("getInfo");
	else if (tix == GETCORNERINFO) return("getCornerinfo");
	else if (tix == SETCORNER) return("setCorner");
	else if (tix == SETTHD) return("setThd");
	else if (tix == TRIGGERTHD) return("triggerThd");

	return("");
};

void CtrWskdArtyFeatdet::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {SET,GETINFO,GETCORNERINFO,SETCORNER,SETTHD,TRIGGERTHD};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyFeatdet::VecVFlgbufstate
 ******************************************************************************/

utinyint CtrWskdArtyFeatdet::VecVFlgbufstate::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "empty") return EMPTY;
	else if (s == "full") return FULL;

	return(0);
};

string CtrWskdArtyFeatdet::VecVFlgbufstate::getSref(
			const utinyint tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == EMPTY) return("empty");
	else if (tix == FULL) return("full");

	return("");
};

void CtrWskdArtyFeatdet::VecVFlgbufstate::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {IDLE,EMPTY,FULL};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyFeatdet::VecVThdstate
 ******************************************************************************/

utinyint CtrWskdArtyFeatdet::VecVThdstate::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "waitfirst") return WAITFIRST;
	else if (s == "waitsecond") return WAITSECOND;
	else if (s == "done") return DONE;

	return(0);
};

string CtrWskdArtyFeatdet::VecVThdstate::getSref(
			const utinyint tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == WAITFIRST) return("waitfirst");
	else if (tix == WAITSECOND) return("waitsecond");
	else if (tix == DONE) return("done");

	return("");
};

void CtrWskdArtyFeatdet::VecVThdstate::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {IDLE,WAITFIRST,WAITSECOND,DONE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyFeatdet
 ******************************************************************************/

CtrWskdArtyFeatdet::CtrWskdArtyFeatdet(
			UntWskd* unt
		) : CtrWskd(unt) {
};

utinyint CtrWskdArtyFeatdet::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdArtyFeatdet::getSrefByTixVCommand(
			const utinyint tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdArtyFeatdet::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdArtyFeatdet::getNewCmd(
			const utinyint tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();
	else if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::GETCORNERINFO) cmd = getNewCmdGetCornerinfo();
	else if (tixVCommand == VecVCommand::SETCORNER) cmd = getNewCmdSetCorner();
	else if (tixVCommand == VecVCommand::SETTHD) cmd = getNewCmdSetThd();
	else if (tixVCommand == VecVCommand::TRIGGERTHD) cmd = getNewCmdTriggerThd();

	return cmd;
};

Cmd* CtrWskdArtyFeatdet::getNewCmdSet() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("thdNotCorner", Par::VecVType::_BOOL);
	cmd->addParInv("thdDeltaNotAbs", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWskdArtyFeatdet::set(
			const bool rng
			, const bool thdNotCorner
			, const bool thdDeltaNotAbs
		) {
	Cmd* cmd = getNewCmdSet();

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["thdNotCorner"].setBool(thdNotCorner);
	cmd->parsInv["thdDeltaNotAbs"].setBool(thdDeltaNotAbs);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running set");
	};

	delete cmd;
};

Cmd* CtrWskdArtyFeatdet::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVFlgbufstate", Par::VecVType::TIX, CtrWskdArtyFeatdet::VecVFlgbufstate::getTix, CtrWskdArtyFeatdet::VecVFlgbufstate::getSref, CtrWskdArtyFeatdet::VecVFlgbufstate::fillFeed);
	cmd->addParRet("tixVThdstate", Par::VecVType::TIX, CtrWskdArtyFeatdet::VecVThdstate::getTix, CtrWskdArtyFeatdet::VecVThdstate::getSref, CtrWskdArtyFeatdet::VecVThdstate::fillFeed);
	cmd->addParRet("tkst", Par::VecVType::UINT);

	return cmd;
};

void CtrWskdArtyFeatdet::getInfo(
			utinyint& tixVFlgbufstate
			, utinyint& tixVThdstate
			, uint& tkst
		) {
	Cmd* cmd = getNewCmdGetInfo();

	if (unt->runCmd(cmd)) {
		tixVFlgbufstate = cmd->parsRet["tixVFlgbufstate"].getTix();
		tixVThdstate = cmd->parsRet["tixVThdstate"].getTix();
		tkst = cmd->parsRet["tkst"].getUint();
	} else {
		delete cmd;
		throw DbeException("error running getInfo");
	};

	delete cmd;
};

Cmd* CtrWskdArtyFeatdet::getNewCmdGetCornerinfo() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::GETCORNERINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("shift", Par::VecVType::UTINYINT);
	cmd->addParRet("scoreMin", Par::VecVType::UTINYINT);
	cmd->addParRet("scoreMax", Par::VecVType::UTINYINT);

	return cmd;
};

void CtrWskdArtyFeatdet::getCornerinfo(
			utinyint& shift
			, utinyint& scoreMin
			, utinyint& scoreMax
		) {
	Cmd* cmd = getNewCmdGetCornerinfo();

	if (unt->runCmd(cmd)) {
		shift = cmd->parsRet["shift"].getUtinyint();
		scoreMin = cmd->parsRet["scoreMin"].getUtinyint();
		scoreMax = cmd->parsRet["scoreMax"].getUtinyint();
	} else {
		delete cmd;
		throw DbeException("error running getCornerinfo");
	};

	delete cmd;
};

Cmd* CtrWskdArtyFeatdet::getNewCmdSetCorner() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::SETCORNER, Cmd::VecVRettype::VOID);

	cmd->addParInv("linNotLog", Par::VecVType::_BOOL);
	cmd->addParInv("thd", Par::VecVType::UTINYINT);

	return cmd;
};

void CtrWskdArtyFeatdet::setCorner(
			const bool linNotLog
			, const utinyint thd
		) {
	Cmd* cmd = getNewCmdSetCorner();

	cmd->parsInv["linNotLog"].setBool(linNotLog);
	cmd->parsInv["thd"].setUtinyint(thd);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setCorner");
	};

	delete cmd;
};

Cmd* CtrWskdArtyFeatdet::getNewCmdSetThd() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::SETTHD, Cmd::VecVRettype::VOID);

	cmd->addParInv("lvlFirst", Par::VecVType::UTINYINT);
	cmd->addParInv("lvlSecond", Par::VecVType::UTINYINT);

	return cmd;
};

void CtrWskdArtyFeatdet::setThd(
			const utinyint lvlFirst
			, const utinyint lvlSecond
		) {
	Cmd* cmd = getNewCmdSetThd();

	cmd->parsInv["lvlFirst"].setUtinyint(lvlFirst);
	cmd->parsInv["lvlSecond"].setUtinyint(lvlSecond);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setThd");
	};

	delete cmd;
};

Cmd* CtrWskdArtyFeatdet::getNewCmdTriggerThd() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::TRIGGERTHD, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWskdArtyFeatdet::triggerThd(
		) {
	Cmd* cmd = getNewCmdTriggerThd();

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running triggerThd");
	};

	delete cmd;
};

