/**
	* \file UntWskdArty.cpp
	* Digilent Arty Z7 unit (implementation)
	* \author Catherine Johnson
	* \date created: 6 Oct 2020
	* \date modified: 6 Oct 2020
	*/

#include "UntWskdArty.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

UntWskdArty::UntWskdArty() : UntWskd() {
	// IP constructor --- IBEGIN
	fd = 0;

	histNotDump = false;
	// IP constructor --- IEND
};

UntWskdArty::~UntWskdArty() {
	if (initdone) term();
};

// IP init.hdr --- RBEGIN
void UntWskdArty::init(
			const string& _path
		) {
// IP init.hdr --- REND
	camacq = new CtrWskdArtyCamacq(this);
	camif = new CtrWskdArtyCamif(this);
	featdet = new CtrWskdArtyFeatdet(this);
	laser = new CtrWskdArtyLaser(this);
	state = new CtrWskdArtyState(this);
	step = new CtrWskdArtyStep(this);
	tkclksrc = new CtrWskdArtyTkclksrc(this);

	// IP init.cust --- IBEGIN
	path = _path;

	Nretry = 5;

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

void UntWskdArty::term() {
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

bool UntWskdArty::rx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

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
		timeout.tv_usec = to;

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

bool UntWskdArty::tx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

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

void UntWskdArty::flush() {
	// IP flush --- INSERT
};

utinyint UntWskdArty::getTixVControllerBySref(
			const string& sref
		) {
	return VecVWskdArtyController::getTix(sref);
};

string UntWskdArty::getSrefByTixVController(
			const utinyint tixVController
		) {
	return VecVWskdArtyController::getSref(tixVController);
};

void UntWskdArty::fillFeedFController(
			Feed& feed
		) {
	VecVWskdArtyController::fillFeed(feed);
};

utinyint UntWskdArty::getTixWBufferBySref(
			const string& sref
		) {
	return VecWWskdArtyBuffer::getTix(sref);
};

string UntWskdArty::getSrefByTixWBuffer(
			const utinyint tixWBuffer
		) {
	return VecWWskdArtyBuffer::getSref(tixWBuffer);
};

void UntWskdArty::fillFeedFBuffer(
			Feed& feed
		) {
	VecWWskdArtyBuffer::fillFeed(feed);
};

utinyint UntWskdArty::getTixVCommandBySref(
			const utinyint tixVController
			, const string& sref
		) {
	utinyint tixVCommand = 0;

	if (tixVController == VecVWskdArtyController::CAMACQ) tixVCommand = VecVWskdArtyCamacqCommand::getTix(sref);
	else if (tixVController == VecVWskdArtyController::CAMIF) tixVCommand = VecVWskdArtyCamifCommand::getTix(sref);
	else if (tixVController == VecVWskdArtyController::FEATDET) tixVCommand = VecVWskdArtyFeatdetCommand::getTix(sref);
	else if (tixVController == VecVWskdArtyController::LASER) tixVCommand = VecVWskdArtyLaserCommand::getTix(sref);
	else if (tixVController == VecVWskdArtyController::STATE) tixVCommand = VecVWskdArtyStateCommand::getTix(sref);
	else if (tixVController == VecVWskdArtyController::STEP) tixVCommand = VecVWskdArtyStepCommand::getTix(sref);
	else if (tixVController == VecVWskdArtyController::TKCLKSRC) tixVCommand = VecVWskdArtyTkclksrcCommand::getTix(sref);

	return tixVCommand;
};

string UntWskdArty::getSrefByTixVCommand(
			const utinyint tixVController
			, const utinyint tixVCommand
		) {
	string sref;

	if (tixVController == VecVWskdArtyController::CAMACQ) sref = VecVWskdArtyCamacqCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdArtyController::CAMIF) sref = VecVWskdArtyCamifCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdArtyController::FEATDET) sref = VecVWskdArtyFeatdetCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdArtyController::LASER) sref = VecVWskdArtyLaserCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdArtyController::STATE) sref = VecVWskdArtyStateCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdArtyController::STEP) sref = VecVWskdArtyStepCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdArtyController::TKCLKSRC) sref = VecVWskdArtyTkclksrcCommand::getSref(tixVCommand);

	return sref;
};

void UntWskdArty::fillFeedFCommand(
			const utinyint tixVController
			, Feed& feed
		) {
	feed.clear();

	if (tixVController == VecVWskdArtyController::CAMACQ) VecVWskdArtyCamacqCommand::fillFeed(feed);
	else if (tixVController == VecVWskdArtyController::CAMIF) VecVWskdArtyCamifCommand::fillFeed(feed);
	else if (tixVController == VecVWskdArtyController::FEATDET) VecVWskdArtyFeatdetCommand::fillFeed(feed);
	else if (tixVController == VecVWskdArtyController::LASER) VecVWskdArtyLaserCommand::fillFeed(feed);
	else if (tixVController == VecVWskdArtyController::STATE) VecVWskdArtyStateCommand::fillFeed(feed);
	else if (tixVController == VecVWskdArtyController::STEP) VecVWskdArtyStepCommand::fillFeed(feed);
	else if (tixVController == VecVWskdArtyController::TKCLKSRC) VecVWskdArtyTkclksrcCommand::fillFeed(feed);
};

Bufxf* UntWskdArty::getNewBufxf(
			const utinyint tixWBuffer
			, const size_t reqlen
			, unsigned char* buf
		) {
	Bufxf* bufxf = NULL;

	if (tixWBuffer == VecWWskdArtyBuffer::FLGBUFFEATDETTOHOSTIF) bufxf = getNewBufxfFlgbufFromFeatdet(reqlen, buf);
	else if (tixWBuffer == VecWWskdArtyBuffer::PVWABUFCAMACQTOHOSTIF) bufxf = getNewBufxfPvwabufFromCamacq(reqlen, buf);
	else if (tixWBuffer == VecWWskdArtyBuffer::PVWBBUFCAMACQTOHOSTIF) bufxf = getNewBufxfPvwbbufFromCamacq(reqlen, buf);

	return bufxf;
};

Cmd* UntWskdArty::getNewCmd(
			const utinyint tixVController
			, const utinyint tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVController == VecVWskdArtyController::CAMACQ) cmd = CtrWskdArtyCamacq::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdArtyController::CAMIF) cmd = CtrWskdArtyCamif::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdArtyController::FEATDET) cmd = CtrWskdArtyFeatdet::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdArtyController::LASER) cmd = CtrWskdArtyLaser::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdArtyController::STATE) cmd = CtrWskdArtyState::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdArtyController::STEP) cmd = CtrWskdArtyStep::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdArtyController::TKCLKSRC) cmd = CtrWskdArtyTkclksrc::getNewCmd(tixVCommand);

	return cmd;
};

Bufxf* UntWskdArty::getNewBufxfFlgbufFromFeatdet(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecWWskdArtyBuffer::FLGBUFFEATDETTOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWskdArty::readFlgbufFromFeatdet(
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

Bufxf* UntWskdArty::getNewBufxfPvwabufFromCamacq(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecWWskdArtyBuffer::PVWABUFCAMACQTOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWskdArty::readPvwabufFromCamacq(
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

Bufxf* UntWskdArty::getNewBufxfPvwbbufFromCamacq(
			const size_t reqlen
			, unsigned char* buf
		) {
	return(new Bufxf(VecWWskdArtyBuffer::PVWBBUFCAMACQTOHOSTIF, false, reqlen, 0, 2, buf));
};

void UntWskdArty::readPvwbbufFromCamacq(
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



