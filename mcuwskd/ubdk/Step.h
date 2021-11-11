/**
	* \file Step.h
	* Step easy model controller (declarations)
	* \copyright (C) 2019-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#ifndef STEP_H
#define	STEP_H

#include "Ubdk.h"

// IP include.cust --- INSERT

void stepInit(void);

bool stepRun(void);

// IP oth --- IBEGIN
void updateAngle(uint32_t* ptrDHhst);
// IP oth --- IEND

#endif
