/**
	* \file Wskd.cpp
	* Wskd global functionality and unit/controller exchange (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#include "Wskd.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

/******************************************************************************
 class UntWskd
 ******************************************************************************/

UntWskd::UntWskd()
		:
			mAccess("mAccess", "UntWskd", "UntWskd")
			, rwmHist("rwmHist", "UntWskd", "UntWskd")
		{
	initdone = false;;

	txburst = false;

	rxtxdump = false;
	histNotDump = false;
	histlimit = 100;

	NRetry = 3;

	bufxfLengthBlockNotByte = false;

	wordlen = 1;

	dtDecode = 0;

	timeoutDev = 10000;

	timeoutRx = 1000;
	timeoutRxWord = 1;

	rxbuf = NULL;
	txbuf = NULL;
};

UntWskd::~UntWskd() {
	if (rxbuf) delete[] rxbuf;
	if (txbuf) delete[] txbuf;

	mAccess.lock("UntWskd", "~UntWskd");
	mAccess.unlock("UntWskd", "~UntWskd");
};

void UntWskd::lockAccess(
			const string& who
		) {
	mAccess.lock(who);
};

void UntWskd::unlockAccess(
			const string& who
		) {
	mAccess.unlock(who);
};

void UntWskd::reset() {
	txbuf[0] = 0xFF;
	tx(txbuf, 1);
};

bool UntWskd::runBufxf(
			Bufxf* bufxf
		) {
	bool success = false;

	timespec deltat;

	// single try: invoke status command on failure
	if (bufxf->writeNotRead) success = runBufxfToBuf(bufxf);
	else success = runBufxfFromBuf(bufxf);

	if (!success) {
		// wait for device to time out
		deltat.tv_sec = 0;
		deltat.tv_nsec = 1000 * timeoutDev;

		nanosleep(&deltat, NULL);
	};

	return success;
};

bool UntWskd::runBufxfFromBuf(
			Bufxf* bufxf
		) {
	bool success = false;

	if (!initdone) return false;
	lockAccess("runBufxfFromBuf");

	Crc crc(0x8005, false);

	flush();

	setBuffer(bufxf->tixWBuffer);
	setController(0x00);
	setCommand(0x00);
	setLength((bufxfLengthBlockNotByte) ? bufxf->reqlen/256 : bufxf->reqlen); // neither reqlen nor length include CRC bytes

	crc.reset();
	crc.includeBytes(txbuf, 1+1+1+2);
	crc.finalize();
	setCrc(crc.crc);

	success = tx(txbuf, 1+1+1+2+2);

	if (success) {
		flush();
		success = rx(bufxf->data, bufxf->reqlen+2);
	};

	if (success) bufxf->ptr = bufxf->reqlen;

	if (success) {
		// received CRC bytes odd bits are bit-inverted
		bufxf->data[bufxf->reqlen] = (bufxf->data[bufxf->reqlen] & 0x55) | (~(bufxf->data[bufxf->reqlen]) & 0xAA);
		bufxf->data[bufxf->reqlen+1] = (bufxf->data[bufxf->reqlen+1] & 0x55) | (~(bufxf->data[bufxf->reqlen+1]) & 0xAA);

		crc.reset();
		crc.includeBytes(bufxf->data, bufxf->reqlen+2);
		crc.finalize();

		success = (crc.crc == 0x0000);
	};

	unlockAccess("runBufxfFromBuf");

	return success;
};

