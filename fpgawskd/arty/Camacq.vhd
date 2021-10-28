-- file Camacq.vhd
-- Camacq easy model controller implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Catherine Johnson (auto-generation)
-- date created: 1 Dec 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Arty.all;

entity Camacq is
	port (
		reset: in std_logic;
		mclk: in std_logic;
		btnPhase: in std_logic;

		reqInvSetGrrd: in std_logic;
		ackInvSetGrrd: out std_logic;

		setGrrdRng: in std_logic_vector(7 downto 0);
		setGrrdRedNotGray: in std_logic_vector(7 downto 0);

		getGrrdinfoTixVGrrdbufstate: out std_logic_vector(7 downto 0);
		getGrrdinfoTkst: out std_logic_vector(31 downto 0);

		reqInvSetPvw: in std_logic;
		ackInvSetPvw: out std_logic;

		setPvwRng: in std_logic_vector(7 downto 0);
		setPvwRawNotBin: in std_logic_vector(7 downto 0);
		setPvwGrayNotRgb: in std_logic_vector(7 downto 0);

		getPvwinfoTixVPvwbufstate: out std_logic_vector(7 downto 0);
		getPvwinfoTkst: out std_logic_vector(31 downto 0);

		tkclksrcGetTkstTkst: in std_logic_vector(31 downto 0);

		reqGrrdcdbufToFeatdet: in std_logic;

		reqGrrdabbufToFeatdet: in std_logic;

		ackGrrdcdbufToFeatdet: out std_logic;

		ackGrrdabbufToFeatdet: out std_logic;

		dneGrrdcdbufToFeatdet: in std_logic;

		dneGrrdabbufToFeatdet: in std_logic;
		avllenGrrdabbufToFeatdet: out std_logic_vector(3 downto 0);

		avllenGrrdcdbufToFeatdet: out std_logic_vector(3 downto 0);

		dGrrdabbufToFeatdet: out std_logic_vector(7 downto 0);

		dGrrdcdbufToFeatdet: out std_logic_vector(7 downto 0);
		strbDGrrdcdbufToFeatdet: in std_logic;

		strbDGrrdabbufToFeatdet: in std_logic;

		reqGrrdefbufToFeatdet: in std_logic;
		ackGrrdefbufToFeatdet: out std_logic;
		dneGrrdefbufToFeatdet: in std_logic;
		avllenGrrdefbufToFeatdet: out std_logic_vector(3 downto 0);

		dGrrdefbufToFeatdet: out std_logic_vector(7 downto 0);
		strbDGrrdefbufToFeatdet: in std_logic;

		reqPvwabufToHostif: in std_logic;
		ackPvwabufToHostif: out std_logic;
		dnePvwabufToHostif: in std_logic;
		avllenPvwabufToHostif: out std_logic_vector(7 downto 0);

		dPvwabufToHostif: out std_logic_vector(31 downto 0);
		strbDPvwabufToHostif: in std_logic;

		reqPvwbbufToHostif: in std_logic;
		ackPvwbbufToHostif: out std_logic;
		dnePvwbbufToHostif: in std_logic;
		avllenPvwbbufToHostif: out std_logic_vector(7 downto 0);

		dPvwbbufToHostif: out std_logic_vector(31 downto 0);
		strbDPvwbbufToHostif: in std_logic;

		pclk: in std_logic;
		href: in std_logic;
		vsync: in std_logic;

		d2: in std_logic;
		d3: in std_logic;
		d4: in std_logic;
		d5: in std_logic;
		d6: in std_logic;
		d7: in std_logic;
		d8: in std_logic;
		d9: in std_logic;

		cntFallA_dbg: out std_logic_vector(7 downto 0);
		cntRiseA_dbg: out std_logic_vector(7 downto 0);
		cntFallB_dbg: out std_logic_vector(7 downto 0);
		cntRiseB_dbg: out std_logic_vector(7 downto 0);

		strb_dbg: out std_logic_vector(5 downto 0);

		stateAlign_dbg: out std_logic_vector(7 downto 0);
		stateGrrd_dbg: out std_logic_vector(7 downto 0);
		stateGrrdabbufB_dbg: out std_logic_vector(7 downto 0);
		stateGrrdacc_dbg: out std_logic_vector(7 downto 0);
		stateGrrdcdbufB_dbg: out std_logic_vector(7 downto 0);
		stateGrrdefbufB_dbg: out std_logic_vector(7 downto 0);
		stateOp_dbg: out std_logic_vector(7 downto 0);
		statePvw_dbg: out std_logic_vector(7 downto 0);
		statePvwbingray_dbg: out std_logic_vector(7 downto 0);
		statePvwbinrgb_dbg: out std_logic_vector(7 downto 0);
		statePvwbuf_dbg: out std_logic_vector(7 downto 0);
		statePvwbufB_dbg: out std_logic_vector(7 downto 0);
		statePvwrawgray_dbg: out std_logic_vector(7 downto 0);
		statePvwrawrgb_dbg: out std_logic_vector(7 downto 0);
		stateSample_dbg: out std_logic_vector(7 downto 0);
		stateTag_dbg: out std_logic_vector(7 downto 0)
	);
end Camacq;

