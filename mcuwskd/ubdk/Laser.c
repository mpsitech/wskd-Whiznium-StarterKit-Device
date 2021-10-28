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

struct ShrdatLaser shrdatLaser; // IP shrdat --- LINE

// IP vars.oth --- INSERT

/******************************************************************************
 initialization
 ******************************************************************************/

void laserInit() {
	// IP init --- INSERT
}

/******************************************************************************
 execution
 ******************************************************************************/

bool laserRun() {
	bool sns;

	// IP run.cust1 --- INSERT
	
	UNSET_SENSITIVE_LASER();

	// IP run.cust2 --- INSERT
	
	return sns;
}

/******************************************************************************
 other
 ******************************************************************************/

// IP oth --- INSERT
