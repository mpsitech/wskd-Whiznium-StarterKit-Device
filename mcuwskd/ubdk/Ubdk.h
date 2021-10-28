/**
	* \file Ubdk.h
	* Ubdk global functionality (declarations)
	* \copyright (C) 2019-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#ifndef UBDK_H
#define	UBDK_H

/*
	peripherals:
		step: pca0 (step@21)
		disp, laser: spi0 (mosi@22, sclk@24)
		chrono: tmr0
		hostif: usb0
	input pins:
		(none)
	output pins:
		disp: dispcs@1
		laser: cs0@12, cs1@13
		state: ledr@18, ledg@17, ledb@16
		step: nslp@2, m0@23, dir@15, step@21
*/

#include <stdbool.h>
#include <stdint.h>
#include <string.h>

// IP include.cust --- IBEGIN
#include <SI_EFM8UB1_Register_Enums.h>
#include "VCPXpress.h"
// IP include.cust --- IEND

// IP define.cust --- INSERT

/**
	* dbecore constants
	*/
#define FLS8 0xAA
#define TRU8 0x55

#define IXOPBUF_buffer 0
#define IXOPBUF_controller 1
#define IXOPBUF_command 2
#define IXOPBUF_length 3
#define IXOPBUF_crc 5

/**
	* ubdk constants
	*/
#define VECVCONTROLLER_chrono 0x01
#define VECVCONTROLLER_disp 0x02
#define VECVCONTROLLER_laser 0x03
#define VECVCONTROLLER_state 0x04
#define VECVCONTROLLER_step 0x05

#define VECVSTATE_nc 0x00
#define VECVSTATE_ready 0x01
#define VECVSTATE_active 0x02

#define VECWBUFFER_cmdretToHostif 0x01
#define VECWBUFFER_hostifToCmdinv 0x02

#define VECVCHRONOCOMMAND_getHhst 0x00
#define VECVCHRONOCOMMAND_setHhst 0x01

#define VECVLASERCOMMAND_set 0x00

#define VECVSTATECOMMAND_get 0x00

#define VECVSTEPCOMMAND_getInfo 0x00
#define VECVSTEPCOMMAND_moveto 0x01
#define VECVSTEPCOMMAND_set 0x02
#define VECVSTEPCOMMAND_zero 0x03

/**
	* global constants
	*/
// IP define.gbl --- INSERT

/**
	* global functionality
	*/
// IP gbl --- IBEGIN
void crcReset(unsigned short* ptrCrc);
void crcIncludeByte(unsigned short* ptrCrc, const unsigned char b);
void crcFinalize(unsigned short* ptrCrc, const bool oddinv);
// IP gbl --- IEND

/**
	* pin declarations
	*/
// IP pins --- BEGIN
sbit DISPCS = SFR_P0^1;
sbit M0 = SFR_P0^7;
sbit NSLP = SFR_P0^0;
sbit SCLK = SFR_P0^6;
sbit DIR = SFR_P1^7;
sbit LEDB = SFR_P1^6;
sbit LEDG = SFR_P1^5;
sbit LEDR = SFR_P1^4;
sbit MOSI = SFR_P1^0;
sbit STEP = SFR_P1^1;
sbit CS0 = SFR_P2^2;
sbit CS1 = SFR_P2^1;
// IP pins --- END

/**
	* data structures and definitions for event-driven execution
	*/
// - flags
extern bdata struct Flags {
	// handshake
	unsigned char reqHostifToUsbrxtxSend:1;

	unsigned char reqDispToMutexLock:1;

	unsigned char ackHostifToUsbrxtxSend:1;

	unsigned char ackDispToMutexLock:1;

	unsigned char dneHostifToUsbrxtxSend:1;

	unsigned char reqLaserToMutexLock:1;
	unsigned char ackLaserToMutexLock:1;

	unsigned char reqHostifToUsbrxtxRecv:1;
	unsigned char ackHostifToUsbrxtxRecv:1;
	unsigned char dneHostifToUsbrxtxRecv:1;

	unsigned char reqInvChronoSetHhst:1;
	unsigned char ackInvChronoSetHhst:1;

	unsigned char reqInvLaserSet:1;
	unsigned char ackInvLaserSet:1;

	unsigned char reqInvStepMoveto:1;
	unsigned char ackInvStepMoveto:1;

	unsigned char reqInvStepSet:1;
	unsigned char ackInvStepSet:1;

	unsigned char reqInvStepZero:1;
	unsigned char ackInvStepZero:1;
} flags;