bool UntWskd::runBufxfToBuf(
			Bufxf* bufxf
		) {
	bool success = false;

	timespec deltat;

	if (!initdone) return false;
	lockAccess("runBufxfToBuf");

	Crc crc(0x8005, false);

	flush();

	setBuffer(bufxf->tixWBuffer);
	setController(0x00);
	setCommand(0x00);
	setLength((bufxfLengthBlockNotByte) ? bufxf->reqlen/256 : bufxf->reqlen);

	crc.reset();
	crc.includeBytes(txbuf, 1+1+1+2);
	crc.finalize();
	setCrc(crc.crc);

	if (txburst) {
		memcpy(bufxf->data, txbuf, 1+1+1+2);
		
		crc.reset();
		crc.includeBytes(&(bufxf->data[7]), bufxf->reqlen);
		crc.finalize();
		setCrc(crc.crc, &(bufxf->data[7+bufxf->reqlen]));

		success = tx(bufxf->data, 1+1+1+2+2 + bufxf->reqlen+2);

	} else {
		success = tx(txbuf, 1+1+1+2+2);

		if (success) {
			crc.reset();
			crc.includeBytes(bufxf->data, bufxf->reqlen);
			crc.finalize();
			setCrc(crc.crc, &(bufxf->data[bufxf->reqlen]));

			if (dtDecode > 0) {
				deltat.tv_sec = 0;
				deltat.tv_nsec = 1000 * dtDecode;

				nanosleep(&deltat, NULL);
			};

			success = tx(bufxf->data, bufxf->reqlen+2);
		};
	};

	if (success) {
		flush();
		success = rx(rxbuf, 2); // expect CRC of empty buffer (0xAAAA)
	};

	if (success) success = ((rxbuf[0] == 0xAA) && (rxbuf[1] == 0xAA));

	unlockAccess("runBufxfToBuf");

	return success;
};

bool UntWskd::runCmd(
			Cmd* cmd
		) {
	bool success = false;

	timespec deltat;

	if (!initdone) return false;
	lockAccess("runCmd");

	for (unsigned int i = 0; i < NRetry; i++) {
		if (cmd->parsInv.empty() && !cmd->parsRet.empty()) success = runCmdVoidToRet(cmd);
		else success = runCmdInvToVoid(cmd); // allow voidToVoid as well

		if (success) break;

		// wait for device to time out
		deltat.tv_sec = 0;
		deltat.tv_nsec = 1000 * timeoutDev;

		nanosleep(&deltat, NULL);
	};

	unlockAccess("runCmd");

	return success;
};

bool UntWskd::runCmdInvToVoid(
			Cmd* cmd
		) {
	bool success;

	timespec deltat;

	unsigned char* buf = NULL;
	size_t buflen;

	size_t invBuflen = cmd->getInvBuflen();

	Crc crc(0x8005, false);

	flush();

	setBuffer(0x02); // hostifToCmdinv
	setController(cmd->tixVController);
	setCommand(cmd->tixVCommand);
	setLength(invBuflen+2);

	crc.reset();
	crc.includeBytes(txbuf, 1+1+1+2);
	crc.finalize();
	setCrc(crc.crc);

	crc.reset();
	cmd->parsInvToBuf(&buf, buflen);
	if (buf) crc.includeBytes(buf, invBuflen);
	crc.finalize();

	if (txburst) {
		if (buf) memcpy(&(txbuf[7]), buf, buflen);
		setCrc(crc.crc, &(txbuf[7+invBuflen]));

		success = tx(txbuf, 1+1+1+2+2 + invBuflen+2);

	} else {
		success = tx(txbuf, 1+1+1+2+2);

		if (success) {
			if (buf) memcpy(txbuf, buf, buflen);
			setCrc(crc.crc, &(txbuf[invBuflen]));

			if (dtDecode > 0) {
				deltat.tv_sec = 0;
				deltat.tv_nsec = 1000 * dtDecode;

				nanosleep(&deltat, NULL);
			};

			success = tx(txbuf, invBuflen+2);
		};
	};

	if (success) {
		flush();
		success = rx(rxbuf, 2); // expect CRC of empty buffer (0xAAAA)
	};

	if (success) success = ((rxbuf[0] == 0xAA) && (rxbuf[1] == 0xAA));

	if (buf) delete[] buf;

	return success;
};

