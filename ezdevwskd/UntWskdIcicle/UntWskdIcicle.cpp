/**
	* \file UntWskdIcicle.cpp
	* Microchip PolarFire Soc Icicle kit unit (implementation)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#include "UntWskdIcicle.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

UntWskdIcicle::UntWskdIcicle() : UntWskd() {
	// IP constructor --- INSERT
};

UntWskdIcicle::~UntWskdIcicle() {
	if (initdone) term();
};

void UntWskdIcicle::init() { // IP init.hdr --- LINE
	camacq = new CtrWskdIcicleCamacq(this);
	camif = new CtrWskdIcicleCamif(this);
	featdet = new CtrWskdIcicleFeatdet(this);
	laser = new CtrWskdIcicleLaser(this);
	state = new CtrWskdIcicleState(this);
	step = new CtrWskdIcicleStep(this);
	tkclksrc = new CtrWskdIcicleTkclksrc(this);

	// IP init.cust --- INSERT

	initdone = true;
};

void UntWskdIcicle::term() {
	// IP term.cust --- INSERT

	delete camacq;
	delete camif;
	delete featdet;
	delete laser;
	delete state;
	delete step;
	delete tkclksrc;

	initdone = false;
};

bool UntWskdIcicle::rx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: receive data from device observing history / rxtxdump settings

	// IP rx --- INSERT

	return retval;
};

bool UntWskdIcicle::tx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: transmit data to device observing history / rxtxdump settings

	// IP tx --- INSERT

	return retval;
};

void UntWskdIcicle::flush() {
	// IP flush --- INSERT
};

uint8_t UntWskdIcicle::getTixVControllerBySref(
			const string& sref
		) {
	return VecVWskdIcicleController::getTix(sref);
};

string UntWskdIcicle::getSrefByTixVController(
			const uint8_t tixVController
		) {
	return VecVWskdIcicleController::getSref(tixVController);
};

void UntWskdIcicle::fillFeedFController(
			Feed& feed
		) {
	VecVWskdIcicleController::fillFeed(feed);
};

uint8_t UntWskdIcicle::getTixWBufferBySref(
			const string& sref
		) {
	return VecWWskdIcicleBuffer::getTix(sref);
};

string UntWskdIcicle::getSrefByTixWBuffer(
			const uint8_t tixWBuffer
		) {
	return VecWWskdIcicleBuffer::getSref(tixWBuffer);
};

void UntWskdIcicle::fillFeedFBuffer(
			Feed& feed
		) {
	VecWWskdIcicleBuffer::fillFeed(feed);
};

uint8_t UntWskdIcicle::getTixVCommandBySref(
			const uint8_t tixVController
			, const string& sref
		) {
	uint8_t tixVCommand = 0;

	if (tixVController == VecVWskdIcicleController::CAMACQ) tixVCommand = VecVWskdIcicleCamacqCommand::getTix(sref);
	else if (tixVController == VecVWskdIcicleController::CAMIF) tixVCommand = VecVWskdIcicleCamifCommand::getTix(sref);
	else if (tixVController == VecVWskdIcicleController::FEATDET) tixVCommand = VecVWskdIcicleFeatdetCommand::getTix(sref);
	else if (tixVController == VecVWskdIcicleController::LASER) tixVCommand = VecVWskdIcicleLaserCommand::getTix(sref);
	else if (tixVController == VecVWskdIcicleController::STATE) tixVCommand = VecVWskdIcicleStateCommand::getTix(sref);
	else if (tixVController == VecVWskdIcicleController::STEP) tixVCommand = VecVWskdIcicleStepCommand::getTix(sref);
	else if (tixVController == VecVWskdIcicleController::TKCLKSRC) tixVCommand = VecVWskdIcicleTkclksrcCommand::getTix(sref);

	return tixVCommand;
};

string UntWskdIcicle::getSrefByTixVCommand(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	string sref;

	if (tixVController == VecVWskdIcicleController::CAMACQ) sref = VecVWskdIcicleCamacqCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdIcicleController::CAMIF) sref = VecVWskdIcicleCamifCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdIcicleController::FEATDET) sref = VecVWskdIcicleFeatdetCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdIcicleController::LASER) sref = VecVWskdIcicleLaserCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdIcicleController::STATE) sref = VecVWskdIcicleStateCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdIcicleController::STEP) sref = VecVWskdIcicleStepCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdIcicleController::TKCLKSRC) sref = VecVWskdIcicleTkclksrcCommand::getSref(tixVCommand);

	return sref;
};

void UntWskdIcicle::fillFeedFCommand(
			const uint8_t tixVController
			, Feed& feed
		) {
	feed.clear();

	if (tixVController == VecVWskdIcicleController::CAMACQ) VecVWskdIcicleCamacqCommand::fillFeed(feed);
	else if (tixVController == VecVWskdIcicleController::CAMIF) VecVWskdIcicleCamifCommand::fillFeed(feed);
	else if (tixVController == VecVWskdIcicleController::FEATDET) VecVWskdIcicleFeatdetCommand::fillFeed(feed);
	else if (tixVController == VecVWskdIcicleController::LASER) VecVWskdIcicleLaserCommand::fillFeed(feed);
	else if (tixVController == VecVWskdIcicleController::STATE) VecVWskdIcicleStateCommand::fillFeed(feed);
	else if (tixVController == VecVWskdIcicleController::STEP) VecVWskdIcicleStepCommand::fillFeed(feed);
	else if (tixVController == VecVWskdIcicleController::TKCLKSRC) VecVWskdIcicleTkclksrcCommand::fillFeed(feed);
};

Bufxf* UntWskdIcicle::getNewBufxf(
			const uint8_t tixWBuffer
			, const size_t reqlen
			, unsigned char* buf
		) {
	Bufxf* bufxf = NULL;

	if (tixWBuffer == VecWWskdIcicleBuffer::FLGBUFFROMFEATDET) bufxf = getNewBufxfFlgbufFromFeatdet(reqlen, buf);
	else if (tixWBuffer == VecWWskdIcicleBuffer::PVWABUFFROMCAMACQ) bufxf = getNewBufxfPvwabufFromCamacq(reqlen, buf);
	else if (tixWBuffer == VecWWskdIcicleBuffer::PVWBBUFFROMCAMACQ) bufxf = getNewBufxfPvwbbufFromCamacq(reqlen, buf);

	return bufxf;
};

Cmd* UntWskdIcicle::getNewCmd(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVController == VecVWskdIcicleController::CAMACQ) cmd = CtrWskdIcicleCamacq::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdIcicleController::CAMIF) cmd = CtrWskdIcicleCamif::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdIcicleController::FEATDET) cmd = CtrWskdIcicleFeatdet::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdIcicleController::LASER) cmd = CtrWskdIcicleLaser::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdIcicleController::STATE) cmd = CtrWskdIcicleState::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdIcicleController::STEP) cmd = CtrWskdIcicleStep::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdIcicleController::TKCLKSRC) cmd = CtrWskdIcicleTkclksrc::getNewCmd(tixVCommand);

	return cmd;
};

Bufxf* UntWskdIcicle::getNewBufxfFlgbufFromFeatdet(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecWWskdIcicleBuffer::FLGBUFFROMFEATDET, false, reqlen, 0, 2, buf));
};

void UntWskdIcicle::readFlgbufFromFeatdet(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfFlgbufFromFeatdet(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readFlgbufFromFeatdet");
	};

	delete bufxf;
};

Bufxf* UntWskdIcicle::getNewBufxfPvwabufFromCamacq(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecWWskdIcicleBuffer::PVWABUFFROMCAMACQ, false, reqlen, 0, 2, buf));
};

void UntWskdIcicle::readPvwabufFromCamacq(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfPvwabufFromCamacq(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readPvwabufFromCamacq");
	};

	delete bufxf;
};

Bufxf* UntWskdIcicle::getNewBufxfPvwbbufFromCamacq(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecWWskdIcicleBuffer::PVWBBUFFROMCAMACQ, false, reqlen, 0, 2, buf));
};

void UntWskdIcicle::readPvwbbufFromCamacq(
			const size_t reqlen
			, unsigned char*& data
			, size_t& datalen
		) {
	Bufxf* bufxf = getNewBufxfPvwbbufFromCamacq(reqlen, data);

	if (runBufxf(bufxf)) {
		if (!data) data = bufxf->getReadData();
		datalen = bufxf->getReadDatalen();

	} else {
		datalen = 0;

		delete bufxf;
		throw DbeException("error running readPvwbbufFromCamacq");
	};

	delete bufxf;
};
