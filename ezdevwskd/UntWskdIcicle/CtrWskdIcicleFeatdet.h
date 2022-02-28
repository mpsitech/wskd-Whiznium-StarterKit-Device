/**
	* \file CtrWskdIcicleFeatdet.h
	* featdet controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDICICLEFEATDET_H
#define CTRWSKDICICLEFEATDET_H

#include "Wskd.h"

#define CmdWskdIcicleFeatdetGetInfo CtrWskdIcicleFeatdet::CmdGetInfo
#define CmdWskdIcicleFeatdetGetCornerinfo CtrWskdIcicleFeatdet::CmdGetCornerinfo

#define VecVWskdIcicleFeatdetCommand CtrWskdIcicleFeatdet::VecVCommand
#define VecVWskdIcicleFeatdetFlgbufstate CtrWskdIcicleFeatdet::VecVFlgbufstate
#define VecVWskdIcicleFeatdetThdstate CtrWskdIcicleFeatdet::VecVThdstate

/**
	* CtrWskdIcicleFeatdet
	*/
class CtrWskdIcicleFeatdet : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdIcicleFeatdetCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t SET = 0x00;
		static constexpr uint8_t GETINFO = 0x01;
		static constexpr uint8_t GETCORNERINFO = 0x02;
		static constexpr uint8_t SETCORNER = 0x03;
		static constexpr uint8_t SETTHD = 0x04;
		static constexpr uint8_t TRIGGERTHD = 0x05;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVFlgbufstate (full: VecVWskdIcicleFeatdetFlgbufstate)
		*/
	class VecVFlgbufstate {

	public:
		static constexpr uint8_t IDLE = 0x00;
		static constexpr uint8_t EMPTY = 0x01;
		static constexpr uint8_t FULL = 0x02;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVThdstate (full: VecVWskdIcicleFeatdetThdstate)
		*/
	class VecVThdstate {

	public:
		static constexpr uint8_t IDLE = 0x00;
		static constexpr uint8_t WAITFIRST = 0x01;
		static constexpr uint8_t WAITSECOND = 0x02;
		static constexpr uint8_t DONE = 0x03;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdIcicleFeatdet(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x03;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const bool rng, const bool thdNotCorner, const bool thdDeltaNotAbs);

	static Dbecore::Cmd* getNewCmdGetInfo();
	void getInfo(uint8_t& tixVFlgbufstate, uint8_t& tixVThdstate, uint32_t& tkst);

	static Dbecore::Cmd* getNewCmdGetCornerinfo();
	void getCornerinfo(uint8_t& shift, uint8_t& scoreMin, uint8_t& scoreMax);

	static Dbecore::Cmd* getNewCmdSetCorner();
	void setCorner(const bool linNotLog, const uint8_t thd);

	static Dbecore::Cmd* getNewCmdSetThd();
	void setThd(const uint8_t lvlFirst, const uint8_t lvlSecond);

	static Dbecore::Cmd* getNewCmdTriggerThd();
	void triggerThd();

};

#endif
