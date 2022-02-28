/**
	* \file CtrWskdIcicleTkclksrc.h
	* tkclksrc controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDICICLETKCLKSRC_H
#define CTRWSKDICICLETKCLKSRC_H

#include "Wskd.h"

#define CmdWskdIcicleTkclksrcGetTkst CtrWskdIcicleTkclksrc::CmdGetTkst

#define VecVWskdIcicleTkclksrcCommand CtrWskdIcicleTkclksrc::VecVCommand

/**
	* CtrWskdIcicleTkclksrc
	*/
class CtrWskdIcicleTkclksrc : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdIcicleTkclksrcCommand)
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
	CtrWskdIcicleTkclksrc(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x07;

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
