/**
	* \file State.c
	* State easy model controller (implementation)
	* \copyright (C) 2019-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "State.h"

#define shrdat shrdatState

// IP define.cust --- INSERT

/******************************************************************************
 constants and variables
 ******************************************************************************/

struct ShrdatState shrdatState; // IP shrdat --- LINE

// IP vars.oth --- INSERT

/******************************************************************************
 initialization
 ******************************************************************************/

void stateInit() {
	// IP init --- INSERT
}

/******************************************************************************
 execution
 ******************************************************************************/

bool stateRun() {
	bool sns;

	// IP run.cust1 --- INSERT
	
	UNSET_SENSITIVE_STATE();

	// IP run.cust2 --- INSERT
	
	return sns;
}

/******************************************************************************
 other
 ******************************************************************************/

// IP oth --- INSERT
