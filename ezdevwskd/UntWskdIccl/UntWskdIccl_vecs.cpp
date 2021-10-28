/**
	* \file UntWskdIccl_vecs.cpp
	* Microchip PolarFire Soc Icicle kit unit vectors (implementation)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 23 Oct 2021
	*/
// IP header --- ABOVE

#include "UntWskdIccl_vecs.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;

/******************************************************************************
 namespace VecVWskdIcclController
 ******************************************************************************/

uint8_t VecVWskdIcclController::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "camacq") return CAMACQ;
	else if (s == "camif") return CAMIF;
	else if (s == "featdet") return FEATDET;
	else if (s == "laser") return LASER;
	else if (s == "state") return STATE;
	else if (s == "step") return STEP;
	else if (s == "tkclksrc") return TKCLKSRC;

	return(0);
};

string VecVWskdIcclController::getSref(
			const uint8_t tix
		) {
	if (tix == CAMACQ) return("camacq");
	else if (tix == CAMIF) return("camif");
	else if (tix == FEATDET) return("featdet");
	else if (tix == LASER) return("laser");
	else if (tix == STATE) return("state");
	else if (tix == STEP) return("step");
	else if (tix == TKCLKSRC) return("tkclksrc");

	return("");
};

void VecVWskdIcclController::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {CAMACQ,CAMIF,FEATDET,LASER,STATE,STEP,TKCLKSRC};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};

/******************************************************************************
 namespace VecVWskdIcclState
 ******************************************************************************/

uint8_t VecVWskdIcclState::getTix(
			const string& sref
		) {
	string s = StrMod::lc(sref);

	if (s == "nc") return NC;
	else if (s == "ready") return READY;
	else if (s == "active") return ACTIVE;

	return(0);
};

string VecVWskdIcclState::getSref(
			const uint8_t tix
		) {
	if (tix == NC) return("nc");
	else if (tix == READY) return("ready");
	else if (tix == ACTIVE) return("active");

	return("");
};

string VecVWskdIcclState::getTitle(
			const uint8_t tix
		) {
	if (tix == NC) return("offline");
	else if (tix == READY) return("ready");
	else if (tix == ACTIVE) return("streaming");

	return("");
};

void VecVWskdIcclState::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {NC,READY,ACTIVE};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getTitle(*it));
};

/******************************************************************************
 namespace VecWWskdIcclBuffer
 ******************************************************************************/

uint8_t VecWWskdIcclBuffer::getTix(
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

string VecWWskdIcclBuffer::getSref(
			const uint8_t tix
		) {
	if (tix == CMDRETTOHOSTIF) return("cmdretToHostif");
	else if (tix == HOSTIFTOCMDINV) return("hostifToCmdinv");
	else if (tix == FLGBUFFEATDETTOHOSTIF) return("flgbufFeatdetToHostif");
	else if (tix == PVWABUFCAMACQTOHOSTIF) return("pvwabufCamacqToHostif");
	else if (tix == PVWBBUFCAMACQTOHOSTIF) return("pvwbbufCamacqToHostif");

	return("");
};

void VecWWskdIcclBuffer::fillFeed(
			Feed& feed
		) {
	feed.clear();

	std::set<uint8_t> items = {CMDRETTOHOSTIF,HOSTIFTOCMDINV,FLGBUFFEATDETTOHOSTIF,PVWABUFCAMACQTOHOSTIF,PVWBBUFCAMACQTOHOSTIF};

	for (auto it = items.begin(); it != items.end(); it++) feed.appendIxSrefTitles(*it, getSref(*it), getSref(*it));
};
