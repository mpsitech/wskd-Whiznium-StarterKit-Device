/**
	* \file Ubdk_exe.c
	* Wskd main (implementation)
	* \copyright (C) 2019-2020 MPSI Technologies GmbH
	* \author Alexander Wirthmueller (auto-generation)
	* \date created: 21 Oct 2021
	*/
// IP header --- ABOVE

#include "Ubdk.h"

#include "Chrono.h"
#include "Disp.h"
#include "Hostif.h"
#include "Laser.h"
#include "Mutex.h"
#include "State.h"
#include "Step.h"
#include "Usbrxtx.h"

bdata volatile struct Flags flags = {0};

volatile unsigned char evts0 = 0, evts1 = 0, evts2 = 0;

volatile unsigned char acts0 = 0;
volatile unsigned char snss0 = 0;

// IP cust1 --- IBEGIN
#define STRING1_LEN 2 * sizeof ("MPSI Technologies")
const uint8_t code USB_MfrStr[] = {STRING1_LEN, 0x03,
	'M', 0,
	'P', 0,
	'S', 0,
	'I', 0,
	' ', 0,
	'T', 0,
	'e', 0,
	'c', 0,
	'h', 0,
	'n', 0,
	'o', 0,
	'l', 0,
	'o', 0,
	'g', 0,
	'e', 0,
	'i', 0,
	's', 0
};

#define STRING2_LEN 2 * sizeof("Whiznium StarterKit Device")
const uint8_t code USB_ProductStr[] = {STRING2_LEN, 0x03,
	'W', 0,
	'h', 0,
	'i', 0,
	'z', 0,
	'n', 0,
	'i', 0,
	'u', 0,
	'm', 0,
	' ', 0,
	'S', 0,
	't', 0,
	'a', 0,
	'r', 0,
	't', 0,
	'e', 0,
	'r', 0,
	'K', 0,
	'i', 0,
	't', 0,
	' ', 0,
	'D', 0,
	'e', 0,
	'v', 0,
	'i', 0,
	'c', 0,
	'e', 0
};

#define STRING3_LEN 2 * sizeof("0005")
const uint8_t code USB_SerialStr[] = {STRING3_LEN, 0x03,
	'0', 0,
	'0', 0,
	'0', 0,
	'5', 0
};

const VCPXpress_Init_TypeDef initStruct = {
	0x10C4, // vendor ID
	0xEA60, // product ID
	USB_MfrStr, // pointer to manufacturer string
	USB_ProductStr, // pointer to product string
	USB_SerialStr, // pointer to serial string
	32, // max. power / 2
	0x80, // power attribute
	0x0100 // device release # (BCD format)
};

void SiLabs_Startup(void) {
  // disable WDT
  WDTCN = 0xDE;
  WDTCN = 0xAD;
}
// IP cust1 --- IEND

/******************************************************************************
 main program
 ******************************************************************************/

