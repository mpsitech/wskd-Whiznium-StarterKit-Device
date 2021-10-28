/**
	* \file UntWskdIccl.cpp
	* Microchip PolarFire Soc Icicle kit unit (implementation)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 23 Oct 2021
	*/
// IP header --- ABOVE

#include "UntWskdIccl.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

UntWskdIccl::UntWskdIccl() : UntWskd() {
	// IP constructor --- IBEGIN
	fd = 0;

	histNotDump = false;
	// IP constructor --- IEND
};

UntWskdIccl::~UntWskdIccl() {
	if (initdone) term();
};

// IP init.hdr --- RBEGIN
void UntWskdIccl::init(
			const string& _path
		) {
// IP init.hdr --- REND
	camacq = new CtrWskdIcclCamacq(this);
	camif = new CtrWskdIcclCamif(this);
	featdet = new CtrWskdIcclFeatdet(this);
	laser = new CtrWskdIcclLaser(this);
	state = new CtrWskdIcclState(this);
	step = new CtrWskdIcclStep(this);
	tkclksrc = new CtrWskdIcclTkclksrc(this);

	// IP init.cust --- IBEGIN
	path = _path;

	NRetry = 5;

	const size_t sizeRxbuf = 1024;
	rxbuf = new unsigned char[sizeRxbuf];

	const size_t sizeTxbuf = 1024;
	txbuf = new unsigned char[sizeTxbuf];

	// open character device
	fd = open(path.c_str(), O_RDWR);
	if (fd == -1) {
		fd = 0;
		throw DbeException("error opening device " + path + "");
	};
	// IP init.cust --- IEND

	initdone = true;
};

void UntWskdIccl::term() {
	// IP term.cust --- IBEGIN
	if (fd) {
		close(fd);
		fd = 0;
	};
	// IP term.cust --- IEND

	delete camacq;
	delete camif;
	delete featdet;
	delete laser;
	delete state;
	delete step;
	delete tkclksrc;

	initdone = false;
};

bool UntWskdIccl::rx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: receive data from device observing history / rxtxdump settings

	// IP rx --- IBEGIN
	if (reqlen != 0) {
		fd_set fds;
		timeval timeout;
		int s;

		size_t nleft;
		int n;

		int en;

		string msg;

		FD_ZERO(&fds);
		FD_SET(fd, &fds);

		timeout.tv_sec = 0;
		timeout.tv_usec = timeoutRx;

		if (rxtxdump) {
			if (!histNotDump) cout << "rx ";
			else hist.push_back("rx ");
		};

		nleft = reqlen;
		en = 0;

		while (nleft > 0) {
			s = select(fd+1, &fds, NULL, NULL, &timeout);

			if (s > 0) {
				n = read(fd, &(buf[reqlen-nleft]), nleft);

				if (n > 0) nleft -= n;
				else {
					if (n == 0) en = ETIMEDOUT; // driver transfers all data at a time or none
					else en = errno;

					break;
				};

			} else if (s == 0) {
				en = ETIMEDOUT;
				break;
			} else {
				en = errno;
			};
		};

		retval = (nleft == 0);

		if (rxtxdump) {
			if (nleft == 0) msg = "0x" + Dbe::bufToHex(buf, reqlen, true);
			else msg = string(strerror(en));
			
			if (!histNotDump) cout << msg << endl;
			else hist[hist.size() - 1] += msg;
		};
	};
	// IP rx --- IEND

	return retval;
};

bool UntWskdIccl::tx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: transmit data to device observing history / rxtxdump settings

	// IP tx --- IBEGIN
	if (reqlen != 0) {
		size_t nleft;
		int n;

		string msg;

		if (rxtxdump) {
			if (!histNotDump) cout << "tx ";
			else hist.push_back("tx ");
		};

		nleft = reqlen;
		n = 0;

		while (nleft > 0) {
			n = write(fd, &(buf[reqlen-nleft]), nleft);

			if (n > 0) nleft -= n; // driver transfers all data at a time or none
			else break;
		};

		retval = (nleft == 0);

		if (rxtxdump) {
			if (nleft == 0) msg = "0x" + Dbe::bufToHex(buf, reqlen, true);
			else msg = string(strerror(n));

			if (!histNotDump) cout << msg << endl;
			else hist[hist.size() - 1] += msg;
		};
	};
	// IP tx --- IEND

	return retval;
};

void UntWskdIccl::flush() {
	// IP flush --- INSERT
};

uint8_t UntWskdIccl::getTixVControllerBySref(
			const string& sref
		) {
	return VecVWskdIcclController::getTix(sref);
};

string UntWskdIccl::getSrefByTixVController(
			const uint8_t tixVController
		) {
	return VecVWskdIcclController::getSref(tixVController);
};

void UntWskdIccl::fillFeedFController(
			Feed& feed
		) {
	VecVWskdIcclController::fillFeed(feed);
};

uint8_t UntWskdIccl::getTixWBufferBySref(
			const string& sref
		) {
	return VecWWskdIcclBuffer::getTix(sref);
};

string UntWskdIccl::getSrefByTixWBuffer(
			const uint8_t tixWBuffer
		) {
	return VecWWskdIcclBuffer::getSref(tixWBuffer);
};