// - events
extern unsigned char evts0, evts1, evts2;

// handshake

#define EVTS0_reqHostifToUsbrxtxSend 0x01
#define SET_EVT_reqHostifToUsbrxtxSend() \
	{evts0 |= EVTS0_reqHostifToUsbrxtxSend; \
	acts0 |= ACTS0_hostif; \
	snss0 |= SNSS0_usbrxtx;}
#define IS_SET_EVT_reqHostifToUsbrxtxSend() ((evts0 & EVTS0_reqHostifToUsbrxtxSend) != 0)

#define EVTS0_reqDispToMutexLock 0x02
#define SET_EVT_reqDispToMutexLock() \
	{evts0 |= EVTS0_reqDispToMutexLock; \
	acts0 |= ACTS0_disp; \
	snss0 |= SNSS0_mutex;}
#define IS_SET_EVT_reqDispToMutexLock() ((evts0 & EVTS0_reqDispToMutexLock) != 0)

#define EVTS0_ackHostifToUsbrxtxSend 0x04
#define SET_EVT_ackHostifToUsbrxtxSend() \
	{evts0 |= EVTS0_ackHostifToUsbrxtxSend; \
	acts0 |= ACTS0_usbrxtx; \
	snss0 |= SNSS0_hostif;}
#define IS_SET_EVT_ackHostifToUsbrxtxSend() ((evts0 & EVTS0_ackHostifToUsbrxtxSend) != 0)

#define EVTS0_ackDispToMutexLock 0x08
#define SET_EVT_ackDispToMutexLock() \
	{evts0 |= EVTS0_ackDispToMutexLock; \
	acts0 |= ACTS0_mutex; \
	snss0 |= SNSS0_disp;}
#define IS_SET_EVT_ackDispToMutexLock() ((evts0 & EVTS0_ackDispToMutexLock) != 0)

#define EVTS0_dneHostifToUsbrxtxSend 0x10
#define SET_EVT_dneHostifToUsbrxtxSend() \
	{evts0 |= EVTS0_dneHostifToUsbrxtxSend; \
	acts0 |= ACTS0_usbrxtx; \
	snss0 |= SNSS0_hostif;}
#define IS_SET_EVT_dneHostifToUsbrxtxSend() ((evts0 & EVTS0_dneHostifToUsbrxtxSend) != 0)

#define EVTS0_reqLaserToMutexLock 0x20
#define SET_EVT_reqLaserToMutexLock() \
	{evts0 |= EVTS0_reqLaserToMutexLock; \
	acts0 |= ACTS0_laser; \
	snss0 |= SNSS0_mutex;}
#define IS_SET_EVT_reqLaserToMutexLock() ((evts0 & EVTS0_reqLaserToMutexLock) != 0)
#define EVTS0_ackLaserToMutexLock 0x40
#define SET_EVT_ackLaserToMutexLock() \
	{evts0 |= EVTS0_ackLaserToMutexLock; \
	acts0 |= ACTS0_mutex; \
	snss0 |= SNSS0_laser;}
#define IS_SET_EVT_ackLaserToMutexLock() ((evts0 & EVTS0_ackLaserToMutexLock) != 0)

#define EVTS0_reqHostifToUsbrxtxRecv 0x80
#define SET_EVT_reqHostifToUsbrxtxRecv() \
	{evts0 |= EVTS0_reqHostifToUsbrxtxRecv; \
	acts0 |= ACTS0_hostif; \
	snss0 |= SNSS0_usbrxtx;}
#define IS_SET_EVT_reqHostifToUsbrxtxRecv() ((evts0 & EVTS0_reqHostifToUsbrxtxRecv) != 0)
#define EVTS1_ackHostifToUsbrxtxRecv 0x01
#define SET_EVT_ackHostifToUsbrxtxRecv() \
	{evts1 |= EVTS1_ackHostifToUsbrxtxRecv; \
	acts0 |= ACTS0_usbrxtx; \
	snss0 |= SNSS0_hostif;}
#define IS_SET_EVT_ackHostifToUsbrxtxRecv() ((evts1 & EVTS1_ackHostifToUsbrxtxRecv) != 0)
#define EVTS1_dneHostifToUsbrxtxRecv 0x02
#define SET_EVT_dneHostifToUsbrxtxRecv() \
	{evts1 |= EVTS1_dneHostifToUsbrxtxRecv; \
	acts0 |= ACTS0_usbrxtx; \
	snss0 |= SNSS0_hostif;}
