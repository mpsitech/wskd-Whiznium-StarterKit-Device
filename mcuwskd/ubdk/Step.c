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

struct ShrdatStep shrdatStep; // IP shrdat --- LINE

// IP vars.oth --- INSERT

/******************************************************************************
 initialization
 ******************************************************************************/

void stepInit() {
	// IP init --- INSERT
}

/******************************************************************************
 execution
 ******************************************************************************/

bool stepRun() {
	bool sns;

	// IP run.cust1 --- INSERT
	
	UNSET_SENSITIVE_STEP();

	// IP run.cust2 --- INSERT
	
	return sns;
}

/******************************************************************************
 other
 ******************************************************************************/

// IP oth --- INSERT
