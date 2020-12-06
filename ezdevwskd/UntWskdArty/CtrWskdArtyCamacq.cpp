/**
	* \file CtrWskdArtyCamacq.cpp
	* camacq controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#include "CtrWskdArtyCamacq.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdArtyCamacq::VecVCommand
 ******************************************************************************/

utinyint CtrWskdArtyCamacq::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "setgrrd") return SETGRRD;
	else if (s == "getgrrdinfo") return GETGRRDINFO;
	else if (s == "setpvw") return SETPVW;
	else if (s == "getpvwinfo") return GETPVWINFO;

	return(0);
};

string CtrWskdArtyCamacq::VecVCommand::getSref(
			const utinyint tix
		) {
	if (tix == SETGRRD) return("setGrrd");
	else if (tix == GETGRRDINFO) return("getGrrdinfo");
	else if (tix == SETPVW) return("setPvw");
	else if (tix == GETPVWINFO) return("getPvwinfo");

	return("");
};

void CtrWskdArtyCamacq::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {SETGRRD,GETGRRDINFO,SETPVW,GETPVWINFO};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyCamacq::VecVGrrdbufstate
 ******************************************************************************/

utinyint CtrWskdArtyCamacq::VecVGrrdbufstate::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "empty") return EMPTY;
	else if (s == "stream") return STREAM;
	else if (s == "pause") return PAUSE;
	else if (s == "endfr") return ENDFR;

	return(0);
};

string CtrWskdArtyCamacq::VecVGrrdbufstate::getSref(
			const utinyint tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == EMPTY) return("empty");
	else if (tix == STREAM) return("stream");
	else if (tix == PAUSE) return("pause");
	else if (tix == ENDFR) return("endfr");

	return("");
};

void CtrWskdArtyCamacq::VecVGrrdbufstate::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {IDLE,EMPTY,STREAM,PAUSE,ENDFR};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyCamacq::VecVPvwbufstate
 ******************************************************************************/

utinyint CtrWskdArtyCamacq::VecVPvwbufstate::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "empty") return EMPTY;
	else if (s == "abuf") return ABUF;
	else if (s == "bbuf") return BBUF;

	return(0);
};

string CtrWskdArtyCamacq::VecVPvwbufstate::getSref(
			const utinyint tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == EMPTY) return("empty");
	else if (tix == ABUF) return("abuf");
	else if (tix == BBUF) return("bbuf");

	return("");
};

void CtrWskdArtyCamacq::VecVPvwbufstate::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {IDLE,EMPTY,ABUF,BBUF};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdArtyCamacq
 ******************************************************************************/

CtrWskdArtyCamacq::CtrWskdArtyCamacq(
			UntWskd* unt
		) : CtrWskd(unt) {
};

utinyint CtrWskdArtyCamacq::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdArtyCamacq::getSrefByTixVCommand(
			const utinyint tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdArtyCamacq::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdArtyCamacq::getNewCmd(
			const utinyint tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::SETGRRD) cmd = getNewCmdSetGrrd();
	else if (tixVCommand == VecVCommand::GETGRRDINFO) cmd = getNewCmdGetGrrdinfo();
	else if (tixVCommand == VecVCommand::SETPVW) cmd = getNewCmdSetPvw();
	else if (tixVCommand == VecVCommand::GETPVWINFO) cmd = getNewCmdGetPvwinfo();

	return cmd;
};

Cmd* CtrWskdArtyCamacq::getNewCmdSetGrrd() {
	Cmd* cmd = new Cmd(0x01, VecVCommand::SETGRRD, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("redNotGray", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWskdArtyCamacq::setGrrd(
			const bool rng
			, const bool redNotGray
		) {
	Cmd* cmd = getNewCmdSetGrrd();

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["redNotGray"].setBool(redNotGray);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setGrrd");
	};

	delete cmd;
};

Cmd* CtrWskdArtyCamacq::getNewCmdGetGrrdinfo() {
	Cmd* cmd = new Cmd(0x01, VecVCommand::GETGRRDINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVGrrdbufstate", Par::VecVType::TIX, CtrWskdArtyCamacq::VecVGrrdbufstate::getTix, CtrWskdArtyCamacq::VecVGrrdbufstate::getSref, CtrWskdArtyCamacq::VecVGrrdbufstate::fillFeed);
	cmd->addParRet("tkst", Par::VecVType::UINT);

	return cmd;
};

void CtrWskdArtyCamacq::getGrrdinfo(
			utinyint& tixVGrrdbufstate
			, uint& tkst
		) {
	Cmd* cmd = getNewCmdGetGrrdinfo();

	if (unt->runCmd(cmd)) {
		tixVGrrdbufstate = cmd->parsRet["tixVGrrdbufstate"].getTix();
		tkst = cmd->parsRet["tkst"].getUint();
	} else {
		delete cmd;
		throw DbeException("error running getGrrdinfo");
	};

	delete cmd;
};

Cmd* CtrWskdArtyCamacq::getNewCmdSetPvw() {
	Cmd* cmd = new Cmd(0x01, VecVCommand::SETPVW, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("rawNotBin", Par::VecVType::_BOOL);
	cmd->addParInv("grayNotRgb", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWskdArtyCamacq::setPvw(
			const bool rng
			, const bool rawNotBin
			, const bool grayNotRgb
		) {
	Cmd* cmd = getNewCmdSetPvw();

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["rawNotBin"].setBool(rawNotBin);
	cmd->parsInv["grayNotRgb"].setBool(grayNotRgb);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setPvw");
	};

	delete cmd;
};

Cmd* CtrWskdArtyCamacq::getNewCmdGetPvwinfo() {
	Cmd* cmd = new Cmd(0x01, VecVCommand::GETPVWINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVPvwbufstate", Par::VecVType::TIX, CtrWskdArtyCamacq::VecVPvwbufstate::getTix, CtrWskdArtyCamacq::VecVPvwbufstate::getSref, CtrWskdArtyCamacq::VecVPvwbufstate::fillFeed);
	cmd->addParRet("tkst", Par::VecVType::UINT);

	return cmd;
};

void CtrWskdArtyCamacq::getPvwinfo(
			utinyint& tixVPvwbufstate
			, uint& tkst
		) {
	Cmd* cmd = getNewCmdGetPvwinfo();

	if (unt->runCmd(cmd)) {
		tixVPvwbufstate = cmd->parsRet["tixVPvwbufstate"].getTix();
		tkst = cmd->parsRet["tkst"].getUint();
	} else {
		delete cmd;
		throw DbeException("error running getPvwinfo");
	};

	delete cmd;
};