#define IS_SET_EVT_dneHostifToUsbrxtxRecv() ((evts1 & EVTS1_dneHostifToUsbrxtxRecv) != 0)

#define EVTS1_reqInvChronoSetHhst 0x04
#define SET_EVT_reqInvChronoSetHhst() \
	{evts1 |= EVTS1_reqInvChronoSetHhst; \
	acts0 |= ACTS0_hostif; \
	snss0 |= SNSS0_chrono;}
#define IS_SET_EVT_reqInvChronoSetHhst() ((evts1 & EVTS1_reqInvChronoSetHhst) != 0)
#define EVTS1_ackInvChronoSetHhst 0x08
#define SET_EVT_ackInvChronoSetHhst() \
	{evts1 |= EVTS1_ackInvChronoSetHhst; \
	acts0 |= ACTS0_chrono; \
	snss0 |= SNSS0_hostif;}
#define IS_SET_EVT_ackInvChronoSetHhst() ((evts1 & EVTS1_ackInvChronoSetHhst) != 0)

#define EVTS1_reqInvLaserSet 0x10
#define SET_EVT_reqInvLaserSet() \
	{evts1 |= EVTS1_reqInvLaserSet; \
	acts0 |= ACTS0_hostif; \
	snss0 |= SNSS0_laser;}
#define IS_SET_EVT_reqInvLaserSet() ((evts1 & EVTS1_reqInvLaserSet) != 0)
#define EVTS1_ackInvLaserSet 0x20
#define SET_EVT_ackInvLaserSet() \
	{evts1 |= EVTS1_ackInvLaserSet; \
	acts0 |= ACTS0_laser; \
	snss0 |= SNSS0_hostif;}
#define IS_SET_EVT_ackInvLaserSet() ((evts1 & EVTS1_ackInvLaserSet) != 0)

#define EVTS1_reqInvStepMoveto 0x40
#define SET_EVT_reqInvStepMoveto() \
	{evts1 |= EVTS1_reqInvStepMoveto; \
	acts0 |= ACTS0_hostif; \
	snss0 |= SNSS0_step;}
#define IS_SET_EVT_reqInvStepMoveto() ((evts1 & EVTS1_reqInvStepMoveto) != 0)
#define EVTS1_ackInvStepMoveto 0x80
#define SET_EVT_ackInvStepMoveto() \
	{evts1 |= EVTS1_ackInvStepMoveto; \
	acts0 |= ACTS0_step; \
	snss0 |= SNSS0_hostif;}
#define IS_SET_EVT_ackInvStepMoveto() ((evts1 & EVTS1_ackInvStepMoveto) != 0)

#define EVTS2_reqInvStepSet 0x01
#define SET_EVT_reqInvStepSet() \
	{evts2 |= EVTS2_reqInvStepSet; \
	acts0 |= ACTS0_hostif; \
	snss0 |= SNSS0_step;}
#define IS_SET_EVT_reqInvStepSet() ((evts2 & EVTS2_reqInvStepSet) != 0)
#define EVTS2_ackInvStepSet 0x02
#define SET_EVT_ackInvStepSet() \
	{evts2 |= EVTS2_ackInvStepSet; \
	acts0 |= ACTS0_step; \
	snss0 |= SNSS0_hostif;}
#define IS_SET_EVT_ackInvStepSet() ((evts2 & EVTS2_ackInvStepSet) != 0)

#define EVTS2_reqInvStepZero 0x04
#define SET_EVT_reqInvStepZero() \
	{evts2 |= EVTS2_reqInvStepZero; \
	acts0 |= ACTS0_hostif; \
	snss0 |= SNSS0_step;}
#define IS_SET_EVT_reqInvStepZero() ((evts2 & EVTS2_reqInvStepZero) != 0)
#define EVTS2_ackInvStepZero 0x08
#define SET_EVT_ackInvStepZero() \
	{evts2 |= EVTS2_ackInvStepZero; \
	acts0 |= ACTS0_step; \
	snss0 |= SNSS0_hostif;}
#define IS_SET_EVT_ackInvStepZero() ((evts2 & EVTS2_ackInvStepZero) != 0)

