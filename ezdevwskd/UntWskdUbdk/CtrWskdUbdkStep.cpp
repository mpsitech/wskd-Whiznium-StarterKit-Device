/**
	* \file CtrWskdUbdkStep.cpp
	* step controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "CtrWskdUbdkStep.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdUbdkStep::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdUbdkStep::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "moveto") return MOVETO;
	else if (s == "set") return SET;
	else if (s == "zero") return ZERO;

	return(0);
};

string CtrWskdUbdkStep::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == MOVETO) return("moveto");
	else if (tix == SET) return("set");
	else if (tix == ZERO) return("zero");

	return("");
};

void CtrWskdUbdkStep::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETINFO,MOVETO,SET,ZERO};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdUbdkStep::VecVState
 ******************************************************************************/

uint8_t CtrWskdUbdkStep::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "move") return MOVE;

	return(0);
};

string CtrWskdUbdkStep::VecVState::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == MOVE) return("move");

	return("");
};

void CtrWskdUbdkStep::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,MOVE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdUbdkStep
 ******************************************************************************/

CtrWskdUbdkStep::CtrWskdUbdkStep(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdUbdkStep::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdUbdkStep::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdUbdkStep::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdUbdkStep::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::MOVETO) cmd = getNewCmdMoveto();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();
	else if (tixVCommand == VecVCommand::ZERO) cmd = getNewCmdZero();

	return cmd;
};

Cmd* CtrWskdUbdkStep::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(0x05, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWskdUbdkStep::VecVState::getTix, CtrWskdUbdkStep::VecVState::getSref, CtrWskdUbdkStep::VecVState::fillFeed);
	cmd->addParRet("angle", Par::VecVType::UINT16);

	return cmd;
};

void CtrWskdUbdkStep::getInfo(
			uint8_t& tixVState
			, uint16_t& angle
		) {
	Cmd* cmd = getNewCmdGetInfo();

	if (unt->runCmd(cmd)) {
		tixVState = cmd->parsRet["tixVState"].getTix();
		angle = cmd->parsRet["angle"].getUint16();
	} else {
		delete cmd;
		throw DbeException("error running getInfo");
	};

	delete cmd;
};

Cmd* CtrWskdUbdkStep::getNewCmdMoveto() {
	Cmd* cmd = new Cmd(0x05, VecVCommand::MOVETO, Cmd::VecVRettype::VOID);

	cmd->addParInv("angle", Par::VecVType::UINT16);
	cmd->addParInv("Tstep", Par::VecVType::UINT8);

	return cmd;
};

void CtrWskdUbdkStep::moveto(
			const uint16_t angle
			, const uint8_t Tstep
		) {
	Cmd* cmd = getNewCmdMoveto();

	cmd->parsInv["angle"].setUint16(angle);
	cmd->parsInv["Tstep"].setUint8(Tstep);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running moveto");
	};

	delete cmd;
};

Cmd* CtrWskdUbdkStep::getNewCmdSet() {
	Cmd* cmd = new Cmd(0x05, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("ccwNotCw", Par::VecVType::_BOOL);
	cmd->addParInv("Tstep", Par::VecVType::UINT8);

	return cmd;
};

void CtrWskdUbdkStep::set(
			const bool rng
			, const bool ccwNotCw
			, const uint8_t Tstep
		) {
	Cmd* cmd = getNewCmdSet();

	cmd->parsInv["rng"].setBool(rng);
	cmd->parsInv["ccwNotCw"].setBool(ccwNotCw);
	cmd->parsInv["Tstep"].setUint8(Tstep);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running set");
	};

	delete cmd;
};

Cmd* CtrWskdUbdkStep::getNewCmdZero() {
	Cmd* cmd = new Cmd(0x05, VecVCommand::ZERO, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWskdUbdkStep::zero(
		) {
	Cmd* cmd = getNewCmdZero();

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running zero");
	};

	delete cmd;
};
