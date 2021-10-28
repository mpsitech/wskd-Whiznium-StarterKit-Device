/**
	* \file CtrWskdUbdkStep.h
	* step controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDUBDKSTEP_H
#define CTRWSKDUBDKSTEP_H

#include "Wskd.h"

#define CmdWskdUbdkStepGetInfo CtrWskdUbdkStep::CmdGetInfo

#define VecVWskdUbdkStepCommand CtrWskdUbdkStep::VecVCommand
#define VecVWskdUbdkStepState CtrWskdUbdkStep::VecVState

/**
	* CtrWskdUbdkStep
	*/
class CtrWskdUbdkStep : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdUbdkStepCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GETINFO = 0x00;
		static constexpr uint8_t MOVETO = 0x01;
		static constexpr uint8_t SET = 0x02;
		static constexpr uint8_t ZERO = 0x03;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVState (full: VecVWskdUbdkStepState)
		*/
	class VecVState {

	public:
		static constexpr uint8_t IDLE = 0x00;
		static constexpr uint8_t MOVE = 0x01;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdUbdkStep(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x05;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGetInfo();
	void getInfo(uint8_t& tixVState, uint16_t& angle);

	static Dbecore::Cmd* getNewCmdMoveto();
	void moveto(const uint16_t angle, const uint8_t Tstep);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const bool rng, const bool ccwNotCw, const uint8_t Tstep);

	static Dbecore::Cmd* getNewCmdZero();
	void zero();

};

#endif
