/**
	* \file CtrWskdIcclFeatdet.cpp
	* featdet controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 23 Oct 2021
	*/
// IP header --- ABOVE

#include "CtrWskdIcclFeatdet.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdIcclFeatdet::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdIcclFeatdet::VecVCommand::getTix(
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

string CtrWskdIcclFeatdet::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == SET) return("set");
	else if (tix == GETINFO) return("getInfo");
	else if (tix == GETCORNERINFO) return("getCornerinfo");
	else if (tix == SETCORNER) return("setCorner");
	else if (tix == SETTHD) return("setThd");
	else if (tix == TRIGGERTHD) return("triggerThd");

	return("");
};

void CtrWskdIcclFeatdet::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {SET,GETINFO,GETCORNERINFO,SETCORNER,SETTHD,TRIGGERTHD};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcclFeatdet::VecVFlgbufstate
 ******************************************************************************/

uint8_t CtrWskdIcclFeatdet::VecVFlgbufstate::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "empty") return EMPTY;
	else if (s == "full") return FULL;

	return(0);
};

string CtrWskdIcclFeatdet::VecVFlgbufstate::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == EMPTY) return("empty");
	else if (tix == FULL) return("full");

	return("");
};

void CtrWskdIcclFeatdet::VecVFlgbufstate::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,EMPTY,FULL};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcclFeatdet::VecVThdstate
 ******************************************************************************/

uint8_t CtrWskdIcclFeatdet::VecVThdstate::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "waitfirst") return WAITFIRST;
	else if (s == "waitsecond") return WAITSECOND;
	else if (s == "done") return DONE;

	return(0);
};

string CtrWskdIcclFeatdet::VecVThdstate::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == WAITFIRST) return("waitfirst");
	else if (tix == WAITSECOND) return("waitsecond");
	else if (tix == DONE) return("done");

	return("");
};

void CtrWskdIcclFeatdet::VecVThdstate::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,WAITFIRST,WAITSECOND,DONE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcclFeatdet
 ******************************************************************************/

CtrWskdIcclFeatdet::CtrWskdIcclFeatdet(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdIcclFeatdet::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdIcclFeatdet::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdIcclFeatdet::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdIcclFeatdet::getNewCmd(
			const uint8_t tixVCommand
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

Cmd* CtrWskdIcclFeatdet::getNewCmdSet() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("thdNotCorner", Par::VecVType::_BOOL);
	cmd->addParInv("thdDeltaNotAbs", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWskdIcclFeatdet::set(
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

Cmd* CtrWskdIcclFeatdet::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVFlgbufstate", Par::VecVType::TIX, CtrWskdIcclFeatdet::VecVFlgbufstate::getTix, CtrWskdIcclFeatdet::VecVFlgbufstate::getSref, CtrWskdIcclFeatdet::VecVFlgbufstate::fillFeed);
	cmd->addParRet("tixVThdstate", Par::VecVType::TIX, CtrWskdIcclFeatdet::VecVThdstate::getTix, CtrWskdIcclFeatdet::VecVThdstate::getSref, CtrWskdIcclFeatdet::VecVThdstate::fillFeed);
	cmd->addParRet("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWskdIcclFeatdet::getInfo(
			uint8_t& tixVFlgbufstate
			, uint8_t& tixVThdstate
			, uint32_t& tkst
		) {
	Cmd* cmd = getNewCmdGetInfo();

	if (unt->runCmd(cmd)) {
		tixVFlgbufstate = cmd->parsRet["tixVFlgbufstate"].getTix();
		tixVThdstate = cmd->parsRet["tixVThdstate"].getTix();
		tkst = cmd->parsRet["tkst"].getUint32();
	} else {
		delete cmd;
		throw DbeException("error running getInfo");
	};

	delete cmd;
};

Cmd* CtrWskdIcclFeatdet::getNewCmdGetCornerinfo() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::GETCORNERINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("shift", Par::VecVType::UINT8);
	cmd->addParRet("scoreMin", Par::VecVType::UINT8);
	cmd->addParRet("scoreMax", Par::VecVType::UINT8);

	return cmd;
};

void CtrWskdIcclFeatdet::getCornerinfo(
			uint8_t& shift
			, uint8_t& scoreMin
			, uint8_t& scoreMax
		) {
	Cmd* cmd = getNewCmdGetCornerinfo();

	if (unt->runCmd(cmd)) {
		shift = cmd->parsRet["shift"].getUint8();
		scoreMin = cmd->parsRet["scoreMin"].getUint8();
		scoreMax = cmd->parsRet["scoreMax"].getUint8();
	} else {
		delete cmd;
		throw DbeException("error running getCornerinfo");
	};

	delete cmd;
};

Cmd* CtrWskdIcclFeatdet::getNewCmdSetCorner() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::SETCORNER, Cmd::VecVRettype::VOID);

	cmd->addParInv("linNotLog", Par::VecVType::_BOOL);
	cmd->addParInv("thd", Par::VecVType::UINT8);

	return cmd;
};

void CtrWskdIcclFeatdet::setCorner(
			const bool linNotLog
			, const uint8_t thd
		) {
	Cmd* cmd = getNewCmdSetCorner();

	cmd->parsInv["linNotLog"].setBool(linNotLog);
	cmd->parsInv["thd"].setUint8(thd);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setCorner");
	};

	delete cmd;
};

Cmd* CtrWskdIcclFeatdet::getNewCmdSetThd() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::SETTHD, Cmd::VecVRettype::VOID);

	cmd->addParInv("lvlFirst", Par::VecVType::UINT8);
	cmd->addParInv("lvlSecond", Par::VecVType::UINT8);

	return cmd;
};

void CtrWskdIcclFeatdet::setThd(
			const uint8_t lvlFirst
			, const uint8_t lvlSecond
		) {
	Cmd* cmd = getNewCmdSetThd();

	cmd->parsInv["lvlFirst"].setUint8(lvlFirst);
	cmd->parsInv["lvlSecond"].setUint8(lvlSecond);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setThd");
	};

	delete cmd;
};

Cmd* CtrWskdIcclFeatdet::getNewCmdTriggerThd() {
	Cmd* cmd = new Cmd(0x03, VecVCommand::TRIGGERTHD, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWskdIcclFeatdet::triggerThd(
		) {
	Cmd* cmd = getNewCmdTriggerThd();

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running triggerThd");
	};

	delete cmd;
};
