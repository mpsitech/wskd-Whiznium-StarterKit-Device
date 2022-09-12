/**
	* \file CtrWskdIcclTkclksrc.h
	* tkclksrc controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 23 Oct 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDICCLTKCLKSRC_H
#define CTRWSKDICCLTKCLKSRC_H

#include "Wskd.h"

#define CmdWskdIcclTkclksrcGetTkst CtrWskdIcclTkclksrc::CmdGetTkst

#define VecVWskdIcclTkclksrcCommand CtrWskdIcclTkclksrc::VecVCommand

/**
	* CtrWskdIcclTkclksrc
	*/
class CtrWskdIcclTkclksrc : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdIcclTkclksrcCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GETTKST = 0x00;
		static constexpr uint8_t SETTKST = 0x01;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdIcclTkclksrc(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x08;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGetTkst();
	void getTkst(uint32_t& tkst);

	static Dbecore::Cmd* getNewCmdSetTkst();
	void setTkst(const uint32_t tkst);

};

#endif
