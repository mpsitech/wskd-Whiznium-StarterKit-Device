/**
	* \file CtrWskdSkmnChrono.h
	* chrono controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#ifndef CTRWSKDSKMNCHRONO_H
#define CTRWSKDSKMNCHRONO_H

#include "Wskd.h"

#define CmdWskdSkmnChronoGetTst CtrWskdSkmnChrono::CmdGetTst

#define VecVWskdSkmnChronoCommand CtrWskdSkmnChrono::VecVCommand

/**
	* CtrWskdSkmnChrono
	*/
class CtrWskdSkmnChrono : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdSkmnChronoCommand)
		*/
	class VecVCommand {

	public:
		static const Sbecore::utinyint GETTST = 0x00;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdSkmnChrono(UntWskd* unt);

public:
	static const Sbecore::utinyint tixVController = 0x01;

public:
	static Sbecore::utinyint getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const Sbecore::utinyint tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVCommand);

	static Dbecore::Cmd* getNewCmdGetTst();
	void getTst(Sbecore::uint& tst);

};

#endif
