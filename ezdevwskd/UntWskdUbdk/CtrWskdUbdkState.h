/**
	* \file CtrWskdUbdkState.h
	* state controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDUBDKSTATE_H
#define CTRWSKDUBDKSTATE_H

#include "Wskd.h"

#include "UntWskdUbdk_vecs.h"

#define CmdWskdUbdkStateGet CtrWskdUbdkState::CmdGet

#define VecVWskdUbdkStateCommand CtrWskdUbdkState::VecVCommand

/**
	* CtrWskdUbdkState
	*/
class CtrWskdUbdkState : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdUbdkStateCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdUbdkState(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x04;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGet();
	void get(uint8_t& tixVUbdkState);

};

#endif
