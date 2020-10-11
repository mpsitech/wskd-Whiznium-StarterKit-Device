/**
	* \file UntWskdSkmn.cpp
	* MPSI starter kit mainboard unit (implementation)
	* \author Catherine Johnson
	* \date created: 6 Oct 2020
	* \date modified: 6 Oct 2020
	*/

#include "UntWskdSkmn.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

UntWskdSkmn::UntWskdSkmn() : UntWskd() {
	// IP constructor --- INSERT
};

UntWskdSkmn::~UntWskdSkmn() {
	if (initdone) term();
};

void UntWskdSkmn::init() { // IP init.hdr --- LINE
	chrono = new CtrWskdSkmnChrono(this);
	laser = new CtrWskdSkmnLaser(this);
	state = new CtrWskdSkmnState(this);
	step = new CtrWskdSkmnStep(this);

	// IP init.cust --- INSERT

	initdone = true;
};

void UntWskdSkmn::term() {
	// IP term.cust --- INSERT

	delete chrono;
	delete laser;
	delete state;
	delete step;

	initdone = false;
};

bool UntWskdSkmn::rx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// IP rx --- INSERT

	return retval;
};

bool UntWskdSkmn::tx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// IP tx --- INSERT

	return retval;
};

void UntWskdSkmn::flush() {
	// IP flush --- INSERT
};

utinyint UntWskdSkmn::getTixVControllerBySref(
			const string& sref
		) {
	return VecVWskdSkmnController::getTix(sref);
};

string UntWskdSkmn::getSrefByTixVController(
			const utinyint tixVController
		) {
	return VecVWskdSkmnController::getSref(tixVController);
};

void UntWskdSkmn::fillFeedFController(
			Feed& feed
		) {
	VecVWskdSkmnController::fillFeed(feed);
};

utinyint UntWskdSkmn::getTixWBufferBySref(
			const string& sref
		) {
	return VecWWskdSkmnBuffer::getTix(sref);
};

string UntWskdSkmn::getSrefByTixWBuffer(
			const utinyint tixWBuffer
		) {
	return VecWWskdSkmnBuffer::getSref(tixWBuffer);
};

void UntWskdSkmn::fillFeedFBuffer(
			Feed& feed
		) {
	VecWWskdSkmnBuffer::fillFeed(feed);
};

utinyint UntWskdSkmn::getTixVCommandBySref(
			const utinyint tixVController
			, const string& sref
		) {
	utinyint tixVCommand = 0;

	if (tixVController == VecVWskdSkmnController::CHRONO) tixVCommand = VecVWskdSkmnChronoCommand::getTix(sref);
	else if (tixVController == VecVWskdSkmnController::LASER) tixVCommand = VecVWskdSkmnLaserCommand::getTix(sref);
	else if (tixVController == VecVWskdSkmnController::STATE) tixVCommand = VecVWskdSkmnStateCommand::getTix(sref);
	else if (tixVController == VecVWskdSkmnController::STEP) tixVCommand = VecVWskdSkmnStepCommand::getTix(sref);

	return tixVCommand;
};

string UntWskdSkmn::getSrefByTixVCommand(
			const utinyint tixVController
			, const utinyint tixVCommand
		) {
	string sref;

	if (tixVController == VecVWskdSkmnController::CHRONO) sref = VecVWskdSkmnChronoCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdSkmnController::LASER) sref = VecVWskdSkmnLaserCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdSkmnController::STATE) sref = VecVWskdSkmnStateCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdSkmnController::STEP) sref = VecVWskdSkmnStepCommand::getSref(tixVCommand);

	return sref;
};

void UntWskdSkmn::fillFeedFCommand(
			const utinyint tixVController
			, Feed& feed
		) {
	feed.clear();

	if (tixVController == VecVWskdSkmnController::CHRONO) VecVWskdSkmnChronoCommand::fillFeed(feed);
	else if (tixVController == VecVWskdSkmnController::LASER) VecVWskdSkmnLaserCommand::fillFeed(feed);
	else if (tixVController == VecVWskdSkmnController::STATE) VecVWskdSkmnStateCommand::fillFeed(feed);
	else if (tixVController == VecVWskdSkmnController::STEP) VecVWskdSkmnStepCommand::fillFeed(feed);
};

Bufxf* UntWskdSkmn::getNewBufxf(
			const utinyint tixWBuffer
			, const size_t reqlen
			, unsigned char* buf
		) {
	Bufxf* bufxf = NULL;

	return bufxf;
};

Cmd* UntWskdSkmn::getNewCmd(
			const utinyint tixVController
			, const utinyint tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVController == VecVWskdSkmnController::CHRONO) cmd = CtrWskdSkmnChrono::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdSkmnController::LASER) cmd = CtrWskdSkmnLaser::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdSkmnController::STATE) cmd = CtrWskdSkmnState::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdSkmnController::STEP) cmd = CtrWskdSkmnStep::getNewCmd(tixVCommand);

	return cmd;
};

