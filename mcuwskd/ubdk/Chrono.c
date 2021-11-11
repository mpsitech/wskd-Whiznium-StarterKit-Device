/**
	* \file Chrono.c
	* Chrono hhstsrc_Easy_v1_0_Mcu easy model controller (implementation)
	* \copyright (C) 2021 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 26 Apr 2021
	*/
// IP header --- ABOVE

#include "Chrono.h"

#define shrdat shrdatChrono

// IP define.cust --- INSERT

/******************************************************************************
 constants and variables
 ******************************************************************************/

xdata struct ShrdatChrono shrdatChrono = {0}; // IP shrdat --- RLINE

#define DIV 10

/******************************************************************************
 initialization
 ******************************************************************************/

void chronoInit() {
	// IP init.cust --- INSERT
}

/******************************************************************************
 execution
 ******************************************************************************/

bool chronoRun() {
	// IP chronoRun.vars --- BEGIN
	bool sns;

	static uint16_t i = 0;
	// IP chronoRun.vars --- END

	UNSET_SENSITIVE_CHRONO();

	// IP chronoRun.cust1 --- INSERT

	// IP chronoRun --- BEGIN
	if (IS_SET_EVT_reqInvChronoSetHhst()) {
		if (flags.reqInvChronoSetHhst == 1) {
			memcpy((unsigned char*) &shrdat.getHhstHhst, shrdatHostif.rxbuf, 4);
			SET_EVT_chronoGetHhst();

			flags.ackInvChronoSetHhst = 1;

		} else {
			flags.ackInvChronoSetHhst = 0;
		};

		SET_EVT_ackInvChronoSetHhst();

	} else if (IS_SET_EVT_isrTIMER0()) { // IP chronoRun.trigger --- RLINE
		i++;
		if (i == DIV) {
			i = 0;

			shrdat.getHhstHhst++;
			SET_EVT_chronoGetHhst();
		};
	};
	// IP chronoRun --- END

	// IP chronoRun.cust2 --- INSERT

	return sns;
}
