/**
	* \file CtrWskdArtyStep.h
	* step controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#ifndef CTRWSKDARTYSTEP_H
#define CTRWSKDARTYSTEP_H

#include "Wskd.h"

#define CmdWskdArtyStepGetInfo CtrWskdArtyStep::CmdGetInfo

#define VecVWskdArtyStepCommand CtrWskdArtyStep::VecVCommand
#define VecVWskdArtyStepState CtrWskdArtyStep::VecVState

/**
	* CtrWskdArtyStep
	*/
class CtrWskdArtyStep : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdArtyStepCommand)
		*/
	class VecVCommand {

	public:
		static const Sbecore::utinyint GETINFO = 0x00;
		static const Sbecore::utinyint MOVETO = 0x01;
		static const Sbecore::utinyint SET = 0x02;
		static const Sbecore::utinyint ZERO = 0x03;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVState (full: VecVWskdArtyStepState)
		*/
	class VecVState {

	public:
		static const Sbecore::utinyint IDLE = 0x00;
		static const Sbecore::utinyint MOVE = 0x01;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdArtyStep(UntWskd* unt);

public:
	static const Sbecore::utinyint tixVController = 0x06;

public:
	static Sbecore::utinyint getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const Sbecore::utinyint tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVCommand);

	static Dbecore::Cmd* getNewCmdGetInfo();
	void getInfo(Sbecore::utinyint& tixVState, Sbecore::usmallint& angle);

	static Dbecore::Cmd* getNewCmdMoveto();
	void moveto(const Sbecore::usmallint angle, const Sbecore::utinyint Tstep);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const bool rng, const bool ccwNotCw, const Sbecore::utinyint Tstep);

	static Dbecore::Cmd* getNewCmdZero();
	void zero();

};

#endif
