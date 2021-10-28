/**
	* \file UntWskdUbdk.cpp
	* SiLabs EFM8UB10 Development Kit unit (implementation)
	* \copyright (C) 2017-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "UntWskdUbdk.h"

using namespace std;
using namespace Sbecore;
using namespace Xmlio;
using namespace Dbecore;

UntWskdUbdk::UntWskdUbdk() : UntWskd() {
	// IP constructor --- IBEGIN
	bpsRx = 0;
	bpsTx = 0;

	fd = 0;
	// IP constructor --- IEND
};

UntWskdUbdk::~UntWskdUbdk() {
	if (initdone) term();
};

// IP init.hdr --- RBEGIN
void UntWskdUbdk::init(
			const string& _path
			, const unsigned int _bpsRx
			, const unsigned int _bpsTx
		) {
// IP init.hdr --- REND
	chrono = new CtrWskdUbdkChrono(this);
	disp = new CtrWskdUbdkDisp(this);
	laser = new CtrWskdUbdkLaser(this);
	state = new CtrWskdUbdkState(this);
	step = new CtrWskdUbdkStep(this);

	// IP init.cust --- IBEGIN
	path = _path;
	bpsRx = _bpsRx;
	bpsTx = _bpsTx;

	NRetry = 3;
	timeoutRx = 25000; // in us; used in rx read() regardless of device configuration

///
	const size_t sizeRxbuf = 1024;
	rxbuf = new unsigned char[sizeRxbuf];

///
	const size_t sizeTxbuf = 1024;
	txbuf = new unsigned char[sizeTxbuf];

#ifdef __linux__
	// open character device
	fd = open(path.c_str(), O_RDWR | O_NOCTTY);
	if (fd == -1) {
		fd = 0;
		throw DbeException("error opening device " + path + "");
	};

	termios term;
	serial_struct ss;

	memset(&term, 0, sizeof(term));
	if (tcgetattr(fd, &term) != 0) throw DbeException("error getting terminal attributes");

	// 38400 8N1, no flow control, read blocking with 100ms timeout
	cfmakeraw(&term);

	if (bpsRx == 300) cfsetispeed(&term, B300);
	else if (bpsRx == 600) cfsetispeed(&term, B600);
	else if (bpsRx == 1200) cfsetispeed(&term, B1200);
	else if (bpsRx == 2400) cfsetispeed(&term, B2400);
	else if (bpsRx == 4800) cfsetispeed(&term, B4800);
	else if (bpsRx == 9600) cfsetispeed(&term, B9600);
	else cfsetispeed(&term, B38400);

	if (bpsTx == 300) cfsetospeed(&term, B300);
	else if (bpsTx == 600) cfsetospeed(&term, B600);
	else if (bpsTx == 1200) cfsetospeed(&term, B1200);
	else if (bpsTx == 2400) cfsetospeed(&term, B2400);
	else if (bpsTx == 4800) cfsetospeed(&term, B4800);
	else if (bpsTx == 9600) cfsetospeed(&term, B9600);
	else cfsetospeed(&term, B38400);

	term.c_iflag = 0;
	term.c_oflag = 0;

	term.c_cflag &= ~(CRTSCTS | CSIZE | CSTOPB);
	term.c_cflag |= (CLOCAL | CREAD | CS8);

	//term.c_lflag = 0;

	term.c_cc[VMIN] = 1;
	term.c_cc[VTIME] = 1;

	tcflush(fd, TCIOFLUSH);
	if (tcsetattr(fd, TCSANOW, &term) != 0) throw DbeException("error setting terminal attributes");

	if (ioctl(fd, TIOCGSERIAL, &ss) == -1) throw DbeException("error getting serial struct");

	cout << "ss.baud_base=" << ss.baud_base << endl; // should be 60'000'000

	ss.flags &= ~ASYNC_SPD_MASK;
	ss.flags |= ASYNC_SPD_CUST;

	int div = ss.baud_base / bpsRx; // down to 12 or up to 5MHz works
	ss.custom_divisor = div; // set to 10Mbps or 1MByte/s ; for 640*480*14/8=537.6kByte/s FLIR => more than 1 image per second

	if (ioctl(fd, TIOCSSERIAL, &ss) == -1) throw DbeException("error setting serial struct");
#endif
	// IP init.cust --- IEND

	initdone = true;
};

void UntWskdUbdk::term() {
	// IP term.cust --- IBEGIN
#ifdef __linux__
	if (fd) {
		close(fd);
		fd = 0;
	};
#endif
	// IP term.cust --- IEND

	delete chrono;
	delete disp;
	delete laser;
	delete state;
	delete step;

	initdone = false;
};

bool UntWskdUbdk::rx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: receive data from device observing history / rxtxdump settings

	// IP rx --- IBEGIN
#ifdef __linux__
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
		timeout.tv_usec = timeoutRx + timeoutRxWord * reqlen; // timeout includes the transfer itself!

		if (rxtxdump) {
			if (!histNotDump) cout << "rx ";
			else appendToHist("rx ");
		};

		nleft = reqlen;
		en = 0;

		while (nleft > 0) {
			s = select(fd+1, &fds, NULL, NULL, &timeout);

			if (s > 0) {
				n = read(fd, &(buf[reqlen-nleft]), nleft);
				if (n >= 0) nleft -= n;
				else {
					en = errno;
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
			else appendToLastInHist(msg);
		};
	};
#endif
	// IP rx --- IEND

	return retval;
};

bool UntWskdUbdk::tx(
			unsigned char* buf
			, const size_t reqlen
		) {
	bool retval = (reqlen == 0);

	// requirement: transmit data to device observing history / rxtxdump settings

	// IP tx --- IBEGIN
	timespec deltat;

#ifdef __linux__
	if (reqlen != 0) {
		size_t nleft;
		int n;

		string msg;

		if (rxtxdump) {
			if (!histNotDump) cout << "tx ";
			else appendToHist("tx ");
		};

		nleft = reqlen;
		n = 0;

		while (nleft > 0) {
			n = write(fd, &(buf[reqlen-nleft]), nleft);

			if (n >= 0) nleft -= n;
			else break;
		};

		retval = (nleft == 0);

		if (nleft == 0) {
			// write() is non-blocking but on hw level ongoing at this stage; make sure subsequent rx() doesn't time out
			deltat.tv_sec = 0;
			deltat.tv_nsec = ((long) 1000000000) * 10 * reqlen / 9600;

			nanosleep(&deltat, NULL);
		};

		if (rxtxdump) {
			if (nleft == 0) msg = "0x" + Dbe::bufToHex(buf, reqlen, true);
			else msg = string(strerror(n));

			if (!histNotDump) cout << msg << endl;
			else appendToLastInHist(msg);
		};
	};
#endif
	// IP tx --- IEND

	return retval;
};

void UntWskdUbdk::flush() {
	tcflush(fd, TCIOFLUSH); // IP flush --- ILINE
};

uint8_t UntWskdUbdk::getTixVControllerBySref(
			const string& sref
		) {
	return VecVWskdUbdkController::getTix(sref);
};

string UntWskdUbdk::getSrefByTixVController(
			const uint8_t tixVController
		) {
	return VecVWskdUbdkController::getSref(tixVController);
};

void UntWskdUbdk::fillFeedFController(
			Feed& feed
		) {
	VecVWskdUbdkController::fillFeed(feed);
};

uint8_t UntWskdUbdk::getTixWBufferBySref(
			const string& sref
		) {
	return VecWWskdUbdkBuffer::getTix(sref);
};

string UntWskdUbdk::getSrefByTixWBuffer(
			const uint8_t tixWBuffer
		) {
	return VecWWskdUbdkBuffer::getSref(tixWBuffer);
};

void UntWskdUbdk::fillFeedFBuffer(
			Feed& feed
		) {
	VecWWskdUbdkBuffer::fillFeed(feed);
};

uint8_t UntWskdUbdk::getTixVCommandBySref(
			const uint8_t tixVController
			, const string& sref
		) {
	uint8_t tixVCommand = 0;

	if (tixVController == VecVWskdUbdkController::CHRONO) tixVCommand = VecVWskdUbdkChronoCommand::getTix(sref);
	else if (tixVController == VecVWskdUbdkController::DISP) tixVCommand = VecVWskdUbdkDispCommand::getTix(sref);
	else if (tixVController == VecVWskdUbdkController::LASER) tixVCommand = VecVWskdUbdkLaserCommand::getTix(sref);
	else if (tixVController == VecVWskdUbdkController::STATE) tixVCommand = VecVWskdUbdkStateCommand::getTix(sref);
	else if (tixVController == VecVWskdUbdkController::STEP) tixVCommand = VecVWskdUbdkStepCommand::getTix(sref);

	return tixVCommand;
};

string UntWskdUbdk::getSrefByTixVCommand(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	string sref;

	if (tixVController == VecVWskdUbdkController::CHRONO) sref = VecVWskdUbdkChronoCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdUbdkController::DISP) sref = VecVWskdUbdkDispCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdUbdkController::LASER) sref = VecVWskdUbdkLaserCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdUbdkController::STATE) sref = VecVWskdUbdkStateCommand::getSref(tixVCommand);
	else if (tixVController == VecVWskdUbdkController::STEP) sref = VecVWskdUbdkStepCommand::getSref(tixVCommand);

	return sref;
};

void UntWskdUbdk::fillFeedFCommand(
			const uint8_t tixVController
			, Feed& feed
		) {
	feed.clear();

	if (tixVController == VecVWskdUbdkController::CHRONO) VecVWskdUbdkChronoCommand::fillFeed(feed);
	else if (tixVController == VecVWskdUbdkController::DISP) VecVWskdUbdkDispCommand::fillFeed(feed);
	else if (tixVController == VecVWskdUbdkController::LASER) VecVWskdUbdkLaserCommand::fillFeed(feed);
	else if (tixVController == VecVWskdUbdkController::STATE) VecVWskdUbdkStateCommand::fillFeed(feed);
	else if (tixVController == VecVWskdUbdkController::STEP) VecVWskdUbdkStepCommand::fillFeed(feed);
};

Bufxf* UntWskdUbdk::getNewBufxf(
			const uint8_t tixWBuffer
			, const size_t reqlen
			, unsigned char* buf
		) {
	Bufxf* bufxf = NULL;

	return bufxf;
};

Cmd* UntWskdUbdk::getNewCmd(
			const uint8_t tixVController
			, const uint8_t tixVCommand
		) {
	Cmd* cmd = NULL;

	if (tixVController == VecVWskdUbdkController::CHRONO) cmd = CtrWskdUbdkChrono::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdUbdkController::DISP) cmd = CtrWskdUbdkDisp::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdUbdkController::LASER) cmd = CtrWskdUbdkLaser::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdUbdkController::STATE) cmd = CtrWskdUbdkState::getNewCmd(tixVCommand);
	else if (tixVController == VecVWskdUbdkController::STEP) cmd = CtrWskdUbdkStep::getNewCmd(tixVCommand);

	return cmd;
};