// strobes including statsng command shared data updates

#define EVTS2_chronoGetHhst 0x10
#define SET_EVT_chronoGetHhst() \
	{evts2 |= EVTS2_chronoGetHhst; \
	acts0 |= ACTS0_chrono; \
	snss0 |= SNSS0_hostif;}
#define IS_SET_EVT_chronoGetHhst() ((evts2 & EVTS2_chronoGetHhst) != 0)
#define EVTS2_stateGet 0x20
#define SET_EVT_stateGet() \
	{evts2 |= EVTS2_stateGet; \
	acts0 |= ACTS0_state;}
#define IS_SET_EVT_stateGet() ((evts2 & EVTS2_stateGet) != 0)
#define EVTS2_stepGetInfo 0x40
#define SET_EVT_stepGetInfo() \
	{evts2 |= EVTS2_stepGetInfo; \
	acts0 |= ACTS0_step;}
#define IS_SET_EVT_stepGetInfo() ((evts2 & EVTS2_stepGetInfo) != 0)

#define HAVE_NO_EVTS() ((evts0 | evts1 | evts2) == 0)

#define CLEAR_EVTS_ISR()

#define CLEAR_EVTS_FROM_CHRONO() \
	evts1 &= ~(EVTS1_ackInvChronoSetHhst); \
	evts2 &= ~(EVTS2_chronoGetHhst); \
	acts0 &= ~ACTS0_chrono;

#define HAVE_EVTS_FOR_CHRONO() (( \
		(evts1 & (EVTS1_reqInvChronoSetHhst)) \
	!= 0))

#define CLEAR_EVTS_FROM_DISP() \
	evts0 &= ~(EVTS0_reqDispToMutexLock); \
	acts0 &= ~ACTS0_disp;

#define HAVE_EVTS_FOR_DISP() (( \
		(evts0 & (EVTS0_ackDispToMutexLock)) \
	!= 0))

#define CLEAR_EVTS_FROM_HOSTIF() \
	evts0 &= ~(EVTS0_reqHostifToUsbrxtxSend | EVTS0_reqHostifToUsbrxtxRecv); \
	evts1 &= ~(EVTS1_reqInvChronoSetHhst | EVTS1_reqInvLaserSet | EVTS1_reqInvStepMoveto); \
	evts2 &= ~(EVTS2_reqInvStepSet | EVTS2_reqInvStepZero); \
	acts0 &= ~ACTS0_hostif;

#define HAVE_EVTS_FOR_HOSTIF() (( \
		(evts0 & (EVTS0_ackHostifToUsbrxtxSend | EVTS0_dneHostifToUsbrxtxSend)) \
		| (evts1 & (EVTS1_ackHostifToUsbrxtxRecv | EVTS1_dneHostifToUsbrxtxRecv | EVTS1_ackInvChronoSetHhst | EVTS1_ackInvLaserSet | EVTS1_ackInvStepMoveto)) \
		| (evts2 & (EVTS2_ackInvStepSet | EVTS2_ackInvStepZero | EVTS2_chronoGetHhst)) \
	!= 0))

#define CLEAR_EVTS_FROM_LASER() \
	evts0 &= ~(EVTS0_reqLaserToMutexLock); \
	evts1 &= ~(EVTS1_ackInvLaserSet); \
	acts0 &= ~ACTS0_laser;

#define HAVE_EVTS_FOR_LASER() (( \
		(evts0 & (EVTS0_ackLaserToMutexLock)) \
		| (evts1 & (EVTS1_reqInvLaserSet)) \
	!= 0))

#define CLEAR_EVTS_FROM_MUTEX() \
	evts0 &= ~(EVTS0_ackDispToMutexLock | EVTS0_ackLaserToMutexLock); \
	acts0 &= ~ACTS0_mutex;

#define HAVE_EVTS_FOR_MUTEX() (( \
		(evts0 & (EVTS0_reqDispToMutexLock | EVTS0_reqLaserToMutexLock)) \
	!= 0))

#define CLEAR_EVTS_FROM_STATE() \
	evts2 &= ~(EVTS2_stateGet); \
	acts0 &= ~ACTS0_state;

#define HAVE_EVTS_FOR_STATE() ((false))

#define CLEAR_EVTS_FROM_STEP() \
	evts1 &= ~(EVTS1_ackInvStepMoveto); \
	evts2 &= ~(EVTS2_ackInvStepSet | EVTS2_ackInvStepZero | EVTS2_stepGetInfo); \
	acts0 &= ~ACTS0_step;

