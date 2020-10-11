/**
	* \file Wskd.h
	* Wskd global functionality and unit/controller exchange (declarations)
	* \author Catherine Johnson
	* \date created: 6 Oct 2020
	* \date modified: 6 Oct 2020
	*/

#ifndef WSKD_H
#define WSKD_H

#include <string>

#include <sbecore/Mttypes.h>

#include <dbecore/Bufxf.h>
#include <dbecore/Cmd.h>
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

	void setBuffer(const Sbecore::utinyint tixWBuffer);
	void setController(const Sbecore::utinyint tixVController);
	void setCommand(const Sbecore::utinyint tixVCommand);
	void setLength(const size_t length);
	void setCrc(const unsigned short crc, unsigned char* ptr = NULL);

public:
	virtual bool rx(unsigned char* buf, const size_t reqlen);
	virtual bool tx(unsigned char* buf, const size_t reqlen);

	virtual void flush();

	virtual Sbecore::utinyint getTixVControllerBySref(const std::string& sref);
	virtual std::string getSrefByTixVController(const Sbecore::utinyint tixVController);
	virtual void fillFeedFController(Sbecore::Xmlio::Feed& feed);

	virtual Sbecore::utinyint getTixWBufferBySref(const std::string& sref);
	virtual std::string getSrefByTixWBuffer(const Sbecore::utinyint tixWBuffer);
	virtual void fillFeedFBuffer(Sbecore::Xmlio::Feed& feed);

	virtual Sbecore::utinyint getTixVCommandBySref(const Sbecore::utinyint tixVController, const std::string& sref);
	virtual std::string getSrefByTixVCommand(const Sbecore::utinyint tixVController, const Sbecore::utinyint tixVCommand);
	virtual void fillFeedFCommand(const Sbecore::utinyint tixVController, Sbecore::Xmlio::Feed& feed);

	virtual Dbecore::Bufxf* getNewBufxf(const Sbecore::utinyint tixWBuffer, const size_t reqlen);
	virtual Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVController, const Sbecore::utinyint tixVCommand);

	std::string getCmdTemplate(const Sbecore::utinyint tixVController, const Sbecore::utinyint tixVCommand, const bool invretNotInv = false);

public:
	bool initdone;

	bool txburst;
	bool rxtxdump;

	unsigned int Nretry;
	unsigned int to;

	unsigned char* rxbuf;
	unsigned char* txbuf;

	Sbecore::Mutex mAccess;
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

