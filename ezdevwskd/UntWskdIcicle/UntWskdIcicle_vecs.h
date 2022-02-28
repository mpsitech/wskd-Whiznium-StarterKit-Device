/**
	* \file UntWskdIcicle_vecs.h
	* Microchip PolarFire Soc Icicle kit unit vectors (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 20 Oct 2021
	*/
// IP header --- ABOVE

#ifndef UNTWSKDICICLE_VECS_H
#define UNTWSKDICICLE_VECS_H

#include <sbecore/Xmlio.h>

/**
	* VecVWskdIcicleController
	*/
namespace VecVWskdIcicleController {
	constexpr uint8_t CAMACQ = 0x01;
	constexpr uint8_t CAMIF = 0x02;
	constexpr uint8_t FEATDET = 0x03;
	constexpr uint8_t LASER = 0x04;
	constexpr uint8_t STATE = 0x05;
	constexpr uint8_t STEP = 0x06;
	constexpr uint8_t TKCLKSRC = 0x07;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecVWskdIcicleState
	*/
namespace VecVWskdIcicleState {
	constexpr uint8_t NC = 0x00;
	constexpr uint8_t READY = 0x01;
	constexpr uint8_t ACTIVE = 0x02;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	std::string getTitle(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecWWskdIcicleBuffer
	*/
namespace VecWWskdIcicleBuffer {
	constexpr uint8_t CMDRETTOHOSTIF = 0x01;
	constexpr uint8_t HOSTIFTOCMDINV = 0x02;
	constexpr uint8_t FLGBUFFROMFEATDET = 0x04;
	constexpr uint8_t PVWABUFFROMCAMACQ = 0x08;
	constexpr uint8_t PVWBBUFFROMCAMACQ = 0x10;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

#endif
