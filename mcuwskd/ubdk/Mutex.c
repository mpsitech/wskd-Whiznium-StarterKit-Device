/**
	* \file Mutex.c
	* Mutex other module (implementation)
	* \copyright (C) 2019-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "Mutex.h"

#define shrdat shrdatMutex

// IP define.cust --- INSERT

/******************************************************************************
 constants and variables
 ******************************************************************************/

xdata struct ShrdatMutex shrdatMutex = {0}; // IP shrdat --- RLINE

// --- main operation (op)
enum StateOp {
	stateOpIdle,
	stateOpLocked
};

static enum StateOp stateOp = stateOpIdle;

// IP vars.oth --- INSERT

/******************************************************************************
 initialization
 ******************************************************************************/

void mutexInit() {
	// IP init --- INSERT
}

/******************************************************************************
 execution
 ******************************************************************************/

bool mutexRun() {
	bool sns;

	// IP run.cust1 --- INSERT
	
	UNSET_SENSITIVE_MUTEX();

	// IP run.op --- BEGIN
	switch (stateOp) {
		case stateOpIdle:
			// IP op.idle --- IBEGIN
			if (flags.reqDispToMutexLock == 1) {
				flags.ackDispToMutexLock = 1;
				SET_EVT_ackDispToMutexLock();

				stateOp = stateOpLocked;

			} else if (flags.reqLaserToMutexLock == 1) {
				flags.ackLaserToMutexLock = 1;
				SET_EVT_ackLaserToMutexLock();

				stateOp = stateOpLocked;
			};
			// IP op.idle --- IEND
			break;

		case stateOpLocked:
			// IP op.locked --- IBEGIN
			if ((flags.ackDispToMutexLock == 1) && (flags.reqDispToMutexLock == 0)) {
				flags.ackDispToMutexLock = 0;
				SET_EVT_ackDispToMutexLock();

				stateOp = stateOpIdle;

				SET_SENSITIVE_MUTEX();

			} else if ((flags.ackLaserToMutexLock == 1) && (flags.reqLaserToMutexLock == 0)) {
				flags.ackLaserToMutexLock = 0;
				SET_EVT_ackLaserToMutexLock();

				stateOp = stateOpIdle;

				SET_SENSITIVE_MUTEX();
			};
			// IP op.locked --- IEND
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
