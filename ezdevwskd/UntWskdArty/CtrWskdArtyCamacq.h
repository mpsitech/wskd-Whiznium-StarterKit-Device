/**
	* \file CtrWskdArtyCamacq.h
	* camacq controller (declarations)
	* \author Catherine Johnson
	* \date created: 16 May 2020
	* \date modified: 16 May 2020
	*/

#ifndef CTRWSKDARTYCAMACQ_H
#define CTRWSKDARTYCAMACQ_H

#include "Wskd.h"

#define CmdWskdArtyCamacqGetGrrdinfo CtrWskdArtyCamacq::CmdGetGrrdinfo
#define CmdWskdArtyCamacqGetPvwinfo CtrWskdArtyCamacq::CmdGetPvwinfo

#define VecVWskdArtyCamacqCommand CtrWskdArtyCamacq::VecVCommand
#define VecVWskdArtyCamacqGrrdbufstate CtrWskdArtyCamacq::VecVGrrdbufstate
#define VecVWskdArtyCamacqPvwbufstate CtrWskdArtyCamacq::VecVPvwbufstate

/**
	* CtrWskdArtyCamacq
	*/
class CtrWskdArtyCamacq : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdArtyCamacqCommand)
		*/
	class VecVCommand {

	public:
		static const Sbecore::utinyint SETSAMPLE = 0x00;
		static const Sbecore::utinyint SETGRRD = 0x01;
		static const Sbecore::utinyint GETGRRDINFO = 0x02;
		static const Sbecore::utinyint SETPVW = 0x03;
		static const Sbecore::utinyint GETPVWINFO = 0x04;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

	/**
		* VecVGrrdbufstate (full: VecVWskdArtyCamacqGrrdbufstate)
		*/
	class VecVGrrdbufstate {

	public:
		static const Sbecore::utinyint IDLE = 0x00;
		static const Sbecore::utinyint EMPTY = 0x01;
		static const Sbecore::utinyint STREAM = 0x02;
		static const Sbecore::utinyint PAUSE = 0x03;
		static const Sbecore::utinyint ENDFR = 0x04;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

	/**
		* VecVPvwbufstate (full: VecVWskdArtyCamacqPvwbufstate)
		*/
	class VecVPvwbufstate {

	public:
		static const Sbecore::utinyint IDLE = 0x00;
		static const Sbecore::utinyint EMPTY = 0x01;
		static const Sbecore::utinyint ABUF = 0x02;
		static const Sbecore::utinyint BBUF = 0x03;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

public:
	CtrWskdArtyCamacq(UntWskd* unt);

public:
	static const Sbecore::utinyint tixVController = 0x01;

public:
	static Sbecore::utinyint getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const Sbecore::utinyint tixVCommand);
	static void fillFeedFCommand(Sbecore::Xmlio::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVCommand);

	static Dbecore::Cmd* getNewCmdSetSample();
	void setSample(const bool fallNotRise);

	static Dbecore::Cmd* getNewCmdSetGrrd();
	void setGrrd(const bool rng, const bool redNotGray);

	static Dbecore::Cmd* getNewCmdGetGrrdinfo();
	void getGrrdinfo(Sbecore::utinyint& tixVGrrdbufstate, Sbecore::uint& tkst);

	static Dbecore::Cmd* getNewCmdSetPvw();
	void setPvw(const bool rng, const bool rawNotBin, const bool grayNotRgb);

	static Dbecore::Cmd* getNewCmdGetPvwinfo();
	void getPvwinfo(Sbecore::utinyint& tixVPvwbufstate, Sbecore::uint& tkst);

};

#endif
