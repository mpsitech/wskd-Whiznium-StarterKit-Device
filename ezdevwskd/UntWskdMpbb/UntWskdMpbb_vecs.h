/**
	* \file UntWskdMpbb_vecs.h
	* enclustra Mercury+ base board unit vectors (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 8 Jun 2022
	*/
// IP header --- ABOVE

#ifndef UNTWSKDMPBB_VECS_H
#define UNTWSKDMPBB_VECS_H

#include <sbecore/Xmlio.h>

/**
	* VecVWskdMpbbCommand
	*/
namespace VecVWskdMpbbCommand {

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

#endif