#define HAVE_EVTS_FOR_STEP() (( \
		(evts1 & (EVTS1_reqInvStepMoveto)) \
		| (evts2 & (EVTS2_reqInvStepSet | EVTS2_reqInvStepZero)) \
	!= 0))

#define CLEAR_EVTS_FROM_USBRXTX() \
	evts0 &= ~(EVTS0_ackHostifToUsbrxtxSend | EVTS0_dneHostifToUsbrxtxSend); \
	evts1 &= ~(EVTS1_ackHostifToUsbrxtxRecv | EVTS1_dneHostifToUsbrxtxRecv); \
	acts0 &= ~ACTS0_usbrxtx;

#define HAVE_EVTS_FOR_USBRXTX() (( \
		(evts0 & (EVTS0_reqHostifToUsbrxtxSend | EVTS0_reqHostifToUsbrxtxRecv)) \
	!= 0))

// - activities
extern unsigned char acts0;

#define ACTS0_chrono 0x01
#define ACTS0_disp 0x02
#define ACTS0_hostif 0x04
#define ACTS0_laser 0x08
#define ACTS0_mutex 0x10
#define ACTS0_state 0x20
#define ACTS0_step 0x40
#define ACTS0_usbrxtx 0x80

#define HAVE_NO_ACTS() ((acts0) == 0)

#define SET_ACTIVE_CHRONO() acts0 |= ACTS0_chrono;
#define UNSET_ACTIVE_CHRONO() acts0 &= ~ACTS0_chrono;
#define IS_ACTIVE_CHRONO() ((acts0 & ACTS0_chrono) != 0)

#define SET_ACTIVE_DISP() acts0 |= ACTS0_disp;
#define UNSET_ACTIVE_DISP() acts0 &= ~ACTS0_disp;
#define IS_ACTIVE_DISP() ((acts0 & ACTS0_disp) != 0)

#define SET_ACTIVE_HOSTIF() acts0 |= ACTS0_hostif;
#define UNSET_ACTIVE_HOSTIF() acts0 &= ~ACTS0_hostif;
#define IS_ACTIVE_HOSTIF() ((acts0 & ACTS0_hostif) != 0)

#define SET_ACTIVE_LASER() acts0 |= ACTS0_laser;
#define UNSET_ACTIVE_LASER() acts0 &= ~ACTS0_laser;
#define IS_ACTIVE_LASER() ((acts0 & ACTS0_laser) != 0)

#define SET_ACTIVE_MUTEX() acts0 |= ACTS0_mutex;
#define UNSET_ACTIVE_MUTEX() acts0 &= ~ACTS0_mutex;
#define IS_ACTIVE_MUTEX() ((acts0 & ACTS0_mutex) != 0)

#define SET_ACTIVE_STATE() acts0 |= ACTS0_state;
#define UNSET_ACTIVE_STATE() acts0 &= ~ACTS0_state;
#define IS_ACTIVE_STATE() ((acts0 & ACTS0_state) != 0)

#define SET_ACTIVE_STEP() acts0 |= ACTS0_step;
#define UNSET_ACTIVE_STEP() acts0 &= ~ACTS0_step;
#define IS_ACTIVE_STEP() ((acts0 & ACTS0_step) != 0)

#define SET_ACTIVE_USBRXTX() acts0 |= ACTS0_usbrxtx;
#define UNSET_ACTIVE_USBRXTX() acts0 &= ~ACTS0_usbrxtx;
#define IS_ACTIVE_USBRXTX() ((acts0 & ACTS0_usbrxtx) != 0)

// - sensitivities
extern unsigned char snss0;

#define SNSS0_chrono 0x01
#define SNSS0_disp 0x02
#define SNSS0_hostif 0x04
#define SNSS0_laser 0x08
#define SNSS0_mutex 0x10
#define SNSS0_state 0x20
#define SNSS0_step 0x40
#define SNSS0_usbrxtx 0x80

#define HAVE_NO_SNSS() ((snss0) == 0)

#define SET_SENSITIVE_CHRONO() snss0 |= SNSS0_chrono; sns = true;
#define UNSET_SENSITIVE_CHRONO() snss0 &= ~SNSS0_chrono; sns = false;
#define IS_SENSITIVE_CHRONO() ((snss0 & SNSS0_chrono) != 0)

