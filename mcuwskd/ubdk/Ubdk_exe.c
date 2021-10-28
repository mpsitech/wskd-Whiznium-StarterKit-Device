/**
	* \file Ubdk_exe.c
	* Wskd main (implementation)
	* \copyright (C) 2019-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "Ubdk.h"

#include "Chrono.h"
#include "Disp.h"
#include "Hostif.h"
#include "Laser.h"
#include "Mutex.h"
#include "State.h"
#include "Step.h"
#include "Usbrxtx.h"

bdata volatile struct Flags flags = {0};

volatile unsigned char evts0 = 0, evts1 = 0, evts2 = 0;

volatile unsigned char acts0 = 0;
volatile unsigned char snss0 = 0;

// IP cust --- IBEGIN
void SiLabs_Startup(void) {
  // disable WDT
  WDTCN = 0xDE;
  WDTCN = 0xAD;
}
// IP cust --- IEND

/******************************************************************************
 main program
 ******************************************************************************/

void init() {
	// IP init.cust --- INSERT

	chronoInit();
	dispInit();
	hostifInit();
	laserInit();
	mutexInit();
	stateInit();
	stepInit();
	usbrxtxInit();
}

void run() {
	// after initialization, this method is invoked from isr's only

	while (1) {
		// IP run.cust --- INSERT

		if (IS_ACTIVE_CHRONO()) CLEAR_EVTS_FROM_CHRONO();
		if (IS_SENSITIVE_CHRONO()) if (!chronoRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_DISP()) CLEAR_EVTS_FROM_DISP();
		if (IS_SENSITIVE_DISP()) if (!dispRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_HOSTIF()) CLEAR_EVTS_FROM_HOSTIF();
		if (IS_SENSITIVE_HOSTIF()) if (!hostifRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_LASER()) CLEAR_EVTS_FROM_LASER();
		if (IS_SENSITIVE_LASER()) if (!laserRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_MUTEX()) CLEAR_EVTS_FROM_MUTEX();
		if (IS_SENSITIVE_MUTEX()) if (!mutexRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_STATE()) CLEAR_EVTS_FROM_STATE();
		if (IS_SENSITIVE_STATE()) if (!stateRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_STEP()) CLEAR_EVTS_FROM_STEP();
		if (IS_SENSITIVE_STEP()) if (!stepRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_USBRXTX()) CLEAR_EVTS_FROM_USBRXTX();
		if (IS_SENSITIVE_USBRXTX()) if (!usbrxtxRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		CLEAR_EVTS_ISR();
		if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;
	};
}

void main(void) {
	init();

	// IP main --- INSERT

	while (1) {
		// IP main.loop --- INSERT
	};
}
