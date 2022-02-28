/**
	* \file UntWskdMcvevp_vecs.cpp
	* Aries Cyclone V evaluation platform unit vectors (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#include "UntWskdMcvevp_vecs.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;

/******************************************************************************
 namespace VecVWskdMcvevpCommand
 ******************************************************************************/

uint8_t VecVWskdMcvevpCommand::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	return(0);
};

string VecVWskdMcvevpCommand::getSref(
			const uint8_t tix
		) {

	return("");
};

void VecVWskdMcvevpCommand::fillFeed(
			Feed& feed
		) {
	feed.clear();
};
