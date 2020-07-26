/**
	* \file CtrWskdSkmnLaser.h
	* laser controller (declarations)
	* \author Catherine Johnson
	* \date created: 16 May 2020
	* \date modified: 16 May 2020
	*/

#ifndef CTRWSKDSKMNLASER_H
#define CTRWSKDSKMNLASER_H

#include "Wskd.h"

#define CmdWskdSkmnLaserShift CtrWskdSkmnLaser::CmdShift

#define VecVWskdSkmnLaserCommand CtrWskdSkmnLaser::VecVCommand

/**
	* CtrWskdSkmnLaser
	*/
class CtrWskdSkmnLaser : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdSkmnLaserCommand)
		*/
	class VecVCommand {

	public:
		static const Sbecore::utinyint SET = 0x00;
		static const Sbecore::utinyint SETMINMAX = 0x01;
		static const Sbecore::utinyint SHIFT = 0x02;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

public:
	CtrWskdSkmnLaser(UntWskd* unt);

public:
	static const Sbecore::utinyint tixVController = 0x02;

public:
	static Sbecore::utinyint getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const Sbecore::utinyint tixVCommand);
	static void fillFeedFCommand(Sbecore::Xmlio::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVCommand);

	static Dbecore::Cmd* getNewCmdSet();
	void set(const Sbecore::uint Tfrm, const bool rngL, const unsigned char* seqL, const size_t seqLlen, const bool rngR, const unsigned char* seqR, const size_t seqRlen);

	static Dbecore::Cmd* getNewCmdSetMinmax();
	void setMinmax(const Sbecore::utinyint minL, const Sbecore::utinyint maxL, const Sbecore::utinyint minR, const Sbecore::utinyint maxR);

	static Dbecore::Cmd* getNewCmdShift();
	void shift(int& dt);

};

#endif

