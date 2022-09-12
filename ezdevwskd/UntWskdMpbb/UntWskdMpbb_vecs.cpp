/**
	* \file UntWskdMpbb_vecs.cpp
	* enclustra Mercury+ base board unit vectors (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 8 Jun 2022
	*/
// IP header --- ABOVE

#include "UntWskdMpbb_vecs.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;

/******************************************************************************
 namespace VecVWskdMpbbCommand
 ******************************************************************************/

uint8_t VecVWskdMpbbCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	return(0);
};

string VecVWskdMpbbCommand::getSref(
			const uint8_t tix
		) {

	return("");
};

void VecVWskdMpbbCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();
};
