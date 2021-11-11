/**
	* \file Step.c
	* Step easy model controller (implementation)
	* \copyright (C) 2019-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "Step.h"

#define IXRXBUF_movetoAngle 0
#define IXRXBUF_movetoTstep 2

#define IXRXBUF_setRng 0
#define IXRXBUF_setCcwNotCw 1
#define IXRXBUF_setTstep 2

#define shrdat shrdatStep

// IP define.cust --- INSERT

/******************************************************************************
 constants and variables
 ******************************************************************************/

xdata struct ShrdatStep shrdatStep = {0}; // IP shrdat --- RLINE

// IP vars.oth --- IBEGIN
static xdata uint8_t Tstep = 30; // f = 167Hz, omega = 10rpm
static bool ccwNotCw = false;
// IP vars.oth --- IEND

/******************************************************************************
 initialization
 ******************************************************************************/

void stepInit() {
	// IP init --- IBEGIN
	M0 = 0;
	NSLP = 0;
	DIR = 0;

	shrdat.getInfoAngle = 0;
	shrdat.getInfoTixVState = VECVSTEPSTATE_idle;
	// IP init --- IEND
}

/******************************************************************************
 execution
 ******************************************************************************/

bool stepRun() {
	bool sns;

	// IP run.cust1 --- IBEGIN
	static bool rng = false;
	static bool targetNotSteady = false;

	static xdata uint16_t target = 0;

	uint8_t _tixVState = shrdat.getInfoTixVState;
  bool reenter = false;

	xdata int16_t dAngle;

	static xdata unsigned long hhst0;

  xdata unsigned long dHhst = 0;
  static xdata unsigned long dHhst_stop;

  xdata uint8_t save;
	// IP run.cust1 --- IEND
	
	UNSET_SENSITIVE_STEP();

	// IP run.cust2 --- IBEGIN
	if (IS_SET_EVT_reqInvStepMoveto()) {
		// moveto(uint16_t target, uint8_t Tstep)
		if (flags.reqInvStepMoveto == 1) {
			memcpy((unsigned char*) &target, &(shrdatHostif.rxbuf[IXRXBUF_movetoAngle]), 2);
			Tstep = shrdatHostif.rxbuf[IXRXBUF_movetoTstep];

			dAngle = target - shrdat.getInfoAngle;

			if (dAngle == 0) {
				_tixVState = VECVSTEPSTATE_idle;

			} else {
				targetNotSteady = true;
				_tixVState = VECVSTEPSTATE_move;

				reenter = true;

				if (dAngle > 500) {
					//dAngle = dAngle - 1000; // will become negative
					ccwNotCw = true;
				} else if (dAngle < -499) {
					//dAngle = dAngle + 1000; // will become positive
					ccwNotCw = true;
				} else ccwNotCw = (dAngle <= 0);

				dHhst_stop = (1001 * dAngle * Tstep) / 50000; // 100.1Hz vs. 10kHz / 2
			};

			flags.ackInvStepMoveto = 1;

		} else {
			flags.ackInvStepMoveto = 0;
		};

		SET_EVT_ackInvStepMoveto();

	} else if (IS_SET_EVT_reqInvStepSet()) {
		if (flags.reqInvStepSet == 1) {
			// set(bool rng, bool ccwNotCw, uint8_t Tstep)
			rng = (shrdatHostif.rxbuf[IXRXBUF_setRng] == TRU8);
			ccwNotCw = (shrdatHostif.rxbuf[IXRXBUF_setCcwNotCw] == TRU8);
			Tstep = shrdatHostif.rxbuf[IXRXBUF_setTstep];

			if (!rng) _tixVState = VECVSTEPSTATE_idle;
			else {
				targetNotSteady = false;
				_tixVState = VECVSTEPSTATE_move;

				reenter = true;
			};

			flags.ackInvStepSet = 1;

		} else {
			flags.ackInvStepSet = 0;
		};

		SET_EVT_ackInvStepSet();

	} else if (IS_SET_EVT_reqInvStepZero()) {
		if (flags.reqInvStepZero == 1) {
			if (shrdat.getInfoTixVState == VECVSTEPSTATE_idle) shrdat.getInfoAngle = 0;

			flags.ackInvStepZero = 1;

		} else {
			flags.ackInvStepZero = 0;
		};

		SET_EVT_ackInvStepZero();

	} else if (IS_SET_EVT_chronoGetHhst() && (shrdat.getInfoTixVState == VECVSTEPSTATE_move)) {
		dHhst = shrdatChrono.getHhstHhst - hhst0;

		if (targetNotSteady && (dHhst >= dHhst_stop)) {
			_tixVState = VECVSTEPSTATE_idle;

		} else if (!targetNotSteady && ((dHhst%10) == 0)) {
			updateAngle(&dHhst);
			if ((dHhst%100) == 0) hhst0 = shrdatChrono.getHhstHhst;

			SET_EVT_stepGetInfo();
		};
	};

	if ((_tixVState != shrdat.getInfoTixVState) || reenter) {
		// leave current state
		switch (shrdat.getInfoTixVState) {
			case VECVSTEPSTATE_idle:
				break;

			case VECVSTEPSTATE_move:
				dHhst = shrdatChrono.getHhstHhst - hhst0;
				updateAngle(&dHhst);

				break;
		};

		shrdat.getInfoTixVState = _tixVState;
		SET_EVT_stepGetInfo();

		// enter new state
		switch (shrdat.getInfoTixVState) {
			case VECVSTEPSTATE_idle:
				NSLP = 0;
				PCA0CN0_CR &= ~PCA0CN0_CR__BMASK;

				break;

			case VECVSTEPSTATE_move:
				if (!ccwNotCw) DIR = 0;
				else DIR = 1;

				PCA0CN0_CR &= ~PCA0CN0_CR__BMASK;
				PCA0CPH0 = Tstep;

				save = PCA0CN0 & 0x38;
				PCA0CN0 = save | PCA0CN0_CR__RUN;

				NSLP = 1;

				hhst0 = shrdatChrono.getHhstHhst;

				break;
		};
	};
	// IP run.cust2 --- IEND
	
	return sns;
}

/******************************************************************************
 other
 ******************************************************************************/

// IP oth --- IBEGIN
void updateAngle(
			uint32_t* ptrDHhst
		) {
	// PCA (driven by LFOSC) and chrono (driven by sysclk) are synchronized
	// PCA increments every 1225 * 2 * Tstep sysclk
	// hhst increments every 10 * 48 * 255 sysclk
	xdata int16_t dAngle;

	dAngle = (50000 * *ptrDHhst) / (1001 * Tstep);

	while (dAngle > 1000) dAngle -= 1000;

	if (!ccwNotCw) {
		shrdat.getInfoAngle = shrdat.getInfoAngle + dAngle;
		if (shrdat.getInfoAngle > 1000) shrdat.getInfoAngle -= 1000;

	} else {
		shrdat.getInfoAngle = shrdat.getInfoAngle - dAngle;
		if (shrdat.getInfoAngle > 1000) shrdat.getInfoAngle += 1000; // angle is unsigned
	};
}
// IP oth --- IEND