bool UntWskd::runCmdVoidToRet(
			Cmd* cmd
		) {
	bool success;

	size_t retBuflen = cmd->getRetBuflen();

	Crc crc(0x8005, false);

	flush();

	setBuffer(0x01); // cmdretToHostif
	setController(cmd->tixVController);
	setCommand(cmd->tixVCommand);
	setLength(retBuflen+2);

	crc.reset();
	crc.includeBytes(txbuf, 1+1+1+2);
	crc.finalize();
	setCrc(crc.crc);

	success = tx(txbuf, 1+1+1+2+2);

	if (success) {
		flush();
		success = rx(rxbuf, retBuflen+2);
	};

	if (success) {
		// received CRC bytes odd bits are bit-inverted
		rxbuf[retBuflen] = (rxbuf[retBuflen] & 0x55) | (~(rxbuf[retBuflen]) & 0xAA);
		rxbuf[retBuflen+1] = (rxbuf[retBuflen+1] & 0x55) | (~(rxbuf[retBuflen+1]) & 0xAA);

		crc.reset();
		crc.includeBytes(rxbuf, retBuflen+2);
		crc.finalize();

		success = (crc.crc == 0x0000);
	};

	if (success) cmd->bufToParsRet(rxbuf, retBuflen);

	return success;
};

timespec UntWskd::calcTimeout(
			const size_t length
		) {
	unsigned long us;
	timespec deltat;

	us = (length * timeoutRxWord) / wordlen + timeoutRx;

	deltat.tv_sec = us / 1000000;
	deltat.tv_nsec = 1000 * (us%1000000);

	return deltat;
};

void UntWskd::setBuffer(
			const uint8_t tixWBuffer
		) {
	// txbuf byte 0
	txbuf[0] = tixWBuffer;
};

void UntWskd::setController(
			const uint8_t tixVController
		) {
	// txbuf byte 1
	txbuf[1] = tixVController;
};

void UntWskd::setCommand(
			const uint8_t tixVCommand
		) {
	// txbuf byte 2
	txbuf[2] = tixVCommand;
};

void UntWskd::setLength(
			const size_t length
		) {
	// txbuf bytes 3..4
	unsigned short _length = length;

	unsigned char* ptr = (unsigned char*) &_length;

	const size_t ofs = 3;

	if (Dbe::bigendian()) {
		txbuf[ofs] = ptr[0];
		txbuf[ofs+1] = ptr[1];
	} else {
		txbuf[ofs] = ptr[1];
		txbuf[ofs+1] = ptr[0];
	};
};

void UntWskd::setCrc(
			const unsigned short crc
			, unsigned char* ptr
		) {
	// txbuf bytes 5..6 by default
	if (!ptr) ptr = &(txbuf[5]);

	unsigned char* crcptr = (unsigned char*) &crc;

	if (Dbe::bigendian()) {
		ptr[0] = crcptr[0];
		ptr[1] = crcptr[1];
	} else {
		ptr[0] = crcptr[1];
		ptr[1] = crcptr[0];
	};
};

bool UntWskd::rx(
			unsigned char* buf
			, const size_t reqlen
		) {
	return false;
};

bool UntWskd::tx(
			unsigned char* buf
			, const size_t reqlen
		) {
	return false;
};

void UntWskd::flush() {
};

uint8_t UntWskd::getTixVControllerBySref(
			const string& sref
		) {
	return 0;
};

string UntWskd::getSrefByTixVController(
			const uint8_t tixVController
		) {
	return("");
};

void UntWskd::fillFeedFController(
			Feed& feed
		) {
};

uint8_t UntWskd::getTixWBufferBySref(
			const string& sref
		) {
	return 0;
};

string UntWskd::getSrefByTixWBuffer(
			const uint8_t tixWBuffer
		) {
	return("");
};

void UntWskd::fillFeedFBuffer(
			Feed& feed
		) {
};

uint8_t UntWskd::getTixVCommandBySref(
			const uint8_t tixVController
			, const string& sref
		) {
	return 0;
};

string UntWskd::getSrefByTixVCommand(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	return("");
};

void UntWskd::fillFeedFCommand(
			const uint8_t tixVController
			, Feed& feed
		) {
};