architecture Camacq of Camacq is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Spbram_v1_0_size2kB is
		port (
			clk: in std_logic;

			en: in std_logic;
			we: in std_logic;

			a: in std_logic_vector(10 downto 0);
			drd: out std_logic_vector(7 downto 0);
			dwr: in std_logic_vector(7 downto 0)
		);
	end component;

	component Spbram_v1_0_size4kB is
		port (
			clk: in std_logic;

			en: in std_logic;
			we: in std_logic;

			a: in std_logic_vector(11 downto 0);
			drd: out std_logic_vector(7 downto 0);
			dwr: in std_logic_vector(7 downto 0)
		);
	end component;

	component Dpbram_v1_0_size2kB is
		port (
			clkA: in std_logic;

			enA: in std_logic;
			weA: in std_logic;

			aA: in std_logic_vector(10 downto 0);
			drdA: out std_logic_vector(7 downto 0);
			dwrA: in std_logic_vector(7 downto 0);

			clkB: in std_logic;

			enB: in std_logic;
			weB: in std_logic;

			aB: in std_logic_vector(10 downto 0);
			drdB: out std_logic_vector(7 downto 0);
			dwrB: in std_logic_vector(7 downto 0)
		);
	end component;

	component Dpbram_size58kB is
		port (
			clkA: in std_logic;

			enA: in std_logic;
			weA: in std_logic_vector(0 downto 0);

			addrA: in std_logic_vector(15 downto 0);
			doutA: out std_logic_vector(7 downto 0);
			dinA: in std_logic_vector(7 downto 0);

			clkB: in std_logic;

			enB: in std_logic;
			weB: in std_logic_vector(0 downto 0);

			addrB: in std_logic_vector(13 downto 0);
			doutB: out std_logic_vector(31 downto 0);
			dinB: in std_logic_vector(31 downto 0)
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	constant tixVGrrdbufstateIdle: std_logic_vector(7 downto 0) := x"00";
	constant tixVGrrdbufstateEmpty: std_logic_vector(7 downto 0) := x"01";
	constant tixVGrrdbufstateStream: std_logic_vector(7 downto 0) := x"02";
	constant tixVGrrdbufstatePause: std_logic_vector(7 downto 0) := x"03";
	constant tixVGrrdbufstateEndfr: std_logic_vector(7 downto 0) := x"04";

	constant tixVPvwbufstateIdle: std_logic_vector(7 downto 0) := x"00";
	constant tixVPvwbufstateEmpty: std_logic_vector(7 downto 0) := x"01";
	constant tixVPvwbufstateAbuf: std_logic_vector(7 downto 0) := x"02";
	constant tixVPvwbufstateBbuf: std_logic_vector(7 downto 0) := x"03";

	---- pixel clock alignment (align)
	type stateAlign_t is (
		stateAlignInit,
		stateAlignCountA, stateAlignCountB, stateAlignCountC,
		stateAlignRun
	);
	signal stateAlign: stateAlign_t := stateAlignInit;

	constant cntmax: natural := 8;

	signal cntFallA: natural range 0 to cntmax;
	signal cntRiseA: natural range 0 to cntmax;
	signal cntFallB: natural range 0 to cntmax;
	signal cntRiseB: natural range 0 to cntmax;

	type phase_t is (phaseFallA, phaseRiseA, phaseFallB, phaseRiseB);
	signal phase: phase_t;
	signal pclk_shift: std_logic;

	-- IP sigs.align.cust --- INSERT

	---- gray/red operation, also managing grrd{ab/cd/ef}buf (grrd)
	type stateGrrd_t is (
		stateGrrdInit,
		stateGrrdWaitFrame,
		stateGrrdReady,
		stateGrrdStore
	);
	signal stateGrrd: stateGrrd_t := stateGrrdInit;

	signal tixVGrrdbufstate: std_logic_vector(7 downto 0);
	signal grrdTkst: std_logic_vector(31 downto 0);

	type grrdbuf_t is (grrdbufAb, grrdbufCd, grrdbufEf);
	signal grrdbuf: grrdbuf_t;

	signal enGrrdabbuf: std_logic;
	signal enGrrdcdbuf: std_logic;
	signal enGrrdefbuf: std_logic;

	signal aGrrdbuf_vec: std_logic_vector(10 downto 0);
	signal aGrrdbuf: natural range 0 to 2048;

	signal dwrGrrdbuf: std_logic_vector(7 downto 0);
	signal grrdaccrun: std_logic;

	-- IP sigs.grrd.cust --- INSERT

	---- grrdabbuf B/featdet-facing operation (grrdabbufB)
	type stateGrrdabbufB_t is (
		stateGrrdabbufBInit,
		stateGrrdabbufBReady,
		stateGrrdabbufBReadA, stateGrrdabbufBReadB
	);
	signal stateGrrdabbufB: stateGrrdabbufB_t := stateGrrdabbufBInit;

	signal ackGrrdabbufToFeatdet_sig: std_logic;
	signal enGrrdabbufB: std_logic;

	signal aGrrdabbufB_vec: std_logic_vector(10 downto 0);
	signal aGrrdabbufB: natural range 0 to 2048;

	-- IP sigs.grrdabbufB.cust --- INSERT

	---- gray/red accumulation, also managing evenbuf (grrdacc)
	type stateGrrdacc_t is (
		stateGrrdaccInit,
		stateGrrdaccWaitFrame,
		stateGrrdaccWaitRow,
		stateGrrdaccLASA, stateGrrdaccLASB, stateGrrdaccLASC, stateGrrdaccLASD
	);
	signal stateGrrdacc: stateGrrdacc_t := stateGrrdaccInit;

	signal dGrrdacc: std_logic_vector(7 downto 0);
	signal strbDGrrdacc: std_logic;

	signal enEvenbuf: std_logic;
	signal weEvenbuf: std_logic;

	signal aEvenbuf_vec: std_logic_vector(11 downto 0);
	signal aEvenbuf: natural range 0 to 4096;

	signal dwrEvenbuf: std_logic_vector(7 downto 0);

	-- IP sigs.grrdacc.cust --- INSERT

	---- grrdcdbuf B/featdet-facing operation (grrdcdbufB)
	type stateGrrdcdbufB_t is (
		stateGrrdcdbufBInit,
		stateGrrdcdbufBReady,
		stateGrrdcdbufBReadA, stateGrrdcdbufBReadB
	);
	signal stateGrrdcdbufB: stateGrrdcdbufB_t := stateGrrdcdbufBInit;

	signal ackGrrdcdbufToFeatdet_sig: std_logic;
	signal enGrrdcdbufB: std_logic;

	signal aGrrdcdbufB_vec: std_logic_vector(10 downto 0);
	signal aGrrdcdbufB: natural range 0 to 2048;

	-- IP sigs.grrdcdbufB.cust --- INSERT

	---- grrdefbuf B/featdet-facing operation (grrdefbufB)
	type stateGrrdefbufB_t is (
		stateGrrdefbufBInit,
		stateGrrdefbufBReady,
		stateGrrdefbufBReadA, stateGrrdefbufBReadB
	);
	signal stateGrrdefbufB: stateGrrdefbufB_t := stateGrrdefbufBInit;

	signal ackGrrdefbufToFeatdet_sig: std_logic;
	signal enGrrdefbufB: std_logic;

	signal aGrrdefbufB_vec: std_logic_vector(10 downto 0);
	signal aGrrdefbufB: natural range 0 to 2048;

	-- IP sigs.grrdefbufB.cust --- INSERT

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpInvGrrd,
		stateOpInvPvw,
		stateOpInv
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal ackInvSetGrrd_sig: std_logic;
	signal ackInvSetPvw_sig: std_logic;
	signal grrdrun: std_logic;
	signal grrdRedNotGray: std_logic;
	signal pvwrun: std_logic;
	type pvwacc_t is (pvwaccBingray, pvwaccBinrgb, pvwaccRawgray, pvwaccRawrgb);
	signal pvwacc: pvwacc_t;

	-- IP sigs.op.cust --- INSERT

	---- preview operation, also managing pvw{a/b}buf (pvw)
	type statePvw_t is (
		statePvwInit,
		statePvwTrylockA, statePvwTrylockB,
		statePvwWaitFrame,
		statePvwReady,
		statePvwStoreA, statePvwStoreB, statePvwStoreC, statePvwStoreD,
		statePvwDoneA, statePvwDoneB
	);
	signal statePvw: statePvw_t := statePvwInit;

	signal pvwTkstA: std_logic_vector(31 downto 0);
	signal pvwTkstB: std_logic_vector(31 downto 0);

	signal pvwLatestBNotA: std_logic;

	signal enPvwabuf: std_logic;
	signal enPvwbbuf: std_logic;

	signal aPvwbuf_vec: std_logic_vector(15 downto 0);
	signal aPvwbuf: natural range 0 to 57600;

	signal dwrPvwbuf: std_logic_vector(7 downto 0);

	signal pvwbingrayrun: std_logic;
	signal pvwbinrgbrun: std_logic;
	signal pvwrawgrayrun: std_logic;
	signal pvwrawrgbrun: std_logic;

	-- IP sigs.pvw.cust --- INSERT

	---- preview 4x4 pixel binning gray, also managing bingraybuf (pvwbingray)
	type statePvwbingray_t is (
		statePvwbingrayInit,
		statePvwbingrayWaitFrame,
		statePvwbingrayWaitRow,
		statePvwbingrayLASA, statePvwbingrayLASB, statePvwbingrayLASC, statePvwbingrayLASD
	);
	signal statePvwbingray: statePvwbingray_t := statePvwbingrayInit;

	signal dPvwbingrayGr: std_logic_vector(7 downto 0);
	signal strbDPvwbingrayGr: std_logic;

	signal enBingraybuf: std_logic;
	signal weBingraybuf: std_logic;

	signal aBingraybuf_vec: std_logic_vector(10 downto 0);
	signal aBingraybuf: natural range 0 to 2048;

	signal dwrBingraybuf: std_logic_vector(7 downto 0);

	-- IP sigs.pvwbingray.cust --- INSERT

	---- preview 8x8 pixel binning RGB, also managing binrgbbuf (pvwbinrgb)
	type statePvwbinrgb_t is (
		statePvwbinrgbInit,
		statePvwbinrgbWaitFrame,
		statePvwbinrgbWaitRow,
		statePvwbinrgbLASA, statePvwbinrgbLASB, statePvwbinrgbLASC, statePvwbinrgbLASD
	);
	signal statePvwbinrgb: statePvwbinrgb_t := statePvwbinrgbInit;

	signal dPvwbinrgbRd: std_logic_vector(7 downto 0);
	signal strbDPvwbinrgbRd: std_logic;

	signal dPvwbinrgbGn: std_logic_vector(7 downto 0);
	signal dPvwbinrgbBl: std_logic_vector(7 downto 0);
	signal strbDPvwbinrgbGnBl: std_logic;

	signal enBinrgbbuf: std_logic;
	signal weBinrgbbuf: std_logic;

	signal aBinrgbbuf_vec: std_logic_vector(10 downto 0);
	signal aBinrgbbuf: natural range 0 to 2048;

	signal dwrBinrgbbuf: std_logic_vector(7 downto 0);

	-- IP sigs.pvwbinrgb.cust --- INSERT

	---- pvw{a/b}buf mutex management (pvwbuf)
	type statePvwbuf_t is (
		statePvwbufInit,
		statePvwbufReady,
		statePvwbufAck
	);
	signal statePvwbuf: statePvwbuf_t := statePvwbufInit;

	type lock_t is (lockIdle, lockBufB, lockPvw);
	signal pvwabufLock: lock_t;
	signal pvwabufFull: std_logic;

	signal pvwbbufLock: lock_t;
	signal pvwbbufFull: std_logic;

	-- IP sigs.pvwbuf.cust --- INSERT

	---- pvw{a/b}buf B/hostif-facing operation (pvwbufB)
	type statePvwbufB_t is (
		statePvwbufBInit,
		statePvwbufBReady,
		statePvwbufBTrylock,
		statePvwbufBReadA, statePvwbufBReadB,
		statePvwbufBDone
	);
	signal statePvwbufB: statePvwbufB_t := statePvwbufBInit;

	signal enPvwabufB: std_logic;
	signal enPvwbbufB: std_logic;

	signal aPvwbufB_vec: std_logic_vector(13 downto 0);
	signal aPvwbufB: natural range 0 to 14400;

	signal tixVPvwbufstate: std_logic_vector(7 downto 0);
	signal pvwtkst: std_logic_vector(31 downto 0);

	signal ackPvwbufToHostif: std_logic;
	signal ackPvwabufToHostif_sig: std_logic;
	signal ackPvwbbufToHostif_sig: std_logic;

	-- IP sigs.pvwbufB.cust --- INSERT

	---- preview raw gray, also managing rawgraybuf (pvwrawgray)
	type statePvwrawgray_t is (
		statePvwrawgrayInit,
		statePvwrawgrayWaitFrame,
		statePvwrawgrayWaitRow,
		statePvwrawgrayLASA, statePvwrawgrayLASB, statePvwrawgrayLASC, statePvwrawgrayLASD
	);
	signal statePvwrawgray: statePvwrawgray_t := statePvwrawgrayInit;

	signal dPvwrawgrayGr: std_logic_vector(7 downto 0);
	signal strbDPvwrawgrayGr: std_logic;

	signal enRawgraybuf: std_logic;
	signal weRawgraybuf: std_logic;

	signal aRawgraybuf_vec: std_logic_vector(10 downto 0);
	signal aRawgraybuf: natural range 0 to 2048;

	signal dwrRawgraybuf: std_logic_vector(7 downto 0);

	-- IP sigs.pvwrawgray.cust --- INSERT

	---- preview raw RGB (pvwrawrgb)
	type statePvwrawrgb_t is (
		statePvwrawrgbInit,
		statePvwrawrgbWaitFrame,
		statePvwrawrgbWaitRow,
		statePvwrawrgbLASA, statePvwrawrgbLASB, statePvwrawrgbLASC, statePvwrawrgbLASD
	);
	signal statePvwrawrgb: statePvwrawrgb_t := statePvwrawrgbInit;

	signal dPvwrawrgbRd: std_logic_vector(7 downto 0);
	signal strbDPvwrawrgbRd: std_logic;

	signal dPvwrawrgbGn: std_logic_vector(7 downto 0);
	signal dPvwrawrgbBl: std_logic_vector(7 downto 0);
	signal strbDPvwrawrgbGnBl: std_logic;

	-- IP sigs.pvwrawrgb.cust --- INSERT

	---- camera data sampling at every other rising or falling mclk edge (sample)
	type stateSample_t is (
		stateSampleInit,
		stateSampleRunA, stateSampleRunB
	);
	signal stateSample: stateSample_t := stateSampleInit;

	signal vsync_sig: std_logic;
	signal vsync_shift: std_logic;

	signal href_sig: std_logic;
	signal href_shift: std_logic;

	signal d: std_logic_vector(7 downto 0);
	signal d_shift: std_logic_vector(7 downto 0);

	-- IP sigs.sample.cust --- INSERT

	---- camera frame tagging (tag)
	type stateTag_t is (
		stateTagInit,
		stateTagFrameA, stateTagFrameB,
		stateTagRowA, stateTagRowB,
		stateTagColA, stateTagColB
	);
	signal stateTag: stateTag_t := stateTagInit;

	constant rowmax: natural := 1944;

	constant row120: natural := 852; -- skiprow (1944 - 240) / 2
	constant row192: natural := 780; -- skiprow (1944 - 384) / 2
	constant row768: natural := 204; -- skiprow (1944 - 1536) / 2
	constant row960: natural := 12; -- skiprow (1944 - 1920) / 2

	constant colmax: natural := 2592;

	constant col160N1: natural := 1135; -- skipcol (2592 - 320) / 2 - 1
	constant col256N3: natural := 1037; -- skipcol (2592 - 512) / 2 - 3
	constant col1024N3: natural := 269; -- skipcol (2592 - 2048) / 2 - 3
	constant col1024N9: natural := 263; -- skipcol (2592 - 2048) / 2 - 9
	constant col1280: natural := 16; -- skipcol (2592 - 2560) / 2
	constant col1280N9: natural := 7; -- skipcol (2592 - 2560) / 2 - 9

	signal row: natural range 0 to rowmax;

	signal col: natural range 0 to colmax;

	signal strbFrame: std_logic;

	signal strbRow120: std_logic;
	signal strbRow192: std_logic;
	signal strbRow768: std_logic;
	signal strbRow960: std_logic;

	signal strbCol160N1: std_logic;
	signal strbCol256N3: std_logic;
	signal strbCol1024N3: std_logic;
	signal strbCol1024N9: std_logic;
	signal strbCol1280: std_logic;
	signal strbCol1280N9: std_logic;

	-- IP sigs.tag.cust --- INSERT

	---- myBingraybuf
	signal drdBingraybuf: std_logic_vector(7 downto 0);

	---- myBinrgbbuf
	signal drdBinrgbbuf: std_logic_vector(7 downto 0);

	---- myEvenbuf
	signal drdEvenbuf: std_logic_vector(7 downto 0);

	---- myRawgraybuf
	signal drdRawgraybuf: std_logic_vector(7 downto 0);

	---- handshake
	-- pvw to pvwbuf
	signal reqPvwToPvwbufAbufLock: std_logic;
	signal ackPvwToPvwbufAbufLock: std_logic;
	signal dnyPvwToPvwbufAbufLock: std_logic;

	-- pvw to pvwbuf
	signal reqPvwToPvwbufAbufSetFull: std_logic;
	signal ackPvwToPvwbufAbufSetFull: std_logic;

	-- pvw to pvwbuf
	signal reqPvwToPvwbufBbufLock: std_logic;
	signal ackPvwToPvwbufBbufLock: std_logic;
	signal dnyPvwToPvwbufBbufLock: std_logic;

	-- pvw to pvwbuf
	signal reqPvwToPvwbufBbufSetFull: std_logic;
	signal ackPvwToPvwbufBbufSetFull: std_logic;

	-- pvwbufB to pvwbuf
	signal reqPvwbufBToPvwbufAbufLock: std_logic;
	signal ackPvwbufBToPvwbufAbufLock: std_logic;
	signal dnyPvwbufBToPvwbufAbufLock: std_logic;

	-- pvwbufB to pvwbuf
	signal reqPvwbufBToPvwbufAbufClear: std_logic;
	signal ackPvwbufBToPvwbufAbufClear: std_logic;

	-- pvwbufB to pvwbuf
	signal reqPvwbufBToPvwbufBbufLock: std_logic;
	signal ackPvwbufBToPvwbufBbufLock: std_logic;
	signal dnyPvwbufBToPvwbufBbufLock: std_logic;

	-- pvwbufB to pvwbuf
	signal reqPvwbufBToPvwbufBbufClear: std_logic;
	signal ackPvwbufBToPvwbufBbufClear: std_logic;

	---- other
	signal mclkn: std_logic;
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myBingraybuf : Spbram_v1_0_size2kB
		port map (
			clk => mclk,

			en => enBingraybuf,
			we => weBingraybuf,

			a => aBingraybuf_vec,
			drd => drdBingraybuf,
			dwr => dwrBingraybuf
		);

	myBinrgbbuf : Spbram_v1_0_size2kB
		port map (
			clk => mclk,

			en => enBinrgbbuf,
			we => weBinrgbbuf,

			a => aBinrgbbuf_vec,
			drd => drdBinrgbbuf,
			dwr => dwrBinrgbbuf
		);

	myEvenbuf : Spbram_v1_0_size4kB
		port map (
			clk => mclkn,

			en => enEvenbuf,
			we => weEvenbuf,

			a => aEvenbuf_vec,
			drd => drdEvenbuf,
			dwr => dwrEvenbuf
		);

	myGrrdabbuf : Dpbram_v1_0_size2kB
		port map (
			clkA => mclk,

			enA => enGrrdabbuf,
			weA => '1',

			aA => aGrrdbuf_vec,
			drdA => open,
			dwrA => dwrGrrdbuf,

			clkB => mclkn,

			enB => enGrrdabbufB,
			weB => '0',

			aB => aGrrdabbufB_vec,
			drdB => dGrrdabbufToFeatdet,
			dwrB => (others => '0')
		);

	myGrrdcdbuf : Dpbram_v1_0_size2kB
		port map (
			clkA => mclk,

			enA => enGrrdcdbuf,
			weA => '1',

			aA => aGrrdbuf_vec,
			drdA => open,
			dwrA => dwrGrrdbuf,

			clkB => mclkn,

			enB => enGrrdcdbufB,
			weB => '0',

			aB => aGrrdcdbufB_vec,
			drdB => dGrrdcdbufToFeatdet,
			dwrB => (others => '0')
		);

	myGrrdefbuf : Dpbram_v1_0_size2kB
		port map (
			clkA => mclk,

			enA => enGrrdefbuf,
			weA => '1',

			aA => aGrrdbuf_vec,
			drdA => open,
			dwrA => dwrGrrdbuf,

			clkB => mclkn,

			enB => enGrrdefbufB,
			weB => '0',

			aB => aGrrdefbufB_vec,
			drdB => dGrrdefbufToFeatdet,
			dwrB => (others => '0')
		);

	myPvwabuf : Dpbram_size58kB
		port map (
			clkA => mclk,

			enA => enPvwabuf,
			weA => (others => '1'),

			addrA => aPvwbuf_vec,
			doutA => open,
			dinA => dwrPvwbuf,

			clkB => mclk,

			enB => enPvwabufB,
			weB => (others => '0'),

			addrB => aPvwbufB_vec,
			doutB => dPvwabufToHostif,
			dinB => (others => '0')
		);

	myPvwbbuf : Dpbram_size58kB
		port map (
			clkA => mclk,

			enA => enPvwbbuf,
			weA => (others => '1'),

			addrA => aPvwbuf_vec,
			doutA => open,
			dinA => dwrPvwbuf,

			clkB => mclk,

			enB => enPvwbbufB,
			weB => (others => '0'),

			addrB => aPvwbufB_vec,
			doutB => dPvwbbufToHostif,
			dinB => (others => '0')
		);

	myRawgraybuf : Spbram_v1_0_size2kB
		port map (
			clk => mclkn,

			en => enRawgraybuf,
			we => weRawgraybuf,

			a => aRawgraybuf_vec,
			drd => drdRawgraybuf,
			dwr => dwrRawgraybuf
		);

	------------------------------------------------------------------------
	-- implementation: pixel clock alignment (align)
	------------------------------------------------------------------------

	-- IP impl.align.wiring --- RBEGIN
	cntFallA_dbg <= std_logic_vector(to_unsigned(cntFallA, 8));
	cntRiseA_dbg <= std_logic_vector(to_unsigned(cntRiseA, 8));
	cntFallB_dbg <= std_logic_vector(to_unsigned(cntFallB, 8));
	cntRiseB_dbg <= std_logic_vector(to_unsigned(cntRiseB, 8));

	stateAlign_dbg <= x"00" when stateAlign=stateAlignInit
				else x"10" when stateAlign=stateAlignCountA
				else x"11" when stateAlign=stateAlignCountB
				else x"12" when stateAlign=stateAlignCountC
				else x"20" when stateAlign=stateAlignRun
				else (others => '1');
	-- IP impl.align.wiring --- REND

	-- IP impl.align.rising --- BEGIN
	process (reset, mclk, stateAlign)
		-- IP impl.align.vars --- RBEGIN
		variable i: natural range 0 to cntmax;
		
		variable btndead: boolean;
		-- IP impl.align.vars --- REND

	begin
		if reset='1' then
			-- IP impl.align.asyncrst --- RBEGIN
			stateAlign <= stateAlignInit;
			cntFallA <= 0;
			cntRiseA <= 0;
			cntFallB <= 0;
			cntRiseB <= 0;
			phase <= phaseFallA;
			-- IP impl.align.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (stateAlign=stateAlignInit or (grrdrun='0' and pvwrun='0')) then
				-- IP impl.align.syncrst --- RBEGIN
				phase <= phaseFallA;
				-- IP impl.align.syncrst --- REND

				if (grrdrun='1' or pvwrun='1') then
					-- IP impl.align.init.start --- IBEGIN
					cntFallA <= 0;
					cntRiseA <= 0;
					cntFallB <= 0;
					cntRiseB <= 0;

					i := 0;
					
					btndead := false;
					-- IP impl.align.init.start --- IEND

					stateAlign <= stateAlignCountA;

				else
					stateAlign <= stateAlignInit;
				end if;

			elsif stateAlign=stateAlignCountA then
				-- IP impl.align.countA --- IBEGIN
				if pclk_shift='1' then
					cntFallA <= cntFallA + 1;
				end if;

				if pclk='1' then
					cntRiseA <= cntRiseA + 1;
				end if;
				-- IP impl.align.countA --- IEND

				stateAlign <= stateAlignCountB;

			elsif stateAlign=stateAlignCountB then
				-- IP impl.align.countB.ext --- IBEGIN
				if pclk_shift='1' then
					cntFallB <= cntFallB + 1;
				end if;

				if pclk='1' then
					cntRiseB <= cntRiseB + 1;
				end if;

				i := i + 1;
				-- IP impl.align.countB.ext --- IEND

				if i=cntmax then
					stateAlign <= stateAlignCountC;

				else
					stateAlign <= stateAlignCountA;
				end if;

			elsif stateAlign=stateAlignCountC then
				-- IP impl.align.countC --- IBEGIN
				if cntFallA<cntmax and cntRiseA=cntmax then
					phase <= phaseRiseA;
				elsif cntRiseA<cntmax and cntFallB=cntmax then
					phase <= phaseFallB;
				elsif cntFallB<cntmax and cntRiseB=cntmax then
					phase <= phaseRiseB;
				elsif cntRiseB<cntmax and cntFallA=cntmax then
					phase <= phaseFallA;
				end if;
				-- IP impl.align.countC --- IEND

				stateAlign <= stateAlignRun;

			elsif stateAlign=stateAlignRun then
				-- IP impl.align.run --- IBEGIN
				if btnPhase='1' and not btndead then
					if phase=phaseRiseA then
						phase <= phaseFallB;
					elsif phase=phaseFallB then
						phase <= phaseRiseB;
					elsif phase=phaseRiseB then
						phase <= phaseFallA;
					else
						phase <= phaseRiseA;
					end if;
					
					btndead := true;

				elsif btnPhase='0' and btndead then
					btndead := false;
				end if;
				-- IP impl.align.run --- IEND
			end if;
		end if;
	end process;
	-- IP impl.align.rising --- END

	-- IP impl.align.falling --- RBEGIN
	process (reset, mclk)
		-- IP impl.align.falling.vars --- BEGIN
		-- IP impl.align.falling.vars --- END
	begin
		if reset='1' then
			pclk_shift <= '0';

		elsif falling_edge(mclk) then
			pclk_shift <= pclk;
		end if;
	end process;
	-- IP impl.align.falling --- REND

	------------------------------------------------------------------------
	-- implementation: gray/red operation, also managing grrd{ab/cd/ef}buf (grrd)
	------------------------------------------------------------------------

	-- IP impl.grrd.wiring --- RBEGIN
	enGrrdabbuf <= '1' when (grrdbuf=grrdbufAb and stateGrrd=stateGrrdStore) else '0';
	enGrrdcdbuf <= '1' when (grrdbuf=grrdbufCd and stateGrrd=stateGrrdStore) else '0';
	enGrrdefbuf <= '1' when (grrdbuf=grrdbufEf and stateGrrd=stateGrrdStore) else '0';

	aGrrdbuf_vec <= std_logic_vector(to_unsigned(aGrrdbuf, 11));

	grrdaccrun <= '1' when (stateGrrd=stateGrrdReady or stateGrrd=stateGrrdStore) else '0';

	stateGrrd_dbg <= x"00" when stateGrrd=stateGrrdInit
				else x"10" when stateGrrd=stateGrrdWaitFrame
				else x"20" when stateGrrd=stateGrrdReady
				else x"30" when stateGrrd=stateGrrdStore
				else (others => '1');
	-- IP impl.grrd.wiring --- REND

	-- IP impl.grrd.rising --- BEGIN
	process (reset, mclk, stateGrrd)
		-- IP impl.grrd.vars --- RBEGIN
		variable rowcnt: natural range 0 to 768;
		-- IP impl.grrd.vars --- REND

	begin
		if reset='1' then
			-- IP impl.grrd.asyncrst --- RBEGIN
			stateGrrd <= stateGrrdInit;

			tixVGrrdbufstate <= tixVGrrdbufstateIdle;
			grrdbuf <= grrdbufAb;
			grrdTkst <= (others => '0');
			aGrrdbuf <= 0;
			dwrGrrdbuf <= (others => '0');

			rowcnt := 0;
			-- IP impl.grrd.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (stateGrrd=stateGrrdInit or grrdrun='0') then
				-- IP impl.grrd.syncrst --- RBEGIN
				grrdbuf <= grrdbufAb;
				aGrrdbuf <= 0;
				rowcnt := 0;
				dwrGrrdbuf <= (others => '0');
				-- IP impl.grrd.syncrst --- REND

				if grrdrun='0' then
					-- IP impl.grrd.init.toIdle --- IBEGIN
					grrdTkst <= (others => '0');
					tixVGrrdbufstate <= tixVGrrdbufstateIdle;
					-- IP impl.grrd.init.toIdle --- IEND

					stateGrrd <= stateGrrdInit;

				else
					stateGrrd <= stateGrrdWaitFrame;
				end if;

			elsif stateGrrd=stateGrrdWaitFrame then
				if strbFrame='1' then
					-- IP impl.grrd.waitFrame --- IBEGIN
					tixVGrrdbufstate <= tixVGrrdbufstateEmpty;
					grrdTkst <= tkclksrcGetTkstTkst;
					-- IP impl.grrd.waitFrame --- IEND

					stateGrrd <= stateGrrdReady;
				end if;

			elsif stateGrrd=stateGrrdReady then
				if strbDGrrdacc='1' then
					-- IP impl.grrd.ready --- IBEGIN
					dwrGrrdbuf <= dGrrdacc;

					tixVGrrdbufstate <= tixVGrrdbufstateStream;
					-- IP impl.grrd.ready --- IEND

					stateGrrd <= stateGrrdStore;
				end if;

			elsif stateGrrd=stateGrrdStore then
				if aGrrdbuf=2046 then
					-- IP impl.grrd.store.eorEven --- IBEGIN
					aGrrdbuf <= 1;
					
					rowcnt := rowcnt + 1;

					tixVGrrdbufstate <= tixVGrrdbufstatePause;
					-- IP impl.grrd.store.eorEven --- IEND

					stateGrrd <= stateGrrdReady;

				elsif aGrrdbuf=2047 then
					-- IP impl.grrd.store.eorOdd --- IBEGIN
					aGrrdbuf <= 0;

					rowcnt := rowcnt + 1;
					-- IP impl.grrd.store.eorOdd --- IEND

					if rowcnt=768 then
						tixVGrrdbufstate <= tixVGrrdbufstateEndfr; -- IP impl.grrd.store.eof --- ILINE

						stateGrrd <= stateGrrdInit;

					else
						-- IP impl.grrd.store.eorOddInt --- IBEGIN
						if grrdbuf=grrdbufAb then
							grrdbuf <= grrdbufCd;
						elsif grrdbuf=grrdbufCd then
							grrdbuf <= grrdbufEf;
						else
							grrdbuf <= grrdbufAb;
						end if;

						tixVGrrdbufstate <= tixVGrrdbufstatePause;
						-- IP impl.grrd.store.eorOddInt --- IEND

						stateGrrd <= stateGrrdReady;
					end if;

				else
					aGrrdbuf <= aGrrdbuf + 2; -- IP impl.grrd.store.inc --- ILINE

					stateGrrd <= stateGrrdReady;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.grrd.rising --- END

	------------------------------------------------------------------------
	-- implementation: grrdabbuf B/featdet-facing operation (grrdabbufB)
	------------------------------------------------------------------------

	-- IP impl.grrdabbufB.wiring --- RBEGIN
	enGrrdabbufB <= '1' when (strbDGrrdabbufToFeatdet='0' and stateGrrdabbufB=stateGrrdabbufBReadA) else '0';
	ackGrrdabbufToFeatdet <= ackGrrdabbufToFeatdet_sig;

	aGrrdabbufB_vec <= std_logic_vector(to_unsigned(aGrrdabbufB, 11));

	stateGrrdabbufB_dbg <= x"00" when stateGrrdabbufB=stateGrrdabbufBInit
				else x"10" when stateGrrdabbufB=stateGrrdabbufBReady
				else x"20" when stateGrrdabbufB=stateGrrdabbufBReadA
				else x"21" when stateGrrdabbufB=stateGrrdabbufBReadB
				else (others => '1');
	-- IP impl.grrdabbufB.wiring --- REND

	-- IP impl.grrdabbufB.rising --- BEGIN
	process (reset, mclk, stateGrrdabbufB)
		-- IP impl.grrdabbufB.vars --- BEGIN
		-- IP impl.grrdabbufB.vars --- END

	begin
		if reset='1' then
			-- IP impl.grrdabbufB.asyncrst --- BEGIN
			stateGrrdabbufB <= stateGrrdabbufBInit;
			ackGrrdabbufToFeatdet_sig <= '0';
			aGrrdabbufB <= 0;
			-- IP impl.grrdabbufB.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateGrrdabbufB=stateGrrdabbufBInit or tixVGrrdbufstate/=tixVGrrdbufstateStream) then
				-- IP impl.grrdabbufB.syncrst --- BEGIN
				ackGrrdabbufToFeatdet_sig <= '0';
				aGrrdabbufB <= 0;

				-- IP impl.grrdabbufB.syncrst --- END

				if tixVGrrdbufstate/=tixVGrrdbufstateStream then
					stateGrrdabbufB <= stateGrrdabbufBInit;

				else
					stateGrrdabbufB <= stateGrrdabbufBReady;
				end if;

			elsif stateGrrdabbufB=stateGrrdabbufBReady then
				if reqGrrdabbufToFeatdet='1' then
					aGrrdabbufB <= 0; -- IP impl.grrdabbufB.ready --- ILINE

					stateGrrdabbufB <= stateGrrdabbufBReadA;
				end if;

			elsif stateGrrdabbufB=stateGrrdabbufBReadA then
				if reqGrrdabbufToFeatdet='0' then
					ackGrrdabbufToFeatdet_sig <= '0'; -- IP impl.grrdabbufB.readA.done --- ILINE

					stateGrrdabbufB <= stateGrrdabbufBReady;

				elsif strbDGrrdabbufToFeatdet='0' then
					ackGrrdabbufToFeatdet_sig <= '1'; -- IP impl.grrdabbufB.readA.next --- ILINE

					stateGrrdabbufB <= stateGrrdabbufBReadB;
				end if;

			elsif stateGrrdabbufB=stateGrrdabbufBReadB then
				if strbDGrrdabbufToFeatdet='1' then
					aGrrdabbufB <= aGrrdabbufB + 1; -- IP impl.grrdabbufB.readB.inc --- ILINE

					stateGrrdabbufB <= stateGrrdabbufBReadA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.grrdabbufB.rising --- END

	------------------------------------------------------------------------
	-- implementation: gray/red accumulation, also managing evenbuf (grrdacc)
	------------------------------------------------------------------------

	-- IP impl.grrdacc.wiring --- RBEGIN
	getGrrdinfoTixVGrrdbufstate <= tixVGrrdbufstate;
	getGrrdinfoTkst <= grrdtkst;

	-- similar to rawgraybuf

	-- works on the premise that pclk is 25MHz for mclk 50MHz

	-- even: GRGRGR..., odd: BGBGBG... (h mirror on / 0x3821=0x06 and vflipped, as determined experimentally)

	enEvenbuf <= '1' when (stateGrrdacc=stateGrrdaccLASA or stateGrrdacc=stateGrrdaccLASB or stateGrrdacc=stateGrrdaccLASC or stateGrrdacc=stateGrrdaccLASD) else '0';

	aEvenbuf_vec <= std_logic_vector(to_unsigned(aEvenbuf, 12));

	stateGrrdacc_dbg <= x"00" when stateGrrdacc=stateGrrdaccInit
				else x"10" when stateGrrdacc=stateGrrdaccWaitFrame
				else x"20" when stateGrrdacc=stateGrrdaccWaitRow
				else x"30" when stateGrrdacc=stateGrrdaccLASA
				else x"31" when stateGrrdacc=stateGrrdaccLASB
				else x"32" when stateGrrdacc=stateGrrdaccLASC
				else x"33" when stateGrrdacc=stateGrrdaccLASD
				else (others => '1');
	-- IP impl.grrdacc.wiring --- REND

	-- IP impl.grrdacc.rising --- BEGIN
	process (reset, mclk, stateGrrdacc)
		-- IP impl.grrdacc.vars --- RBEGIN
		variable rdA: std_logic_vector(7 downto 0);
		variable rdB: std_logic_vector(7 downto 0);

		variable gnA: std_logic_vector(7 downto 0);
		variable gnB: std_logic_vector(7 downto 0);

		variable gn: std_logic_vector(8 downto 0);
		variable bl: std_logic_vector(7 downto 0);

		variable grrd: std_logic_vector(9 downto 0);

		variable ab: natural range 0 to 1; -- accumulator used for adding - 0: a, 1: b

		constant rowmax_lcl: natural := 1536;
		variable row_lcl: std_logic_vector(10 downto 0);

		variable pre: std_logic;
		variable post: std_logic;

		variable col2L: natural range 0 to 2048;
		variable col2A: natural range 0 to 2048;
		variable col2S: natural range 0 to 2048;
		-- IP impl.grrdacc.vars --- REND

	begin
		if reset='1' then
			-- IP impl.grrdacc.asyncrst --- RBEGIN
			stateGrrdacc <= stateGrrdaccInit;

			dGrrdacc <= (others => '0');
			strbDGrrdacc <= '0';
			weEvenbuf <= '0';
			aEvenbuf <= 0;
			dwrEvenbuf <= (others => '0');

			rdA := (others => '0');
			rdB := (others => '0');
			gnA := (others => '0');
			gnB := (others => '0');
			gn := (others => '0');
			bl := (others => '0');
			grrd := (others => '0');
			ab := 0;
			row_lcl := (others => '0');
			pre := '0';
			post := '0';
			col2L := 0;
			col2A := 0;
			col2S := 0;
			-- IP impl.grrdacc.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (stateGrrdacc=stateGrrdaccInit or grrdaccrun='0') then
				-- IP impl.grrdacc.syncrst --- BEGIN
				dGrrdacc <= (others => '0');
				strbDGrrdacc <= '0';
				weEvenbuf <= '0';
				aEvenbuf <= 0;
				dwrEvenbuf <= (others => '0');

				-- IP impl.grrdacc.syncrst --- END

				if grrdaccrun='0' then
					stateGrrdacc <= stateGrrdaccInit;

				else
					stateGrrdacc <= stateGrrdaccWaitFrame;
				end if;

			elsif stateGrrdacc=stateGrrdaccWaitFrame then
				if strbRow768='1' then
					row_lcl := (others => '0'); -- IP impl.grrdacc.waitFrame --- ILINE

					stateGrrdacc <= stateGrrdaccWaitRow;
				end if;

			elsif stateGrrdacc=stateGrrdaccWaitRow then
				if strbCol1024N3='1' then
					-- IP impl.grrdacc.waitRow --- IBEGIN
					ab := 0;

					pre := '1';
					post := '0';

					col2L := 0;
					col2A := 0;
					col2S := 0;
					-- IP impl.grrdacc.waitRow --- IEND

					stateGrrdacc <= stateGrrdaccLASA;
				end if;

			elsif stateGrrdacc=stateGrrdaccLASA then
				-- IP impl.grrdacc.LASA --- IBEGIN
				if post='0' then
					-- load
					if row_lcl(0)='1' then
						weEvenbuf <= '0';

						aEvenbuf <= col2L;
					end if;
				end if;

				if pre='0' then
					-- store
					if row_lcl(0)='0' then
						weEvenbuf <= '1';

						aEvenbuf <= col2S;

						if ab=0 then
							dwrEvenbuf <= gnB;
						else
							dwrEvenbuf <= gnA;
						end if;

						col2S := col2S + 1;
					end if;
				end if;

				if (pre='0' and post='0') then
					-- add
					if row_lcl(0)='0' then
						if ab=0 then
							gnA := d;
						else
							gnB := d;
						end if;
					else
						bl := d;
					end if;

					col2A := col2A + 1;
				end if;
				-- IP impl.grrdacc.LASA --- IEND

				stateGrrdacc <= stateGrrdaccLASB;

			elsif stateGrrdacc=stateGrrdaccLASB then
				-- IP impl.grrdacc.LASB --- IBEGIN
				if post='0' then
					-- load
					if row_lcl(0)='1' then
						if ab=0 then
							gnB := drdEvenbuf;
						else
							gnA := drdEvenbuf;
						end if;

						col2L := col2L + 1;
					end if;
				end if;
				-- IP impl.grrdacc.LASB --- IEND

				stateGrrdacc <= stateGrrdaccLASC;

			elsif stateGrrdacc=stateGrrdaccLASC then
				-- IP impl.grrdacc.LASC --- IBEGIN
				if post='0' then
					-- load
					if row_lcl(0)='1' then
						weEvenbuf <= '0';

						aEvenbuf <= col2L;
					end if;
				end if;

				if pre='0' then
					-- store
					if row_lcl(0)='0' then
						weEvenbuf <= '1';

						aEvenbuf <= col2S;

						if ab=0 then
							dwrEvenbuf <= rdB;
						else
							dwrEvenbuf <= rdA;
						end if;

						col2S := col2S + 1;
					end if;
				end if;

				if (pre='0' and post='0') then
					if row_lcl(0)='0' then
						-- add
						if ab=0 then
							rdA := d;
						else
							rdB := d;
						end if;

					else
						-- add and store in grrdbuf
						if grrdRedNotGray='0' then
							if ab=0 then
								grrd := std_logic_vector(unsigned("00" & bl) + unsigned("00" & rdA) + unsigned("00" & gnA) + unsigned("00" & d));
							else
								grrd := std_logic_vector(unsigned("00" & bl) + unsigned("00" & rdB) + unsigned("00" & gnB) + unsigned("00" & d));
							end if;

							dGrrdacc <= grrd(9 downto 2);

						else
							if ab=0 then
								gn := std_logic_vector(unsigned("0" & gnA) + unsigned("0" & d));

								if ( (unsigned(rdA) > unsigned(gn(8 downto 1))) and (unsigned(rdA) > unsigned(bl)) ) then
									grrd := std_logic_vector(unsigned("0" & rdA & "0") - unsigned("00" & gn(8 downto 1)) - unsigned("00" & bl)); -- red dominance: (r-g) + (r-b)
								else
									grrd := (others => '0');
								end if;

							else
								gn := std_logic_vector(unsigned("0" & gnB) + unsigned("0" & d));

								if ( (unsigned(rdB) > unsigned(gn(8 downto 1))) and (unsigned(rdB) > unsigned(bl)) ) then
									grrd := std_logic_vector(unsigned("0" & rdB & "0") - unsigned("00" & gn(8 downto 1)) - unsigned("00" & bl));
								else
									grrd := (others => '0');
								end if;
							end if;

							dGrrdacc <= grrd(7 downto 0);
						end if;

						strbDGrrdacc <= '1';
					end if;

					col2A := col2A + 1;
				end if;
				-- IP impl.grrdacc.LASC --- IEND

				stateGrrdacc <= stateGrrdaccLASD;

			elsif stateGrrdacc=stateGrrdaccLASD then
				-- IP impl.grrdacc.LASD.ext --- IBEGIN
				strbDGrrdacc <= '0';

				if post='0' then
					-- load
					if row_lcl(0)='1' then
						if ab=0 then
							rdB := drdEvenbuf;
						else
							rdA := drdEvenbuf;
						end if;

						col2L := col2L + 1;
					end if;
				end if;

				if ab=1 then
					ab := 0;
				else
					ab := ab + 1;
				end if;
				-- IP impl.grrdacc.LASD.ext --- IEND

				if pre='1' then
					pre := '0'; -- IP impl.grrdacc.LASD.preOff --- ILINE

					stateGrrdacc <= stateGrrdaccLASA;

				elsif (col2A=2048 and post='0') then
					post := '1'; -- IP impl.grrdacc.LASD.postOn --- ILINE

					stateGrrdacc <= stateGrrdaccLASA;

				elsif post='1' then
					row_lcl := std_logic_vector(unsigned(row_lcl) + 1); -- IP impl.grrdacc.LASD.incRow --- ILINE

					if row_lcl=std_logic_vector(to_unsigned(rowmax_lcl, 11)) then
						stateGrrdacc <= stateGrrdaccWaitFrame;

					else
						stateGrrdacc <= stateGrrdaccWaitRow;
					end if;

				else
					stateGrrdacc <= stateGrrdaccLASA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.grrdacc.rising --- END

	------------------------------------------------------------------------
	-- implementation: grrdcdbuf B/featdet-facing operation (grrdcdbufB)
	------------------------------------------------------------------------

	-- IP impl.grrdcdbufB.wiring --- RBEGIN
	enGrrdcdbufB <= '1' when (strbDGrrdcdbufToFeatdet='0' and stateGrrdcdbufB=stateGrrdcdbufBReadA) else '0';
	ackGrrdcdbufToFeatdet <= ackGrrdcdbufToFeatdet_sig;

  aGrrdcdbufB_vec <= std_logic_vector(to_unsigned(aGrrdcdbufB, 11));

	stateGrrdcdbufB_dbg <= x"00" when stateGrrdcdbufB=stateGrrdcdbufBInit
				else x"10" when stateGrrdcdbufB=stateGrrdcdbufBReady
				else x"20" when stateGrrdcdbufB=stateGrrdcdbufBReadA
				else x"21" when stateGrrdcdbufB=stateGrrdcdbufBReadB
				else (others => '1');
	-- IP impl.grrdcdbufB.wiring --- REND

	-- IP impl.grrdcdbufB.rising --- BEGIN
	process (reset, mclk, stateGrrdcdbufB)
		-- IP impl.grrdcdbufB.vars --- BEGIN
		-- IP impl.grrdcdbufB.vars --- END

	begin
		if reset='1' then
			-- IP impl.grrdcdbufB.asyncrst --- BEGIN
			stateGrrdcdbufB <= stateGrrdcdbufBInit;
			ackGrrdcdbufToFeatdet_sig <= '0';
			aGrrdcdbufB <= 0;
			-- IP impl.grrdcdbufB.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateGrrdcdbufB=stateGrrdcdbufBInit or tixVGrrdbufstate/=tixVGrrdbufstateStream) then
				-- IP impl.grrdcdbufB.syncrst --- BEGIN
				ackGrrdcdbufToFeatdet_sig <= '0';
				aGrrdcdbufB <= 0;

				-- IP impl.grrdcdbufB.syncrst --- END

				if tixVGrrdbufstate/=tixVGrrdbufstateStream then
					stateGrrdcdbufB <= stateGrrdcdbufBInit;

				else
					stateGrrdcdbufB <= stateGrrdcdbufBReady;
				end if;

			elsif stateGrrdcdbufB=stateGrrdcdbufBReady then
				if reqGrrdcdbufToFeatdet='1' then
				-- IP impl.grrdcdbufB.ready --- IBEGIN
        if reqGrrdcdbufToFeatdet='1' then
          aGrrdcdbufB <= 0;
          stateGrrdcdbufB <= stateGrrdcdbufBReadA;
        end if;
				-- IP impl.grrdcdbufB.ready --- IEND

					stateGrrdcdbufB <= stateGrrdcdbufBReadA;
				end if;

			elsif stateGrrdcdbufB=stateGrrdcdbufBReadA then
				if reqGrrdcdbufToFeatdet='0' then
					-- IP impl.grrdcdbufB.readA.done --- INSERT

					stateGrrdcdbufB <= stateGrrdcdbufBReady;

				elsif strbDGrrdcdbufToFeatdet='0' then
					ackGrrdcdbufToFeatdet_sig <= '1'; -- IP impl.grrdcdbufB.readA.next --- ILINE

					stateGrrdcdbufB <= stateGrrdcdbufBReadB;
				end if;

			elsif stateGrrdcdbufB=stateGrrdcdbufBReadB then
				if strbDGrrdcdbufToFeatdet='1' then
					aGrrdcdbufB <= aGrrdcdbufB + 1; -- IP impl.grrdcdbufB.readB.inc --- ILINE

					stateGrrdcdbufB <= stateGrrdcdbufBReadA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.grrdcdbufB.rising --- END

	------------------------------------------------------------------------
	-- implementation: grrdefbuf B/featdet-facing operation (grrdefbufB)
	------------------------------------------------------------------------

	-- IP impl.grrdefbufB.wiring --- RBEGIN
	enGrrdefbufB <= '1' when (strbDGrrdefbufToFeatdet='0' and stateGrrdefbufB=stateGrrdefbufBReadA) else '0';
	ackGrrdefbufToFeatdet <= ackGrrdefbufToFeatdet_sig;

  aGrrdefbufB_vec <= std_logic_vector(to_unsigned(aGrrdefbufB, 11));

	stateGrrdefbufB_dbg <= x"00" when stateGrrdefbufB=stateGrrdefbufBInit
				else x"10" when stateGrrdefbufB=stateGrrdefbufBReady
				else x"20" when stateGrrdefbufB=stateGrrdefbufBReadA
				else x"21" when stateGrrdefbufB=stateGrrdefbufBReadB
				else (others => '1');
	-- IP impl.grrdefbufB.wiring --- REND

	-- IP impl.grrdefbufB.rising --- BEGIN
	process (reset, mclk, stateGrrdefbufB)
		-- IP impl.grrdefbufB.vars --- BEGIN
		-- IP impl.grrdefbufB.vars --- END

	begin
		if reset='1' then
			-- IP impl.grrdefbufB.asyncrst --- BEGIN
			stateGrrdefbufB <= stateGrrdefbufBInit;
			ackGrrdefbufToFeatdet_sig <= '0';
			aGrrdefbufB <= 0;
			-- IP impl.grrdefbufB.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateGrrdefbufB=stateGrrdefbufBInit or tixVGrrdbufstate/=tixVGrrdbufstateStream) then
				-- IP impl.grrdefbufB.syncrst --- BEGIN
				ackGrrdefbufToFeatdet_sig <= '0';
				aGrrdefbufB <= 0;

				-- IP impl.grrdefbufB.syncrst --- END

				if tixVGrrdbufstate/=tixVGrrdbufstateStream then
					stateGrrdefbufB <= stateGrrdefbufBInit;

				else
					stateGrrdefbufB <= stateGrrdefbufBReady;
				end if;

			elsif stateGrrdefbufB=stateGrrdefbufBReady then
				if reqGrrdefbufToFeatdet='1' then
				-- IP impl.grrdefbufB.ready --- IBEGIN
        if reqGrrdefbufToFeatdet='1' then
          aGrrdefbufB <= 0;
          stateGrrdefbufB <= stateGrrdefbufBReadA;
        end if;
				-- IP impl.grrdefbufB.ready --- IEND

					stateGrrdefbufB <= stateGrrdefbufBReadA;
				end if;

			elsif stateGrrdefbufB=stateGrrdefbufBReadA then
				if reqGrrdefbufToFeatdet='0' then
					ackGrrdefbufToFeatdet_sig <= '0'; -- IP impl.grrdefbufB.readA.done --- ILINE

					stateGrrdefbufB <= stateGrrdefbufBReady;

				elsif strbDGrrdefbufToFeatdet='0' then
					ackGrrdefbufToFeatdet_sig <= '1'; -- IP impl.grrdefbufB.readA.next --- ILINE

					stateGrrdefbufB <= stateGrrdefbufBReadB;
				end if;

			elsif stateGrrdefbufB=stateGrrdefbufBReadB then
				if strbDGrrdefbufToFeatdet='1' then
					aGrrdefbufB <= aGrrdefbufB + 1; -- IP impl.grrdefbufB.readB.inc --- ILINE

					stateGrrdefbufB <= stateGrrdefbufBReadA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.grrdefbufB.rising --- END

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	-- IP impl.op.wiring --- BEGIN
	ackInvSetGrrd <= ackInvSetGrrd_sig;
	ackInvSetPvw <= ackInvSetPvw_sig;

	stateOp_dbg <= x"00" when stateOp=stateOpInit
				else x"10" when stateOp=stateOpInvGrrd
				else x"20" when stateOp=stateOpInvPvw
				else x"30" when stateOp=stateOpInv
				else (others => '1');
	-- IP impl.op.wiring --- END

	-- IP impl.op.rising --- BEGIN
	process (reset, mclk, stateOp)
		-- IP impl.op.vars --- RBEGIN
		-- currently not in use: assume pclk = mclk / 2
		--constant imax: natural := 2; -- mclk per pclk
		--variable i: natural range 0 to imax;
		-- IP impl.op.vars --- REND

	begin
		if reset='1' then
			-- IP impl.op.asyncrst --- BEGIN
			stateOp <= stateOpInit;
			ackInvSetGrrd_sig <= '0';
			ackInvSetPvw_sig <= '0';
			grrdrun <= '0';
			grrdRedNotGray <= '0';
			pvwrun <= '0';
			pvwacc <= pvwaccBinrgb;
			-- IP impl.op.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateOp=stateOpInit or (stateOp/=stateOpInvGrrd and stateOp/=stateOpInvPvw and stateOp/=stateOpInv and (reqInvSetGrrd='1' or reqInvSetPvw='1'))) then
				-- IP impl.op.syncrst --- RBEGIN
				ackInvSetGrrd_sig <= '0';
				ackInvSetPvw_sig <= '0';
				-- IP impl.op.syncrst --- REND

				if reqInvSetGrrd='1' then
					grrdrun <= '0'; -- IP impl.op.init.invSetGrrd --- ILINE

					stateOp <= stateOpInvGrrd;

				elsif reqInvSetPvw='1' then
					pvwrun <= '0'; -- IP impl.op.init.invSetPvw --- ILINE

					stateOp <= stateOpInvPvw;

				else
					stateOp <= stateOpInit;
				end if;

			elsif stateOp=stateOpInvGrrd then
				-- IP impl.op.invGrrd --- IBEGIN
				if setGrrdRng=tru8 then
					grrdrun <= '1';
				else
					grrdrun <= '0';
				end if;
	
				if setGrrdRedNotGray=tru8 then
					grrdRedNotGray <= '1';
				else
					grrdRedNotGray <= '0';
				end if;
	
				ackInvSetGrrd_sig <= '1';
				-- IP impl.op.invGrrd --- IEND

				stateOp <= stateOpInv;

			elsif stateOp=stateOpInvPvw then
				-- IP impl.op.invPvw --- IBEGIN
				if setPvwRng=tru8 then
					pvwrun <= '1';
				else
					pvwrun <= '0';
				end if;

				if (setPvwRawNotBin=fls8 and setPvwGrayNotRgb=fls8) then
					pvwacc <= pvwaccBinrgb;
				elsif (setPvwRawNotBin=fls8 and setPvwGrayNotRgb=tru8) then
					pvwacc <= pvwaccBingray;
				elsif (setPvwRawNotBin=tru8 and setPvwGrayNotRgb=fls8) then
					pvwacc <= pvwaccRawrgb;
				else
					pvwacc <= pvwaccRawgray;
				end if;

				ackInvSetPvw_sig <= '1';
				-- IP impl.op.invPvw --- IEND

				stateOp <= stateOpInv;

			elsif stateOp=stateOpInv then
				if ((reqInvSetGrrd='0' and ackInvSetGrrd_sig='1') or (reqInvSetPvw='0' and ackInvSetPvw_sig='1')) then
					stateOp <= stateOpInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.op.rising --- END

	------------------------------------------------------------------------
	-- implementation: preview operation, also managing pvw{a/b}buf (pvw)
	------------------------------------------------------------------------

	-- IP impl.pvw.wiring --- RBEGIN
	enPvwabuf <= '1' when (pvwabufLock=lockPvw and (statePvw=statePvwStoreA or statePvw=statePvwStoreB or statePvw=statePvwStoreC or statePvw=statePvwStoreD)) else '0';
	enPvwbbuf <= '1' when (pvwbbufLock=lockPvw and (statePvw=statePvwStoreA or statePvw=statePvwStoreB or statePvw=statePvwStoreC or statePvw=statePvwStoreD)) else '0';

	aPvwbuf_vec <= std_logic_vector(to_unsigned(aPvwbuf, 16));

	pvwbingrayrun <= '1' when (pvwacc=pvwaccBingray and (statePvw=statePvwReady or statePvw=statePvwStoreA or statePvw=statePvwStoreB or statePvw=statePvwStoreC or statePvw=statePvwStoreD)) else '0';
	pvwbinrgbrun <= '1' when (pvwacc=pvwaccBinrgb and (statePvw=statePvwReady or statePvw=statePvwStoreA or statePvw=statePvwStoreB or statePvw=statePvwStoreC or statePvw=statePvwStoreD)) else '0';
	pvwrawgrayrun <= '1' when (pvwacc=pvwaccRawgray and (statePvw=statePvwReady or statePvw=statePvwStoreA or statePvw=statePvwStoreB or statePvw=statePvwStoreC or statePvw=statePvwStoreD)) else '0';
	pvwrawrgbrun <= '1' when (pvwacc=pvwaccRawrgb and (statePvw=statePvwReady or statePvw=statePvwStoreA or statePvw=statePvwStoreB or statePvw=statePvwStoreC or statePvw=statePvwStoreD)) else '0';

	statePvw_dbg <= x"00" when statePvw=statePvwInit
				else x"10" when statePvw=statePvwTrylockA
				else x"11" when statePvw=statePvwTrylockB
				else x"20" when statePvw=statePvwWaitFrame
				else x"30" when statePvw=statePvwReady
				else x"40" when statePvw=statePvwStoreA
				else x"41" when statePvw=statePvwStoreB
				else x"42" when statePvw=statePvwStoreC
				else x"43" when statePvw=statePvwStoreD
				else x"50" when statePvw=statePvwDoneA
				else x"51" when statePvw=statePvwDoneB
				else (others => '1');
	-- IP impl.pvw.wiring --- REND

	-- IP impl.pvw.rising --- BEGIN
	process (reset, mclk, statePvw)
		-- IP impl.pvw.vars --- RBEGIN
		variable aPvwbufGr: natural range 0 to 49151;

		variable aPvwbufRd: natural range 0 to 19199;
		variable aPvwbufGn: natural range 19200 to 38399;
		variable aPvwbufBl: natural range 38400 to 57599;
		-- IP impl.pvw.vars --- REND

	begin
		if reset='1' then
			-- IP impl.pvw.asyncrst --- RBEGIN
			statePvw <= statePvwInit;
			pvwLatestBNotA <= '0';
			aPvwbuf <= 0;
			dwrPvwbuf <= (others => '0');

			pvwTkstA <= (others => '0');
			pvwTkstB <= (others => '0');

			reqPvwToPvwbufAbufLock <= '0';
			reqPvwToPvwbufAbufSetFull <= '0';
			reqPvwToPvwbufBbufLock <= '0';
			reqPvwToPvwbufBbufSetFull <= '0';
			
			aPvwbufGr := 0;

			aPvwbufRd := 0;
			aPvwbufGn := 19200;
			aPvwbufBl := 38400;
			-- IP impl.pvw.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (statePvw=statePvwInit or pvwrun='0') then
				-- IP impl.pvw.syncrst --- RBEGIN
				pvwLatestBNotA <= '0';
				aPvwbuf <= 0;
				dwrPvwbuf <= (others => '0');

				pvwTkstA <= (others => '0');
				pvwTkstB <= (others => '0');

				reqPvwToPvwbufAbufSetFull <= '0';
				reqPvwToPvwbufBbufLock <= '0';
				reqPvwToPvwbufBbufSetFull <= '0';
				-- IP impl.pvw.syncrst --- REND

				if pvwrun='0' then
					reqPvwToPvwbufAbufLock <= '0'; -- IP impl.pvw.init.reset --- ILINE

					statePvw <= statePvwInit;

				else
					reqPvwToPvwbufAbufLock <= '1'; -- IP impl.pvw.init.toLock --- ILINE

					statePvw <= statePvwTrylockA;
				end if;

			elsif statePvw=statePvwTrylockA then
				if ackPvwToPvwbufAbufLock='1' then
					reqPvwToPvwbufAbufLock <= '0'; -- IP impl.pvw.trylockA.ack --- ILINE

					statePvw <= statePvwWaitFrame;

				elsif dnyPvwToPvwbufAbufLock='1' then
					-- IP impl.pvw.trylockA.dny --- IBEGIN
					reqPvwToPvwbufAbufLock <= '0';
					reqPvwToPvwbufBbufLock <= '1';
					-- IP impl.pvw.trylockA.dny --- IEND

					statePvw <= statePvwTrylockB;
				end if;

			elsif statePvw=statePvwTrylockB then
				if ackPvwToPvwbufBbufLock='1' then
					reqPvwToPvwbufBbufLock <= '0'; -- IP impl.pvw.trylockB.ack --- ILINE

					statePvw <= statePvwWaitFrame;

				elsif dnyPvwToPvwbufBbufLock='1' then
					-- IP impl.pvw.trylockB.dny --- IBEGIN
					reqPvwToPvwbufBbufLock <= '0';
					reqPvwToPvwbufAbufLock <= '1';
					-- IP impl.pvw.trylockB.dny --- IEND

					statePvw <= statePvwTrylockA;
				end if;

			elsif statePvw=statePvwWaitFrame then
				if strbFrame='1' then
					-- IP impl.pvw.waitFrame --- IBEGIN
					if pvwabufLock=lockPvw then
						pvwTkstA <= tkclksrcGetTkstTkst;
					elsif pvwbbufLock=lockPvw then
						pvwTkstB <= tkclksrcGetTkstTkst;
					end if;

					aPvwbufGr := 0;
		
					aPvwbufRd := 0;
					aPvwbufGn := 19200;
					aPvwbufBl := 38400;
					-- IP impl.pvw.waitFrame --- IEND

					statePvw <= statePvwReady;
				end if;

			elsif statePvw=statePvwReady then
				if strbDPvwbingrayGr='1' then
					-- IP impl.pvw.ready.bingrayGr --- IBEGIN
					aPvwbuf <= aPvwbufGr;
					dwrPvwbuf <= dPvwbingrayGr;
					-- IP impl.pvw.ready.bingrayGr --- IEND

					statePvw <= statePvwStoreA;

				elsif strbDPvwrawgrayGr='1' then
					-- IP impl.pvw.ready.rawgrayGr --- IBEGIN
					aPvwbuf <= aPvwbufGr;
					dwrPvwbuf <= dPvwrawgrayGr;
					-- IP impl.pvw.ready.rawgrayGr --- IEND

					statePvw <= statePvwStoreA;

				elsif strbDPvwbinrgbRd='1' then
					-- IP impl.pvw.ready.binrgbRd --- IBEGIN
					aPvwbuf <= aPvwbufRd;
					dwrPvwbuf <= dPvwbinrgbRd;
					-- IP impl.pvw.ready.binrgbRd --- IEND

					statePvw <= statePvwStoreB;

				elsif strbDPvwrawrgbRd='1' then
					-- IP impl.pvw.ready.rawrgbRd --- IBEGIN
					aPvwbuf <= aPvwbufRd;
					dwrPvwbuf <= dPvwrawrgbRd;
					-- IP impl.pvw.ready.rawrgbRd --- IEND

					statePvw <= statePvwStoreB;

				elsif strbDPvwbinrgbGnBl='1' then
					-- IP impl.pvw.ready.binrgbGnBl --- IBEGIN
					aPvwbuf <= aPvwbufGn;
					dwrPvwbuf <= dPvwbinrgbGn;
					-- IP impl.pvw.ready.binrgbGnBl --- IEND

					statePvw <= statePvwStoreC;

				elsif strbDPvwrawrgbGnBl='1' then
					-- IP impl.pvw.ready.rawrgbGnBl --- IBEGIN
					aPvwbuf <= aPvwbufGn;
					dwrPvwbuf <= dPvwrawrgbGn;
					-- IP impl.pvw.ready.rawrgbGnBl --- IEND

					statePvw <= statePvwStoreC;
				end if;

			elsif statePvw=statePvwStoreA then
				if aPvwbufGr=49151 then
					statePvw <= statePvwDoneA;

				else
					aPvwbufGr := aPvwbufGr + 1; -- IP impl.pvw.storeA.inc --- ILINE

					statePvw <= statePvwReady;
				end if;

			elsif statePvw=statePvwStoreB then
				aPvwbufRd := aPvwbufRd + 1; -- IP impl.pvw.storeB.inc --- ILINE

				statePvw <= statePvwReady;

			elsif statePvw=statePvwStoreC then
				-- IP impl.pvw.storeC --- IBEGIN
				aPvwbufGn := aPvwbufGn + 1;

				aPvwbuf <= aPvwbufBl;

				if pvwacc=pvwaccBinrgb then
					dwrPvwbuf <= dPvwbinrgbBl;
				else
					dwrPvwbuf <= dPvwrawrgbBl;
				end if;
				-- IP impl.pvw.storeC --- IEND

				statePvw <= statePvwStoreD;

			elsif statePvw=statePvwStoreD then
				if aPvwbufBl=57599 then
					statePvw <= statePvwDoneA;

				else
					aPvwbufBl := aPvwbufBl + 1; -- IP impl.pvw.storeD.inc --- ILINE

					statePvw <= statePvwReady;
				end if;

			elsif statePvw=statePvwDoneA then
				-- IP impl.pvw.doneA --- IBEGIN
				if pvwabufLock=lockPvw then
					pvwlatestBNotA <= '0';
					reqPvwToPvwbufAbufSetFull <= '1';
				elsif pvwbbufLock=lockPvw then
					pvwlatestBNotA <= '1';
					reqPvwToPvwbufBbufSetFull <= '1';
				end if;
				-- IP impl.pvw.doneA --- IEND

				statePvw <= statePvwDoneB;

			elsif statePvw=statePvwDoneB then
				if (ackPvwToPvwbufAbufSetFull='1' or ackPvwToPvwbufBbufSetFull='1') then
					-- IP impl.pvw.doneB --- IBEGIN
					reqPvwToPvwbufAbufSetFull <= '0';
					reqPvwToPvwbufBbufSetFull <= '0';
					-- IP impl.pvw.doneB --- IEND

					if pvwLatestBNotA='0' then
						reqPvwToPvwbufBbufLock <= '1'; -- IP impl.pvw.doneB.bbuf --- ILINE					

						statePvw <= statePvwTrylockB;

					else
						reqPvwToPvwbufAbufLock <= '1'; -- IP impl.pvw.doneB.abuf --- ILINE			

						statePvw <= statePvwTrylockA;
					end if;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.pvw.rising --- END

	------------------------------------------------------------------------
	-- implementation: preview 4x4 pixel binning gray, also managing bingraybuf (pvwbingray)
	------------------------------------------------------------------------

	-- IP impl.pvwbingray.wiring --- RBEGIN
	-- works on the premise that pclk is 25MHz for mclk 50MHz

	-- even: GRGRGR..., odd: BGBGBG... (h mirror on / 0x3821=0x06 and vflipped, as determined experimentally)

	enBingraybuf <= '1' when (statePvwbingray=statePvwbingrayLASB or statePvwbingray=statePvwbingrayLASC) else '0';

	aBingraybuf_vec <= std_logic_vector(to_unsigned(aBingraybuf, 11));

	statePvwbingray_dbg <= x"00" when statePvwbingray=statePvwbingrayInit
				else x"10" when statePvwbingray=statePvwbingrayWaitFrame
				else x"20" when statePvwbingray=statePvwbingrayWaitRow
				else x"30" when statePvwbingray=statePvwbingrayLASA
				else x"31" when statePvwbingray=statePvwbingrayLASB
				else x"32" when statePvwbingray=statePvwbingrayLASC
				else x"33" when statePvwbingray=statePvwbingrayLASD
				else (others => '1');
	-- IP impl.pvwbingray.wiring --- REND

	-- IP impl.pvwbingray.rising --- BEGIN
	process (reset, mclk, statePvwbingray)
		-- IP impl.pvwbingray.vars --- RBEGIN
		variable grA: std_logic_vector(13 downto 0);
		variable grB: std_logic_vector(13 downto 0);

		variable ab: natural range 0 to 1; -- accumulator used for adding - 0: a, 1: b

		constant rowmax_lcl: natural := 1536;
		variable row_lcl: std_logic_vector(10 downto 0);

		variable pre1, pre2: std_logic;
		variable post1, post2: std_logic;

		variable col2L: natural range 0 to 512;
		variable col2A: natural range 0 to 512;
		variable col2S: natural range 0 to 512;

		variable pixcnt: std_logic_vector(1 downto 0);
		-- IP impl.pvwbingray.vars --- REND

	begin
		if reset='1' then
			-- IP impl.pvwbingray.asyncrst --- RBEGIN
			statePvwbingray <= statePvwbingrayInit;

			dPvwbingrayGr <= (others => '0');
			strbDPvwbingrayGr <= '0';
			weBingraybuf <= '0';
			aBingraybuf <= 0;
			dwrBingraybuf <= (others => '0');

			grA := (others => '0');
			grB := (others => '0');
			ab := 0;
			row_lcl := (others => '0');
			pre1 := '0';
			pre2 := '0';
			post1 := '0';
			post2 := '0';
			col2L := 0;
			col2A := 0;
			col2S := 0;
			pixcnt := (others => '0');
			-- IP impl.pvwbingray.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (statePvwbingray=statePvwbingrayInit or pvwbingrayrun='0') then
				-- IP impl.pvwbingray.syncrst --- BEGIN
				dPvwbingrayGr <= (others => '0');
				strbDPvwbingrayGr <= '0';
				weBingraybuf <= '0';
				aBingraybuf <= 0;
				dwrBingraybuf <= (others => '0');

				-- IP impl.pvwbingray.syncrst --- END

				if pvwbingrayrun='0' then
					statePvwbingray <= statePvwbingrayInit;

				else
					statePvwbingray <= statePvwbingrayWaitFrame;
				end if;

			elsif statePvwbingray=statePvwbingrayWaitFrame then
				if strbRow768='1' then
					row_lcl := (others => '0'); -- IP impl.pvwbingray.waitFrame.reset --- ILINE

					statePvwbingray <= statePvwbingrayWaitRow;
				end if;

			elsif statePvwbingray=statePvwbingrayWaitRow then
				if strbCol1024N9='1' then
					-- IP impl.pvwbingray.waitRow.reset --- IBEGIN
					ab := 0;

					pre1 := '1';
					pre2 := '0';
					post1 := '0';
					post2 := '0';

					col2L := 0;
					col2A := 0;
					col2S := 0;

					pixcnt := (others => '0');
					-- IP impl.pvwbingray.waitRow.reset --- IEND

					statePvwbingray <= statePvwbingrayLASA;
				end if;

			elsif statePvwbingray=statePvwbingrayLASA then
				-- IP impl.pvwbingray.LASA --- IBEGIN
				if (pre1='0' and pre2='0') then
					-- store
					if pixcnt="00" then
						weBingraybuf <= '1';

						aBingraybuf <= col2S;

						if ab=0 then
							dwrBingraybuf <= "00" & grB(13 downto 8);
						else
							dwrBingraybuf <= "00" & grA(13 downto 8);
						end if;

						col2S := col2S + 1;

					elsif pixcnt="01" then
						weBingraybuf <= '1';

						aBingraybuf <= col2S;

						if ab=0 then
							dwrBingraybuf <= grB(7 downto 0);
						else
							dwrBingraybuf <= grA(7 downto 0);
						end if;

						col2S := col2S + 1;
					end if;
				end if;

				if (post1='0' and post2='0') then
					-- load (part I)
					if pixcnt="10" then
						weBingraybuf <= '0';

						aBingraybuf <= col2L;

					elsif pixcnt="11" then
						weBingraybuf <= '0';

						aBingraybuf <= col2L;
					end if;
				end if;

				if (pre1='0' and post2='0') then
					-- add
					if (row_lcl(2 downto 0)="000" and pixcnt="00") then
						if ab=0 then
							grA := "000000" & d;
						else
							grB := "000000" & d;
						end if;
					else
						if ab=0 then
							grA := std_logic_vector(unsigned(grA) + unsigned("000000" & d));
						else
							grB := std_logic_vector(unsigned(grB) + unsigned("000000" & d));
						end if;
					end if;

					col2A := col2A + 1;
				end if;
				-- IP impl.pvwbingray.LASA --- IEND

				statePvwbingray <= statePvwbingrayLASB;

			elsif statePvwbingray=statePvwbingrayLASB then
				statePvwbingray <= statePvwbingrayLASC;

			elsif statePvwbingray=statePvwbingrayLASC then
				-- IP impl.pvwbingray.LASC --- IBEGIN
				if (post1='0' and post2='0') then
					-- load (part II)
					if pixcnt="10" then
						if ab=0 then
							grB(13 downto 8) := drdBingraybuf(5 downto 0);
						else
							grA(13 downto 8) := drdBingraybuf(5 downto 0);
						end if;

						col2L := col2L + 1;

					elsif pixcnt="11" then
						if ab=0 then
							grB(7 downto 0) := drdBingraybuf;
						else
							grA(7 downto 0) := drdBingraybuf;
						end if;

						col2L := col2L + 1;
					end if;
				end if;

				if (pre1='0' and post2='0') then
					-- add and store in pvwbuf
					if ab=0 then
						grA := std_logic_vector(unsigned(grA) + unsigned("000000" & d));
					else
						grB := std_logic_vector(unsigned(grB) + unsigned("000000" & d));
					end if;

					col2A := col2A + 1;

					if pixcnt="11" then
						if row_lcl(2 downto 0)="111" then
							-- store gray/64
							if ab=0 then
								dPvwbingrayGr <= grA(13 downto 6);
							else
								dPvwbingrayGr <= grB(13 downto 6);
							end if;

							strbDPvwbingrayGr <= '1';
						end if;
					end if;
				end if;

				if pixcnt="11" then
					pixcnt := "00";

					if ab=1 then
						ab := 0;
					else
						ab := ab + 1;
					end if;

				else
					pixcnt := std_logic_vector(unsigned(pixcnt) + 1);
				end if;
				-- IP impl.pvwbingray.LASC --- IEND

				statePvwbingray <= statePvwbingrayLASD;

			elsif statePvwbingray=statePvwbingrayLASD then
				strbDPvwbingrayGr <= '0'; -- IP impl.pvwbingray.LASD.ext --- ILINE

				if pixcnt="00" then
					if pre1='1' then
						-- IP impl.pvwbingray.LASD.pre1 --- IBEGIN
						pre1 := '0';
						pre2 := '1';
						-- IP impl.pvwbingray.LASD.pre1 --- IEND

						statePvwbingray <= statePvwbingrayLASA;

					elsif pre2='1' then
						pre2 := '0'; -- IP impl.pvwbingray.LASD.pre2 --- ILINE

						statePvwbingray <= statePvwbingrayLASA;

					elsif (col2L=512 and post1='0' and post2='0') then
						post1 := '1'; -- IP impl.pvwbingray.LASD.post --- ILINE

						statePvwbingray <= statePvwbingrayLASA;

					elsif post1='1' then
						-- IP impl.pvwbingray.LASD.post1 --- IBEGIN
						post1 := '0';
						post2 := '1';
						-- IP impl.pvwbingray.LASD.post1 --- IEND

						statePvwbingray <= statePvwbingrayLASA;

					elsif post2='1' then
						row_lcl := std_logic_vector(unsigned(row_lcl) + 1); -- IP impl.pvwbingray.LASD.post2 --- ILINE

						if row_lcl=std_logic_vector(to_unsigned(rowmax_lcl, 11)) then
							statePvwbingray <= statePvwbingrayWaitFrame;

						else
							statePvwbingray <= statePvwbingrayWaitRow;
						end if;

					else
						statePvwbingray <= statePvwbingrayLASA;
					end if;

				else
					statePvwbingray <= statePvwbingrayLASA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.pvwbingray.rising --- END

	------------------------------------------------------------------------
	-- implementation: preview 8x8 pixel binning RGB, also managing binrgbbuf (pvwbinrgb)
	------------------------------------------------------------------------

	-- IP impl.pvwbinrgb.wiring --- RBEGIN
	-- works on the premise that pclk is 25MHz for mclk 50MHz
	
	-- even: GRGRGR..., odd: BGBGBG... (h mirror on / 0x3821=0x06 and vflipped, as determined experimentally)

	enBinrgbbuf <= '1' when (statePvwbinrgb=statePvwbinrgbLASB or statePvwbinrgb=statePvwbinrgbLASC) else '0';

	aBinrgbbuf_vec <= std_logic_vector(to_unsigned(aBinrgbbuf, 11));

	statePvwbinrgb_dbg <= x"00" when statePvwbinrgb=statePvwbinrgbInit
				else x"10" when statePvwbinrgb=statePvwbinrgbWaitFrame
				else x"20" when statePvwbinrgb=statePvwbinrgbWaitRow
				else x"30" when statePvwbinrgb=statePvwbinrgbLASA
				else x"31" when statePvwbinrgb=statePvwbinrgbLASB
				else x"32" when statePvwbinrgb=statePvwbinrgbLASC
				else x"33" when statePvwbinrgb=statePvwbinrgbLASD
				else (others => '1');
	-- IP impl.pvwbinrgb.wiring --- REND

	-- IP impl.pvwbinrgb.rising --- BEGIN
	process (reset, mclk, statePvwbinrgb)
		-- IP impl.pvwbinrgb.vars --- RBEGIN
		constant a0BinrgbbufRed: natural := 0;
		constant a0BinrgbbufGreen: natural := 320;
		constant a0BinrgbbufBlue: natural := 640;

		variable gnA: std_logic_vector(15 downto 0);
		variable gnB: std_logic_vector(15 downto 0);
		variable gnC: std_logic_vector(15 downto 0);

		variable rdblA: std_logic_vector(15 downto 0);
		variable rdblB: std_logic_vector(15 downto 0);
		variable rdblC: std_logic_vector(15 downto 0);

		variable abc: natural range 0 to 2; -- accumulator used for adding - 0: a, 1: b, 2: c

		constant rowmax_lcl: natural := 1920;
		variable row_lcl: std_logic_vector(10 downto 0);

		variable pre1, pre2: std_logic;
		variable post1, post2: std_logic;

		variable col2L: natural range 0 to 320;
		variable col2A: natural range 0 to 320;
		variable col2S: natural range 0 to 320;

		variable pixcnt: std_logic_vector(2 downto 0);
		-- IP impl.pvwbinrgb.vars --- REND

	begin
		if reset='1' then
			-- IP impl.pvwbinrgb.asyncrst --- RBEGIN
			statePvwbinrgb <= statePvwbinrgbInit;

			dPvwbinrgbRd <= (others => '0');
			dPvwbinrgbGn <= (others => '0');
			strbDPvwbinrgbGnBl <= '0';
			dPvwbinrgbBl <= (others => '0');
			strbDPvwbinrgbRd <= '0';
			weBinrgbbuf <= '0';
			aBinrgbbuf <= 0;
			dwrBinrgbbuf <= (others => '0');
		
			gnA := (others => '0');
			gnB := (others => '0');
			gnC := (others => '0');
			rdblA := (others => '0');
			rdblB := (others => '0');
			rdblC := (others => '0');
			abc := 0;
			row_lcl := (others => '0');
			pre1 := '0';
			pre2 := '0';
			post1 := '0';
			post2 := '0';
			col2L := 0;
			col2A := 0;
			col2S := 0;
			pixcnt := (others => '0');
			-- IP impl.pvwbinrgb.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (statePvwbinrgb=statePvwbinrgbInit or pvwbinrgbrun='0') then
				if pvwbinrgbrun='0' then
					-- IP impl.pvwbinrgb.syncrst --- BEGIN
					dPvwbinrgbRd <= (others => '0');
					strbDPvwbinrgbRd <= '0';
					dPvwbinrgbGn <= (others => '0');
					dPvwbinrgbBl <= (others => '0');
					strbDPvwbinrgbGnBl <= '0';
					weBinrgbbuf <= '0';
					aBinrgbbuf <= 0;
					dwrBinrgbbuf <= (others => '0');

					-- IP impl.pvwbinrgb.syncrst --- END

					statePvwbinrgb <= statePvwbinrgbInit;

				else
					statePvwbinrgb <= statePvwbinrgbWaitFrame;
				end if;

			elsif statePvwbinrgb=statePvwbinrgbWaitFrame then
				if strbRow960='1' then
					row_lcl := (others => '0'); -- IP impl.pvwbinrgb.waitFrame.reset --- ILINE

					statePvwbinrgb <= statePvwbinrgbWaitRow;
				end if;

			elsif statePvwbinrgb=statePvwbinrgbWaitRow then
				if strbCol1280N9='1' then
					-- IP impl.pvwbinrgb.waitRow.reset --- IBEGIN
					abc := 0;

					pre1 := '1';
					pre2 := '0';
					post1 := '0';
					post2 := '0';

					col2L := 0;
					col2A := 0;
					col2S := 0;

					pixcnt := (others => '0');
					-- IP impl.pvwbinrgb.waitRow.reset --- IEND

					statePvwbinrgb <= statePvwbinrgbLASA;
				end if;

			elsif statePvwbinrgb=statePvwbinrgbLASA then
				-- IP impl.pvwbinrgb.LASA --- IBEGIN
				if (post1='0' and post2='0') then
					-- load
					if pixcnt="000" then
						weBinrgbbuf <= '0';
	
						if row_lcl(0)='0' then
							aBinrgbbuf <= a0BinrgbbufGreen + col2L;
						else
							aBinrgbbuf <= a0BinrgbbufBlue + col2L;
						end if;
	
					elsif pixcnt="001" then
						if row_lcl(0)='0' then
							if abc=0 then
								gnB(15 downto 8) := drdBinrgbbuf;
							elsif abc=1 then
								gnC(15 downto 8) := drdBinrgbbuf;
							else
								gnA(15 downto 8) := drdBinrgbbuf;
							end if;
						else
							if abc=0 then
								rdblB(15 downto 8) := drdBinrgbbuf;
							elsif abc=1 then
								rdblC(15 downto 8) := drdBinrgbbuf;
							else
								rdblA(15 downto 8) := drdBinrgbbuf;
							end if;
						end if;
	
						weBinrgbbuf <= '0';
	
						if row_lcl(0)='0' then
							aBinrgbbuf <= a0BinrgbbufRed + col2L;
						else
							aBinrgbbuf <= a0BinrgbbufGreen + col2L;
						end if;
	
					elsif pixcnt="010" then
						if row_lcl(0)='0' then
							if abc=0 then
								rdblB(15 downto 8) := drdBinrgbbuf;
							elsif abc=1 then
								rdblC(15 downto 8) := drdBinrgbbuf;
							else
								rdblA(15 downto 8) := drdBinrgbbuf;
							end if;
						else
							if abc=0 then
								gnB(15 downto 8) := drdBinrgbbuf;
							elsif abc=1 then
								gnC(15 downto 8) := drdBinrgbbuf;
							else
								gnA(15 downto 8) := drdBinrgbbuf;
							end if;
						end if;
						
						weBinrgbbuf <= '0';
	
						col2L := col2L + 1;
						
						if row_lcl(0)='0' then
							aBinrgbbuf <= a0BinrgbbufGreen + col2L;
						else
							aBinrgbbuf <= a0BinrgbbufBlue + col2L;
						end if;
	
					elsif pixcnt="011" then
						if row_lcl(0)='0' then
							if abc=0 then
								gnB(7 downto 0) := drdBinrgbbuf;
							elsif abc=1 then
								gnC(7 downto 0) := drdBinrgbbuf;
							else
								gnA(7 downto 0) := drdBinrgbbuf;
							end if;
						else
							if abc=0 then
								rdblB(7 downto 0) := drdBinrgbbuf;
							elsif abc=1 then
								rdblC(7 downto 0) := drdBinrgbbuf;
							else
								rdblA(7 downto 0) := drdBinrgbbuf;
							end if;
						end if;
		
						weBinrgbbuf <= '0';
	
						if row_lcl(0)='0' then
							aBinrgbbuf <= a0BinrgbbufRed + col2L;
						else
							aBinrgbbuf <= a0BinrgbbufGreen + col2L;
						end if;
		
					elsif pixcnt="100" then
						if row_lcl(0)='0' then
							if abc=0 then
								rdblB(7 downto 0) := drdBinrgbbuf;
							elsif abc=1 then
								rdblC(7 downto 0) := drdBinrgbbuf;
							else
								rdblA(7 downto 0) := drdBinrgbbuf;
							end if;
						else
							if abc=0 then
								gnB(7 downto 0) := drdBinrgbbuf;
							elsif abc=1 then
								gnC(7 downto 0) := drdBinrgbbuf;
							else
								gnA(7 downto 0) := drdBinrgbbuf;
							end if;
						end if;
						
						col2L := col2L + 1;
					end if;
				end if;
	
				if (pre1='0' and pre2='0') then
					-- store
					if pixcnt="100" then
						weBinrgbbuf <= '1';
	
						if row_lcl(0)='0' then
							aBinrgbbuf <= a0BinrgbbufGreen + col2S;
						else
							aBinrgbbuf <= a0BinrgbbufBlue + col2S;
						end if;
		
						if row_lcl(0)='0' then
							if abc=0 then
								dwrBinrgbbuf <= gnC(15 downto 8);
							elsif abc=1 then
								dwrBinrgbbuf <= gnA(15 downto 8);
							else
								dwrBinrgbbuf <= gnB(15 downto 8);
							end if;
						else
							if abc=0 then
								dwrBinrgbbuf <= rdblC(15 downto 8);
							elsif abc=1 then
								dwrBinrgbbuf <= rdblA(15 downto 8);
							else
								dwrBinrgbbuf <= rdblB(15 downto 8);
							end if;
						end if;
	
					elsif pixcnt="101" then
						weBinrgbbuf <= '1';
	
						if row_lcl(0)='0' then
							aBinrgbbuf <= a0BinrgbbufRed + col2S;
						else
							aBinrgbbuf <= a0BinrgbbufGreen + col2S;
						end if;
		
						if row_lcl(0)='0' then
							if abc=0 then
								dwrBinrgbbuf <= rdblC(15 downto 8);
							elsif abc=1 then
								dwrBinrgbbuf <= rdblA(15 downto 8);
							else
								dwrBinrgbbuf <= rdblB(15 downto 8);
							end if;
						else
							if abc=0 then
								dwrBinrgbbuf <= gnC(15 downto 8);
							elsif abc=1 then
								dwrBinrgbbuf <= gnA(15 downto 8);
							else
								dwrBinrgbbuf <= gnB(15 downto 8);
							end if;
						end if;
		
						col2S := col2S + 1;
	
					elsif pixcnt="110" then
						weBinrgbbuf <= '1';
	
						if row_lcl(0)='0' then
							aBinrgbbuf <= a0BinrgbbufGreen + col2S;
						else
							aBinrgbbuf <= a0BinrgbbufBlue + col2S;
						end if;
		
						if row_lcl(0)='0' then
							if abc=0 then
								dwrBinrgbbuf <= gnC(7 downto 0);
							elsif abc=1 then
								dwrBinrgbbuf <= gnA(7 downto 0);
							else
								dwrBinrgbbuf <= gnB(7 downto 0);
							end if;
						else
							if abc=0 then
								dwrBinrgbbuf <= rdblC(7 downto 0);
							elsif abc=1 then
								dwrBinrgbbuf <= rdblA(7 downto 0);
							else
								dwrBinrgbbuf <= rdblB(7 downto 0);
							end if;
						end if;
	
					elsif pixcnt="111" then
						weBinrgbbuf <= '1';
	
						if row_lcl(0)='0' then
							aBinrgbbuf <= a0BinrgbbufRed + col2S;
						else
							aBinrgbbuf <= a0BinrgbbufGreen + col2S;
						end if;
		
						if row_lcl(0)='0' then
							if abc=0 then
								dwrBinrgbbuf <= rdblC(7 downto 0);
							elsif abc=1 then
								dwrBinrgbbuf <= rdblA(7 downto 0);
							else
								dwrBinrgbbuf <= rdblB(7 downto 0);
							end if;
						else
							if abc=0 then
								dwrBinrgbbuf <= gnC(7 downto 0);
							elsif abc=1 then
								dwrBinrgbbuf <= gnA(7 downto 0);
							else
								dwrBinrgbbuf <= gnB(7 downto 0);
							end if;
						end if;
		
						col2S := col2S + 1;
					end if;
				end if;

				if (pre1='0' and post2='0') then
					-- add
					if (row_lcl(3 downto 0)="0000" and pixcnt="000") then
						if abc=0 then
							gnA := x"00" & d; -- green
						elsif abc=1 then
							gnB := x"00" & d;
						else
							gnC := x"00" & d;
						end if;
					elsif (row_lcl(3 downto 0)="0001" and pixcnt="000") then
						if abc=0 then
							rdblA := x"00" & d; -- blue
						elsif abc=1 then
							rdblB := x"00" & d;
						else
							rdblC := x"00" & d;
						end if;
					elsif row_lcl(0)='0' then
						if abc=0 then
							gnA := std_logic_vector(unsigned(gnA) + unsigned(x"00" & d)); -- green
						elsif abc=1 then
							gnB := std_logic_vector(unsigned(gnB) + unsigned(x"00" & d));
						else
							gnC := std_logic_vector(unsigned(gnC) + unsigned(x"00" & d));
						end if;
					else
						if abc=0 then
							rdblA := std_logic_vector(unsigned(rdblA) + unsigned(x"00" & d)); -- blue
						elsif abc=1 then
							rdblB := std_logic_vector(unsigned(rdblB) + unsigned(x"00" & d));
						else
							rdblC := std_logic_vector(unsigned(rdblC) + unsigned(x"00" & d));
						end if;
					end if;
	
					col2A := col2A + 1;
				end if;
				-- IP impl.pvwbinrgb.LASA --- IEND

				statePvwbinrgb <= statePvwbinrgbLASB;

			elsif statePvwbinrgb=statePvwbinrgbLASB then
				statePvwbinrgb <= statePvwbinrgbLASC;

			elsif statePvwbinrgb=statePvwbinrgbLASC then
				-- IP impl.pvwbinrgb.LASC --- IBEGIN
				if (pre1='0' and post2='0') then
					-- add and store in pvwbuf

					-- add
					if (row_lcl(3 downto 0)="0000" and pixcnt="000") then
						if abc=0 then
							rdblA := x"00" & d; -- red
						elsif abc=1 then
							rdblB := x"00" & d;
						else
							rdblC := x"00" & d;
						end if;
					elsif row_lcl(0)='0' then
						if abc=0 then
							rdblA := std_logic_vector(unsigned(rdblA) + unsigned(x"00" & d)); -- red
						elsif abc=1 then
							rdblB := std_logic_vector(unsigned(rdblB) + unsigned(x"00" & d));
						else
							rdblC := std_logic_vector(unsigned(rdblC) + unsigned(x"00" & d));
						end if;
					else
						if abc=0 then
							gnA := std_logic_vector(unsigned(gnA) + unsigned(x"00" & d)); -- green
						elsif abc=1 then
							gnB := std_logic_vector(unsigned(gnB) + unsigned(x"00" & d));
						else
							gnC := std_logic_vector(unsigned(gnC) + unsigned(x"00" & d));
						end if;
					end if;
	
					col2A := col2A + 1;
	
					if pixcnt="111" then
						if row_lcl(3 downto 0)="1110" then
							-- store red/64
							if abc=0 then
								dPvwbinrgbRd <= rdblA(13 downto 6);
							elsif abc=1 then
								dPvwbinrgbRd <= rdblB(13 downto 6);
							else
								dPvwbinrgbRd <= rdblC(13 downto 6);
							end if;

							strbDPvwbinrgbRd <= '1';
	
						elsif row_lcl(3 downto 0)="1111" then
							-- store blue/64
							if abc=0 then
								dPvwbinrgbBl <= rdblA(13 downto 6);
							elsif abc=1 then
								dPvwbinrgbBl <= rdblB(13 downto 6);
							else	
								dPvwbinrgbBl <= rdblC(13 downto 6);
							end if;
	
							-- store green/128
							if abc=0 then
								dPvwbinrgbGn <= gnA(14 downto 7);
							elsif abc=1 then
								dPvwbinrgbGn <= gnB(14 downto 7);
							else
								dPvwbinrgbGn <= gnC(14 downto 7);
							end if;

							strbDPvwbinrgbGnBl <= '1';
						end if;
					end if;
				end if;

				if pixcnt="111" then
					pixcnt := "000";

					if abc=2 then
						abc := 0;
					else
						abc := abc + 1;
					end if;

				else
					pixcnt := std_logic_vector(unsigned(pixcnt) + 1);
				end if;
				-- IP impl.pvwbinrgb.LASC --- IEND

				statePvwbinrgb <= statePvwbinrgbLASD;

			elsif statePvwbinrgb=statePvwbinrgbLASD then
				-- IP impl.pvwbinrgb.LASD.ext --- IBEGIN
				strbDPvwbinrgbGnBl <= '0';
				strbDPvwbinrgbRd <= '0';
				-- IP impl.pvwbinrgb.LASD.ext --- IEND

				if pixcnt="000" then
					if pre1='1' then
						-- IP impl.pvwbinrgb.LASD.pre1 --- IBEGIN
						pre1 := '0';
						pre2 := '1';
						-- IP impl.pvwbinrgb.LASD.pre1 --- IEND

						statePvwbinrgb <= statePvwbinrgbLASA;

					elsif pre2='1' then
						pre2 := '0'; -- IP impl.pvwbinrgb.LASD.pre2 --- ILINE

						statePvwbinrgb <= statePvwbinrgbLASA;

					elsif (col2L=320 and post1='0' and post2='0') then
						post1 := '1'; -- IP impl.pvwbinrgb.LASD.post --- ILINE

						statePvwbinrgb <= statePvwbinrgbLASA;

					elsif post1='1' then
						-- IP impl.pvwbinrgb.LASD.post1 --- IBEGIN
						post1 := '0';
						post2 := '1';
						-- IP impl.pvwbinrgb.LASD.post1 --- IEND

						statePvwbinrgb <= statePvwbinrgbLASA;

					elsif post2='1' then
						row_lcl := std_logic_vector(unsigned(row_lcl) + 1); -- IP impl.pvwbinrgb.LASD.post2 --- ILINE

						if row_lcl=std_logic_vector(to_unsigned(rowmax_lcl, 11)) then
							statePvwbinrgb <= statePvwbinrgbWaitFrame;

						else
							statePvwbinrgb <= statePvwbinrgbWaitRow;
						end if;

					else
						statePvwbinrgb <= statePvwbinrgbLASA;
					end if;

				else
					statePvwbinrgb <= statePvwbinrgbLASA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.pvwbinrgb.rising --- END

	------------------------------------------------------------------------
	-- implementation: pvw{a/b}buf mutex management (pvwbuf)
	------------------------------------------------------------------------

	-- IP impl.pvwbuf.wiring --- RBEGIN
	statePvwbuf_dbg <= x"00" when statePvwbuf=statePvwbufInit
				else x"10" when statePvwbuf=statePvwbufReady
				else x"20" when statePvwbuf=statePvwbufAck
				else (others => '1');
	-- IP impl.pvwbuf.wiring --- REND

	-- IP impl.pvwbuf.rising --- BEGIN
	process (reset, mclk, statePvwbuf)
		-- IP impl.pvwbuf.vars --- BEGIN
		-- IP impl.pvwbuf.vars --- END

	begin
		if reset='1' then
			-- IP impl.pvwbuf.asyncrst --- BEGIN
			statePvwbuf <= statePvwbufInit;
			pvwabufLock <= lockIdle;
			pvwabufFull <= '0';
			pvwbbufLock <= lockIdle;
			pvwbbufFull <= '0';
			ackPvwToPvwbufAbufLock <= '0';
			dnyPvwToPvwbufAbufLock <= '0';
			ackPvwToPvwbufAbufSetFull <= '0';
			ackPvwToPvwbufBbufLock <= '0';
			dnyPvwToPvwbufBbufLock <= '0';
			ackPvwToPvwbufBbufSetFull <= '0';
			ackPvwbufBToPvwbufAbufLock <= '0';
			dnyPvwbufBToPvwbufAbufLock <= '0';
			ackPvwbufBToPvwbufAbufClear <= '0';
			ackPvwbufBToPvwbufBbufLock <= '0';
			dnyPvwbufBToPvwbufBbufLock <= '0';
			ackPvwbufBToPvwbufBbufClear <= '0';
			-- IP impl.pvwbuf.asyncrst --- END

		elsif rising_edge(mclk) then
			if (statePvwbuf=statePvwbufInit or pvwrun='0') then
				-- IP impl.pvwbuf.syncrst --- BEGIN
				pvwabufLock <= lockIdle;
				pvwabufFull <= '0';
				pvwbbufLock <= lockIdle;
				pvwbbufFull <= '0';
				ackPvwToPvwbufAbufLock <= '0';
				dnyPvwToPvwbufAbufLock <= '0';
				ackPvwToPvwbufAbufSetFull <= '0';
				ackPvwToPvwbufBbufLock <= '0';
				dnyPvwToPvwbufBbufLock <= '0';
				ackPvwToPvwbufBbufSetFull <= '0';
				ackPvwbufBToPvwbufAbufLock <= '0';
				dnyPvwbufBToPvwbufAbufLock <= '0';
				ackPvwbufBToPvwbufAbufClear <= '0';
				ackPvwbufBToPvwbufBbufLock <= '0';
				dnyPvwbufBToPvwbufBbufLock <= '0';
				ackPvwbufBToPvwbufBbufClear <= '0';

				-- IP impl.pvwbuf.syncrst --- END

				if pvwrun='0' then
					statePvwbuf <= statePvwbufInit;

				else
					statePvwbuf <= statePvwbufReady;
				end if;

			elsif statePvwbuf=statePvwbufReady then
				if reqPvwToPvwbufAbufLock='1' then
					-- IP impl.pvwbuf.ready.pvwAbufLock --- IBEGIN
					if pvwabufLock=lockIdle then
						pvwabufLock <= lockPvw;
						pvwabufFull <= '0';
						ackPvwToPvwbufAbufLock <= '1';
					elsif pvwabufLock=lockBufB then
						dnyPvwToPvwbufAbufLock <= '1';
					elsif pvwabufLock=lockPvw then
						pvwabufLock <= lockIdle; -- unlock
						ackPvwToPvwbufAbufLock <= '1';
					end if;
					-- IP impl.pvwbuf.ready.pvwAbufLock --- IEND

					statePvwbuf <= statePvwbufAck;

				elsif reqPvwToPvwbufAbufSetFull='1' then
					-- IP impl.pvwbuf.ready.pvwAbufFull --- IBEGIN
					if pvwabufLock=lockPvw then
						pvwabufLock <= lockIdle;
						pvwabufFull <= '1';
						ackPvwToPvwbufAbufSetFull <= '1';
					end if;
					-- IP impl.pvwbuf.ready.pvwAbufFull --- IEND

					statePvwbuf <= statePvwbufAck;

				elsif reqPvwToPvwbufBbufLock='1' then
					-- IP impl.pvwbuf.ready.pvwBbufLock --- IBEGIN
					if pvwbbufLock=lockIdle then
						pvwbbufLock <= lockPvw;
						pvwbbufFull <= '0';
						ackPvwToPvwbufBbufLock <= '1';
					elsif pvwbbufLock=lockBufB then
						dnyPvwToPvwbufBbufLock <= '1';
					elsif pvwbbufLock=lockPvw then
						pvwbbufLock <= lockIdle; -- unlock
						ackPvwToPvwbufBbufLock <= '1';
					end if;
					-- IP impl.pvwbuf.ready.pvwBbufLock --- IEND

					statePvwbuf <= statePvwbufAck;

				elsif reqPvwToPvwbufBbufSetFull='1' then
					-- IP impl.pvwbuf.ready.pvwBbufFull --- IBEGIN
					if pvwbbufLock=lockPvw then
						pvwbbufLock <= lockIdle;
						pvwbbufFull <= '1';
						ackPvwToPvwbufBbufSetFull <= '1';
					end if;
					-- IP impl.pvwbuf.ready.pvwBbufFull --- IEND

					statePvwbuf <= statePvwbufAck;

				elsif reqPvwbufBToPvwbufAbufLock='1' then
					-- IP impl.pvwbuf.ready.pvwbufBAbufLock --- IBEGIN
					if pvwabufLock=lockIdle then
						pvwabufLock <= lockBufB;
						ackPvwbufBToPvwbufAbufLock <= '1';
					elsif pvwabufLock=lockBufB then
						pvwabufLock <= lockIdle; -- unlock
						ackPvwbufBToPvwbufAbufLock <= '1';
					elsif pvwabufLock=lockPvw then
						dnyPvwbufBToPvwbufAbufLock <= '1';
					end if;
					-- IP impl.pvwbuf.ready.pvwbufBAbufLock --- IEND

					statePvwbuf <= statePvwbufAck;

				elsif reqPvwbufBToPvwbufAbufClear='1' then
					-- IP impl.pvwbuf.ready.pvwbufBAbufClear --- IBEGIN
					if pvwabufLock=lockBufB then
						pvwabufLock <= lockIdle;
						pvwabufFull <= '0';
						ackPvwbufBToPvwbufAbufClear <= '1';
					end if;
					-- IP impl.pvwbuf.ready.pvwbufBAbufClear --- IEND

					statePvwbuf <= statePvwbufAck;

				elsif reqPvwbufBToPvwbufBbufLock='1' then
					-- IP impl.pvwbuf.ready.pvwbufBBbufLock --- IBEGIN
					if pvwbbufLock=lockIdle then
						pvwbbufLock <= lockBufB;
						ackPvwbufBToPvwbufBbufLock <= '1';
					elsif pvwbbufLock=lockBufB then
						pvwbbufLock <= lockIdle; -- unlock
						ackPvwbufBToPvwbufBbufLock <= '1';
					elsif pvwbbufLock=lockPvw then
						dnyPvwbufBToPvwbufBbufLock <= '1';
					end if;
					-- IP impl.pvwbuf.ready.pvwbufBBbufLock --- IEND

					statePvwbuf <= statePvwbufAck;

				elsif reqPvwbufBToPvwbufBbufClear='1' then
					-- IP impl.pvwbuf.ready.pvwbufBBbufClear --- IBEGIN
					if pvwbbufLock=lockBufB then
						pvwbbufLock <= lockIdle;
						pvwbbufFull <= '0';
						ackPvwbufBToPvwbufBbufClear <= '1';
					end if;
					-- IP impl.pvwbuf.ready.pvwbufBBbufClear --- IEND

					statePvwbuf <= statePvwbufAck;
				end if;

			elsif statePvwbuf=statePvwbufAck then
				if ((ackPvwToPvwbufAbufLock='1' or dnyPvwToPvwbufAbufLock='1') and reqPvwToPvwbufAbufLock='0') then
					-- IP impl.pvwbuf.ack.pvwAbufLock --- IBEGIN
					ackPvwToPvwbufAbufLock <= '0';
					dnyPvwToPvwbufAbufLock <= '0';
					-- IP impl.pvwbuf.ack.pvwAbufLock --- IEND

					statePvwbuf <= statePvwbufReady;

				elsif (ackPvwToPvwbufAbufSetFull='1' and reqPvwToPvwbufAbufSetFull='0') then
					ackPvwToPvwbufAbufSetFull <= '0'; -- IP impl.pvwbuf.ack.pvwAbufFull --- ILINE

					statePvwbuf <= statePvwbufReady;

				elsif ((ackPvwToPvwbufBbufLock='1' or dnyPvwToPvwbufBbufLock='1') and reqPvwToPvwbufBbufLock='0') then
					-- IP impl.pvwbuf.ack.pvwBbufLock --- IBEGIN
					ackPvwToPvwbufBbufLock <= '0';
					dnyPvwToPvwbufBbufLock <= '0';
					-- IP impl.pvwbuf.ack.pvwBbufLock --- IEND

					statePvwbuf <= statePvwbufReady;

				elsif (ackPvwToPvwbufBbufSetFull='1' and reqPvwToPvwbufBbufSetFull='0') then
					ackPvwToPvwbufBbufSetFull <= '0'; -- IP impl.pvwbuf.ack.pvwBbufFull --- ILINE

					statePvwbuf <= statePvwbufReady;

				elsif ((ackPvwbufBToPvwbufAbufLock='1' or dnyPvwbufBToPvwbufAbufLock='1') and reqPvwbufBToPvwbufAbufLock='0') then
					-- IP impl.pvwbuf.ack.pvwbufBAbufLock --- IBEGIN
					ackPvwbufBToPvwbufAbufLock <= '0';
					dnyPvwbufBToPvwbufAbufLock <= '0';
					-- IP impl.pvwbuf.ack.pvwbufBAbufLock --- IEND

					statePvwbuf <= statePvwbufReady;

				elsif (ackPvwbufBToPvwbufAbufClear='1' and reqPvwbufBToPvwbufAbufClear='0') then
					ackPvwbufBToPvwbufAbufClear <= '0'; -- IP impl.pvwbuf.ack.pvwbufBAbufClear --- ILINE

					statePvwbuf <= statePvwbufReady;

				elsif ((ackPvwbufBToPvwbufBbufLock='1' or dnyPvwbufBToPvwbufBbufLock='1') and reqPvwbufBToPvwbufBbufLock='0') then
					-- IP impl.pvwbuf.ack.pvwbufBBbufLock --- IBEGIN
					ackPvwbufBToPvwbufBbufLock <= '0';
					dnyPvwbufBToPvwbufBbufLock <= '0';
					-- IP impl.pvwbuf.ack.pvwbufBBbufLock --- IEND

					statePvwbuf <= statePvwbufReady;

				elsif (ackPvwbufBToPvwbufBbufClear='1' and reqPvwbufBToPvwbufBbufClear='0') then
					ackPvwbufBToPvwbufBbufClear <= '0'; -- IP impl.pvwbuf.ack.pvwbufBBbufClear --- ILINE

					statePvwbuf <= statePvwbufReady;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.pvwbuf.rising --- END

	------------------------------------------------------------------------
	-- implementation: pvw{a/b}buf B/hostif-facing operation (pvwbufB)
	------------------------------------------------------------------------

	-- IP impl.pvwbufB.wiring --- RBEGIN
	enPvwabufB <= '1' when (pvwabufLock=lockBufB and strbDPvwabufToHostif='0' and statePvwbufB=statePvwbufBReadA) else '0';
	enPvwbbufB <= '1' when (pvwbbufLock=lockBufB and strbDPvwbbufToHostif='0' and statePvwbufB=statePvwbufBReadA) else '0';

	aPvwbufB_vec <= std_logic_vector(to_unsigned(aPvwbufB, 14));

	tixVPvwbufstate <= tixVPvwbufstateAbuf when ((pvwLatestBNotA='0' and pvwabufLock=lockIdle and pvwabufFull='1') or (pvwLatestBNotA='1' and pvwbbufLock=lockPvw and pvwabufFull='1'))
				else tixVPvwbufstateBbuf when ((pvwLatestBNotA='0' and pvwabufLock=lockPvw and pvwbbufFull='1') or (pvwLatestBNotA='1' and pvwbbufLock=lockIdle and pvwbbufFull='1'))
				else tixVPvwbufstateEmpty when pvwrun='1'
				else tixVPvwbufstateIdle; -- pvw can't have a lock on abuf and bbuf simultaneously

	getPvwinfoTixVPvwbufstate <= tixVPvwbufstate;

	pvwtkst <= pvwTkstB when tixVPvwbufstate=tixVPvwbufstateBbuf else pvwTkstA;
	getPvwinfoTkst <= pvwtkst;

	avllenPvwabufToHostif <= std_logic_vector(to_unsigned(225, 8)) when ((pvwacc=pvwaccBinrgb or pvwacc=pvwaccRawrgb) and pvwabufLock=lockIdle and pvwabufFull='1')
				else std_logic_vector(to_unsigned(192, 8)) when ((pvwacc=pvwaccBingray or pvwacc=pvwaccRawgray) and pvwabufLock=lockIdle and pvwabufFull='1')
				else (others => '0');
	avllenPvwbbufToHostif <= std_logic_vector(to_unsigned(225, 8)) when ((pvwacc=pvwaccBinrgb or pvwacc=pvwaccRawrgb) and pvwbbufLock=lockIdle and pvwbbufFull='1')
				else std_logic_vector(to_unsigned(192, 8)) when ((pvwacc=pvwaccBingray or pvwacc=pvwaccRawgray) and pvwbbufLock=lockIdle and pvwbbufFull='1')
				else (others => '0');

	ackPvwabufToHostif_sig <= ackPvwbufToHostif when pvwabufLock=lockBufB else '0';
	ackPvwabufToHostif <= ackPvwabufToHostif_sig;
	ackPvwbbufToHostif_sig <= ackPvwbufToHostif when pvwbbufLock=lockBufB else '0';
	ackPvwbbufToHostif <= ackPvwbbufToHostif_sig;

	statePvwbufB_dbg <= x"00" when statePvwbufB=statePvwbufBInit
				else x"10" when statePvwbufB=statePvwbufBReady
				else x"20" when statePvwbufB=statePvwbufBTrylock
				else x"30" when statePvwbufB=statePvwbufBReadA
				else x"31" when statePvwbufB=statePvwbufBReadB
				else x"40" when statePvwbufB=statePvwbufBDone
				else (others => '1');
	-- IP impl.pvwbufB.wiring --- REND

	-- IP impl.pvwbufB.rising --- BEGIN
	process (reset, mclk, statePvwbufB)
		-- IP impl.pvwbufB.vars --- BEGIN
		-- IP impl.pvwbufB.vars --- END

	begin
		if reset='1' then
			-- IP impl.pvwbufB.asyncrst --- RBEGIN
			statePvwbufB <= statePvwbufBInit;
			aPvwbufB <= 0;
			ackPvwbufToHostif <= '0';
			reqPvwbufBToPvwbufAbufLock <= '0';
			reqPvwbufBToPvwbufAbufClear <= '0';
			reqPvwbufBToPvwbufBbufLock <= '0';
			reqPvwbufBToPvwbufBbufClear <= '0';
			-- IP impl.pvwbufB.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (statePvwbufB=statePvwbufBInit or pvwrun='0') then
				-- IP impl.pvwbufB.syncrst --- RBEGIN
				aPvwbufB <= 0;
				ackPvwbufToHostif <= '0';
				reqPvwbufBToPvwbufAbufLock <= '0';
				reqPvwbufBToPvwbufAbufClear <= '0';
				reqPvwbufBToPvwbufBbufLock <= '0';
				reqPvwbufBToPvwbufBbufClear <= '0';
				-- IP impl.pvwbufB.syncrst --- REND

				if pvwrun='0' then
					statePvwbufB <= statePvwbufBInit;

				else
					statePvwbufB <= statePvwbufBReady;
				end if;

			elsif statePvwbufB=statePvwbufBReady then
				if (tixVPvwbufstate=tixVPvwbufstateAbuf and reqPvwabufToHostif='1') then
					reqPvwbufBToPvwbufAbufLock <= '1'; -- IP impl.pvwbufB.ready.aprep --- ILINE

					statePvwbufB <= statePvwbufBTrylock;

				elsif (tixVPvwbufstate=tixVPvwbufstateBbuf and reqPvwbbufToHostif='1') then
					reqPvwbufBToPvwbufBbufLock <= '1'; -- IP impl.pvwbufB.ready.bprep --- ILINE

					statePvwbufB <= statePvwbufBTrylock;
				end if;

			elsif statePvwbufB=statePvwbufBTrylock then
				if (ackPvwbufBToPvwbufAbufLock='1' or ackPvwbufBToPvwbufBbufLock='1') then
					-- IP impl.pvwbufB.trylock.ack --- IBEGIN
					reqPvwbufBToPvwbufAbufLock <= '0';
					reqPvwbufBToPvwbufBbufLock <= '0';
					-- IP impl.pvwbufB.trylock.ack --- IEND

					statePvwbufB <= statePvwbufBReadA;

				elsif (dnyPvwbufBToPvwbufAbufLock='1' or dnyPvwbufBToPvwbufBbufLock='1') then
					statePvwbufB <= statePvwbufBInit;
				end if;

			elsif statePvwbufB=statePvwbufBReadA then
				if pvwabufLock=lockBufB then
					if dnePvwabufToHostif='1' then
						-- IP impl.pvwbufB.readA.adne --- IBEGIN
						reqPvwbufBToPvwbufAbufClear <= '1';
						ackPvwbufToHostif <= '0';
						-- IP impl.pvwbufB.readA.adne --- IEND

						statePvwbufB <= statePvwbufBDone;

					elsif reqPvwabufToHostif='0' then
						-- IP impl.pvwbufB.readA.acnc --- IBEGIN
						reqPvwbufBToPvwbufAbufLock <= '1'; -- unlock
						ackPvwbufToHostif <= '0';
						-- IP impl.pvwbufB.readA.acnc --- IEND

						statePvwbufB <= statePvwbufBDone;

					elsif strbDPvwabufToHostif='0' then
						ackPvwbufToHostif <= '1'; -- IP impl.pvwbufB.readA.astep --- ILINE

						statePvwbufB <= statePvwbufBReadB;
					end if;

				elsif pvwbbufLock=lockBufB then
					if dnePvwbbufToHostif='1' then
						-- IP impl.pvwbufB.readA.bdne --- IBEGIN
						reqPvwbufBToPvwbufBbufClear <= '1';
						ackPvwbufToHostif <= '0';
						-- IP impl.pvwbufB.readA.bdne --- IEND

						statePvwbufB <= statePvwbufBDone;

					elsif reqPvwbbufToHostif='0' then
						-- IP impl.pvwbufB.readA.bcnc --- IBEGIN
						reqPvwbufBToPvwbufBbufLock <= '1'; -- unlock
						ackPvwbufToHostif <= '0';
						-- IP impl.pvwbufB.readA.bcnc --- IEND

						statePvwbufB <= statePvwbufBDone;

					elsif strbDPvwbbufToHostif='0' then
						ackPvwbufToHostif <= '1'; -- IP impl.pvwbufB.readA.bstep --- ILINE

						statePvwbufB <= statePvwbufBReadB;
					end if;
				end if;

			elsif statePvwbufB=statePvwbufBReadB then
				if pvwabufLock=lockBufB then
					if reqPvwabufToHostif='0' then
						-- IP impl.pvwbufB.readB.acnc --- IBEGIN
						reqPvwbufBToPvwbufAbufLock <= '1'; -- unlock
						ackPvwbufToHostif <= '0';
						-- IP impl.pvwbufB.readB.acnc --- IEND

						statePvwbufB <= statePvwbufBDone;

					elsif strbDPvwabufToHostif='1' then
						aPvwbufB <= aPvwbufB + 1; -- IP impl.pvwbufB.readB.ainc --- ILINE

						statePvwbufB <= statePvwbufBReadA;
					end if;

				elsif pvwbbufLock=lockBufB then
					if reqPvwbbufToHostif='0' then
						-- IP impl.pvwbufB.readB.bcnc --- IBEGIN
						reqPvwbufBToPvwbufBbufLock <= '1'; -- unlock
						ackPvwbufToHostif <= '0';
						-- IP impl.pvwbufB.readB.bcnc --- IEND

						statePvwbufB <= statePvwbufBDone;

					elsif strbDPvwbbufToHostif='1' then
						aPvwbufB <= aPvwbufB + 1; -- IP impl.pvwbufB.readB.binc --- ILINE

						statePvwbufB <= statePvwbufBReadA;
					end if;
				end if;

			elsif statePvwbufB=statePvwbufBDone then
				if (ackPvwbufBToPvwbufAbufLock='1' or ackPvwbufBToPvwbufAbufClear='1' or ackPvwbufBToPvwbufBbufLock='1' or ackPvwbufBToPvwbufBbufClear='1') then
					statePvwbufB <= statePvwbufBInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.pvwbufB.rising --- END

	------------------------------------------------------------------------
	-- implementation: preview raw gray, also managing rawgraybuf (pvwrawgray)
	------------------------------------------------------------------------

	-- IP impl.pvwrawgray.wiring --- RBEGIN
	-- works on the premise that pclk is 25MHz for mclk 50MHz

	-- even: GRGRGR..., odd: BGBGBG... (h mirror on / 0x3821=0x06 and vflipped, as determined experimentally)

	enRawgraybuf <= '1' when (statePvwrawgray=statePvwrawgrayLASA or statePvwrawgray=statePvwrawgrayLASB or statePvwrawgray=statePvwrawgrayLASC or statePvwrawgray=statePvwrawgrayLASD) else '0';

	aRawgraybuf_vec <= std_logic_vector(to_unsigned(aRawgraybuf, 11));

	statePvwrawgray_dbg <= x"00" when statePvwrawgray=statePvwrawgrayInit
				else x"10" when statePvwrawgray=statePvwrawgrayWaitFrame
				else x"20" when statePvwrawgray=statePvwrawgrayWaitRow
				else x"30" when statePvwrawgray=statePvwrawgrayLASA
				else x"31" when statePvwrawgray=statePvwrawgrayLASB
				else x"32" when statePvwrawgray=statePvwrawgrayLASC
				else x"33" when statePvwrawgray=statePvwrawgrayLASD
				else (others => '1');
	-- IP impl.pvwrawgray.wiring --- REND

	-- IP impl.pvwrawgray.rising --- BEGIN
	process (reset, mclk, statePvwrawgray)
		-- IP impl.pvwrawgray.vars --- RBEGIN
		variable rdA: std_logic_vector(7 downto 0);
		variable rdB: std_logic_vector(7 downto 0);

		variable gnA: std_logic_vector(7 downto 0);
		variable gnB: std_logic_vector(7 downto 0);

		variable grA: std_logic_vector(9 downto 0);
		variable grB: std_logic_vector(9 downto 0);

		variable ab: natural range 0 to 1; -- accumulator used for adding - 0: a, 1: b

		constant rowmax_lcl: natural := 384;
		variable row_lcl: std_logic_vector(8 downto 0);

		variable pre: std_logic;
		variable post: std_logic;

		variable col2L: natural range 0 to 512;
		variable col2A: natural range 0 to 512;
		variable col2S: natural range 0 to 512;
		-- IP impl.pvwrawgray.vars --- REND

	begin
		if reset='1' then
			-- IP impl.pvwrawgray.asyncrst --- RBEGIN
			statePvwrawgray <= statePvwrawgrayInit;

			dPvwrawgrayGr <= (others => '0');
			strbDPvwrawgrayGr <= '0';
			weRawgraybuf <= '0';
			aRawgraybuf <= 0;
			dwrRawgraybuf <= (others => '0');

			rdA := (others => '0');
			rdB := (others => '0');
			gnA := (others => '0');
			gnB := (others => '0');
			grA := (others => '0');
			grB := (others => '0');
			ab := 0;
			row_lcl := (others => '0');
			pre := '0';
			post := '0';
			col2L := 0;
			col2A := 0;
			col2S := 0;
			-- IP impl.pvwrawgray.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (statePvwrawgray=statePvwrawgrayInit or pvwrawgrayrun='0') then
				-- IP impl.pvwrawgray.syncrst --- BEGIN
				dPvwrawgrayGr <= (others => '0');
				strbDPvwrawgrayGr <= '0';
				weRawgraybuf <= '0';
				aRawgraybuf <= 0;
				dwrRawgraybuf <= (others => '0');

				-- IP impl.pvwrawgray.syncrst --- END

				if pvwrawgrayrun='0' then
					statePvwrawgray <= statePvwrawgrayInit;

				else
					statePvwrawgray <= statePvwrawgrayWaitFrame;
				end if;

			elsif statePvwrawgray=statePvwrawgrayWaitFrame then
				if strbRow192='1' then
					row_lcl := (others => '0'); -- IP impl.pvwrawgray.waitFrame.reset --- ILINE

					statePvwrawgray <= statePvwrawgrayWaitRow;
				end if;

			elsif statePvwrawgray=statePvwrawgrayWaitRow then
				if strbCol256N3='1' then
					-- IP impl.pvwrawgray.waitRow.reset --- IBEGIN
					ab := 0;

					pre := '1';
					post := '0';

					col2L := 0;
					col2A := 0;
					col2S := 0;
					-- IP impl.pvwrawgray.waitRow.reset --- IEND

					statePvwrawgray <= statePvwrawgrayLASA;
				end if;

			elsif statePvwrawgray=statePvwrawgrayLASA then
				-- IP impl.pvwrawgray.LASA --- IBEGIN
				if post='0' then
					-- load
					if row_lcl(0)='1' then
						weRawgraybuf <= '0';

						aRawgraybuf <= col2L;
					end if;
				end if;

				if pre='0' then
					-- store
					if row_lcl(0)='0' then
						weRawgraybuf <= '1';

						aRawgraybuf <= col2S;

						if ab=0 then
							dwrRawgraybuf <= gnB;
						else
							dwrRawgraybuf <= gnA;
						end if;

						col2S := col2S + 1;
					end if;
				end if;

				if (pre='0' and post='0') then
					-- add
					if row_lcl(0)='0' then
						if ab=0 then
							gnA := d;
						else
							gnB := d;
						end if;
					else
						if ab=0 then
							grA := "00" & d;
						else
							grB := "00" & d;
						end if;
					end if;

					col2A := col2A + 1;
				end if;
				-- IP impl.pvwrawgray.LASA --- IEND

				statePvwrawgray <= statePvwrawgrayLASB;

			elsif statePvwrawgray=statePvwrawgrayLASB then
				-- IP impl.pvwrawgray.LASB --- IBEGIN
				if post='0' then
					-- load
					if row_lcl(0)='1' then
						if ab=0 then
							gnB := drdRawgraybuf;
						else
							gnA := drdRawgraybuf;
						end if;

						col2L := col2L + 1;
					end if;
				end if;
				-- IP impl.pvwrawgray.LASB --- IEND

				statePvwrawgray <= statePvwrawgrayLASC;

			elsif statePvwrawgray=statePvwrawgrayLASC then
				-- IP impl.pvwrawgray.LASC --- IBEGIN
				if post='0' then
					-- load
					if row_lcl(0)='1' then
						weRawgraybuf <= '0';

						aRawgraybuf <= col2L;
					end if;
				end if;

				if pre='0' then
					-- store
					if row_lcl(0)='0' then
						weRawgraybuf <= '1';

						aRawgraybuf <= col2S;

						if ab=0 then
							dwrRawgraybuf <= rdB;
						else
							dwrRawgraybuf <= rdA;
						end if;

						col2S := col2S + 1;
					end if;
				end if;

				if (pre='0' and post='0') then
					if row_lcl(0)='0' then
						-- add
						if ab=0 then
							rdA := d;
						else
							rdB := d;
						end if;

					else
						-- add and store in pvwbuf
						if ab=0 then
							grA := std_logic_vector(unsigned(grA) + unsigned("00" & rdA) + unsigned("00" & gnA) + unsigned("00" & d));
							dPvwrawgrayGr <= grA(9 downto 2);
						else
							grB := std_logic_vector(unsigned(grB) + unsigned("00" & rdB) + unsigned("00" & gnB) + unsigned("00" & d));
							dPvwrawgrayGr <= grB(9 downto 2);
						end if;

						strbDPvwrawgrayGr <= '1';
					end if;

					col2A := col2A + 1;
				end if;
				-- IP impl.pvwrawgray.LASC --- IEND

				statePvwrawgray <= statePvwrawgrayLASD;

			elsif statePvwrawgray=statePvwrawgrayLASD then
				-- IP impl.pvwrawgray.LASD.ext --- IBEGIN
				strbDPvwrawgrayGr <= '0';

				if post='0' then
					-- load
					if row_lcl(0)='1' then
						if ab=0 then
							rdB := drdRawgraybuf;
						else
							rdA := drdRawgraybuf;
						end if;

						col2L := col2L + 1;
					end if;
				end if;

				if ab=1 then
					ab := 0;
				else
					ab := ab + 1;
				end if;
				-- IP impl.pvwrawgray.LASD.ext --- IEND

				if pre='1' then
					pre := '0'; -- IP impl.pvwrawgray.LASD.pre --- ILINE

					statePvwrawgray <= statePvwrawgrayLASA;

				elsif (col2A=512 and post='0') then
					post := '1'; -- IP impl.pvwrawgray.LASD.toPost --- ILINE

					statePvwrawgray <= statePvwrawgrayLASA;

				elsif post='1' then
					row_lcl := std_logic_vector(unsigned(row_lcl) + 1); -- IP impl.pvwrawgray.LASD.post --- ILINE

					if row_lcl=std_logic_vector(to_unsigned(rowmax_lcl, 9)) then
						statePvwrawgray <= statePvwrawgrayWaitFrame;

					else
						statePvwrawgray <= statePvwrawgrayWaitRow;
					end if;

				else
					statePvwrawgray <= statePvwrawgrayLASA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.pvwrawgray.rising --- END

	------------------------------------------------------------------------
	-- implementation: preview raw RGB (pvwrawrgb)
	------------------------------------------------------------------------

	-- IP impl.pvwrawrgb.wiring --- RBEGIN
	-- works on the premise that pclk is 25MHz for mclk 50MHz

	-- even: GRGRGR..., odd: BGBGBG... (h mirror on / 0x3821=0x06 and vflipped, as determined experimentally)

	statePvwrawrgb_dbg <= x"00" when statePvwrawrgb=statePvwrawrgbInit
				else x"10" when statePvwrawrgb=statePvwrawrgbWaitFrame
				else x"20" when statePvwrawrgb=statePvwrawrgbWaitRow
				else x"30" when statePvwrawrgb=statePvwrawrgbLASA
				else x"31" when statePvwrawrgb=statePvwrawrgbLASB
				else x"32" when statePvwrawrgb=statePvwrawrgbLASC
				else x"33" when statePvwrawrgb=statePvwrawrgbLASD
				else (others => '1');
	-- IP impl.pvwrawrgb.wiring --- REND

	-- IP impl.pvwrawrgb.rising --- BEGIN
	process (reset, mclk, statePvwrawrgb)
		-- IP impl.pvwrawrgb.vars --- RBEGIN
		variable gn: std_logic_vector(8 downto 0);
		variable bl: std_logic_vector(7 downto 0);

		constant rowmax_lcl: natural := 240;
		variable row_lcl: std_logic_vector(7 downto 0);

		constant colmax_lcl: natural := 160;
		variable col_lcl: natural range 0 to colmax_lcl;

		type rawrgbbuf_t is array (0 to 159) of std_logic_vector(7 downto 0);
		variable rawrgbbuf: rawrgbbuf_t;
		-- IP impl.pvwrawrgb.vars --- REND

	begin
		if reset='1' then
			-- IP impl.pvwrawrgb.asyncrst --- RBEGIN
			statePvwrawrgb <= statePvwrawrgbInit;

			dPvwrawrgbRd <= (others => '0');
			dPvwrawrgbGn <= (others => '0');
			strbDPvwrawrgbGnBl <= '0';
			dPvwrawrgbBl <= (others => '0');
			strbDPvwrawrgbRd <= '0';

			gn := (others => '0');
			bl := (others => '0');
			row_lcl := (others => '0');
			col_lcl := 0;
			for i in 0 to 159 loop
				rawrgbbuf(i) := (others => '0');
			end loop;
			-- IP impl.pvwrawrgb.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (statePvwrawrgb=statePvwrawrgbInit or pvwrawrgbrun='0') then
				-- IP impl.pvwrawrgb.syncrst --- BEGIN
				dPvwrawrgbRd <= (others => '0');
				strbDPvwrawrgbRd <= '0';
				dPvwrawrgbGn <= (others => '0');
				dPvwrawrgbBl <= (others => '0');
				strbDPvwrawrgbGnBl <= '0';

				-- IP impl.pvwrawrgb.syncrst --- END

				if pvwrawrgbrun='0' then
					statePvwrawrgb <= statePvwrawrgbInit;

				else
					statePvwrawrgb <= statePvwrawrgbWaitFrame;
				end if;

			elsif statePvwrawrgb=statePvwrawrgbWaitFrame then
				if strbRow120='1' then
					row_lcl := (others => '0'); -- IP impl.pvwrawrgb.waitFrame.reset --- ILINE

					statePvwrawrgb <= statePvwrawrgbWaitRow;
				end if;

			elsif statePvwrawrgb=statePvwrawrgbWaitRow then
				if strbCol160N1='1' then
					col_lcl := 0; -- IP impl.pvwrawrgb.waitRow.reset --- ILINE

					statePvwrawrgb <= statePvwrawrgbLASA;
				end if;

			elsif statePvwrawrgb=statePvwrawrgbLASA then
				-- IP impl.pvwrawrgb.LASA --- IBEGIN
				if row_lcl(0)='0' then
					-- store
					rawrgbbuf(col_lcl) := d;

				elsif row_lcl(0)='1' then
					-- store in pvwbuf
					bl := d;
				end if;
				-- IP impl.pvwrawrgb.LASA --- IEND

				statePvwrawrgb <= statePvwrawrgbLASB;

			elsif statePvwrawrgb=statePvwrawrgbLASB then
				statePvwrawrgb <= statePvwrawrgbLASC;

			elsif statePvwrawrgb=statePvwrawrgbLASC then
				-- IP impl.pvwrawrgb.LASC --- IBEGIN
				if row_lcl(0)='0' then
					-- store in pvwbuf
					dPvwrawrgbRd <= d;

					strbDPvwrawrgbRd <= '1';

				elsif row_lcl(0)='1' then
					-- load / store in pvwbuf
					--gn := std_logic_vector(unsigned("0" & drdRawrgbbuf) + unsigned("0" & d));
					gn := std_logic_vector(unsigned('0' & rawrgbbuf(col_lcl)) + unsigned('0' & d));

					dPvwrawrgbGn <= gn(8 downto 1);
					dPvwrawrgbBl <= bl;

					strbDPvwrawrgbGnBl <= '1';
				end if;

				col_lcl := col_lcl + 1;
				-- IP impl.pvwrawrgb.LASC --- IEND

				statePvwrawrgb <= statePvwrawrgbLASD;

			elsif statePvwrawrgb=statePvwrawrgbLASD then
				-- IP impl.pvwrawrgb.LASD.ext --- IBEGIN
				strbDPvwrawrgbRd <= '0';
				strbDPvwrawrgbGnBl <= '0';
				-- IP impl.pvwrawrgb.LASD.ext --- IEND

				if col_lcl=colmax_lcl then
					row_lcl := std_logic_vector(unsigned(row_lcl) + 1); -- IP impl.pvwrawrgb.LASD.inc --- ILINE

					if row_lcl=std_logic_vector(to_unsigned(rowmax_lcl, 8)) then
						statePvwrawrgb <= statePvwrawrgbWaitFrame;

					else
						statePvwrawrgb <= statePvwrawrgbWaitRow;
					end if;

				else
					statePvwrawrgb <= statePvwrawrgbLASA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.pvwrawrgb.rising --- END

	------------------------------------------------------------------------
	-- implementation: camera data sampling at every other rising or falling mclk edge (sample)
	------------------------------------------------------------------------

	-- IP impl.sample.wiring --- BEGIN
	stateSample_dbg <= x"00" when stateSample=stateSampleInit
				else x"10" when stateSample=stateSampleRunA
				else x"11" when stateSample=stateSampleRunB
				else (others => '1');
	-- IP impl.sample.wiring --- END

	-- IP impl.sample.rising --- BEGIN
	process (reset, mclk, stateSample)
		-- IP impl.sample.vars --- RBEGIN
		-- IP impl.sample.vars --- REND

	begin
		if reset='1' then
			-- IP impl.sample.asyncrst --- RBEGIN
			stateSample <= stateSampleInit;

			vsync_sig <= '0';
			href_sig <= '0';

			d <= (others => '0');
			-- IP impl.sample.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (stateSample=stateSampleInit or (grrdrun='0' and pvwrun='0')) then
				-- IP impl.sample.syncrst --- RBEGIN
				vsync_sig <= '0';
				href_sig <= '0';

				d <= (others => '0');
				-- IP impl.sample.syncrst --- REND

				if (grrdrun='1' or pvwrun='1') then
					stateSample <= stateSampleRunA;

				else
					stateSample <= stateSampleInit;
				end if;

			elsif stateSample=stateSampleRunA then
				-- IP impl.sample.runA --- IBEGIN
				if phase=phaseFallA then
					vsync_sig <= vsync_shift;
					href_sig <= href_shift;
					d <= d_shift;

				elsif phase=phaseRiseA then
					vsync_sig <= vsync;
					href_sig <= href;
					d <= d9 & d8 & d7 & d6 & d5 & d4 & d3 & d2;
				end if;
				-- IP impl.sample.runA --- IEND

				stateSample <= stateSampleRunB;

			elsif stateSample=stateSampleRunB then
				-- IP impl.sample.runB --- IBEGIN
				if phase=phaseFallB then
					vsync_sig <= vsync_shift;
					href_sig <= href_shift;
					d <= d_shift;

				elsif phase=phaseRiseB then
					vsync_sig <= vsync;
					href_sig <= href;
					d <= d9 & d8 & d7 & d6 & d5 & d4 & d3 & d2;
				end if;
				-- IP impl.sample.runB --- IEND

				stateSample <= stateSampleRunA;
			end if;
		end if;
	end process;
	-- IP impl.sample.rising --- END

	-- IP impl.sample.falling --- RBEGIN
	process (reset, mclk)
		-- IP impl.sample.falling.vars --- BEGIN
		-- IP impl.sample.falling.vars --- END
	begin
		if reset='1' then
			vsync_shift <= '0';
			href_shift <= '0';

			d_shift <= (others => '0');

		elsif falling_edge(mclk) then
			vsync_shift <= vsync;
			href_shift <= href;

			d_shift <= d9 & d8 & d7 & d6 & d5 & d4 & d3 & d2;
		end if;
	end process;
	-- IP impl.sample.falling --- REND

	------------------------------------------------------------------------
	-- implementation: camera frame tagging (tag)
	------------------------------------------------------------------------

	-- IP impl.tag.wiring --- BEGIN
	strbFrame <= '1' when (stateTag=stateTagFrameB and vsync_sig='0') else '0';

	strbRow120 <= '1' when (stateTag=stateTagRowB and href_sig='1' and row=row120) else '0';
	strbRow192 <= '1' when (stateTag=stateTagRowB and href_sig='1' and row=row192) else '0';
	strbRow768 <= '1' when (stateTag=stateTagRowB and href_sig='1' and row=row768) else '0';
	strbRow960 <= '1' when (stateTag=stateTagRowB and href_sig='1' and row=row960) else '0';

	strbCol160N1 <= '1' when (stateTag=stateTagColA and col=col160N1) else '0';
	strbCol256N3 <= '1' when (stateTag=stateTagColA and col=col256N3) else '0';
	strbCol1024N3 <= '1' when (stateTag=stateTagColA and col=col1024N3) else '0';
	strbCol1024N9 <= '1' when (stateTag=stateTagColA and col=col1024N9) else '0';
	strbCol1280 <= '1' when (stateTag=stateTagColA and col=col1280) else '0';
	strbCol1280N9 <= '1' when (stateTag=stateTagColA and col=col1280N9) else '0';

	stateTag_dbg <= x"00" when stateTag=stateTagInit
				else x"10" when stateTag=stateTagFrameA
				else x"11" when stateTag=stateTagFrameB
				else x"20" when stateTag=stateTagRowA
				else x"21" when stateTag=stateTagRowB
				else x"30" when stateTag=stateTagColA
				else x"31" when stateTag=stateTagColB
				else (others => '1');
	-- IP impl.tag.wiring --- END

	-- IP impl.tag.rising --- BEGIN
	process (reset, mclk, stateTag)
		-- IP impl.tag.vars --- RBEGIN
		-- currently not in use: assume pclk = mclk / 2
		--constant imax: natural := 2; -- mclk per pclk
		--variable i: natural range 0 to imax;
		-- IP impl.tag.vars --- REND

	begin
		if reset='1' then
			-- IP impl.tag.asyncrst --- BEGIN
			stateTag <= stateTagInit;
			row <= 0;
			col <= 0;
			-- IP impl.tag.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateTag=stateTagInit or (grrdrun='0' and pvwrun='0')) then
				-- IP impl.tag.syncrst --- BEGIN
				row <= 0;
				col <= 0;

				-- IP impl.tag.syncrst --- END

				if (grrdrun='1' or pvwrun='1') then
					stateTag <= stateTagFrameA;

				else
					stateTag <= stateTagInit;
				end if;

			elsif stateTag=stateTagFrameA then
				if vsync_sig='1' then
					stateTag <= stateTagFrameB;
				end if;

			elsif stateTag=stateTagFrameB then
				if vsync_sig='0' then
					row <= 0; -- IP impl.tag.frameB --- ILINE

					stateTag <= stateTagRowA;
				end if;

			elsif stateTag=stateTagRowA then
				if href_sig='0' then
					stateTag <= stateTagRowB;
				end if;

			elsif stateTag=stateTagRowB then
				if href_sig='1' then
					col <= 0; -- IP impl.tag.rowB --- ILINE

					stateTag <= stateTagColA;
				end if;

			elsif stateTag=stateTagColA then
				stateTag <= stateTagColB;

			elsif stateTag=stateTagColB then
				if col=colmax-1 then
					col <= 0; -- IP impl.tag.colB.colzero --- ILINE

					if row=rowmax-1 then
						row <= 0; -- IP impl.tag.colB.rowzero --- ILINE

						stateTag <= stateTagFrameA;

					else
						row <= row + 1; -- IP impl.tag.colB.rowinc --- ILINE

						stateTag <= stateTagRowA;
					end if;

				else
					col <= col + 1; -- IP impl.tag.colB.colinc --- ILINE

					stateTag <= stateTagColA;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.tag.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- IBEGIN
	nmclk <= not mclk;

	--strb_dbg <= strbFrame & strbRow960 & strbRow768 & strbCol1280N9 & strbCol1280 & strbCol1024N3;
	strb_dbg <= strbFrame & strbRow192 & strbRow768 & strbDPvwbinrgbGnBl & strbDPvwbinrgbRd & strbDPvwbingrayGr;
	--strb_dbg <= "000000";
	-- IP impl.oth.cust --- IEND

end Camacq;
