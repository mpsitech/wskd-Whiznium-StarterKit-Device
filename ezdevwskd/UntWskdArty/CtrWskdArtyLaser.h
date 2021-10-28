/**
	* \file CtrWskdArtyLaser.h
	* laser controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#ifndef CTRWSKDARTYLASER_H
#define CTRWSKDARTYLASER_H

#include "Wskd.h"

#define VecVWskdArtyLaserCommand CtrWskdArtyLaser::VecVCommand

/**
	* CtrWskdArtyLaser
	*/
class CtrWskdArtyLaser : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdArtyLaserCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t SET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdArtyLaser(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x04;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const uint16_t l, const uint16_t r);

};

#endif
