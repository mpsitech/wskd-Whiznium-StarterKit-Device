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

struct ShrdatMutex shrdatMutex; // IP shrdat --- LINE

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

	// IP run.cust2 --- INSERT
	
	return sns;
}

/******************************************************************************
 other
 ******************************************************************************/

// IP oth --- INSERT
