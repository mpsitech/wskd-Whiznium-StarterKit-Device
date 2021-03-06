/**
	* \file CtrWskdArtyLaser.h
	* laser controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#ifndef CTRWSKDARTYLASER_H
#define CTRWSKDARTYLASER_H

#include "Wskd.h"

#define VecVWskdArtyLaserCommand CtrWskdArtyLaser::VecVCommand

/**
	* CtrWskdArtyLaser
	*/
class CtrWskdArtyLaser : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdArtyLaserCommand)
		*/
	class VecVCommand {

	public:
		static const Sbecore::utinyint SET = 0x00;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdArtyLaser(UntWskd* unt);

public:
	static const Sbecore::utinyint tixVController = 0x04;

public:
	static Sbecore::utinyint getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const Sbecore::utinyint tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVCommand);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const Sbecore::usmallint l, const Sbecore::usmallint r);

};

#endif
