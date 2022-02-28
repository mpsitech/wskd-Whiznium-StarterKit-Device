/**
	* \file CtrWskdIcicleCamacq.h
	* camacq controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDICICLECAMACQ_H
#define CTRWSKDICICLECAMACQ_H

#include "Wskd.h"

#define CmdWskdIcicleCamacqGetGrrdinfo CtrWskdIcicleCamacq::CmdGetGrrdinfo
#define CmdWskdIcicleCamacqGetPvwinfo CtrWskdIcicleCamacq::CmdGetPvwinfo

#define VecVWskdIcicleCamacqCommand CtrWskdIcicleCamacq::VecVCommand
#define VecVWskdIcicleCamacqGrrdbufstate CtrWskdIcicleCamacq::VecVGrrdbufstate
#define VecVWskdIcicleCamacqPvwbufstate CtrWskdIcicleCamacq::VecVPvwbufstate

/**
	* CtrWskdIcicleCamacq
	*/
class CtrWskdIcicleCamacq : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdIcicleCamacqCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t SETGRRD = 0x00;
		static constexpr uint8_t GETGRRDINFO = 0x01;
		static constexpr uint8_t SETPVW = 0x02;
		static constexpr uint8_t GETPVWINFO = 0x03;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVGrrdbufstate (full: VecVWskdIcicleCamacqGrrdbufstate)
		*/
	class VecVGrrdbufstate {

	public:
		static constexpr uint8_t IDLE = 0x00;
		static constexpr uint8_t EMPTY = 0x01;
		static constexpr uint8_t STREAM = 0x02;
		static constexpr uint8_t PAUSE = 0x03;
		static constexpr uint8_t ENDFR = 0x04;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

	/**
		* VecVPvwbufstate (full: VecVWskdIcicleCamacqPvwbufstate)
		*/
	class VecVPvwbufstate {

	public:
		static constexpr uint8_t IDLE = 0x00;
		static constexpr uint8_t EMPTY = 0x01;
		static constexpr uint8_t ABUF = 0x02;
		static constexpr uint8_t BBUF = 0x03;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdIcicleCamacq(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x01;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdSetGrrd();
	void setGrrd(const bool rng, const bool redNotGray);

	static Dbecore::Cmd* getNewCmdGetGrrdinfo();
	void getGrrdinfo(uint8_t& tixVGrrdbufstate, uint32_t& tkst);

	static Dbecore::Cmd* getNewCmdSetPvw();
	void setPvw(const bool rng, const bool rawNotBin, const bool grayNotRgb);

	static Dbecore::Cmd* getNewCmdGetPvwinfo();
	void getPvwinfo(uint8_t& tixVPvwbufstate, uint32_t& tkst);

};

#endif
