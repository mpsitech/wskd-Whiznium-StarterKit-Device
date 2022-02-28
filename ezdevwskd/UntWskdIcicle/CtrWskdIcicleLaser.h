/**
	* \file CtrWskdIcicleLaser.h
	* laser controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDICICLELASER_H
#define CTRWSKDICICLELASER_H

#include "Wskd.h"

#define VecVWskdIcicleLaserCommand CtrWskdIcicleLaser::VecVCommand

/**
	* CtrWskdIcicleLaser
	*/
class CtrWskdIcicleLaser : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdIcicleLaserCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t SET = 0x00;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdIcicleLaser(UntWskd* unt);

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