void init() {
	// IP init.cust --- IBEGIN
  uint8_t save;

  // - always revert to SFRPAGE 0x00
	SFRPAGE = 0x00;

	// pin buffer configuration
	P0MDOUT = P0MDOUT_B0__PUSH_PULL | P0MDOUT_B1__PUSH_PULL
			| P0MDOUT_B2__OPEN_DRAIN | P0MDOUT_B3__OPEN_DRAIN | P0MDOUT_B4__OPEN_DRAIN
			| P0MDOUT_B5__OPEN_DRAIN | P0MDOUT_B6__PUSH_PULL | P0MDOUT_B7__PUSH_PULL;

	P0MDIN = P0MDIN_B0__DIGITAL | P0MDIN_B1__DIGITAL | P0MDIN_B2__DIGITAL
			| P0MDIN_B3__DIGITAL | P0MDIN_B4__DIGITAL | P0MDIN_B5__DIGITAL
			| P0MDIN_B6__DIGITAL | P0MDIN_B7__DIGITAL;

	P0SKIP = P0SKIP_B0__SKIPPED | P0SKIP_B1__SKIPPED | P0SKIP_B2__SKIPPED
			| P0SKIP_B3__SKIPPED | P0SKIP_B4__SKIPPED | P0SKIP_B5__SKIPPED
			| P0SKIP_B6__NOT_SKIPPED | P0SKIP_B7__NOT_SKIPPED;

	P1MDOUT = P1MDOUT_B0__PUSH_PULL | P1MDOUT_B1__PUSH_PULL
			| P1MDOUT_B2__OPEN_DRAIN | P1MDOUT_B3__OPEN_DRAIN | P1MDOUT_B4__PUSH_PULL
			| P1MDOUT_B5__PUSH_PULL | P1MDOUT_B6__PUSH_PULL | P1MDOUT_B7__PUSH_PULL;

	P1MDIN = P1MDIN_B0__DIGITAL | P1MDIN_B1__DIGITAL | P1MDIN_B2__DIGITAL
			| P1MDIN_B3__DIGITAL | P1MDIN_B4__DIGITAL | P1MDIN_B5__DIGITAL
			| P1MDIN_B6__DIGITAL | P1MDIN_B7__DIGITAL;

	P1SKIP = P1SKIP_B0__NOT_SKIPPED | P1SKIP_B1__NOT_SKIPPED | P1SKIP_B2__SKIPPED
			| P1SKIP_B3__SKIPPED | P1SKIP_B4__SKIPPED | P1SKIP_B5__SKIPPED
			| P1SKIP_B6__SKIPPED | P1SKIP_B7__SKIPPED;

	SFRPAGE = 0x20;

	P2MDOUT = P2MDOUT_B0__OPEN_DRAIN | P2MDOUT_B1__PUSH_PULL
			| P2MDOUT_B2__PUSH_PULL | P2MDOUT_B3__PUSH_PULL;

	P2MDIN = P2MDIN_B0__DIGITAL | P2MDIN_B1__DIGITAL | P2MDIN_B2__DIGITAL
			| P2MDIN_B3__DIGITAL;

	P2SKIP = P2SKIP_B0__SKIPPED | P2SKIP_B1__SKIPPED | P2SKIP_B2__SKIPPED
			| P2SKIP_B3__SKIPPED;

	SFRPAGE = 0x00;

	// crossbar
	XBR0 = XBR0_URT0E__DISABLED | XBR0_SPI0E__ENABLED | XBR0_SMB0E__DISABLED
			| XBR0_CP0E__DISABLED | XBR0_CP0AE__DISABLED | XBR0_CP1E__DISABLED
			| XBR0_CP1AE__DISABLED | XBR0_SYSCKE__DISABLED;

	XBR1 = XBR1_PCA0ME__CEX0 | XBR1_ECIE__DISABLED | XBR1_T0E__DISABLED
			| XBR1_T1E__DISABLED | XBR1_T2E__DISABLED;

	XBR2 = XBR2_WEAKPUD__PULL_UPS_ENABLED | XBR2_XBARE__ENABLED
			| XBR2_URT1E__DISABLED | XBR2_URT1RTSE__DISABLED | XBR2_URT1CTSE__DISABLED;

	// - RSTSRC_0_enter_DefaultMode_from_RESET

	// a power-on or supply monitor reset occurred
	// a missing clock detector reset did not occur
	// a comparator 0 reset did not occur
	RSTSRC = RSTSRC_PORSF__SET | RSTSRC_MCDRSF__NOT_SET | RSTSRC_C0RSEF__NOT_SET;

	// - LFOSC0 (derived from reference manual)
	save = LFO0CN & 0x7C;

	LFO0CN = save | LFO0CN_OSCLEN__ENABLED | LFO0CN_OSCLD__DIVIDE_BY_8;

	// - CLOCK_0_enter_DefaultMode_from_RESET

	// clock derived from internal high-frequency oscillator, divided by 2 for SYSCLK
	save = CLKSEL & 0x08;

	CLKSEL = save | CLKSEL_CLKSL__HFOSC0 | CLKSEL_CLKDIV__SYSCLK_DIV_2;

	while ((CLKSEL & CLKSEL_DIVRDY__BMASK) == CLKSEL_DIVRDY__NOT_READY);

	// - TIMER01_0_enter_DefaultMode_from_RESET

	// save timer configuration
	save = TCON;

	// stop timer
	TCON &= ~TCON_TR0__BMASK;

	// TIMER0 high byte = 0x01 i.e. divider 255 resulting in 100.1Hz for chrono
	TH0 = (0x01 << TH0_TH0__SHIFT);

	// restore timer configuration
	TCON |= (save & TCON_TR0__BMASK);

	// - TIMER_SETUP_0_enter_DefaultMode_from_RESET

	// TIMER3 high byte uses the clock defined by T3XCLK in TMR3CN0
	// TIMER3 low byte uses the clock defined by T3XCLK in TMR3CN0
	// TIMER2 high byte uses the clock defined by T2XCLK in TMR2CN0
	// TIMER2 low byte uses the clock defined by T2XCLK in TMR2CN0
	// TIMER1 uses system clock
	// TIMERO uses pre-scaled system clock (/48)
	CKCON0 = CKCON0_T3MH__EXTERNAL_CLOCK | CKCON0_T3ML__EXTERNAL_CLOCK
			| CKCON0_T2MH__EXTERNAL_CLOCK | CKCON0_T2ML__EXTERNAL_CLOCK
			| CKCON0_T1M__SYSCLK | CKCON0_T0M__PRESCALE | CKCON0_SCA__SYSCLK_DIV_48;

	// TIMER0 mode 2 8-bit counter/timer with auto-reload, enabled when TR0 = 1 irrespective of INT0 logic level
	TMOD = TMOD_T0M__MODE2 | TMOD_CT0__TIMER | TMOD_GATE0__DISABLED;

	// set TIMER0 running
	TCON |= TCON_TR0__RUN;

	// - SPI_0_enter_DefaultMode_from_RESET

	// clock rate of 1.02MHz (for mclk = 12.25MHz)
	SPI0CKR = (0x04 << SPI0CKR_SPI0CKR__SHIFT);

	// enable master mode
	SPI0CFG |= SPI0CFG_MSTEN__MASTER_ENABLED;

	// enable the SPI module, 3-wire slave or master mode
	SPI0CN0 &= ~SPI0CN0_NSSMD__FMASK;
	SPI0CN0 |= SPI0CN0_SPIEN__ENABLED;

	// - PCA0 (derived from reference manual)
	NSLP = 0;

	PCA0CN0_CR = PCA0CN0_CR__STOP;

	// frequency mode: symmetric square wave based on 80kHz/8 low-frequency oscillator
	save = PCA0MD & 0x70;
	PCA0MD = save | PCA0MD_CIDL__NORMAL | PCA0MD_CPS__LFOSC_DIV_8 | PCA0MD_ECF__OVF_INT_DISABLED;

	PCA0CPM0 = PCA0CPM0_CAPN__DISABLED | PCA0CPM0_ECCF__DISABLED | PCA0CPM0_MAT__DISABLED
			 | PCA0CPM0_PWM16__16_BIT | PCA0CPM0_CAPP__DISABLED | PCA0CPM0_ECOM__ENABLED
			 | PCA0CPM0_PWM__ENABLED | PCA0CPM0_TOG__ENABLED;

	save = PCA0PWM & 0x18;
	PCA0PWM = save | PCA0PWM_ARSEL__CAPTURE_COMPARE | PCA0PWM_ECOV__COVF_MASK_DISABLED
			| PCA0PWM_COVF__NO_OVERFLOW | PCA0PWM_CLSEL__8_BITS;

	PCA0CPH0 = 0x3C; // adjustable frequency: f = 10kHz / PCA0CPH0 / 2

	save = PCA0CN0 & 0x38;
	PCA0CN0 = save | PCA0CN0_CR__RUN;

	// - VCPXpress initialization
 	USB_Init(&initStruct);

	API_Callback_Enable();
	// IP init.cust --- IEND

	chronoInit();
	dispInit();
	hostifInit();
	laserInit();
	mutexInit();
	stateInit();
	stepInit();
	usbrxtxInit();
}

