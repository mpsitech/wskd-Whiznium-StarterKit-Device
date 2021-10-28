/**
	* \file UntWskdMcep_vecs.h
	* Aries Cyclone V evaluation platform unit vectors (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 23 Oct 2021
	*/
// IP header --- ABOVE

#ifndef UNTWSKDMCEP_VECS_H
#define UNTWSKDMCEP_VECS_H

#include <sbecore/Xmlio.h>

/**
	* VecVWskdMcepCommand
	*/
namespace VecVWskdMcepCommand {

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

#endif
