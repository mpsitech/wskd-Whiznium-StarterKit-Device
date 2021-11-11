/**
	* \file Laser.c
	* Laser easy model controller (implementation)
	* \copyright (C) 2019-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "Laser.h"

#define IXRXBUF_setL 0
#define IXRXBUF_setR 2

#define shrdat shrdatLaser

// IP define.cust --- INSERT

/******************************************************************************
 constants and variables
 ******************************************************************************/

xdata struct ShrdatLaser shrdatLaser = {0}; // IP shrdat --- RLINE

// --- main operation (op)
enum StateOp {
	stateOpPrepA, stateOpPrepB, stateOpPrepC,
	stateOpInit,
	stateOpIdle,
	stateOpSetLeft,
	stateOpSetRight,
	stateOpInv
};

static enum StateOp stateOp = stateOpPrepA;

// IP vars.oth --- INSERT

/******************************************************************************
 initialization
 ******************************************************************************/

void laserInit() {
	// IP init --- IBEGIN
	bool sns;

	CS0 = 1;
	CS1 = 1;

	// run preparation at start-up
	SET_SENSITIVE_LASER();
	// IP init --- IEND
}

/******************************************************************************
 execution
 ******************************************************************************/

bool laserRun() {
	bool sns;

	// IP run.cust1 --- IBEGIN
	uint8_t dummy;
	// IP run.cust1 --- IEND
	
	UNSET_SENSITIVE_LASER();

	// IP run.op --- BEGIN
	switch (stateOp) {
		case stateOpPrepA:
			// IP op.prepA --- IBEGIN
			// preparation: enable output, send 0xF0 0x00, both DAC's in parallel
			flags.reqLaserToMutexLock = 1;
			SET_EVT_reqLaserToMutexLock();

			stateOp = stateOpPrepB;
			// IP op.prepA --- IEND
			break;

		case stateOpPrepB:
			// IP op.prepB --- IBEGIN
			if (flags.ackLaserToMutexLock == 1) {
				CS0 = 0;
				CS1 = 0;

        SPI0DAT = 0xF0;
        while (SPI0CN0_SPIF == 0) {};

        dummy = SPI0DAT;
        SPI0CN0_SPIF = 0;

        SPI0DAT = 0x00;
        while (SPI0CN0_SPIF == 0) {};

        dummy = SPI0DAT;
        SPI0CN0_SPIF = 0;

				CS0 = 1;
				CS1 = 1;

				flags.reqLaserToMutexLock = 0;
				SET_EVT_reqLaserToMutexLock();

				stateOp = stateOpPrepC;
			};
			// IP op.prepB --- IEND
			break;

		case stateOpPrepC:
			// IP op.prepC --- IBEGIN
			if (flags.ackLaserToMutexLock == 0) {
				stateOp = stateOpIdle;
			};
			// IP op.prepC --- IEND
			break;

		case stateOpInit:
			// IP op.init --- IBEGIN
			flags.ackInvLaserSet = 0;
			SET_EVT_ackInvLaserSet();

			stateOp = stateOpIdle;
			// IP op.init --- IEND
			break;

		case stateOpIdle:
			// IP op.idle --- IBEGIN
			if (flags.reqInvLaserSet == 1) {
				flags.reqLaserToMutexLock = 1;
				SET_EVT_reqLaserToMutexLock();

				stateOp = stateOpSetLeft;
			};
			// IP op.idle --- IEND
			break;

		case stateOpSetLeft:
			// IP op.setLeft --- IBEGIN
			if (flags.ackLaserToMutexLock == 1) {
				CS0 = 0;

        SPI0DAT = (shrdatHostif.rxbuf[IXRXBUF_setL] << 2) | ((shrdatHostif.rxbuf[IXRXBUF_setL+1] & 0xC0) >> 6);
        while (SPI0CN0_SPIF == 0) {};

        dummy = SPI0DAT;
        SPI0CN0_SPIF = 0;

        SPI0DAT = ((shrdatHostif.rxbuf[IXRXBUF_setL+1] & 0x3F) << 2);
        while (SPI0CN0_SPIF == 0) {};

        dummy = SPI0DAT;
        SPI0CN0_SPIF = 0;

        CS0 = 1;

        stateOp = stateOpSetRight;

        SET_SENSITIVE_LASER();
			};
			// IP op.setLeft --- IEND
			break;

		case stateOpSetRight:
			// IP op.setRight --- IBEGIN
			CS1 = 0;

      SPI0DAT = (shrdatHostif.rxbuf[IXRXBUF_setR] << 2) | ((shrdatHostif.rxbuf[IXRXBUF_setR+1] & 0xC0) >> 6);
      while (SPI0CN0_SPIF == 0) {};

      dummy = SPI0DAT;
      SPI0CN0_SPIF = 0;

      SPI0DAT = ((shrdatHostif.rxbuf[IXRXBUF_setR+1] & 0x3F) << 2);
      while (SPI0CN0_SPIF == 0) {};

      dummy = SPI0DAT;
      SPI0CN0_SPIF = 0;

			CS1 = 1;

			flags.reqLaserToMutexLock = 0;
			SET_EVT_reqLaserToMutexLock();

			flags.ackInvLaserSet = 1;
			SET_EVT_ackInvLaserSet();

			stateOp = stateOpInv;
			// IP op.setRight --- IEND
			break;

		case stateOpInv:
			// IP op.inv --- IBEGIN
			if ((flags.ackLaserToMutexLock == 0) && (flags.reqInvLaserSet == 0)) {
				stateOp = stateOpInit;

				SET_SENSITIVE_LASER();
			};
			// IP op.inv --- IEND
			break;

	};

	// IP run.op --- END

	// IP run.cust2 --- INSERT
	
	return sns;
}

/******************************************************************************
 other
 ******************************************************************************/

// IP oth --- INSERT
