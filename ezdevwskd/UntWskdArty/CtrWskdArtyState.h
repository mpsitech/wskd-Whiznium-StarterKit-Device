/**
	* \file CtrWskdArtyState.h
	* state controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#ifndef CTRWSKDARTYSTATE_H
#define CTRWSKDARTYSTATE_H

#include "Wskd.h"

#include "UntWskdArty_vecs.h"

#define CmdWskdArtyStateGet CtrWskdArtyState::CmdGet

#define VecVWskdArtyStateCommand CtrWskdArtyState::VecVCommand

/**
	* CtrWskdArtyState
	*/
class CtrWskdArtyState : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdArtyStateCommand)
		*/
	class VecVCommand {

	public:
		static const Sbecore::utinyint GET = 0x00;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

public:
	CtrWskdArtyState(UntWskd* unt);

public:
	static const Sbecore::utinyint tixVController = 0x05;

public:
	static Sbecore::utinyint getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const Sbecore::utinyint tixVCommand);
	static void fillFeedFCommand(Sbecore::Xmlio::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVCommand);

	static Dbecore::Cmd* getNewCmdGet();
	void get(Sbecore::utinyint& tixVArtyState);

};

#endif





