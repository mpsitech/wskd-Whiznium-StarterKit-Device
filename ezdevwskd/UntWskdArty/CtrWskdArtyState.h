/**
	* \file CtrWskdArtyState.h
	* state controller (declarations)
	* \author Catherine Johnson
	* \date created: 6 Oct 2020
	* \date modified: 6 Oct 2020
	*/

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

