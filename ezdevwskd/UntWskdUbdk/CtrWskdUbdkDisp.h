/**
	* \file CtrWskdUbdkDisp.h
	* disp controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDUBDKDISP_H
#define CTRWSKDUBDKDISP_H

#include "Wskd.h"

#define VecVWskdUbdkDispCommand CtrWskdUbdkDisp::VecVCommand

/**
	* CtrWskdUbdkDisp
	*/
class CtrWskdUbdkDisp : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdUbdkDispCommand)
		*/
	class VecVCommand {

	public:

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdUbdkDisp(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x02;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

};

#endif
