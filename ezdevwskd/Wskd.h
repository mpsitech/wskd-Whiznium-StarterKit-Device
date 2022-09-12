/**
	* \file Wskd.h
	* Wskd global functionality and unit/controller exchange (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#ifndef WSKD_H
#define WSKD_H

#include <list>
#include <string>

#include <dbecore/Bufxf.h>
#include <dbecore/Crc.h>

/**
	* UntWskd
	*/
class UntWskd {

public:
	UntWskd();
	virtual ~UntWskd();

public:
	void lockAccess(const std::string& who);
	void unlockAccess(const std::string& who);

	void reset();

	bool runBufxf(Dbecore::Bufxf* bufxf);
	bool runBufxfFromBuf(Dbecore::Bufxf* bufxf);
	bool runBufxfToBuf(Dbecore::Bufxf* bufxf);

	bool runCmd(Dbecore::Cmd* cmd);
	bool runCmdInvToVoid(Dbecore::Cmd* cmd);
	bool runCmdVoidToRet(Dbecore::Cmd* cmd);

	timespec calcTimeout(const size_t length);

	void setBuffer(const uint8_t tixWBuffer);
	void setController(const uint8_t tixVController);
	void setCommand(const uint8_t tixVCommand);
	void setLength(const size_t length);
	void setCrc(const unsigned short crc, unsigned char* ptr = NULL);

public:
	virtual bool rx(unsigned char* buf, const size_t reqlen);
	virtual bool tx(unsigned char* buf, const size_t reqlen);

	virtual void flush();

	virtual uint8_t getTixVControllerBySref(const std::string& sref);
	virtual std::string getSrefByTixVController(const uint8_t tixVController);
	virtual void fillFeedFController(Sbecore::Feed& feed);

	virtual uint8_t getTixWBufferBySref(const std::string& sref);
	virtual std::string getSrefByTixWBuffer(const uint8_t tixWBuffer);
	virtual void fillFeedFBuffer(Sbecore::Feed& feed);

	virtual uint8_t getTixVCommandBySref(const uint8_t tixVController, const std::string& sref);
	virtual std::string getSrefByTixVCommand(const uint8_t tixVController, const uint8_t tixVCommand);
	virtual void fillFeedFCommand(const uint8_t tixVController, Sbecore::Feed& feed);

	virtual Dbecore::Bufxf* getNewBufxf(const uint8_t tixWBuffer, const size_t reqlen);
	virtual Dbecore::Cmd* getNewCmd(const uint8_t tixVController, const uint8_t tixVCommand);

	std::string getCmdTemplate(const uint8_t tixVController, const uint8_t tixVCommand, const bool invretNotInv = false);

	void parseCmd(std::string s, Dbecore::Cmd*& cmd);
	Sbecore::uint getCmdix(const std::string& cmdsref);
	std::string getCmdsref(const Sbecore::uint cmdix);

	void clearHist();
	void appendToHist(const std::string& s);
	void appendToLastInHist(const std::string& s);
	void copyHist(std::vector<std::string>& vec, const bool append = false);

public:
	bool initdone;

	bool txburst;

	bool rxtxdump;
	bool histNotDump;
	unsigned int histlimit;

	unsigned int NRetry;

	bool bufxfLengthBlockNotByte;

	unsigned int wordlen;

	unsigned int dtDecode; // in µs

	unsigned int timeoutDev; // in µs

	unsigned int timeoutRx; // in µs
	unsigned int timeoutRxWord; // in µs

	unsigned char* rxbuf;
	unsigned char* txbuf;

	Sbecore::Mutex mAccess;

	Sbecore::Rwmutex rwmHist;
	std::list<std::string> hist;
};

/**
	* CtrWskd
	*/
class CtrWskd {

public:
	CtrWskd(UntWskd* unt);
	virtual ~CtrWskd();

public:
	UntWskd* unt;
};

#endif
