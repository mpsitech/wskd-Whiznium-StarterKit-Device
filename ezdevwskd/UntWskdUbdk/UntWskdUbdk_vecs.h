/**
	* \file UntWskdUbdk_vecs.h
	* SiLabs EFM8UB10 Development Kit unit vectors (declarations)
	* \copyright (C) 2016-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#ifndef UNTWSKDUBDK_VECS_H
#define UNTWSKDUBDK_VECS_H

#include <sbecore/Xmlio.h>

/**
	* VecVWskdUbdkController
	*/
namespace VecVWskdUbdkController {
	constexpr uint8_t CHRONO = 0x01;
	constexpr uint8_t DISP = 0x02;
	constexpr uint8_t LASER = 0x03;
	constexpr uint8_t STATE = 0x04;
	constexpr uint8_t STEP = 0x05;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecVWskdUbdkState
	*/
namespace VecVWskdUbdkState {
	constexpr uint8_t NC = 0x00;
	constexpr uint8_t READY = 0x01;
	constexpr uint8_t ACTIVE = 0x02;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	std::string getTitle(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

/**
	* VecWWskdUbdkBuffer
	*/
namespace VecWWskdUbdkBuffer {
	constexpr uint8_t CMDRETTOHOSTIF = 0x01;
	constexpr uint8_t HOSTIFTOCMDINV = 0x02;

	uint8_t getTix(const std::string& sref);
	std::string getSref(const uint8_t tix);

	void fillFeed(Sbecore::Feed& feed);
};

#endif