#define SET_SENSITIVE_DISP() snss0 |= SNSS0_disp; sns = true;
#define UNSET_SENSITIVE_DISP() snss0 &= ~SNSS0_disp; sns = false;
#define IS_SENSITIVE_DISP() ((snss0 & SNSS0_disp) != 0)

#define SET_SENSITIVE_HOSTIF() snss0 |= SNSS0_hostif; sns = true;
#define UNSET_SENSITIVE_HOSTIF() snss0 &= ~SNSS0_hostif; sns = false;
#define IS_SENSITIVE_HOSTIF() ((snss0 & SNSS0_hostif) != 0)

#define SET_SENSITIVE_LASER() snss0 |= SNSS0_laser; sns = true;
#define UNSET_SENSITIVE_LASER() snss0 &= ~SNSS0_laser; sns = false;
#define IS_SENSITIVE_LASER() ((snss0 & SNSS0_laser) != 0)

#define SET_SENSITIVE_MUTEX() snss0 |= SNSS0_mutex; sns = true;
#define UNSET_SENSITIVE_MUTEX() snss0 &= ~SNSS0_mutex; sns = false;
#define IS_SENSITIVE_MUTEX() ((snss0 & SNSS0_mutex) != 0)

#define SET_SENSITIVE_STATE() snss0 |= SNSS0_state; sns = true;
#define UNSET_SENSITIVE_STATE() snss0 &= ~SNSS0_state; sns = false;
#define IS_SENSITIVE_STATE() ((snss0 & SNSS0_state) != 0)

#define SET_SENSITIVE_STEP() snss0 |= SNSS0_step; sns = true;
#define UNSET_SENSITIVE_STEP() snss0 &= ~SNSS0_step; sns = false;
#define IS_SENSITIVE_STEP() ((snss0 & SNSS0_step) != 0)

#define SET_SENSITIVE_USBRXTX() snss0 |= SNSS0_usbrxtx; sns = true;
#define UNSET_SENSITIVE_USBRXTX() snss0 &= ~SNSS0_usbrxtx; sns = false;
#define IS_SENSITIVE_USBRXTX() ((snss0 & SNSS0_usbrxtx) != 0)

/**
	* chrono controller
	*/

// IP chrono.cust --- INSERT

extern struct ShrdatChrono { // ShrdatChrono --- LINE
	uint32_t getHhstHhst;

	// IP ShrdatChrono.cust --- INSERT
} shrdatChrono;

/**
	* disp controller
	*/

// IP disp.cust --- INSERT

extern struct ShrdatDisp { // ShrdatDisp --- LINE
	uint8_t dummy; // IP ShrdatDisp.cust --- LINE
} shrdatDisp;

/**
	* hostif module
	*/

// IP hostif.cust --- INSERT

extern struct ShrdatHostif { // ShrdatHostif --- LINE
	unsigned char rxbuf[7];

	// IP ShrdatHostif.cust --- INSERT
} shrdatHostif;

/**
	* laser controller
	*/

// IP laser.cust --- INSERT

extern struct ShrdatLaser { // ShrdatLaser --- LINE
	uint8_t dummy; // IP ShrdatLaser.cust --- LINE
} shrdatLaser;

/**
	* mutex module
	*/

// IP mutex.cust --- INSERT

extern struct ShrdatMutex { // ShrdatMutex --- LINE
	uint8_t dummy; // IP ShrdatMutex.cust --- LINE
} shrdatMutex;

/**
	* state controller
	*/

// IP state.cust --- INSERT

extern struct ShrdatState { // ShrdatState --- LINE
	uint8_t getTixVUbdkState;

	// IP ShrdatState.cust --- INSERT
} shrdatState;

/**
	* step controller
	*/

// IP step.cust --- INSERT

extern struct ShrdatStep { // ShrdatStep --- LINE
	uint8_t getInfoTixVState;

	uint16_t getInfoAngle;

	// IP ShrdatStep.cust --- INSERT
} shrdatStep;

/**
	* usbrxtx module
	*/

// IP usbrxtx.cust --- INSERT

extern struct ShrdatUsbrxtx { // ShrdatUsbrxtx --- LINE
	uint16_t len;
	unsigned char* ptrBuf;

	// IP ShrdatUsbrxtx.cust --- INSERT
} shrdatUsbrxtx;

#endif
