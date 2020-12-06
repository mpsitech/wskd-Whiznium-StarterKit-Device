/**
	* \file CtrWskdArtyFeatdet.h
	* featdet controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#ifndef CTRWSKDARTYFEATDET_H
#define CTRWSKDARTYFEATDET_H

#include "Wskd.h"

#define CmdWskdArtyFeatdetGetInfo CtrWskdArtyFeatdet::CmdGetInfo
#define CmdWskdArtyFeatdetGetCornerinfo CtrWskdArtyFeatdet::CmdGetCornerinfo

#define VecVWskdArtyFeatdetCommand CtrWskdArtyFeatdet::VecVCommand
#define VecVWskdArtyFeatdetFlgbufstate CtrWskdArtyFeatdet::VecVFlgbufstate
#define VecVWskdArtyFeatdetThdstate CtrWskdArtyFeatdet::VecVThdstate

/**
	* CtrWskdArtyFeatdet
	*/
class CtrWskdArtyFeatdet : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdArtyFeatdetCommand)
		*/
	class VecVCommand {

	public:
		static const Sbecore::utinyint SET = 0x00;
		static const Sbecore::utinyint GETINFO = 0x01;
		static const Sbecore::utinyint GETCORNERINFO = 0x02;
		static const Sbecore::utinyint SETCORNER = 0x03;
		static const Sbecore::utinyint SETTHD = 0x04;
		static const Sbecore::utinyint TRIGGERTHD = 0x05;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

	/**
		* VecVFlgbufstate (full: VecVWskdArtyFeatdetFlgbufstate)
		*/
	class VecVFlgbufstate {

	public:
		static const Sbecore::utinyint IDLE = 0x00;
		static const Sbecore::utinyint EMPTY = 0x01;
		static const Sbecore::utinyint FULL = 0x02;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

	/**
		* VecVThdstate (full: VecVWskdArtyFeatdetThdstate)
		*/
	class VecVThdstate {

	public:
		static const Sbecore::utinyint IDLE = 0x00;
		static const Sbecore::utinyint WAITFIRST = 0x01;
		static const Sbecore::utinyint WAITSECOND = 0x02;
		static const Sbecore::utinyint DONE = 0x03;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

public:
	CtrWskdArtyFeatdet(UntWskd* unt);

public:
	static const Sbecore::utinyint tixVController = 0x03;

public:
	static Sbecore::utinyint getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const Sbecore::utinyint tixVCommand);
	static void fillFeedFCommand(Sbecore::Xmlio::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVCommand);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const bool rng, const bool thdNotCorner, const bool thdDeltaNotAbs);

	static Dbecore::Cmd* getNewCmdGetInfo();
	void getInfo(Sbecore::utinyint& tixVFlgbufstate, Sbecore::utinyint& tixVThdstate, Sbecore::uint& tkst);

	static Dbecore::Cmd* getNewCmdGetCornerinfo();
	void getCornerinfo(Sbecore::utinyint& shift, Sbecore::utinyint& scoreMin, Sbecore::utinyint& scoreMax);

	static Dbecore::Cmd* getNewCmdSetCorner();
	void setCorner(const bool linNotLog, const Sbecore::utinyint thd);

	static Dbecore::Cmd* getNewCmdSetThd();
	void setThd(const Sbecore::utinyint lvlFirst, const Sbecore::utinyint lvlSecond);

	static Dbecore::Cmd* getNewCmdTriggerThd();
	void triggerThd();

};

#endif
