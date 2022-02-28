/**
	* \file CtrWskdIcicleCamif.cpp
	* camif controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#include "CtrWskdIcicleCamif.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdIcicleCamif::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdIcicleCamif::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "setrng") return SETRNG;
	else if (s == "setreg") return SETREG;
	else if (s == "setregaddr") return SETREGADDR;
	else if (s == "getreg") return GETREG;
	else if (s == "modreg") return MODREG;

	return(0);
};

string CtrWskdIcicleCamif::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == SETRNG) return("setRng");
	else if (tix == SETREG) return("setReg");
	else if (tix == SETREGADDR) return("setRegaddr");
	else if (tix == GETREG) return("getReg");
	else if (tix == MODREG) return("modReg");

	return("");
};

void CtrWskdIcicleCamif::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {SETRNG,SETREG,SETREGADDR,GETREG,MODREG};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcicleCamif
 ******************************************************************************/

CtrWskdIcicleCamif::CtrWskdIcicleCamif(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdIcicleCamif::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdIcicleCamif::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdIcicleCamif::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdIcicleCamif::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::SETRNG) cmd = getNewCmdSetRng();
	else if (tixVCommand == VecVCommand::SETREG) cmd = getNewCmdSetReg();
	else if (tixVCommand == VecVCommand::SETREGADDR) cmd = getNewCmdSetRegaddr();
	else if (tixVCommand == VecVCommand::GETREG) cmd = getNewCmdGetReg();
	else if (tixVCommand == VecVCommand::MODREG) cmd = getNewCmdModReg();

	return cmd;
};

Cmd* CtrWskdIcicleCamif::getNewCmdSetRng() {
	Cmd* cmd = new Cmd(0x02, VecVCommand::SETRNG, Cmd::VecVRettype::VOID);

	cmd->addParInv("rng", Par::VecVType::_BOOL);

	return cmd;
};

void CtrWskdIcicleCamif::setRng(
			const bool rng
		) {
	Cmd* cmd = getNewCmdSetRng();

	cmd->parsInv["rng"].setBool(rng);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setRng");
	};

	delete cmd;
};

Cmd* CtrWskdIcicleCamif::getNewCmdSetReg() {
	Cmd* cmd = new Cmd(0x02, VecVCommand::SETREG, Cmd::VecVRettype::VOID);

	cmd->addParInv("addr", Par::VecVType::UINT16);
	cmd->addParInv("val", Par::VecVType::UINT8);

	return cmd;
};

void CtrWskdIcicleCamif::setReg(
			const uint16_t addr
			, const uint8_t val
		) {
	Cmd* cmd = getNewCmdSetReg();

	cmd->parsInv["addr"].setUint16(addr);
	cmd->parsInv["val"].setUint8(val);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setReg");
	};

	delete cmd;
};

Cmd* CtrWskdIcicleCamif::getNewCmdSetRegaddr() {
	Cmd* cmd = new Cmd(0x02, VecVCommand::SETREGADDR, Cmd::VecVRettype::VOID);

	cmd->addParInv("addr", Par::VecVType::UINT16);

	return cmd;
};

void CtrWskdIcicleCamif::setRegaddr(
			const uint16_t addr
		) {
	Cmd* cmd = getNewCmdSetRegaddr();

	cmd->parsInv["addr"].setUint16(addr);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setRegaddr");
	};

	delete cmd;
};

Cmd* CtrWskdIcicleCamif::getNewCmdGetReg() {
	Cmd* cmd = new Cmd(0x02, VecVCommand::GETREG, Cmd::VecVRettype::IMMSNG);

	cmd->addParRet("val", Par::VecVType::UINT8);

	return cmd;
};

void CtrWskdIcicleCamif::getReg(
			uint8_t& val
		) {
	Cmd* cmd = getNewCmdGetReg();

	if (unt->runCmd(cmd)) {
		val = cmd->parsRet["val"].getUint8();
	} else {
		delete cmd;
		throw DbeException("error running getReg");
	};

	delete cmd;
};

Cmd* CtrWskdIcicleCamif::getNewCmdModReg() {
	Cmd* cmd = new Cmd(0x02, VecVCommand::MODREG, Cmd::VecVRettype::VOID);

	cmd->addParInv("addr", Par::VecVType::UINT16);
	cmd->addParInv("mask", Par::VecVType::UINT8);
	cmd->addParInv("val", Par::VecVType::UINT8);

	return cmd;
};

void CtrWskdIcicleCamif::modReg(
			const uint16_t addr
			, const uint8_t mask
			, const uint8_t val
		) {
	Cmd* cmd = getNewCmdModReg();

	cmd->parsInv["addr"].setUint16(addr);
	cmd->parsInv["mask"].setUint8(mask);
	cmd->parsInv["val"].setUint8(val);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running modReg");
	};

	delete cmd;
};