void UntWskdIccl::fillFeedFBuffer(
			Feed& feed
		) {
	VecWWskdIcclBuffer::fillFeed(feed);
};

uint8_t UntWskdIccl::getTixVCommandBySref(
			const uint8_t tixVController
			, const string& sref
		) {
	uint8_t tixVCommand = 0;

	if (tixVController == VecVWskdIcclController::CAMACQ) tixVCommand = VecVWskdIcclCamacqCommand::getTix(sref);
	else if (tixVController == VecVWskdIcclController::CAMIF) tixVCommand = VecVWskdIcclCamifCommand::getTix(sref);
	else if (tixVController == VecVWskdIcclController::FEATDET) tixVCommand = VecVWskdIcclFeatdetCommand::getTix(sref);
	else if (tixVController == VecVWskdIcclController::LASER) tixVCommand = VecVWskdIcclLaserCommand::getTix(sref);
	else if (tixVController == VecVWskdIcclController::STATE) tixVCommand = VecVWskdIcclStateCommand::getTix(sref);
	else if (tixVController == VecVWskdIcclController::STEP) tixVCommand = VecVWskdIcclStepCommand::getTix(sref);
	else if (tixVController == VecVWskdIcclController::TKCLKSRC) tixVCommand = VecVWskdIcclTkclksrcCommand::getTix(sref);

	return tixVCommand;
};

string UntWskdIccl::getSrefByTixVCommand(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	string sref;

	if (tixVController == VecVWskdIcclController::CAMACQ) sref = VecVWskdIcclCamacqCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdIcclController::CAMIF) sref = VecVWskdIcclCamifCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdIcclController::FEATDET) sref = VecVWskdIcclFeatdetCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdIcclController::LASER) sref = VecVWskdIcclLaserCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdIcclController::STATE) sref = VecVWskdIcclStateCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdIcclController::STEP) sref = VecVWskdIcclStepCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdIcclController::TKCLKSRC) sref = VecVWskdIcclTkclksrcCommand::getSref(tixVCommand);

	return sref;
};

void UntWskdIccl::fillFeedFCommand(
			const uint8_t tixVController
			, Feed& feed
		) {
	feed.clear();

	if (tixVController == VecVWskdIcclController::CAMACQ) VecVWskdIcclCamacqCommand::fillFeed(feed);
	else if (tixVController == VecVWskdIcclController::CAMIF) VecVWskdIcclCamifCommand::fillFeed(feed);
	else if (tixVController == VecVWskdIcclController::FEATDET) VecVWskdIcclFeatdetCommand::fillFeed(feed);
	else if (tixVController == VecVWskdIcclController::LASER) VecVWskdIcclLaserCommand::fillFeed(feed);
	else if (tixVController == VecVWskdIcclController::STATE) VecVWskdIcclStateCommand::fillFeed(feed);
	else if (tixVController == VecVWskdIcclController::STEP) VecVWskdIcclStepCommand::fillFeed(feed);
	else if (tixVController == VecVWskdIcclController::TKCLKSRC) VecVWskdIcclTkclksrcCommand::fillFeed(feed);
};

Bufxf* UntWskdIccl::getNewBufxf(
			const uint8_t tixWBuffer
			, const size_t reqlen
			, unsigned char* buf
		) {
	Bufxf* bufxf = NULL;

	if (tixWBuffer == VecWWskdIcclBuffer::FLGBUFFEATDETTOHOSTIF) bufxf = getNewBufxfFlgbufFromFeatdet(reqlen, buf);
	else if (tixWBuffer == VecWWskdIcclBuffer::PVWABUFCAMACQTOHOSTIF) bufxf = getNewBufxfPvwabufFromCamacq(reqlen, buf);
	else if (tixWBuffer == VecWWskdIcclBuffer::PVWBBUFCAMACQTOHOSTIF) bufxf = getNewBufxfPvwbbufFromCamacq(reqlen, buf);

	return bufxf;
};

Cmd* UntWskdIccl::getNewCmd(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVController == VecVWskdIcclController::CAMACQ) cmd = CtrWskdIcclCamacq::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdIcclController::CAMIF) cmd = CtrWskdIcclCamif::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdIcclController::FEATDET) cmd = CtrWskdIcclFeatdet::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdIcclController::LASER) cmd = CtrWskdIcclLaser::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdIcclController::STATE) cmd = CtrWskdIcclState::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdIcclController::STEP) cmd = CtrWskdIcclStep::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdIcclController::TKCLKSRC) cmd = CtrWskdIcclTkclksrc::getNewCmd(tixVCommand);

	return cmd;
};

Bufxf* UntWskdIccl::getNewBufxfFlgbufFromFeatdet(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecWWskdIcclBuffer::FLGBUFFEATDETTOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWskdIccl::readFlgbufFromFeatdet(
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

Bufxf* UntWskdIccl::getNewBufxfPvwabufFromCamacq(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecWWskdIcclBuffer::PVWABUFCAMACQTOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWskdIccl::readPvwabufFromCamacq(
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

Bufxf* UntWskdIccl::getNewBufxfPvwbbufFromCamacq(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecWWskdIcclBuffer::PVWBBUFCAMACQTOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWskdIccl::readPvwbbufFromCamacq(
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
