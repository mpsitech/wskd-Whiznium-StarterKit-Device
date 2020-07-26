/**
	* \file CtrWskdSkmnStep.h
	* step controller (declarations)
	* \author Catherine Johnson
	* \date created: 16 May 2020
	* \date modified: 16 May 2020
	*/

#ifndef CTRWSKDSKMNSTEP_H
#define CTRWSKDSKMNSTEP_H

#include "Wskd.h"

#define CmdWskdSkmnStepGetInfo CtrWskdSkmnStep::CmdGetInfo

#define VecVWskdSkmnStepCommand CtrWskdSkmnStep::VecVCommand
#define VecVWskdSkmnStepState CtrWskdSkmnStep::VecVState

/**
	* CtrWskdSkmnStep
	*/
class CtrWskdSkmnStep : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdSkmnStepCommand)
		*/
	class VecVCommand {

	public:
		static const Sbecore::utinyint GETINFO = 0x00;
		static const Sbecore::utinyint MOVETO = 0x01;
		static const Sbecore::utinyint SET = 0x02;
		static const Sbecore::utinyint ZERO = 0x03;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

	/**
		* VecVState (full: VecVWskdSkmnStepState)
		*/
	class VecVState {

	public:
		static const Sbecore::utinyint IDLE = 0x00;
		static const Sbecore::utinyint MOVE = 0x01;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

public:
	CtrWskdSkmnStep(UntWskd* unt);

public:
	static const Sbecore::utinyint tixVController = 0x04;

public:
	static Sbecore::utinyint getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const Sbecore::utinyint tixVCommand);
	static void fillFeedFCommand(Sbecore::Xmlio::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVCommand);

	static Dbecore::Cmd* getNewCmdGetInfo();
	void getInfo(Sbecore::utinyint& tixVState, Sbecore::usmallint& angle);

	static Dbecore::Cmd* getNewCmdMoveto();
	void moveto(const Sbecore::usmallint angle);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const bool rng, const bool ccwNotCw, const Sbecore::utinyint speed);

	static Dbecore::Cmd* getNewCmdZero();
	void zero();

};

#endif

