/**
	* \file UntWskdSkmn_vecs.h
	* MPSI starter kit mainboard unit vectors (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Catherine Johnson (auto-generation)
	* \date created: 1 Dec 2020
	*/
// IP header --- ABOVE

#ifndef UNTWSKDSKMN_VECS_H
#define UNTWSKDSKMN_VECS_H

#include <sbecore/Xmlio.h>

/**
	* VecVWskdSkmnController
	*/
namespace VecVWskdSkmnController {
	const Sbecore::utinyint CHRONO = 0x01;
	const Sbecore::utinyint LASER = 0x02;
	const Sbecore::utinyint STATE = 0x03;
	const Sbecore::utinyint STEP = 0x04;

	Sbecore::utinyint getTix(const std::string& sref);
	std::string getSref(const Sbecore::utinyint tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecVWskdSkmnState
	*/
namespace VecVWskdSkmnState {
	const Sbecore::utinyint NC = 0x00;
	const Sbecore::utinyint COMMERR = 0x01;
	const Sbecore::utinyint RDY = 0x02;
	const Sbecore::utinyint ACT = 0x03;

	Sbecore::utinyint getTix(const std::string& sref);
	std::string getSref(const Sbecore::utinyint tix);

	std::string getTitle(const Sbecore::utinyint tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecWWskdSkmnBuffer
	*/
namespace VecWWskdSkmnBuffer {
	const Sbecore::utinyint CMDRETTOHOSTIF = 0x01;
	const Sbecore::utinyint HOSTIFTOCMDINV = 0x02;

	Sbecore::utinyint getTix(const std::string& sref);
	std::string getSref(const Sbecore::utinyint tix);

	void fillFeed(Sbecore::Feed& feed);
};

#endif