Bufxf* UntWskd::getNewBufxf(
			const uint8_t tixWBuffer
			, const size_t reqlen
		) {
	return NULL;
};

Cmd* UntWskd::getNewCmd(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	return NULL;
};

string UntWskd::getCmdTemplate(
			const uint8_t tixVController
			, const uint8_t tixVCommand
			, const bool invretNotInv
		) {
	string retval;

	Cmd* cmd = getNewCmd(tixVController, tixVCommand);

	if (cmd) {
		if (invretNotInv) {
			retval = cmd->parsToTemplate(true);
			if (retval != "") retval = "(" + retval + ") = ";
		};

		retval += getSrefByTixVController(tixVController);
		if (retval != "") retval += ".";
		retval += getSrefByTixVCommand(tixVController, tixVCommand);

		retval += "(" + cmd->parsToTemplate(false) + ")";

		delete cmd;
	};

	return retval;
};

void UntWskd::parseCmd(
			string s
			, Dbecore::Cmd*& cmd
		) {
	string cmdsref;
	uint cmdix;

	utinyint tixVController;
	utinyint tixVCommand;

	if (cmd) delete cmd;
	cmd = NULL;

	size_t ptr;

	if (s.length() == 0) return;
	if (s[s.length()-1] != ')') return;
	s = s.substr(0, s.length()-1);
	ptr = s.find('(');
	if (ptr == string::npos) return;

	cmdix = getCmdix(s.substr(0, ptr));
	tixVController = (cmdix >> 8);
	tixVCommand = (cmdix & 0xFF);
	s = s.substr(ptr+1);

	cmd = getNewCmd(tixVController, tixVCommand);
	if (cmd) cmd->parlistToParsInv(s);
};

uint UntWskd::getCmdix(
			const string& cmdsref
		) {
	utinyint tixVController = 0;
	utinyint tixVCommand = 0;

	size_t ptr;

	ptr = cmdsref.find('.');

	if (ptr != string::npos) {
		tixVController = getTixVControllerBySref(cmdsref.substr(0, ptr));
		tixVCommand = getTixVCommandBySref(tixVController, cmdsref.substr(ptr+1));

		return((tixVController << 8) + tixVCommand);

	} else return 0;
};

string UntWskd::getCmdsref(
			const uint cmdix
		) {
	string cmdsref;

	utinyint tixVController = (cmdix >> 8);
	utinyint tixVCommand = (cmdix & 0xFF);

	cmdsref = getSrefByTixVController(tixVController);
	cmdsref += ".";
	cmdsref += getSrefByTixVCommand(tixVController, tixVCommand);

	return cmdsref;
};

void UntWskd::clearHist() {
	rwmHist.wlock("UntWskd", "clearHist");

	hist.clear();

	rwmHist.wunlock("UntWskd", "clearHist");
};

void UntWskd::appendToHist(
			const string& s
		) {
	rwmHist.wlock("UntWskd", "appendToHist");

	while (hist.size() > histlimit) hist.pop_front();
	hist.push_back(s);

	rwmHist.wunlock("UntWskd", "appendToHist");
};

void UntWskd::appendToLastInHist(
			const string& s
		) {
	rwmHist.wlock("UntWskd", "appendToLastInHist");

	if (!hist.empty()) hist.back() += s;

	rwmHist.wunlock("UntWskd", "appendToLastInHist");
};

void UntWskd::copyHist(
			vector<string>& vec
			, const bool append
		) {
	rwmHist.rlock("UntWskd", "copyHist");

	if (!append) vec.clear();
	for (auto it = hist.begin(); it != hist.end(); it++) vec.push_back(*it);

	rwmHist.runlock("UntWskd", "copyHist");
};

/******************************************************************************
 class CtrWskd
 ******************************************************************************/

CtrWskd::CtrWskd(
			UntWskd* unt
		) {
	this->unt = unt;
};

CtrWskd::~CtrWskd() {
};
