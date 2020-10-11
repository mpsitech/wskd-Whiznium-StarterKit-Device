/**
	* \file CtrWskdSkmnState.h
	* state controller (declarations)
	* \author Catherine Johnson
	* \date created: 6 Oct 2020
	* \date modified: 6 Oct 2020
	*/

#ifndef CTRWSKDSKMNSTATE_H
#define CTRWSKDSKMNSTATE_H

#include "Wskd.h"

#include "UntWskdSkmn_vecs.h"

#define CmdWskdSkmnStateGet CtrWskdSkmnState::CmdGet

#define VecVWskdSkmnStateCommand CtrWskdSkmnState::VecVCommand

/**
	* CtrWskdSkmnState
	*/
class CtrWskdSkmnState : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdSkmnStateCommand)
		*/
	class VecVCommand {

	public:
		static const Sbecore::utinyint GET = 0x00;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

public:
	CtrWskdSkmnState(UntWskd* unt);

public:
	static const Sbecore::utinyint tixVController = 0x03;

public:
	static Sbecore::utinyint getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const Sbecore::utinyint tixVCommand);
	static void fillFeedFCommand(Sbecore::Xmlio::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVCommand);

	static Dbecore::Cmd* getNewCmdGet();
	void get(Sbecore::utinyint& tixVSkmnState);

};

#endif

