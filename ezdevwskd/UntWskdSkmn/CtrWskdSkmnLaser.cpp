/**
	* \file CtrWskdSkmnLaser.cpp
	* laser controller (implementation)
	* \author Catherine Johnson
	* \date created: 6 Oct 2020
	* \date modified: 6 Oct 2020
	*/

#include "CtrWskdSkmnLaser.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdSkmnLaser::VecVCommand
 ******************************************************************************/

utinyint CtrWskdSkmnLaser::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "set") return SET;
	else if (s == "setminmax") return SETMINMAX;
	else if (s == "shift") return SHIFT;

	return(0);
};

string CtrWskdSkmnLaser::VecVCommand::getSref(
			const utinyint tix
		) {
	if (tix == SET) return("set");
	else if (tix == SETMINMAX) return("setMinmax");
	else if (tix == SHIFT) return("shift");

	return("");
};

void CtrWskdSkmnLaser::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {SET,SETMINMAX,SHIFT};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdSkmnLaser
 ******************************************************************************/

CtrWskdSkmnLaser::CtrWskdSkmnLaser(
			UntWskd* unt
		) : CtrWskd(unt) {
};

utinyint CtrWskdSkmnLaser::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdSkmnLaser::getSrefByTixVCommand(
			const utinyint tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdSkmnLaser::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdSkmnLaser::getNewCmd(
			const utinyint tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::SET) cmd = getNewCmdSet();
	else if (tixVCommand == VecVCommand::SETMINMAX) cmd = getNewCmdSetMinmax();
	else if (tixVCommand == VecVCommand::SHIFT) cmd = getNewCmdShift();

	return cmd;
};

Cmd* CtrWskdSkmnLaser::getNewCmdSet() {
	Cmd* cmd = new Cmd(0x02, VecVCommand::SET, Cmd::VecVRettype::VOID);

	cmd->addParInv("Tfrm", Par::VecVType::UINT);
	cmd->addParInv("rngL", Par::VecVType::_BOOL);
	cmd->addParInv("seqL", Par::VecVType::VBLOB, NULL, NULL, NULL, 32);
	cmd->addParInv("rngR", Par::VecVType::_BOOL);
	cmd->addParInv("seqR", Par::VecVType::VBLOB, NULL, NULL, NULL, 32);

	return cmd;
};

void CtrWskdSkmnLaser::set(
			const uint Tfrm
			, const bool rngL
			, const unsigned char* seqL
			, const size_t seqLlen
			, const bool rngR
			, const unsigned char* seqR
			, const size_t seqRlen
		) {
	Cmd* cmd = getNewCmdSet();

	cmd->parsInv["Tfrm"].setUint(Tfrm);
	cmd->parsInv["rngL"].setBool(rngL);
	cmd->parsInv["seqL"].setVblob(seqL, seqLlen);
	cmd->parsInv["rngR"].setBool(rngR);
	cmd->parsInv["seqR"].setVblob(seqR, seqRlen);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running set");
	};

	delete cmd;
};

Cmd* CtrWskdSkmnLaser::getNewCmdSetMinmax() {
	Cmd* cmd = new Cmd(0x02, VecVCommand::SETMINMAX, Cmd::VecVRettype::VOID);

	cmd->addParInv("minL", Par::VecVType::UTINYINT);
	cmd->addParInv("maxL", Par::VecVType::UTINYINT);
	cmd->addParInv("minR", Par::VecVType::UTINYINT);
	cmd->addParInv("maxR", Par::VecVType::UTINYINT);

	return cmd;
};

void CtrWskdSkmnLaser::setMinmax(
			const utinyint minL
			, const utinyint maxL
			, const utinyint minR
			, const utinyint maxR
		) {
	Cmd* cmd = getNewCmdSetMinmax();

	cmd->parsInv["minL"].setUtinyint(minL);
	cmd->parsInv["maxL"].setUtinyint(maxL);
	cmd->parsInv["minR"].setUtinyint(minR);
	cmd->parsInv["maxR"].setUtinyint(maxR);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running setMinmax");
	};

	delete cmd;
};

Cmd* CtrWskdSkmnLaser::getNewCmdShift() {
	Cmd* cmd = new Cmd(0x02, VecVCommand::SHIFT, Cmd::VecVRettype::VOID);

	cmd->addParRet("dt", Par::VecVType::INT);

	return cmd;
};

void CtrWskdSkmnLaser::shift(
			int& dt
		) {
	Cmd* cmd = getNewCmdShift();

	if (unt->runCmd(cmd)) {
		dt = cmd->parsRet["dt"].getInt();
	} else {
		delete cmd;
		throw DbeException("error running shift");
	};

	delete cmd;
};