void run() {
	// after initialization, this method is invoked from isr's only

	while (1) {
		// IP run.cust --- INSERT

		if (IS_ACTIVE_CHRONO()) CLEAR_EVTS_FROM_CHRONO();
		if (IS_SENSITIVE_CHRONO()) if (!chronoRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_DISP()) CLEAR_EVTS_FROM_DISP();
		if (IS_SENSITIVE_DISP()) if (!dispRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_HOSTIF()) CLEAR_EVTS_FROM_HOSTIF();
		if (IS_SENSITIVE_HOSTIF()) if (!hostifRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_LASER()) CLEAR_EVTS_FROM_LASER();
		if (IS_SENSITIVE_LASER()) if (!laserRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_MUTEX()) CLEAR_EVTS_FROM_MUTEX();
		if (IS_SENSITIVE_MUTEX()) if (!mutexRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_STATE()) CLEAR_EVTS_FROM_STATE();
		if (IS_SENSITIVE_STATE()) if (!stateRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_STEP()) CLEAR_EVTS_FROM_STEP();
		if (IS_SENSITIVE_STEP()) if (!stepRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		if (IS_ACTIVE_USBRXTX()) CLEAR_EVTS_FROM_USBRXTX();
		if (IS_SENSITIVE_USBRXTX()) if (!usbrxtxRun()) if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;

		CLEAR_EVTS_ISR();
		if (HAVE_NO_SNSS()) if (HAVE_NO_ACTS()) break;
	};
}

// IP cust2 --- IBEGIN
SI_INTERRUPT(TIMER0_ISR, TIMER0_IRQn) {
	SET_EVT_isrTIMER0();

	run();

	TCON_TF0 = 0; // auto-reload
}
// IP cust2 --- IEND

void main(void) {
	init();

	// IP main --- IBEGIN
	// - interrupt enable
	IE = IE_EX0__DISABLED | IE_ET0__ENABLED | IE_EX1__DISABLED | IE_ET1__DISABLED
			| IE_ES0__DISABLED | IE_ESPI0__DISABLED | IE_EA__ENABLED;
	// IP main --- IEND

	while (1) {
		// IP main.loop --- INSERT
	};
}
