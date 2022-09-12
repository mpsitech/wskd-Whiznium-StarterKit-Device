/**
	* \file CtrWskdIcclPwmonif.cpp
	* pwmonif controller (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 8 Jun 2022
	*/
// IP header --- ABOVE

#include "CtrWskdIcclPwmonif.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class CtrWskdIcclPwmonif::VecVCommand
 ******************************************************************************/

uint8_t CtrWskdIcclPwmonif::VecVCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "get") return GET;
	else if (s == "rx") return RX;
	else if (s == "tx") return TX;
	else if (s == "txrx") return TXRX;

	return(0);
};

string CtrWskdIcclPwmonif::VecVCommand::getSref(
			const uint8_t tix
		) {
	if (tix == GET) return("get");
	else if (tix == RX) return("rx");
	else if (tix == TX) return("tx");
	else if (tix == TXRX) return("txrx");

	return("");
};

void CtrWskdIcclPwmonif::VecVCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {GET,RX,TX,TXRX};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 class CtrWskdIcclPwmonif::VecVState
 ******************************************************************************/

uint8_t CtrWskdIcclPwmonif::VecVState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "idle") return IDLE;
	else if (s == "tx") return TX;
	else if (s == "rx") return RX;
	else if (s == "done") return DONE;
	else if (s == "to") return TO;

	return(0);
};

string CtrWskdIcclPwmonif::VecVState::getSref(
			const uint8_t tix
		) {
	if (tix == IDLE) return("idle");
	else if (tix == TX) return("tx");
	else if (tix == RX) return("rx");
	else if (tix == DONE) return("done");
	else if (tix == TO) return("to");

	return("");
};

string CtrWskdIcclPwmonif::VecVState::getTitle(
			const uint8_t tix
		) {
	return(getSref(tix));

	return("");
};

void CtrWskdIcclPwmonif::VecVState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {IDLE,TX,RX,DONE,TO};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 class CtrWskdIcclPwmonif
 ******************************************************************************/

CtrWskdIcclPwmonif::CtrWskdIcclPwmonif(
			UntWskd* unt
		) : CtrWskd(unt) {
};

uint8_t CtrWskdIcclPwmonif::getTixVCommandBySref(
			const string& sref
		) {
	return VecVCommand::getTix(sref);
};

string CtrWskdIcclPwmonif::getSrefByTixVCommand(
			const uint8_t tixVCommand
		) {
	return VecVCommand::getSref(tixVCommand);
};

void CtrWskdIcclPwmonif::fillFeedFCommand(
			Feed& feed
		) {
	VecVCommand::fillFeed(feed);
};

Cmd* CtrWskdIcclPwmonif::getNewCmd(
			const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVCommand == VecVCommand::GET) cmd = getNewCmdGet();
	else if (tixVCommand == VecVCommand::RX) cmd = getNewCmdRx();
	else if (tixVCommand == VecVCommand::TX) cmd = getNewCmdTx();
	else if (tixVCommand == VecVCommand::TXRX) cmd = getNewCmdTxrx();

	return cmd;
};

Cmd* CtrWskdIcclPwmonif::getNewCmdGet() {
	Cmd* cmd = new Cmd(0x05, VecVCommand::GET, Cmd::VecVRettype::STATSNG);

	cmd->addParRet("tixVState", Par::VecVType::TIX, CtrWskdIcclPwmonif::VecVState::getTix, CtrWskdIcclPwmonif::VecVState::getSref, CtrWskdIcclPwmonif::VecVState::fillFeed);
	cmd->addParRet("rxleft", Par::VecVType::UINT8);
	cmd->addParRet("rxdata", Par::VecVType::VBLOB, NULL, NULL, NULL, 32);

	return cmd;
};

void CtrWskdIcclPwmonif::get(
			uint8_t& tixVState
			, uint8_t& rxleft
			, unsigned char*& rxdata
			, size_t& rxdatalen
		) {
	Cmd* cmd = getNewCmdGet();

	if (unt->runCmd(cmd)) {
		tixVState = cmd->parsRet["tixVState"].getTix();
		rxleft = cmd->parsRet["rxleft"].getUint8();
		rxdata = cmd->parsRet["rxdata"].getVblob();
		rxdatalen = cmd->parsRet["rxdata"].getLen();
	} else {
		delete cmd;
		throw DbeException("error running get");
	};

	delete cmd;
};

Cmd* CtrWskdIcclPwmonif::getNewCmdRx() {
	Cmd* cmd = new Cmd(0x05, VecVCommand::RX, Cmd::VecVRettype::VOID);

	cmd->addParInv("len", Par::VecVType::UINT8);
	cmd->addParInv("to", Par::VecVType::UINT16);

	return cmd;
};

void CtrWskdIcclPwmonif::rx(
			const uint8_t len
			, const uint16_t to
		) {
	Cmd* cmd = getNewCmdRx();

	cmd->parsInv["len"].setUint8(len);
	cmd->parsInv["to"].setUint16(to);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running rx");
	};

	delete cmd;
};

Cmd* CtrWskdIcclPwmonif::getNewCmdTx() {
	Cmd* cmd = new Cmd(0x05, VecVCommand::TX, Cmd::VecVRettype::VOID);

	cmd->addParInv("data", Par::VecVType::VBLOB, NULL, NULL, NULL, 32);

	return cmd;
};

void CtrWskdIcclPwmonif::tx(
			const unsigned char* data
			, const size_t datalen
		) {
	Cmd* cmd = getNewCmdTx();

	cmd->parsInv["data"].setVblob(data, datalen);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running tx");
	};

	delete cmd;
};

Cmd* CtrWskdIcclPwmonif::getNewCmdTxrx() {
	Cmd* cmd = new Cmd(0x05, VecVCommand::TXRX, Cmd::VecVRettype::VOID);

	cmd->addParInv("txdata", Par::VecVType::VBLOB, NULL, NULL, NULL, 32);
	cmd->addParInv("rxlen", Par::VecVType::UINT8);
	cmd->addParInv("rxto", Par::VecVType::UINT16);

	return cmd;
};

void CtrWskdIcclPwmonif::txrx(
			const unsigned char* txdata
			, const size_t txdatalen
			, const uint8_t rxlen
			, const uint16_t rxto
		) {
	Cmd* cmd = getNewCmdTxrx();

	cmd->parsInv["txdata"].setVblob(txdata, txdatalen);
	cmd->parsInv["rxlen"].setUint8(rxlen);
	cmd->parsInv["rxto"].setUint16(rxto);

	if (unt->runCmd(cmd)) {
	} else {
		delete cmd;
		throw DbeException("error running txrx");
	};

	delete cmd;
};
