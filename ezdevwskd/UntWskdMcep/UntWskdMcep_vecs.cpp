/**
	* \file UntWskdMcep_vecs.cpp
	* Aries Cyclone V evaluation platform unit vectors (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 23 Oct 2021
	*/
// IP header --- ABOVE

#include "UntWskdMcep_vecs.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;

/******************************************************************************
 namespace VecVWskdMcepCommand
 ******************************************************************************/

uint8_t VecVWskdMcepCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	return(0);
};

string VecVWskdMcepCommand::getSref(
			const uint8_t tix
		) {

	return("");
};

void VecVWskdMcepCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();
};
