/**
	* \file UntWskdCleb_vecs.h
	* Lattice CrossLink-NX Evaluation Board unit vectors (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 24 Dec 2021
	*/
// IP header --- ABOVE

#ifndef UNTWSKDCLEB_VECS_H
#define UNTWSKDCLEB_VECS_H

#include <sbecore/Xmlio.h>

/**
	* VecVWskdClebController
	*/
namespace VecVWskdClebController {
	constexpr uint8_t LASER = 0x01;
	constexpr uint8_t STATE = 0x02;
	constexpr uint8_t STEP = 0x03;
	constexpr uint8_t TKCLKSRC = 0x04;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecVWskdClebState
	*/
namespace VecVWskdClebState {
	constexpr uint8_t NC = 0x00;
	constexpr uint8_t READY = 0x01;
	constexpr uint8_t ACTIVE = 0x02;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	std::string getTitle(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecWWskdClebBuffer
	*/
namespace VecWWskdClebBuffer {
	constexpr uint8_t CMDRETTOHOSTIF = 0x01;
	constexpr uint8_t HOSTIFTOCMDINV = 0x02;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

#endif
