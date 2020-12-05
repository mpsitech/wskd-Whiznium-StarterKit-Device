/**
	* \file CtrWskdArtyTkclksrc.h
	* tkclksrc controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#ifndef CTRWSKDARTYTKCLKSRC_H
#define CTRWSKDARTYTKCLKSRC_H

#include "Wskd.h"

#define CmdWskdArtyTkclksrcGetTkst CtrWskdArtyTkclksrc::CmdGetTkst

#define VecVWskdArtyTkclksrcCommand CtrWskdArtyTkclksrc::VecVCommand

/**
	* CtrWskdArtyTkclksrc
	*/
class CtrWskdArtyTkclksrc : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdArtyTkclksrcCommand)
		*/
	class VecVCommand {

	public:
		static const Sbecore::utinyint GETTKST = 0x00;
		static const Sbecore::utinyint SETTKST = 0x01;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

public:
	CtrWskdArtyTkclksrc(UntWskd* unt);

public:
	static const Sbecore::utinyint tixVController = 0x07;

public:
	static Sbecore::utinyint getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const Sbecore::utinyint tixVCommand);
	static void fillFeedFCommand(Sbecore::Xmlio::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVCommand);

	static Dbecore::Cmd* getNewCmdGetTkst();
	void getTkst(Sbecore::uint& tkst);

	static Dbecore::Cmd* getNewCmdSetTkst();
	void setTkst(const Sbecore::uint tkst);

};

#endif





