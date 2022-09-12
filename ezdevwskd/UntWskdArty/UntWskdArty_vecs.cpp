/**
	* \file UntWskdArty_vecs.cpp
	* Digilent Arty Z7 unit vectors (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#include "UntWskdArty_vecs.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;

/******************************************************************************
 namespace VecVWskdArtyController
 ******************************************************************************/

uint8_t VecVWskdArtyController::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "camacq") return CAMACQ;
	else if (s == "camif") return CAMIF;
	else if (s == "featdet") return FEATDET;
	else if (s == "laser") return LASER;
	else if (s == "pwmonif") return PWMONIF;
	else if (s == "state") return STATE;
	else if (s == "step") return STEP;
	else if (s == "tkclksrc") return TKCLKSRC;

	return(0);
};

string VecVWskdArtyController::getSref(
			const uint8_t tix
		) {
	if (tix == CAMACQ) return("camacq");
	else if (tix == CAMIF) return("camif");
	else if (tix == FEATDET) return("featdet");
	else if (tix == LASER) return("laser");
	else if (tix == PWMONIF) return("pwmonif");
	else if (tix == STATE) return("state");
	else if (tix == STEP) return("step");
	else if (tix == TKCLKSRC) return("tkclksrc");

	return("");
};

void VecVWskdArtyController::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {CAMACQ,CAMIF,FEATDET,LASER,PWMONIF,STATE,STEP,TKCLKSRC};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 namespace VecVWskdArtyState
 ******************************************************************************/

uint8_t VecVWskdArtyState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "nc") return NC;
	else if (s == "ready") return READY;
	else if (s == "active") return ACTIVE;

	return(0);
};

string VecVWskdArtyState::getSref(
			const uint8_t tix
		) {
	if (tix == NC) return("nc");
	else if (tix == READY) return("ready");
	else if (tix == ACTIVE) return("active");

	return("");
};

string VecVWskdArtyState::getTitle(
			const uint8_t tix
		) {
	if (tix == NC) return("offline");
	else if (tix == READY) return("ready");
	else if (tix == ACTIVE) return("streaming");

	return("");
};

void VecVWskdArtyState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {NC,READY,ACTIVE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 namespace VecWWskdArtyBuffer
 ******************************************************************************/

uint8_t VecWWskdArtyBuffer::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "cmdrettohostif") return CMDRETTOHOSTIF;
	else if (s == "hostiftocmdinv") return HOSTIFTOCMDINV;
	else if (s == "flgbuffeatdettohostif") return FLGBUFFEATDETTOHOSTIF;
	else if (s == "pvwabufcamacqtohostif") return PVWABUFCAMACQTOHOSTIF;
	else if (s == "pvwbbufcamacqtohostif") return PVWBBUFCAMACQTOHOSTIF;

	return(0);
};

string VecWWskdArtyBuffer::getSref(
			const uint8_t tix
		) {
	if (tix == CMDRETTOHOSTIF) return("cmdretToHostif");
	else if (tix == HOSTIFTOCMDINV) return("hostifToCmdinv");
	else if (tix == FLGBUFFEATDETTOHOSTIF) return("flgbufFeatdetToHostif");
	else if (tix == PVWABUFCAMACQTOHOSTIF) return("pvwabufCamacqToHostif");
	else if (tix == PVWBBUFCAMACQTOHOSTIF) return("pvwbbufCamacqToHostif");

	return("");
};

void VecWWskdArtyBuffer::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {CMDRETTOHOSTIF,HOSTIFTOCMDINV,FLGBUFFEATDETTOHOSTIF,PVWABUFCAMACQTOHOSTIF,PVWBBUFCAMACQTOHOSTIF};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};
