/**
	* \file CtrWskdArtyCamif.h
	* camif controller (declarations)
	* \author Catherine Johnson
	* \date created: 16 May 2020
	* \date modified: 16 May 2020
	*/

#ifndef CTRWSKDARTYCAMIF_H
#define CTRWSKDARTYCAMIF_H

#include "Wskd.h"

#define CmdWskdArtyCamifGetReg CtrWskdArtyCamif::CmdGetReg

#define VecVWskdArtyCamifCommand CtrWskdArtyCamif::VecVCommand

/**
	* CtrWskdArtyCamif
	*/
class CtrWskdArtyCamif : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdArtyCamifCommand)
		*/
	class VecVCommand {

	public:
		static const Sbecore::utinyint SETRNG = 0x00;
		static const Sbecore::utinyint SETFOCUS = 0x01;
		static const Sbecore::utinyint SETTEXP = 0x02;
		static const Sbecore::utinyint SETREG = 0x03;
		static const Sbecore::utinyint GETREG = 0x04;
		static const Sbecore::utinyint MODREG = 0x05;

		static Sbecore::utinyint getTix(const std::string& sref);
		static std::string getSref(const Sbecore::utinyint tix);

		static void fillFeed(Sbecore::Xmlio::Feed& feed);
	};

public:
	CtrWskdArtyCamif(UntWskd* unt);

public:
	static const Sbecore::utinyint tixVController = 0x02;

public:
	static Sbecore::utinyint getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const Sbecore::utinyint tixVCommand);
	static void fillFeedFCommand(Sbecore::Xmlio::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const Sbecore::utinyint tixVCommand);

	static Dbecore::Cmd* getNewCmdSetRng();
	void setRng(const bool rng);

	static Dbecore::Cmd* getNewCmdSetFocus();
	void setFocus(const Sbecore::usmallint vcm);

	static Dbecore::Cmd* getNewCmdSetTexp();
	void setTexp(const Sbecore::usmallint Texp);

	static Dbecore::Cmd* getNewCmdSetReg();
	void setReg(const Sbecore::usmallint addr, const Sbecore::utinyint val);

	static Dbecore::Cmd* getNewCmdGetReg();
	void getReg(const Sbecore::usmallint addr, Sbecore::utinyint& val);

	static Dbecore::Cmd* getNewCmdModReg();
	void modReg(const Sbecore::usmallint addr, const Sbecore::utinyint mask, const Sbecore::utinyint val);

};

#endif

