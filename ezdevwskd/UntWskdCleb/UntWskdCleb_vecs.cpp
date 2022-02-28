/**
	* \file UntWskdCleb_vecs.cpp
	* Lattice CrossLink-NX Evaluation Board unit vectors (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 24 Dec 2021
	*/
// IP header --- ABOVE

#include "UntWskdCleb_vecs.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;

/******************************************************************************
 namespace VecVWskdClebController
 ******************************************************************************/

uint8_t VecVWskdClebController::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "laser") return LASER;
	else if (s == "state") return STATE;
	else if (s == "step") return STEP;
	else if (s == "tkclksrc") return TKCLKSRC;

	return(0);
};

string VecVWskdClebController::getSref(
			const uint8_t tix
		) {
	if (tix == LASER) return("laser");
	else if (tix == STATE) return("state");
	else if (tix == STEP) return("step");
	else if (tix == TKCLKSRC) return("tkclksrc");

	return("");
};

void VecVWskdClebController::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {LASER,STATE,STEP,TKCLKSRC};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 namespace VecVWskdClebState
 ******************************************************************************/

uint8_t VecVWskdClebState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "nc") return NC;
	else if (s == "ready") return READY;
	else if (s == "active") return ACTIVE;

	return(0);
};

string VecVWskdClebState::getSref(
			const uint8_t tix
		) {
	if (tix == NC) return("nc");
	else if (tix == READY) return("ready");
	else if (tix == ACTIVE) return("active");

	return("");
};

string VecVWskdClebState::getTitle(
			const uint8_t tix
		) {
	if (tix == NC) return("offline");
	else if (tix == READY) return("ready");
	else if (tix == ACTIVE) return("streaming");

	return("");
};

void VecVWskdClebState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {NC,READY,ACTIVE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 namespace VecWWskdClebBuffer
 ******************************************************************************/

uint8_t VecWWskdClebBuffer::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "cmdrettohostif") return CMDRETTOHOSTIF;
	else if (s == "hostiftocmdinv") return HOSTIFTOCMDINV;

	return(0);
};

string VecWWskdClebBuffer::getSref(
			const uint8_t tix
		) {
	if (tix == CMDRETTOHOSTIF) return("cmdretToHostif");
	else if (tix == HOSTIFTOCMDINV) return("hostifToCmdinv");

	return("");
};

void VecWWskdClebBuffer::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {CMDRETTOHOSTIF,HOSTIFTOCMDINV};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};
