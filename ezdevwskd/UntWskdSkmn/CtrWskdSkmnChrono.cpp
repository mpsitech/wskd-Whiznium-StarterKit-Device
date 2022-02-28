/**
	* \file CtrWskdSkmnChrono.cpp
	* chrono controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#include "CtrWskdSkmnChrono.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdSkmnChrono::VecVCommand
 ******************************************************************************/

utinyint CtrWskdSkmnChrono::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "gettst") return GETTST;

	return(0);
};

string CtrWskdSkmnChrono::VecVCommand::getSref(
			const utinyint tix
		) {
	if (tix == GETTST) return("getTst");

	return("");
};

void CtrWskdSkmnChrono::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {GETTST};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdSkmnChrono
 ******************************************************************************/

CtrWskdSkmnChrono::CtrWskdSkmnChrono(
			UntWskd* unt
		) : CtrWskd(unt) {
};

utinyint CtrWskdSkmnChrono::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdSkmnChrono::getSrefByTixVCommand(
			const utinyint tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdSkmnChrono::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdSkmnChrono::getNewCmd(
			const utinyint tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GETTST) cmd = getNewCmdGetTst();

	return cmd;
};

Cmd* CtrWskdSkmnChrono::getNewCmdGetTst() {
	Cmd* cmd = new Cmd(0x01, VecVCommand::GETTST, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tst", Par::VecVType::UINT);

	return cmd;
};

void CtrWskdSkmnChrono::getTst(
			uint& tst
		) {
	Cmd* cmd = getNewCmdGetTst();

	if (unt->runCmd(cmd)) {
		tst = cmd->parsRet["tst"].getUint();
	} else {
		delete cmd;
		throw DbeException("error running getTst");
	};

	delete cmd;
};
