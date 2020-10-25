/**
	* \file UntWskdArty_vecs.h
	* Digilent Arty Z7 unit vectors (declarations)
	* \author Catherine Johnson
	* \date created: 17 Oct 2020
	* \date modified: 17 Oct 2020
	*/

#ifndef UNTWSKDARTY_VECS_H
#define UNTWSKDARTY_VECS_H

#include <sbecore/Xmlio.h>

/**
	* VecVWskdArtyController
	*/
namespace VecVWskdArtyController {
	const Sbecore::utinyint CAMACQ = 0x01;
	const Sbecore::utinyint CAMIF = 0x02;
	const Sbecore::utinyint FEATDET = 0x03;
	const Sbecore::utinyint LASER = 0x04;
	const Sbecore::utinyint STATE = 0x05;
	const Sbecore::utinyint STEP = 0x06;
	const Sbecore::utinyint TKCLKSRC = 0x07;

	Sbecore::utinyint getTix(const std::string& sref);
	std::string getSref(const Sbecore::utinyint tix);

	void fillFeed(Sbecore::Xmlio::Feed& feed);
};

/**
	* VecVWskdArtyState
	*/
namespace VecVWskdArtyState {
	const Sbecore::utinyint NC = 0x00;
	const Sbecore::utinyint READY = 0x01;
	const Sbecore::utinyint ACTIVE = 0x02;

	Sbecore::utinyint getTix(const std::string& sref);
	std::string getSref(const Sbecore::utinyint tix);

	std::string getTitle(const Sbecore::utinyint tix);

	void fillFeed(Sbecore::Xmlio::Feed& feed);
};

/**
	* VecWWskdArtyBuffer
	*/
namespace VecWWskdArtyBuffer {
	const Sbecore::utinyint CMDRETTOHOSTIF = 0x01;
	const Sbecore::utinyint HOSTIFTOCMDINV = 0x02;
	const Sbecore::utinyint FLGBUFFEATDETTOHOSTIF = 0x04;
	const Sbecore::utinyint PVWABUFCAMACQTOHOSTIF = 0x08;
	const Sbecore::utinyint PVWBBUFCAMACQTOHOSTIF = 0x10;

	Sbecore::utinyint getTix(const std::string& sref);
	std::string getSref(const Sbecore::utinyint tix);

	void fillFeed(Sbecore::Xmlio::Feed& feed);
};

#endif

