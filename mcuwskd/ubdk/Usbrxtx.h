/**
	* \file Usbrxtx.h
	* Usbrxtx usbrxtx_slbs_v1_0_Mcu (declarations)
	* \copyright (C) 2019-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 2 Oct 2021
	*/
// IP header --- ABOVE

#ifndef USBRXTX_H
#define	USBRXTX_H

#include "Ubdk.h"

#include "VCPXpress.h"

void usbrxtxInit(void);

bool usbrxtxRun(void);

//void VCP_Callback(); // declared in VCPXpress.h

#endif
