/**
	* \file UntWskdSkmn_vecs.cpp
	* MPSI starter kit mainboard unit vectors (implementation)
	* \author Catherine Johnson
	* \date created: 17 Oct 2020
	* \date modified: 17 Oct 2020
	*/

#include "UntWskdSkmn_vecs.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;

/******************************************************************************
 namespace VecVWskdSkmnController
 ******************************************************************************/

utinyint VecVWskdSkmnController::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "chrono") return CHRONO;
	else if (s == "laser") return LASER;
	else if (s == "state") return STATE;
	else if (s == "step") return STEP;

	return(0);
};

string VecVWskdSkmnController::getSref(
			const utinyint tix
		) {
	if (tix == CHRONO) return("chrono");
	else if (tix == LASER) return("laser");
	else if (tix == STATE) return("state");
	else if (tix == STEP) return("step");

	return("");
};

void VecVWskdSkmnController::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {CHRONO,LASER,STATE,STEP};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 namespace VecVWskdSkmnState
 ******************************************************************************/

utinyint VecVWskdSkmnState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "nc") return NC;
	else if (s == "commerr") return COMMERR;
	else if (s == "rdy") return RDY;
	else if (s == "act") return ACT;

	return(0);
};

string VecVWskdSkmnState::getSref(
			const utinyint tix
		) {
	if (tix == NC) return("nc");
	else if (tix == COMMERR) return("commerr");
	else if (tix == RDY) return("rdy");
	else if (tix == ACT) return("act");

	return("");
};

string VecVWskdSkmnState::getTitle(
			const utinyint tix
		) {
	if (tix == NC) return("offline");
	else if (tix == COMMERR) return("communication error");
	else if (tix == RDY) return("ready");
	else if (tix == ACT) return("active");

	return("");
};

void VecVWskdSkmnState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {NC,COMMERR,RDY,ACT};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 namespace VecWWskdSkmnBuffer
 ******************************************************************************/

utinyint VecWWskdSkmnBuffer::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "cmdrettohostif") return CMDRETTOHOSTIF;
	else if (s == "hostiftocmdinv") return HOSTIFTOCMDINV;

	return(0);
};

string VecWWskdSkmnBuffer::getSref(
			const utinyint tix
		) {
	if (tix == CMDRETTOHOSTIF) return("cmdretToHostif");
	else if (tix == HOSTIFTOCMDINV) return("hostifToCmdinv");

	return("");
};

void VecWWskdSkmnBuffer::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<utinyint> items = {CMDRETTOHOSTIF,HOSTIFTOCMDINV};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

