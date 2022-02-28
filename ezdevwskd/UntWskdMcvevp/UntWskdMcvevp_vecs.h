/**
	* \file UntWskdMcvevp_vecs.h
	* Aries Cyclone V evaluation platform unit vectors (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#ifndef UNTWSKDMCVEVP_VECS_H
#define UNTWSKDMCVEVP_VECS_H

#include <sbecore/Xmlio.h>

/**
	* VecVWskdMcvevpCommand
	*/
namespace VecVWskdMcvevpCommand {

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

#endif
