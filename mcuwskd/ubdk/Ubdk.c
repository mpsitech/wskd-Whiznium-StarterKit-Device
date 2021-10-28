/**
	* \file Ubdk.c
	* Ubdk global functionality (implementation)
	* \copyright (C) 2019-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "Ubdk.h"

/******************************************************************************
 global functionality
 ******************************************************************************/

// IP gbl --- IBEGIN
// slightly adapted version from dbecore C++ library
void crcReset(
      unsigned short* ptrCrc
    ) {
  *ptrCrc = 0x0000;
}

void crcIncludeByte(
      unsigned short* ptrCrc
      , const unsigned char b
    ) {
  const unsigned short crcpoly = 0x8005;

  unsigned short newcrc;
  bool _bit;

  unsigned char i;

  i = 0x80;

  while (i != 0) {
    _bit = b & i;

    newcrc = (*ptrCrc << 1);
    if (_bit) newcrc |= 0x0001;

    if (*ptrCrc & 0x8000) *ptrCrc = newcrc ^ crcpoly;
    else *ptrCrc = newcrc;

    i = (i >> 1);
  };
}

void crcFinalize(
      unsigned short* ptrCrc
      , const bool oddinv
    ) {
  crcIncludeByte(ptrCrc, 0x00);
  crcIncludeByte(ptrCrc, 0x00);

  if (oddinv) *ptrCrc = (*ptrCrc & 0x5555) | (~(*ptrCrc) & 0xAAAA);
}
// IP gbl --- IEND
