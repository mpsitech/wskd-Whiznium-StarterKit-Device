/**
	* \file CtrWskdIcclCamacq.cpp
	* camacq controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 23 Oct 2021
	*/
// IP header --- ABOVE

#include "CtrWskdIcclCamacq.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdIcclCamacq::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdIcclCamacq::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "setgrrd") return SETGRRD;
	else if (s == "getgrrdinfo") return GETGRRDINFO;
	else if (s == "setpvw") return SETPVW;
	else if (s == "getpvwinfo") return GETPVWINFO;

	return(0);
};

string CtrWskdIcclCamacq::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == SETGRRD) return("setGrrd");
	else if (tix == GETGRRDINFO) return("getGrrdinfo");
	else if (tix == SETPVW) return("setPvw");
	else if (tix == GETPVWINFO) return("getPvwinfo");

	return("");
};

void CtrWskdIcclCamacq::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {SETGRRD,GETGRRDINFO,SETPVW,GETPVWINFO};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcclCamacq::VecVGrrdbufstate
 ******************************************************************************/

uint8_t CtrWskdIcclCamacq::VecVGrrdbufstate::getTix(
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

string CtrWskdIcclCamacq::VecVGrrdbufstate::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == EMPTY) return("empty");
	else if (tix == STREAM) return("stream");
	else if (tix == PAUSE) return("pause");
	else if (tix == ENDFR) return("endfr");

	return("");
};

void CtrWskdIcclCamacq::VecVGrrdbufstate::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,EMPTY,STREAM,PAUSE,ENDFR};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcclCamacq::VecVPvwbufstate
 ******************************************************************************/

uint8_t CtrWskdIcclCamacq::VecVPvwbufstate::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "empty") return EMPTY;
	else if (s == "abuf") return ABUF;
	else if (s == "bbuf") return BBUF;

	return(0);
};

string CtrWskdIcclCamacq::VecVPvwbufstate::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == EMPTY) return("empty");
	else if (tix == ABUF) return("abuf");
	else if (tix == BBUF) return("bbuf");

	return("");
};

void CtrWskdIcclCamacq::VecVPvwbufstate::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,EMPTY,ABUF,BBUF};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcclCamacq
 ******************************************************************************/

CtrWskdIcclCamacq::CtrWskdIcclCamacq(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdIcclCamacq::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdIcclCamacq::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdIcclCamacq::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdIcclCamacq::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::SETGRRD) cmd = getNewCmdSetGrrd();
	else if (tixVCommand == VecVCommand::GETGRRDINFO) cmd = getNewCmdGetGrrdinfo();
	else if (tixVCommand == VecVCommand::SETPVW) cmd = getNewCmdSetPvw();
	else if (tixVCommand == VecVCommand::GETPVWINFO) cmd = getNewCmdGetPvwinfo();

	return cmd;
};

Cmd* CtrWskdIcclCamacq::getNewCmdSetGrrd() {
	Cmd* cmd = new Cmd(0x01, VecVCommand::SETGRRD, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("redNotGray", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWskdIcclCamacq::setGrrd(
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

Cmd* CtrWskdIcclCamacq::getNewCmdGetGrrdinfo() {
	Cmd* cmd = new Cmd(0x01, VecVCommand::GETGRRDINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVGrrdbufstate", Par::VecVType::TIX, CtrWskdIcclCamacq::VecVGrrdbufstate::getTix, CtrWskdIcclCamacq::VecVGrrdbufstate::getSref, CtrWskdIcclCamacq::VecVGrrdbufstate::fillFeed);
	cmd->addParRet("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWskdIcclCamacq::getGrrdinfo(
			uint8_t& tixVGrrdbufstate
			, uint32_t& tkst
		) {
	Cmd* cmd = getNewCmdGetGrrdinfo();

	if (unt->runCmd(cmd)) {
		tixVGrrdbufstate = cmd->parsRet["tixVGrrdbufstate"].getTix();
		tkst = cmd->parsRet["tkst"].getUint32();
	} else {
		delete cmd;
		throw DbeException("error running getGrrdinfo");
	};

	delete cmd;
};

Cmd* CtrWskdIcclCamacq::getNewCmdSetPvw() {
	Cmd* cmd = new Cmd(0x01, VecVCommand::SETPVW, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("rawNotBin", Par::VecVType::_BOOL);
	cmd->addParInv("grayNotRgb", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWskdIcclCamacq::setPvw(
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

Cmd* CtrWskdIcclCamacq::getNewCmdGetPvwinfo() {
	Cmd* cmd = new Cmd(0x01, VecVCommand::GETPVWINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVPvwbufstate", Par::VecVType::TIX, CtrWskdIcclCamacq::VecVPvwbufstate::getTix, CtrWskdIcclCamacq::VecVPvwbufstate::getSref, CtrWskdIcclCamacq::VecVPvwbufstate::fillFeed);
	cmd->addParRet("tkst", Par::VecVType::UINT32);

	return cmd;
};

void CtrWskdIcclCamacq::getPvwinfo(
			uint8_t& tixVPvwbufstate
			, uint32_t& tkst
		) {
	Cmd* cmd = getNewCmdGetPvwinfo();

	if (unt->runCmd(cmd)) {
		tixVPvwbufstate = cmd->parsRet["tixVPvwbufstate"].getTix();
		tkst = cmd->parsRet["tkst"].getUint32();
	} else {
		delete cmd;
		throw DbeException("error running getPvwinfo");
	};

	delete cmd;
};
