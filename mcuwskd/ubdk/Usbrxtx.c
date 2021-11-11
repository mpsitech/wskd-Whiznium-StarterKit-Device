/**
	* \file Usbrxtx.c
	* Usbrxtx usbrxtx_slbs_v1_0_Mcu (implementation)
	* \copyright (C) 2021 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 2 Oct 2021
	*/
// IP header --- ABOVE

#include "Usbrxtx.h"

#define shrdat shrdatUsbrxtx

/******************************************************************************
 constants and variables
 ******************************************************************************/

xdata struct ShrdatUsbrxtx shrdatUsbrxtx = {0}; // IP shrdat --- RLINE

enum StateOp {
	stateOpInit,
	stateOpIdle,
	stateOpRecv,
	stateOpSend
};

static enum StateOp stateOp = stateOpInit;

static uint16_t reqlen;
static uint16_t actlen;

/******************************************************************************
 initialization
 ******************************************************************************/

void usbrxtxInit() {
	// IP usbrxtxInit --- LINE
}

/******************************************************************************
 execution
 ******************************************************************************/

bool usbrxtxRun() {
	// IP usbrxtxRun.vars --- BEGIN
	bool sns;
	// IP usbrxtxRun.vars --- END

	UNSET_SENSITIVE_USBRXTX();

	// IP usbrxtxRun.cust1 --- INSERT

	// IP usbrxtxRun.op --- BEGIN
	switch (stateOp) {
		case stateOpInit:
			// IP syncrst --- IBEGIN
			flags.ackHostifToUsbrxtxSend = 0;
			SET_EVT_ackHostifToUsbrxtxSend();
			flags.dneHostifToUsbrxtxSend = 0;
			SET_EVT_dneHostifToUsbrxtxSend();
			flags.ackHostifToUsbrxtxRecv = 0;
			SET_EVT_ackHostifToUsbrxtxRecv();
			flags.dneHostifToUsbrxtxRecv = 0;
			SET_EVT_dneHostifToUsbrxtxRecv();
			// IP syncrst --- IEND

			stateOp = stateOpIdle;

			SET_SENSITIVE_USBRXTX();

			break;

		case stateOpIdle:
			if (flags.reqHostifToUsbrxtxRecv == 1) {
				flags.ackHostifToUsbrxtxRecv = 1;
				SET_EVT_ackHostifToUsbrxtxRecv();

				if (shrdat.len == 0) {
					flags.dneHostifToUsbrxtxRecv = 1;
					SET_EVT_dneHostifToUsbrxtxRecv();

				} else {
					reqlen = shrdat.len;
					Block_Read(shrdat.ptrBuf, reqlen, &actlen);
				};

				stateOp = stateOpRecv;

			} else if (flags.reqHostifToUsbrxtxSend == 1) {
				flags.ackHostifToUsbrxtxSend = 1;
				SET_EVT_ackHostifToUsbrxtxSend();

				if (shrdat.len == 0) {
					flags.dneHostifToUsbrxtxSend = 1;
					SET_EVT_dneHostifToUsbrxtxSend();

				} else {
					reqlen = shrdat.len;
					Block_Write(shrdat.ptrBuf, reqlen, &actlen);
				};

				stateOp = stateOpSend;
			};

			break;

		case stateOpRecv:
			if (flags.reqHostifToUsbrxtxRecv == 0) {
				stateOp = stateOpInit;

				SET_SENSITIVE_USBRXTX();
			};

			break;

		case stateOpSend:
			if (flags.reqHostifToUsbrxtxSend == 0) {
				stateOp = stateOpInit;

				SET_SENSITIVE_USBRXTX();
			};

			break;
	};
	// IP usbrxtxRun.op --- END

	// IP usbrxtxRun.cust2 --- INSERT

	return sns;
}

/******************************************************************************
 other
 ******************************************************************************/

void VCP_Callback() {
	bool sns;

	uint32_t source = Get_Callback_Source();

	if (source & RX_COMPLETE) {
		if ((reqlen == actlen) && (stateOp == stateOpRecv)) {
			flags.dneHostifToUsbrxtxRecv = 1;
			SET_EVT_dneHostifToUsbrxtxRecv();

			SET_SENSITIVE_USBRXTX();

			run();
		};

	} else if (source & TX_COMPLETE) {
		if ((reqlen == actlen) && (stateOp == stateOpSend)) {
			flags.dneHostifToUsbrxtxSend = 1;
			SET_EVT_dneHostifToUsbrxtxSend();

			SET_SENSITIVE_USBRXTX();

			run();
		};
	};
}
