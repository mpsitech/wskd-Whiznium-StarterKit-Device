/**
	* \file CtrWskdUbdkLaser.h
	* laser controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDUBDKLASER_H
#define CTRWSKDUBDKLASER_H

#include "Wskd.h"

#define VecVWskdUbdkLaserCommand CtrWskdUbdkLaser::VecVCommand

/**
	* CtrWskdUbdkLaser
	*/
class CtrWskdUbdkLaser : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdUbdkLaserCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t SET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdUbdkLaser(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x03;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const uint16_t l, const uint16_t r);

};

#endif
