/**
	* \file Hostif.c
	* Hostif usbhostif_Easy_v1_0_Mcu easy model host interface (implementation)
	* \copyright (C) 2021 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 2 Oct 2021
	*/
// IP header --- ABOVE

#include "Hostif.h"

#define shrdat shrdatHostif

/******************************************************************************
 constants and variables
 ******************************************************************************/

struct ShrdatHostif shrdatHostif; // IP shrdat --- LINE

// --- main operation (op)
enum StateOp {
	stateOpInit,
	stateOpIdle,
	stateOpRxopA, stateOpRxopB, stateOpRxopC,
	stateOpVoidinv,
	stateOpTxA, stateOpTxB,
	stateOpRxA, stateOpRxB, stateOpRxC, stateOpRxD,
	stateOpInv,
	stateOpTxackA, stateOpTxackB
};

static enum StateOp stateOp = stateOpInit;

/******************************************************************************
 initialization
 ******************************************************************************/

void hostifInit() {
	// IP hostifInit --- INSERT
}

/******************************************************************************
 execution
 ******************************************************************************/

bool hostifRun() {
	// IP hostifRun.vars --- BEGIN
	bool sns;

	static const uint16_t sizeOpbuf = 7;
	static unsigned char opbuf[7];

	static unsigned char buf[7];

	static uint32_t hhstLast;
	static const uint8_t deltaHhst = 2; // 20ms timeout

	static uint16_t crc;
	static uint16_t i, icrc;
	// IP hostifRun.vars --- END

	UNSET_SENSITIVE_HOSTIF();

	// IP hostifRun.cust1 --- INSERT

	// IP hostifRun.op --- BEGIN
	switch (stateOp) {
		case stateOpInit:
			// IP syncrst --- INSERT

			stateOp = stateOpIdle;

			SET_SENSITIVE_HOSTIF();

			break;

		case stateOpIdle:
			if ((flags.ackHostifToUsbrxtxRecv == 0) && (flags.ackHostifToUsbrxtxSend == 0)) {
				shrdatUsbrxtx.len = sizeOpbuf;
				shrdatUsbrxtx.ptrBuf = opbuf;

				flags.reqHostifToUsbrxtxRecv = 1;
				SET_EVT_reqHostifToUsbrxtxRecv();
				
				stateOp = stateOpRxopA;
			};

			break;

		case stateOpRxopA:
			if (flags.ackHostifToUsbrxtxRecv == 1) {
				hhstLast = shrdatChrono.getHhstHhst;

				stateOp = stateOpRxopB;
			};

			break;

		case stateOpRxopB:
			if (flags.dneHostifToUsbrxtxRecv == 1) {
				flags.reqHostifToUsbrxtxRecv = 0;
				SET_EVT_reqHostifToUsbrxtxRecv();

				crcReset(&crc);
				for (i = 0; i < sizeOpbuf; i++) crcIncludeByte(&crc, opbuf[i]);
				crcFinalize(&crc, false);
				
				if (crc == 0x0000) stateOp = stateOpRxopC;
				else stateOp = stateOpIdle;

			} else if (IS_SET_EVT_chronoGetHhst() && ((shrdatChrono.getHhstHhst - hhstLast) >= deltaHhst)) {
				stateOp = stateOpInit;

				SET_SENSITIVE_HOSTIF();
			};

			break;

		case stateOpRxopC:
			stateOp = stateOpIdle; // default

			if (opbuf[IXOPBUF_buffer] == VECWBUFFER_cmdretToHostif) {
				if ((opbuf[IXOPBUF_controller] == VECVCONTROLLER_chrono) && (opbuf[IXOPBUF_command] == VECVCHRONOCOMMAND_getHhst)) {
					memcpy(buf, (unsigned char*) &shrdatChrono.getHhstHhst, 5);
					stateOp = stateOpTxA;
				} else if ((opbuf[IXOPBUF_controller] == VECVCONTROLLER_state) && (opbuf[IXOPBUF_command] == VECVSTATECOMMAND_get)) {
					memcpy(buf, (unsigned char*) &shrdatState.getTixVUbdkState, 2);
					stateOp = stateOpTxA;
				} else if ((opbuf[IXOPBUF_controller] == VECVCONTROLLER_step) && (opbuf[IXOPBUF_command] == VECVSTEPCOMMAND_getInfo)) {
					memcpy(buf, (unsigned char*) &shrdatStep.getInfoTixVState, 4);
					stateOp = stateOpTxA;
				};

			} else if (opbuf[IXOPBUF_buffer] == VECWBUFFER_hostifToCmdinv) {
				// return type: void
				shrdatUsbrxtx.len = (opbuf[IXOPBUF_length] << 8) + opbuf[IXOPBUF_length+1]; // 2 bytes of CRC included
				shrdatUsbrxtx.ptrBuf = shrdat.rxbuf;

				stateOp = stateOpRxA;

			};

			SET_SENSITIVE_HOSTIF();
			
			break;

		case stateOpVoidinv:

			break;
			
		case stateOpTxA:
			shrdatUsbrxtx.len = (opbuf[IXOPBUF_length] << 8) + opbuf[IXOPBUF_length+1];
			icrc = shrdatUsbrxtx.len - 2;

			crcReset(&crc);
			for (i = 0; i < icrc; i++) crcIncludeByte(&crc, buf[i]);

			crcFinalize(&crc, false);
			memcpy(&(buf[icrc]), &crc, 2);

			shrdatUsbrxtx.ptrBuf = buf;

			flags.reqHostifToUsbrxtxSend = 1;
			SET_EVT_reqHostifToUsbrxtxSend();

			stateOp = stateOpTxB;

			break;

		case stateOpTxB:
			if (flags.dneHostifToUsbrxtxSend == 1) {
				stateOp = stateOpInit;
			};

			break;

		case stateOpRxA:
			if (flags.ackHostifToUsbrxtxRecv == 0) {
				flags.reqHostifToUsbrxtxRecv = 1;
				SET_EVT_reqHostifToUsbrxtxRecv();

				stateOp = stateOpRxB;
			};

			break;

		case stateOpRxB:
			if (flags.ackHostifToUsbrxtxRecv == 1) {
				hhstLast = shrdatChrono.getHhstHhst;

				stateOp = stateOpRxC;
			};

			break;

		case stateOpRxC:
			if (flags.dneHostifToUsbrxtxRecv == 1) {
				flags.reqHostifToUsbrxtxRecv = 0;
				SET_EVT_reqHostifToUsbrxtxRecv();

				crcReset(&crc);
				for (i = 0; i < shrdatUsbrxtx.len; i++) crcIncludeByte(&crc, shrdat.rxbuf[i]);
				crcFinalize(&crc, false);
				
				if (crc == 0x0000) stateOp = stateOpRxD;
				else stateOp = stateOpIdle;

				SET_SENSITIVE_HOSTIF();

			} else if (IS_SET_EVT_chronoGetHhst() && ((shrdatChrono.getHhstHhst - hhstLast) >= deltaHhst)) {
				stateOp = stateOpInit;

				SET_SENSITIVE_HOSTIF();
			};

			break;

		case stateOpRxD:
			stateOp = stateOpIdle; // default

			if ((opbuf[IXOPBUF_controller] == VECVCONTROLLER_chrono) && (opbuf[IXOPBUF_command] == VECVCHRONOCOMMAND_setHhst)) {
				flags.reqInvChronoSetHhst = 1;
				SET_EVT_reqInvChronoSetHhst();
				stateOp = stateOpInv;
			} else if ((opbuf[IXOPBUF_controller] == VECVCONTROLLER_laser) && (opbuf[IXOPBUF_command] == VECVLASERCOMMAND_set)) {
				flags.reqInvLaserSet = 1;
				SET_EVT_reqInvLaserSet();
				stateOp = stateOpInv;
			} else if (opbuf[IXOPBUF_controller] == VECVCONTROLLER_step) {
				if (opbuf[IXOPBUF_command] == VECVSTEPCOMMAND_moveto) {
					flags.reqInvStepMoveto = 1;
					SET_EVT_reqInvStepMoveto();
					stateOp = stateOpInv;
				} else if (opbuf[IXOPBUF_command] == VECVSTEPCOMMAND_set) {
					flags.reqInvStepSet = 1;
					SET_EVT_reqInvStepSet();
					stateOp = stateOpInv;
				} else if (opbuf[IXOPBUF_command] == VECVSTEPCOMMAND_zero) {
					flags.reqInvStepZero = 1;
					SET_EVT_reqInvStepZero();
					stateOp = stateOpInv;
				};
			};
			
			break;

		case stateOpInv:
			if (flags.ackInvChronoSetHhst == 1) {
				flags.reqInvChronoSetHhst = 0;
				SET_EVT_reqInvChronoSetHhst();
				stateOp = stateOpTxackA;
			} else if (flags.ackInvLaserSet == 1) {
				flags.reqInvLaserSet = 0;
				SET_EVT_reqInvLaserSet();
				stateOp = stateOpTxackA;
			} else if (flags.ackInvStepMoveto == 1) {
				flags.reqInvStepMoveto = 0;
				SET_EVT_reqInvStepMoveto();
				stateOp = stateOpTxackA;
			} else if (flags.ackInvStepSet == 1) {
				flags.reqInvStepSet = 0;
				SET_EVT_reqInvStepSet();
				stateOp = stateOpTxackA;
			} else if (flags.ackInvStepZero == 1) {
				flags.reqInvStepZero = 0;
				SET_EVT_reqInvStepZero();
				stateOp = stateOpTxackA;
			};

			break;

		case stateOpTxackA:
			memset(buf, 0xAA, 2);

			shrdatUsbrxtx.len = 2;
			shrdatUsbrxtx.ptrBuf = buf;

			flags.reqHostifToUsbrxtxSend = 1;
			SET_EVT_reqHostifToUsbrxtxSend();

			stateOp = stateOpTxackB;

			break;

		case stateOpTxackB:
			if (flags.dneHostifToUsbrxtxSend == 1) {
				stateOp = stateOpInit;

				SET_SENSITIVE_HOSTIF();
			};

			break;
	};
	// IP hostifRun.op --- END

	// IP hostifRun.cust2 --- INSERT

	return sns;
}

/******************************************************************************
 other
 ******************************************************************************/

// IP oth --- INSERT
