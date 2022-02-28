/**
	* \file CtrWskdIcicleStep.cpp
	* step controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#include "CtrWskdIcicleStep.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdIcicleStep::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdIcicleStep::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "getinfo") return GETINFO;
	else if (s == "moveto") return MOVETO;
	else if (s == "set") return SET;
	else if (s == "zero") return ZERO;

	return(0);
};

string CtrWskdIcicleStep::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GETINFO) return("getInfo");
	else if (tix == MOVETO) return("moveto");
	else if (tix == SET) return("set");
	else if (tix == ZERO) return("zero");

	return("");
};

void CtrWskdIcicleStep::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GETINFO,MOVETO,SET,ZERO};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcicleStep::VecVState
 ******************************************************************************/

uint8_t CtrWskdIcicleStep::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "move") return MOVE;

	return(0);
};

string CtrWskdIcicleStep::VecVState::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == MOVE) return("move");

	return("");
};

void CtrWskdIcicleStep::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,MOVE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcicleStep
 ******************************************************************************/

CtrWskdIcicleStep::CtrWskdIcicleStep(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdIcicleStep::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdIcicleStep::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdIcicleStep::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdIcicleStep::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETINFO) cmd = getNewCmdGetInfo();
	else if (tixVCommand == VecVCommand::MOVETO) cmd = getNewCmdMoveto();
	else if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();
	else if (tixVCommand == VecVCommand::ZERO) cmd = getNewCmdZero();

	return cmd;
};

Cmd* CtrWskdIcicleStep::getNewCmdGetInfo() {
	Cmd* cmd = new Cmd(0x06, VecVCommand::GETINFO, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWskdIcicleStep::VecVState::getTix, CtrWskdIcicleStep::VecVState::getSref, CtrWskdIcicleStep::VecVState::fillFeed);
	cmd->addParRet("angle", Par::VecVType::UINT16);

	return cmd;
};

void CtrWskdIcicleStep::getInfo(
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

Cmd* CtrWskdIcicleStep::getNewCmdMoveto() {
	Cmd* cmd = new Cmd(0x06, VecVCommand::MOVETO, Cmd::VecVRettype::VOID);

	cmd->addParInv("angle", Par::VecVType::UINT16);
	cmd->addParInv("Tstep", Par::VecVType::UINT8);

	return cmd;
};

void CtrWskdIcicleStep::moveto(
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

Cmd* CtrWskdIcicleStep::getNewCmdSet() {
	Cmd* cmd = new Cmd(0x06, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);
	cmd->addParInv("ccwNotCw", Par::VecVType::_BOOL);
	cmd->addParInv("Tstep", Par::VecVType::UINT8);

	return cmd;
};

void CtrWskdIcicleStep::set(
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

Cmd* CtrWskdIcicleStep::getNewCmdZero() {
	Cmd* cmd = new Cmd(0x06, VecVCommand::ZERO, Cmd::VecVRettype::VOID);

	return cmd;
};

void CtrWskdIcicleStep::zero(
		) {
	Cmd* cmd = getNewCmdZero();

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running zero");
	};

	delete cmd;
};
