/**
	* \file CtrWskdIcclPwmonif.h
	* pwmonif controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 8 Jun 2022
	*/
// IP header --- ABOVE

#ifndef CTRWSKDICCLPWMONIF_H
#define CTRWSKDICCLPWMONIF_H

#include "Wskd.h"

#define CmdWskdIcclPwmonifGet CtrWskdIcclPwmonif::CmdGet

#define VecVWskdIcclPwmonifCommand CtrWskdIcclPwmonif::VecVCommand
#define VecVWskdIcclPwmonifState CtrWskdIcclPwmonif::VecVState

/**
	* CtrWskdIcclPwmonif
	*/
class CtrWskdIcclPwmonif : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdIcclPwmonifCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GET = 0x00;
		static constexpr uint8_t RX = 0x01;
		static constexpr uint8_t TX = 0x02;
		static constexpr uint8_t TXRX = 0x03;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVState (full: VecVWskdIcclPwmonifState)
		*/
	class VecVState {

	public:
		static constexpr uint8_t IDLE = 0x00;
		static constexpr uint8_t TX = 0x01;
		static constexpr uint8_t RX = 0x02;
		static constexpr uint8_t DONE = 0x03;
		static constexpr uint8_t TO = 0x04;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static std::string getTitle(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdIcclPwmonif(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x05;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGet();
	void get(uint8_t& tixVState, uint8_t& rxleft, unsigned char*& rxdata, size_t& rxdatalen);

	static Dbecore::Cmd* getNewCmdRx();
	void rx(const uint8_t len, const uint16_t to);

	static Dbecore::Cmd* getNewCmdTx();
	void tx(const unsigned char* data, const size_t datalen);

	static Dbecore::Cmd* getNewCmdTxrx();
	void txrx(const unsigned char* txdata, const size_t txdatalen, const uint8_t rxlen, const uint16_t rxto);

};

#endif
