/**
	* \file CtrWskdClebStep.h
	* step controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 24 Dec 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDCLEBSTEP_H
#define CTRWSKDCLEBSTEP_H

#include "Wskd.h"

#define CmdWskdClebStepGetInfo CtrWskdClebStep::CmdGetInfo

#define VecVWskdClebStepCommand CtrWskdClebStep::VecVCommand
#define VecVWskdClebStepState CtrWskdClebStep::VecVState

/**
	* CtrWskdClebStep
	*/
class CtrWskdClebStep : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdClebStepCommand)
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
		* VecVState (full: VecVWskdClebStepState)
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
	CtrWskdClebStep(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x03;

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
