/**
	* \file CtrWskdIcclCamif.h
	* camif controller (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 23 Oct 2021
	*/
// IP header --- ABOVE

#ifndef CTRWSKDICCLCAMIF_H
#define CTRWSKDICCLCAMIF_H

#include "Wskd.h"

#define CmdWskdIcclCamifGetReg CtrWskdIcclCamif::CmdGetReg

#define VecVWskdIcclCamifCommand CtrWskdIcclCamif::VecVCommand

/**
	* CtrWskdIcclCamif
	*/
class CtrWskdIcclCamif : public CtrWskd {

public:
	/**
		* VecVCommand (full: VecVWskdIcclCamifCommand)
		*/
	class VecVCommand {

	public:
		static constexpr uint8_t SETRNG = 0x00;
		static constexpr uint8_t SETREG = 0x01;
		static constexpr uint8_t SETREGADDR = 0x02;
		static constexpr uint8_t GETREG = 0x03;
		static constexpr uint8_t MODREG = 0x04;

		static uint8_t getTix(const std::string& sref);
		static std::string getSref(const uint8_t tix);

		static void fillFeed(Sbecore::Feed& feed);
	};

public:
	CtrWskdIcclCamif(UntWskd* unt);

public:
	static const uint8_t tixVController = 0x02;

public:
	static uint8_t getTixVCommandBySref(const std::string& sref);
	static std::string getSrefByTixVCommand(const uint8_t tixVCommand);
	static void fillFeedFCommand(Sbecore::Feed& feed);

	static Dbecore::Cmd* getNewCmd(const uint8_t tixVCommand);

	static Dbecore::Cmd* getNewCmdSetRng();
	void setRng(const bool rng);

	static Dbecore::Cmd* getNewCmdSetReg();
	void setReg(const uint16_t addr, const uint8_t val);

	static Dbecore::Cmd* getNewCmdSetRegaddr();
	void setRegaddr(const uint16_t addr);

	static Dbecore::Cmd* getNewCmdGetReg();
	void getReg(uint8_t& val);

	static Dbecore::Cmd* getNewCmdModReg();
	void modReg(const uint16_t addr, const uint8_t mask, const uint8_t val);

};

#endif
