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
		static constexpr uint8_t GET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdArtyState(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x06;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGet();
	void get(uint8_t& tixVArtyState);

};

#endif
