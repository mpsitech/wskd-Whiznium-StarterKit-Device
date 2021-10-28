/**
	* \file CtrWskdUbdkChrono.h
	* chrono controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDUBDKCHRONO_H
#define CTRWSKDUBDKCHRONO_H

#include "Wskd.h"

#define CmdWskdUbdkChronoGetHhst CtrWskdUbdkChrono::CmdGetHhst

#define VecVWskdUbdkChronoCommand CtrWskdUbdkChrono::VecVCommand

/**
	* CtrWskdUbdkChrono
	*/
class CtrWskdUbdkChrono : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdUbdkChronoCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t GETHHST = 0x00;
		static constexpr uint8_t SETHHST = 0x01;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdUbdkChrono(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x01;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdGetHhst();
	void getHhst(uint32_t& hhst);

	static Dbecore::Cmd* getNewCmdSetHhst();
	void setHhst(const uint32_t hhst);

};

#endif
