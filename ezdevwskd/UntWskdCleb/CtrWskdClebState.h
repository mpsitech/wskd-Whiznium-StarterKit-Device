/**
	* \file CtrWskdClebState.h
	* state controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 24 Dec 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDCLEBSTATE_H
#define CTRWSKDCLEBSTATE_H

#include "Wskd.h"

#include "UntWskdCleb_vecs.h"

#define CmdWskdClebStateGet CtrWskdClebState::CmdGet

#define VecVWskdClebStateCommand CtrWskdClebState::VecVCommand

/**
	* CtrWskdClebState
	*/
class CtrWskdClebState : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdClebStateCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdClebState(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x02;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGet();
	void get(uint8_t& tixVClebState);

};

#endif
