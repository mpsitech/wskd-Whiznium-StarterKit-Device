/**
	* \file UntWskdUbdk_vecs.cpp
	* SiLabs EFM8UB10 Development Kit unit vectors (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "UntWskdUbdk_vecs.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;

/******************************************************************************
 namespace VecVWskdUbdkController
 ******************************************************************************/

uint8_t VecVWskdUbdkController::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "chrono") return CHRONO;
	else if (s == "disp") return DISP;
	else if (s == "laser") return LASER;
	else if (s == "state") return STATE;
	else if (s == "step") return STEP;

	return(0);
};

string VecVWskdUbdkController::getSref(
			const uint8_t tix
		) {
	if (tix == CHRONO) return("chrono");
	else if (tix == DISP) return("disp");
	else if (tix == LASER) return("laser");
	else if (tix == STATE) return("state");
	else if (tix == STEP) return("step");

	return("");
};

void VecVWskdUbdkController::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {CHRONO,DISP,LASER,STATE,STEP};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 namespace VecVWskdUbdkState
 ******************************************************************************/

uint8_t VecVWskdUbdkState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "nc") return NC;
	else if (s == "ready") return READY;
	else if (s == "active") return ACTIVE;

	return(0);
};

string VecVWskdUbdkState::getSref(
			const uint8_t tix
		) {
	if (tix == NC) return("nc");
	else if (tix == READY) return("ready");
	else if (tix == ACTIVE) return("active");

	return("");
};

string VecVWskdUbdkState::getTitle(
			const uint8_t tix
		) {
	if (tix == NC) return("offline");
	else if (tix == READY) return("ready");
	else if (tix == ACTIVE) return("turntable in motion");

	return("");
};

void VecVWskdUbdkState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {NC,READY,ACTIVE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 namespace VecWWskdUbdkBuffer
 ******************************************************************************/

uint8_t VecWWskdUbdkBuffer::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "cmdrettohostif") return CMDRETTOHOSTIF;
	else if (s == "hostiftocmdinv") return HOSTIFTOCMDINV;

	return(0);
};

string VecWWskdUbdkBuffer::getSref(
			const uint8_t tix
		) {
	if (tix == CMDRETTOHOSTIF) return("cmdretToHostif");
	else if (tix == HOSTIFTOCMDINV) return("hostifToCmdinv");

	return("");
};

void VecWWskdUbdkBuffer::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {CMDRETTOHOSTIF,HOSTIFTOCMDINV};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};
