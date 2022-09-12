-- file Top.vhd
-- Top top_v1_0 top implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Catherine Johnson (auto-generation)
-- date created: 1 Dec 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Iccl.all;

entity Top is
	generic (
		fMclk: natural range 1 to 1000000 := 50000
	);
	port (
		extresetn: in std_logic;
		extclk: in std_logic;
		dbg0: out std_logic;
		dbg1: out std_logic;
		csi_clk_p: in std_logic;
		csi_clk_n: in std_logic;
		csi_d0_p: in std_logic;
		csi_d0_n: in std_logic;
		csi_d1_p: in std_logic;
		csi_d1_n: in std_logic;
		csi_d2_p: in std_logic;
		csi_d2_n: in std_logic;
		csi_d3_p: in std_logic;
		csi_d3_n: in std_logic;

		scl: out std_logic;
		sda: inout std_logic;

		btn0: in std_logic;
		btn1: in std_logic;

		rdyRx: out std_logic;
		enRx: in std_logic;

		rx: in std_logic_vector(31 downto 0);
		strbRx: in std_logic;

		rdyTx: out std_logic;
		enTx: in std_logic;

		tx: out std_logic_vector(31 downto 0);
		strbTx: in std_logic;

		cs: out std_logic;
		sclk: out std_logic;
		mosi: out std_logic;
		pmnd_rxd: in std_logic;
		pmnd_txd: out std_logic;
		led4_r: out std_logic;
		led4_g: out std_logic;
		led5_r: out std_logic;
		led5_g: out std_logic;
		nslp: out std_logic;
		m0: inout std_logic;
		dir: out std_logic;
		step0: out std_logic;
		nflt: in std_logic
	);
end Top;

architecture Top of Top is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Bcdfreq_v1_0 is
		generic (
			fMclk: natural range 1 to 1000000 := 100000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;

			high: in std_logic_vector(3 downto 0);
			low: in std_logic_vector(3 downto 0);

			freq: out std_logic
		);
	end component;

	component Camacq is
		port (
			reset: in std_logic;
			mclk: in std_logic;

			tkclksrcGetTkstTkst: in std_logic_vector(31 downto 0);

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

			reqGrrdabbufToFeatdet: in std_logic;
			ackGrrdabbufToFeatdet: out std_logic;

			reqGrrdcdbufToFeatdet: in std_logic;

			dneGrrdabbufToFeatdet: in std_logic;
			avllenGrrdabbufToFeatdet: out std_logic_vector(3 downto 0);

			ackGrrdcdbufToFeatdet: out std_logic;
			dneGrrdcdbufToFeatdet: in std_logic;

			dGrrdabbufToFeatdet: out std_logic_vector(7 downto 0);

			avllenGrrdcdbufToFeatdet: out std_logic_vector(3 downto 0);

			strbDGrrdabbufToFeatdet: in std_logic;

			dGrrdcdbufToFeatdet: out std_logic_vector(7 downto 0);
			strbDGrrdcdbufToFeatdet: in std_logic;

			reqGrrdefbufToFeatdet: in std_logic;
			ackGrrdefbufToFeatdet: out std_logic;
			dneGrrdefbufToFeatdet: in std_logic;
			avllenGrrdefbufToFeatdet: out std_logic_vector(3 downto 0);

			dGrrdefbufToFeatdet: out std_logic_vector(7 downto 0);

			reqPvwabufToHostif: in std_logic;

			strbDGrrdefbufToFeatdet: in std_logic;

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

			csi_clk_p: in std_logic;
			csi_clk_n: in std_logic;

			csi_d0_p: in std_logic;
			csi_d0_n: in std_logic;

			csi_d1_p: in std_logic;
			csi_d1_n: in std_logic;

			csi_d2_p: in std_logic;
			csi_d2_n: in std_logic;

			csi_d3_p: in std_logic;
			csi_d3_n: in std_logic;

			rx_clk_p: in std_logic;
			rx_clk_n: in std_logic;

			pixclk_dbg: out std_logic;
			strb_dbg: out std_logic_vector(3 downto 0)
		);
	end component;

	component Camif is
		generic (
			fMclk: natural range 1 to 1000000 := 50000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;
			rng: out std_logic;

			reqInvSetRng: in std_logic;
			ackInvSetRng: out std_logic;

			setRngRng: in std_logic_vector(7 downto 0);

			reqInvSetReg: in std_logic;
			ackInvSetReg: out std_logic;

			setRegAddr: in std_logic_vector(15 downto 0);
			setRegVal: in std_logic_vector(7 downto 0);

			reqInvSetRegaddr: in std_logic;
			ackInvSetRegaddr: out std_logic;

			setRegaddrAddr: in std_logic_vector(15 downto 0);

			reqInvGetReg: in std_logic;
			ackInvGetReg: out std_logic;

			getRegVal: out std_logic_vector(7 downto 0);

			reqInvModReg: in std_logic;
			ackInvModReg: out std_logic;

			modRegAddr: in std_logic_vector(15 downto 0);
			modRegMask: in std_logic_vector(7 downto 0);
			modRegVal: in std_logic_vector(7 downto 0);

			scl: out std_logic;
			sda: inout std_logic
		);
	end component;

	component Ccc_div2_5 is
		port (
			PLL_POWERDOWN_N_0: in std_logic;
			REF_CLK_0: in std_logic;
			OUT0_FABCLK_0: out std_logic;
			PLL_LOCK_0: out std_logic
		);
	end component;

	component Debounce_v1_0 is
		generic (
			invert: boolean := false;
			tdead: natural range 1 to 10000 := 100
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;

			noisy: in std_logic;
			clean: out std_logic
		);
	end component;

	component Featdet is
		port (
			reset: in std_logic;
			mclk: in std_logic;

			camacqGetGrrdinfoTixVGrrdbufstate: in std_logic_vector(7 downto 0);
			camacqGetGrrdinfoTkst: in std_logic_vector(31 downto 0);

			reqInvSet: in std_logic;
			ackInvSet: out std_logic;

			setRng: in std_logic_vector(7 downto 0);
			setThdNotCorner: in std_logic_vector(7 downto 0);
			setThdDeltaNotAbs: in std_logic_vector(7 downto 0);

			getInfoTixVFlgbufstate: out std_logic_vector(7 downto 0);
			getInfoTixVThdstate: out std_logic_vector(7 downto 0);
			getInfoTkst: out std_logic_vector(31 downto 0);

			getCornerinfoShift: out std_logic_vector(7 downto 0);
			getCornerinfoScoreMin: out std_logic_vector(7 downto 0);
			getCornerinfoScoreMax: out std_logic_vector(7 downto 0);

			reqInvSetCorner: in std_logic;
			ackInvSetCorner: out std_logic;

			setCornerLinNotLog: in std_logic_vector(7 downto 0);
			setCornerThd: in std_logic_vector(7 downto 0);

			reqInvSetThd: in std_logic;
			ackInvSetThd: out std_logic;

			setThdLvlFirst: in std_logic_vector(7 downto 0);
			setThdLvlSecond: in std_logic_vector(7 downto 0);

			reqInvTriggerThd: in std_logic;
			ackInvTriggerThd: out std_logic;

			reqGrrdabbufFromCamacq: out std_logic;
			ackGrrdabbufFromCamacq: in std_logic;

			reqGrrdcdbufFromCamacq: out std_logic;

			dneGrrdabbufFromCamacq: out std_logic;

			avllenGrrdabbufFromCamacq: in std_logic_vector(3 downto 0);

			ackGrrdcdbufFromCamacq: in std_logic;
			dneGrrdcdbufFromCamacq: out std_logic;

			dGrrdabbufFromCamacq: in std_logic_vector(7 downto 0);

			avllenGrrdcdbufFromCamacq: in std_logic_vector(3 downto 0);

			strbDGrrdabbufFromCamacq: out std_logic;

			dGrrdcdbufFromCamacq: in std_logic_vector(7 downto 0);
			strbDGrrdcdbufFromCamacq: out std_logic;

			reqGrrdefbufFromCamacq: out std_logic;
			ackGrrdefbufFromCamacq: in std_logic;
			dneGrrdefbufFromCamacq: out std_logic;

			avllenGrrdefbufFromCamacq: in std_logic_vector(3 downto 0);

			dGrrdefbufFromCamacq: in std_logic_vector(7 downto 0);
			strbDGrrdefbufFromCamacq: out std_logic;

			reqFlgbufToHostif: in std_logic;
			ackFlgbufToHostif: out std_logic;
			dneFlgbufToHostif: in std_logic;
			avllenFlgbufToHostif: out std_logic_vector(8 downto 0);

			dFlgbufToHostif: out std_logic_vector(31 downto 0);
			strbDFlgbufToHostif: in std_logic;

			strb_dbg: out std_logic_vector(3 downto 0)
		);
	end component;

	component Hostif is
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;
			commok: out std_logic;
			reqReset: out std_logic;

			reqInvLaserSet: out std_logic;
			ackInvLaserSet: in std_logic;

			laserSetL: out std_logic_vector(15 downto 0);
			laserSetR: out std_logic_vector(15 downto 0);

			pwmonifGetTixVState: in std_logic_vector(7 downto 0);
			pwmonifGetRxleft: in std_logic_vector(7 downto 0);
			pwmonifGetLenRxdata: in std_logic_vector(7 downto 0);
			pwmonifGetRxdata: in std_logic_vector(263 downto 0);

			reqInvPwmonifRx: out std_logic;
			ackInvPwmonifRx: in std_logic;

			pwmonifRxLen: out std_logic_vector(7 downto 0);
			pwmonifRxTo: out std_logic_vector(15 downto 0);

			reqInvPwmonifTx: out std_logic;
			ackInvPwmonifTx: in std_logic;

			pwmonifTxLenData: out std_logic_vector(7 downto 0);
			pwmonifTxData: out std_logic_vector(255 downto 0);

			reqInvPwmonifTxrx: out std_logic;
			ackInvPwmonifTxrx: in std_logic;

			pwmonifTxrxLenTxdata: out std_logic_vector(7 downto 0);
			pwmonifTxrxTxdata: out std_logic_vector(255 downto 0);
			pwmonifTxrxRxlen: out std_logic_vector(7 downto 0);
			pwmonifTxrxRxto: out std_logic_vector(15 downto 0);

			stateGetTixVIcclState: in std_logic_vector(7 downto 0);

			stepGetInfoTixVState: in std_logic_vector(7 downto 0);
			stepGetInfoAngle: in std_logic_vector(15 downto 0);

			reqInvStepMoveto: out std_logic;
			ackInvStepMoveto: in std_logic;

			stepMovetoAngle: out std_logic_vector(15 downto 0);
			stepMovetoTstep: out std_logic_vector(7 downto 0);

			reqInvStepSet: out std_logic;
			ackInvStepSet: in std_logic;

			stepSetRng: out std_logic_vector(7 downto 0);
			stepSetCcwNotCw: out std_logic_vector(7 downto 0);
			stepSetTstep: out std_logic_vector(7 downto 0);

			reqInvStepZero: out std_logic;
			ackInvStepZero: in std_logic;

			tkclksrcGetTkstTkst: in std_logic_vector(31 downto 0);

			reqInvTkclksrcSetTkst: out std_logic;
			ackInvTkclksrcSetTkst: in std_logic;

			tkclksrcSetTkstTkst: out std_logic_vector(31 downto 0);

			reqInvCamacqSetGrrd: out std_logic;
			ackInvCamacqSetGrrd: in std_logic;

			camacqSetGrrdRng: out std_logic_vector(7 downto 0);
			camacqSetGrrdRedNotGray: out std_logic_vector(7 downto 0);

			camacqGetGrrdinfoTixVGrrdbufstate: in std_logic_vector(7 downto 0);
			camacqGetGrrdinfoTkst: in std_logic_vector(31 downto 0);

			reqInvCamacqSetPvw: out std_logic;
			ackInvCamacqSetPvw: in std_logic;

			camacqSetPvwRng: out std_logic_vector(7 downto 0);
			camacqSetPvwRawNotBin: out std_logic_vector(7 downto 0);
			camacqSetPvwGrayNotRgb: out std_logic_vector(7 downto 0);

			camacqGetPvwinfoTixVPvwbufstate: in std_logic_vector(7 downto 0);
			camacqGetPvwinfoTkst: in std_logic_vector(31 downto 0);

			reqInvCamifSetRng: out std_logic;
			ackInvCamifSetRng: in std_logic;

			camifSetRngRng: out std_logic_vector(7 downto 0);

			reqInvCamifSetReg: out std_logic;
			ackInvCamifSetReg: in std_logic;

			camifSetRegAddr: out std_logic_vector(15 downto 0);
			camifSetRegVal: out std_logic_vector(7 downto 0);

			reqInvCamifSetRegaddr: out std_logic;
			ackInvCamifSetRegaddr: in std_logic;

			camifSetRegaddrAddr: out std_logic_vector(15 downto 0);

			reqInvCamifGetReg: out std_logic;
			ackInvCamifGetReg: in std_logic;

			camifGetRegVal: in std_logic_vector(7 downto 0);

			reqInvCamifModReg: out std_logic;
			ackInvCamifModReg: in std_logic;

			camifModRegAddr: out std_logic_vector(15 downto 0);
			camifModRegMask: out std_logic_vector(7 downto 0);
			camifModRegVal: out std_logic_vector(7 downto 0);

			reqInvFeatdetSet: out std_logic;
			ackInvFeatdetSet: in std_logic;

			featdetSetRng: out std_logic_vector(7 downto 0);
			featdetSetThdNotCorner: out std_logic_vector(7 downto 0);
			featdetSetThdDeltaNotAbs: out std_logic_vector(7 downto 0);

			featdetGetInfoTixVFlgbufstate: in std_logic_vector(7 downto 0);
			featdetGetInfoTixVThdstate: in std_logic_vector(7 downto 0);
			featdetGetInfoTkst: in std_logic_vector(31 downto 0);

			featdetGetCornerinfoShift: in std_logic_vector(7 downto 0);
			featdetGetCornerinfoScoreMin: in std_logic_vector(7 downto 0);
			featdetGetCornerinfoScoreMax: in std_logic_vector(7 downto 0);

			reqInvFeatdetSetCorner: out std_logic;
			ackInvFeatdetSetCorner: in std_logic;

			featdetSetCornerLinNotLog: out std_logic_vector(7 downto 0);
			featdetSetCornerThd: out std_logic_vector(7 downto 0);

			reqInvFeatdetSetThd: out std_logic;
			ackInvFeatdetSetThd: in std_logic;

			featdetSetThdLvlFirst: out std_logic_vector(7 downto 0);
			featdetSetThdLvlSecond: out std_logic_vector(7 downto 0);

			reqInvFeatdetTriggerThd: out std_logic;
			ackInvFeatdetTriggerThd: in std_logic;

			reqPvwabufFromCamacq: out std_logic;
			ackPvwabufFromCamacq: in std_logic;
			dnePvwabufFromCamacq: out std_logic;

			avllenPvwabufFromCamacq: in std_logic_vector(7 downto 0);

			dPvwabufFromCamacq: in std_logic_vector(31 downto 0);
			strbDPvwabufFromCamacq: out std_logic;

			reqPvwbbufFromCamacq: out std_logic;
			ackPvwbbufFromCamacq: in std_logic;
			dnePvwbbufFromCamacq: out std_logic;

			avllenPvwbbufFromCamacq: in std_logic_vector(7 downto 0);

			reqFlgbufFromFeatdet: out std_logic;

			dPvwbbufFromCamacq: in std_logic_vector(31 downto 0);

			ackFlgbufFromFeatdet: in std_logic;

			strbDPvwbbufFromCamacq: out std_logic;

			dneFlgbufFromFeatdet: out std_logic;

			avllenFlgbufFromFeatdet: in std_logic_vector(8 downto 0);

			dFlgbufFromFeatdet: in std_logic_vector(31 downto 0);
			strbDFlgbufFromFeatdet: out std_logic;

			rdyRx: out std_logic;
			enRx: in std_logic;

			rx: in std_logic_vector(31 downto 0);
			strbRx: in std_logic;

			rdyTx: out std_logic;
			enTx: in std_logic;

			tx: out std_logic_vector(31 downto 0);
			strbTx: in std_logic;

			stateOp_dbg: out std_logic_vector(7 downto 0)
		);
	end component;

	component Laser is
		generic (
			fMclk: natural range 1 to 1000000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;

			reqInvSet: in std_logic;
			ackInvSet: out std_logic;

			setL: in std_logic_vector(15 downto 0);
			setR: in std_logic_vector(15 downto 0);

			nss: out std_logic;
			sclk: out std_logic;
			mosi: out std_logic
		);
	end component;

	component Pwmonif is
		generic (
			fMclk: natural range 1 to 1000000 := 50000;
			fSclk: natural range 100 to 50000000 := 5000000;

			toRx: natural range 1 to 10000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;

			getTixVState: out std_logic_vector(7 downto 0);
			getRxleft: out std_logic_vector(7 downto 0);
			getLenRxdata: out std_logic_vector(7 downto 0);
			getRxdata: out std_logic_vector(263 downto 0);

			reqInvRx: in std_logic;
			ackInvRx: out std_logic;

			rxLen: in std_logic_vector(7 downto 0);
			rxTo: in std_logic_vector(15 downto 0);

			reqInvTx: in std_logic;
			ackInvTx: out std_logic;

			txLenData: in std_logic_vector(7 downto 0);
			txData: in std_logic_vector(255 downto 0);

			reqInvTxrx: in std_logic;
			ackInvTxrx: out std_logic;

			txrxLenTxdata: in std_logic_vector(7 downto 0);
			txrxTxdata: in std_logic_vector(255 downto 0);
			txrxRxlen: in std_logic_vector(7 downto 0);
			txrxRxto: in std_logic_vector(15 downto 0);

			rxd: in std_logic;
			txd: out std_logic
		);
	end component;

	component Rgbled4 is
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;
			rgb: in std_logic_vector(23 downto 0);
			r: out std_logic;
			g: out std_logic;
			b: out std_logic
		);
	end component;

	component Rgbled5 is
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;
			rgb: in std_logic_vector(23 downto 0);
			r: out std_logic;
			g: out std_logic;
			b: out std_logic
		);
	end component;

	component State is
		port (
			reset: in std_logic;
			tkclk: in std_logic;

			commok: in std_logic;
			camrng: in std_logic;

			rgb: out std_logic_vector(23 downto 0);

			getTixVIcclState: out std_logic_vector(7 downto 0)
		);
	end component;

	component Step is
		generic (
			fMclk: natural range 1 to 1000000 := 50000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;

			getInfoTixVState: out std_logic_vector(7 downto 0);
			getInfoAngle: out std_logic_vector(15 downto 0);

			reqInvMoveto: in std_logic;
			ackInvMoveto: out std_logic;

			movetoAngle: in std_logic_vector(15 downto 0);
			movetoTstep: in std_logic_vector(7 downto 0);

			reqInvSet: in std_logic;
			ackInvSet: out std_logic;

			setRng: in std_logic_vector(7 downto 0);
			setCcwNotCw: in std_logic_vector(7 downto 0);
			setTstep: in std_logic_vector(7 downto 0);

			reqInvZero: in std_logic;
			ackInvZero: out std_logic;

			nslp: out std_logic;
			m0: inout std_logic;
			dir: out std_logic;
			step0: out std_logic;
			nflt: in std_logic
		);
	end component;

	component Tkclksrc is
		generic (
			fMclk: natural range 1 to 1000000 := 50000
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: out std_logic;

			getTkstTkst: out std_logic_vector(31 downto 0);

			reqInvSetTkst: in std_logic;
			ackInvSetTkst: out std_logic;

			setTkstTkst: in std_logic_vector(31 downto 0)
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- reset (rst)
	type stateRst_t is (
		stateRstReset,
		stateRstRun
	);
	signal stateRst: stateRst_t := stateRstReset;

	signal reset: std_logic;

	-- IP sigs.rst.cust --- INSERT

	---- myCamacq
	signal camacqGetGrrdinfoTixVGrrdbufstate: std_logic_vector(7 downto 0);
	signal camacqGetGrrdinfoTkst: std_logic_vector(31 downto 0);

	signal camacqGetPvwinfoTixVPvwbufstate: std_logic_vector(7 downto 0);
	signal camacqGetPvwinfoTkst: std_logic_vector(31 downto 0);

	signal avllenGrrdabbufCamacqToFeatdet: std_logic_vector(3 downto 0);

	signal dGrrdabbufCamacqToFeatdet: std_logic_vector(7 downto 0);

	signal avllenGrrdcdbufCamacqToFeatdet: std_logic_vector(3 downto 0);

	signal dGrrdcdbufCamacqToFeatdet: std_logic_vector(7 downto 0);

	signal avllenGrrdefbufCamacqToFeatdet: std_logic_vector(3 downto 0);

	signal dGrrdefbufCamacqToFeatdet: std_logic_vector(7 downto 0);

	signal avllenPvwabufCamacqToHostif: std_logic_vector(7 downto 0);

	signal dPvwabufCamacqToHostif: std_logic_vector(31 downto 0);

	signal avllenPvwbbufCamacqToHostif: std_logic_vector(7 downto 0);

	signal dPvwbbufCamacqToHostif: std_logic_vector(31 downto 0);

	---- myCamif
	signal camrng: std_logic;

	signal camifGetRegVal: std_logic_vector(7 downto 0);

	---- myCccMclk
	signal mclk: std_logic;

	---- myDebounceBtn0
	signal btn0_sig: std_logic;

	---- myFeatdet
	signal featdetGetInfoTixVFlgbufstate: std_logic_vector(7 downto 0);
	signal featdetGetInfoTixVThdstate: std_logic_vector(7 downto 0);
	signal featdetGetInfoTkst: std_logic_vector(31 downto 0);

	signal featdetGetCornerinfoShift: std_logic_vector(7 downto 0);
	signal featdetGetCornerinfoScoreMin: std_logic_vector(7 downto 0);
	signal featdetGetCornerinfoScoreMax: std_logic_vector(7 downto 0);

	signal strbDGrrdabbufCamacqToFeatdet: std_logic;

	signal strbDGrrdcdbufCamacqToFeatdet: std_logic;

	signal strbDGrrdefbufCamacqToFeatdet: std_logic;

	signal avllenFlgbufFeatdetToHostif: std_logic_vector(8 downto 0);

	signal dFlgbufFeatdetToHostif: std_logic_vector(31 downto 0);

	---- myHostif
	signal commok: std_logic;

	signal laserSetL: std_logic_vector(15 downto 0);
	signal laserSetR: std_logic_vector(15 downto 0);

	signal pwmonifRxLen: std_logic_vector(7 downto 0);
	signal pwmonifRxTo: std_logic_vector(15 downto 0);

	signal pwmonifTxLenData: std_logic_vector(7 downto 0);
	signal pwmonifTxData: std_logic_vector(255 downto 0);

	signal pwmonifTxrxLenTxdata: std_logic_vector(7 downto 0);
	signal pwmonifTxrxTxdata: std_logic_vector(255 downto 0);
	signal pwmonifTxrxRxlen: std_logic_vector(7 downto 0);
	signal pwmonifTxrxRxto: std_logic_vector(15 downto 0);

	signal stepMovetoAngle: std_logic_vector(15 downto 0);
	signal stepMovetoTstep: std_logic_vector(7 downto 0);

	signal stepSetRng: std_logic_vector(7 downto 0);
	signal stepSetCcwNotCw: std_logic_vector(7 downto 0);
	signal stepSetTstep: std_logic_vector(7 downto 0);

	signal tkclksrcSetTkstTkst: std_logic_vector(31 downto 0);

	signal camacqSetGrrdRng: std_logic_vector(7 downto 0);
	signal camacqSetGrrdRedNotGray: std_logic_vector(7 downto 0);

	signal camacqSetPvwRng: std_logic_vector(7 downto 0);
	signal camacqSetPvwRawNotBin: std_logic_vector(7 downto 0);
	signal camacqSetPvwGrayNotRgb: std_logic_vector(7 downto 0);

	signal camifSetRngRng: std_logic_vector(7 downto 0);

	signal camifSetRegAddr: std_logic_vector(15 downto 0);
	signal camifSetRegVal: std_logic_vector(7 downto 0);

	signal camifSetRegaddrAddr: std_logic_vector(15 downto 0);

	signal camifModRegAddr: std_logic_vector(15 downto 0);
	signal camifModRegMask: std_logic_vector(7 downto 0);
	signal camifModRegVal: std_logic_vector(7 downto 0);

	signal featdetSetRng: std_logic_vector(7 downto 0);
	signal featdetSetThdNotCorner: std_logic_vector(7 downto 0);
	signal featdetSetThdDeltaNotAbs: std_logic_vector(7 downto 0);

	signal featdetSetCornerLinNotLog: std_logic_vector(7 downto 0);
	signal featdetSetCornerThd: std_logic_vector(7 downto 0);

	signal featdetSetThdLvlFirst: std_logic_vector(7 downto 0);
	signal featdetSetThdLvlSecond: std_logic_vector(7 downto 0);

	signal strbDPvwabufCamacqToHostif: std_logic;

	signal strbDPvwbbufCamacqToHostif: std_logic;

	signal strbDFlgbufFeatdetToHostif: std_logic;

	---- myPwmonif
	signal pwmonifGetTixVState: std_logic_vector(7 downto 0);
	signal pwmonifGetRxleft: std_logic_vector(7 downto 0);
	signal pwmonifGetLenRxdata: std_logic_vector(7 downto 0);
	signal pwmonifGetRxdata: std_logic_vector(263 downto 0);

	---- myState
	signal rgb4: std_logic_vector(23 downto 0);

	signal stateGetTixVIcclState: std_logic_vector(7 downto 0);

	---- myStep
	signal stepGetInfoTixVState: std_logic_vector(7 downto 0);
	signal stepGetInfoAngle: std_logic_vector(15 downto 0);

	---- myTkclksrc
	signal tkclk: std_logic;

	signal tkclksrcGetTkstTkst: std_logic_vector(31 downto 0);

	---- handshake
	-- myHostif to (many)
	signal reqResetFromHostif: std_logic;

	-- myHostif to myLaser
	signal reqInvLaserSet: std_logic;
	signal ackInvLaserSet: std_logic;

	-- myDebounceBtn1 to (many)
	signal reqResetBtn1: std_logic;

	-- myHostif to myPwmonif
	signal reqInvPwmonifRx: std_logic;
	signal ackInvPwmonifRx: std_logic;

	-- myHostif to myPwmonif
	signal reqInvPwmonifTx: std_logic;
	signal ackInvPwmonifTx: std_logic;

	-- myHostif to myPwmonif
	signal reqInvPwmonifTxrx: std_logic;
	signal ackInvPwmonifTxrx: std_logic;

	-- myHostif to myStep
	signal reqInvStepMoveto: std_logic;
	signal ackInvStepMoveto: std_logic;

	-- myHostif to myStep
	signal reqInvStepSet: std_logic;
	signal ackInvStepSet: std_logic;

	-- myHostif to myStep
	signal reqInvStepZero: std_logic;
	signal ackInvStepZero: std_logic;

	-- myHostif to myTkclksrc
	signal reqInvTkclksrcSetTkst: std_logic;
	signal ackInvTkclksrcSetTkst: std_logic;

	-- myHostif to myCamacq
	signal reqInvCamacqSetGrrd: std_logic;
	signal ackInvCamacqSetGrrd: std_logic;

	-- myHostif to myCamacq
	signal reqInvCamacqSetPvw: std_logic;
	signal ackInvCamacqSetPvw: std_logic;

	-- myHostif to myCamif
	signal reqInvCamifSetRng: std_logic;
	signal ackInvCamifSetRng: std_logic;

	-- myHostif to myCamif
	signal reqInvCamifSetReg: std_logic;
	signal ackInvCamifSetReg: std_logic;

	-- myHostif to myCamif
	signal reqInvCamifSetRegaddr: std_logic;
	signal ackInvCamifSetRegaddr: std_logic;

	-- myHostif to myCamif
	signal reqInvCamifGetReg: std_logic;
	signal ackInvCamifGetReg: std_logic;

	-- myHostif to myCamif
	signal reqInvCamifModReg: std_logic;
	signal ackInvCamifModReg: std_logic;

	-- myHostif to myFeatdet
	signal reqInvFeatdetSet: std_logic;
	signal ackInvFeatdetSet: std_logic;

	-- myHostif to myFeatdet
	signal reqInvFeatdetSetCorner: std_logic;
	signal ackInvFeatdetSetCorner: std_logic;

	-- myHostif to myFeatdet
	signal reqInvFeatdetSetThd: std_logic;
	signal ackInvFeatdetSetThd: std_logic;

	-- myHostif to myFeatdet
	signal reqInvFeatdetTriggerThd: std_logic;
	signal ackInvFeatdetTriggerThd: std_logic;

	-- myFeatdet to myCamacq
	signal reqGrrdabbufCamacqToFeatdet: std_logic;
	signal ackGrrdabbufCamacqToFeatdet: std_logic;
	signal dneGrrdabbufCamacqToFeatdet: std_logic;

	-- myFeatdet to myCamacq
	signal reqGrrdcdbufCamacqToFeatdet: std_logic;
	signal ackGrrdcdbufCamacqToFeatdet: std_logic;
	signal dneGrrdcdbufCamacqToFeatdet: std_logic;

	-- myFeatdet to myCamacq
	signal reqGrrdefbufCamacqToFeatdet: std_logic;
	signal ackGrrdefbufCamacqToFeatdet: std_logic;
	signal dneGrrdefbufCamacqToFeatdet: std_logic;

	-- myHostif to myCamacq
	signal reqPvwabufCamacqToHostif: std_logic;
	signal ackPvwabufCamacqToHostif: std_logic;
	signal dnePvwabufCamacqToHostif: std_logic;

	-- myHostif to myCamacq
	signal reqPvwbbufCamacqToHostif: std_logic;
	signal ackPvwbbufCamacqToHostif: std_logic;
	signal dnePvwbbufCamacqToHostif: std_logic;

	-- myHostif to myFeatdet
	signal reqFlgbufFeatdetToHostif: std_logic;
	signal ackFlgbufFeatdetToHostif: std_logic;
	signal dneFlgbufFeatdetToHostif: std_logic;

	---- other
	signal rgb5: std_logic_vector(23 downto 0);
	signal camacqPixclk_dbg: std_logic;
	signal camacqStrb_dbg: std_logic_vector(3 downto 0);
	signal featdetStrb_dbg: std_logic_vector(3 downto 0);

	signal bcddbg0: std_logic_vector(7 downto 0);
	signal bcddbg1: std_logic_vector(7 downto 0);
	signal bcddbg2: std_logic_vector(7 downto 0);
	signal bcddbg3: std_logic_vector(7 downto 0);
	-- IP sigs.oth.cust --- IBEGIN

	signal camacqStateOp_dbg: std_logic_vector(7 downto 0);
	signal camacqStatePvwrawgray_dbg: std_logic_vector(7 downto 0);
	signal hostifStateOp_dbg: std_logic_vector(7 downto 0);
	-- IP sigs.oth.cust --- IEND

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myBcdfreqDbg0 : Bcdfreq_v1_0
		generic map (
			fMclk => fMclk
		)
		port map (
			reset => reset,
			mclk => mclk,

			high => bcddbg0(7 downto 4),
			low => bcddbg0(3 downto 0),

			freq => dbg0
		);

	myBcdfreqDbg1 : Bcdfreq_v1_0
		generic map (
			fMclk => fMclk
		)
		port map (
			reset => reset,
			mclk => mclk,

			high => bcddbg1(7 downto 4),
			low => bcddbg1(3 downto 0),

			freq => dbg1
		);

	myCamacq : Camacq
		port map (
			reset => reset,
			mclk => mclk,

			tkclksrcGetTkstTkst => tkclksrcGetTkstTkst,

			reqInvSetGrrd => reqInvCamacqSetGrrd,
			ackInvSetGrrd => ackInvCamacqSetGrrd,

			setGrrdRng => camacqSetGrrdRng,
			setGrrdRedNotGray => camacqSetGrrdRedNotGray,

			getGrrdinfoTixVGrrdbufstate => camacqGetGrrdinfoTixVGrrdbufstate,
			getGrrdinfoTkst => camacqGetGrrdinfoTkst,

			reqInvSetPvw => reqInvCamacqSetPvw,
			ackInvSetPvw => ackInvCamacqSetPvw,

			setPvwRng => camacqSetPvwRng,
			setPvwRawNotBin => camacqSetPvwRawNotBin,
			setPvwGrayNotRgb => camacqSetPvwGrayNotRgb,

			getPvwinfoTixVPvwbufstate => camacqGetPvwinfoTixVPvwbufstate,
			getPvwinfoTkst => camacqGetPvwinfoTkst,

			reqGrrdabbufToFeatdet => reqGrrdabbufCamacqToFeatdet,
			ackGrrdabbufToFeatdet => ackGrrdabbufCamacqToFeatdet,

			reqGrrdcdbufToFeatdet => reqGrrdcdbufCamacqToFeatdet,

			dneGrrdabbufToFeatdet => dneGrrdabbufCamacqToFeatdet,
			avllenGrrdabbufToFeatdet => avllenGrrdabbufCamacqToFeatdet,

			ackGrrdcdbufToFeatdet => ackGrrdcdbufCamacqToFeatdet,
			dneGrrdcdbufToFeatdet => dneGrrdcdbufCamacqToFeatdet,

			dGrrdabbufToFeatdet => dGrrdabbufCamacqToFeatdet,

			avllenGrrdcdbufToFeatdet => avllenGrrdcdbufCamacqToFeatdet,

			strbDGrrdabbufToFeatdet => strbDGrrdabbufCamacqToFeatdet,

			dGrrdcdbufToFeatdet => dGrrdcdbufCamacqToFeatdet,
			strbDGrrdcdbufToFeatdet => strbDGrrdcdbufCamacqToFeatdet,

			reqGrrdefbufToFeatdet => reqGrrdefbufCamacqToFeatdet,
			ackGrrdefbufToFeatdet => ackGrrdefbufCamacqToFeatdet,
			dneGrrdefbufToFeatdet => dneGrrdefbufCamacqToFeatdet,
			avllenGrrdefbufToFeatdet => avllenGrrdefbufCamacqToFeatdet,

			dGrrdefbufToFeatdet => dGrrdefbufCamacqToFeatdet,

			reqPvwabufToHostif => reqPvwabufCamacqToHostif,

			strbDGrrdefbufToFeatdet => strbDGrrdefbufCamacqToFeatdet,

			ackPvwabufToHostif => ackPvwabufCamacqToHostif,
			dnePvwabufToHostif => dnePvwabufCamacqToHostif,
			avllenPvwabufToHostif => avllenPvwabufCamacqToHostif,

			dPvwabufToHostif => dPvwabufCamacqToHostif,
			strbDPvwabufToHostif => strbDPvwabufCamacqToHostif,

			reqPvwbbufToHostif => reqPvwbbufCamacqToHostif,
			ackPvwbbufToHostif => ackPvwbbufCamacqToHostif,
			dnePvwbbufToHostif => dnePvwbbufCamacqToHostif,
			avllenPvwbbufToHostif => avllenPvwbbufCamacqToHostif,

			dPvwbbufToHostif => dPvwbbufCamacqToHostif,
			strbDPvwbbufToHostif => strbDPvwbbufCamacqToHostif,

			csi_clk_p => csi_clk_p,
			csi_clk_n => csi_clk_n,

			csi_d0_p => csi_d0_p,
			csi_d0_n => csi_d0_n,

			csi_d1_p => csi_d1_p,
			csi_d1_n => csi_d1_n,

			csi_d2_p => csi_d2_p,
			csi_d2_n => csi_d2_n,

			csi_d3_p => csi_d3_p,
			csi_d3_n => csi_d3_n,

			rx_clk_p => csi_clk_p,
			rx_clk_n => csi_clk_n,

			pixclk_dbg => camacqPixclk_dbg,
			strb_dbg => camacqStrb_dbg
		);

	myCamif : Camif
		generic map (
			fMclk => fMclk -- in kHz
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,
			rng => camrng,

			reqInvSetRng => reqInvCamifSetRng,
			ackInvSetRng => ackInvCamifSetRng,

			setRngRng => camifSetRngRng,

			reqInvSetReg => reqInvCamifSetReg,
			ackInvSetReg => ackInvCamifSetReg,

			setRegAddr => camifSetRegAddr,
			setRegVal => camifSetRegVal,

			reqInvSetRegaddr => reqInvCamifSetRegaddr,
			ackInvSetRegaddr => ackInvCamifSetRegaddr,

			setRegaddrAddr => camifSetRegaddrAddr,

			reqInvGetReg => reqInvCamifGetReg,
			ackInvGetReg => ackInvCamifGetReg,

			getRegVal => camifGetRegVal,

			reqInvModReg => reqInvCamifModReg,
			ackInvModReg => ackInvCamifModReg,

			modRegAddr => camifModRegAddr,
			modRegMask => camifModRegMask,
			modRegVal => camifModRegVal,

			scl => scl,
			sda => sda
		);

	myCccMclk : Ccc_div2_5
		port map (
			PLL_POWERDOWN_N_0 => '0',
			REF_CLK_0 => extclk,
			OUT0_FABCLK_0 => mclk,
			PLL_LOCK_0 => open
		);

	myDebounceBtn0 : Debounce_v1_0
		generic map (
			invert => true,
			tdead => 100
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			noisy => btn0,
			clean => btn0_sig
		);

	myDebounceBtn1 : Debounce_v1_0
		generic map (
			invert => true,
			tdead => 100
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			noisy => btn1,
			clean => reqResetBtn1
		);

	myFeatdet : Featdet
		port map (
			reset => reset,
			mclk => mclk,

			camacqGetGrrdinfoTixVGrrdbufstate => camacqGetGrrdinfoTixVGrrdbufstate,
			camacqGetGrrdinfoTkst => camacqGetGrrdinfoTkst,

			reqInvSet => reqInvFeatdetSet,
			ackInvSet => ackInvFeatdetSet,

			setRng => featdetSetRng,
			setThdNotCorner => featdetSetThdNotCorner,
			setThdDeltaNotAbs => featdetSetThdDeltaNotAbs,

			getInfoTixVFlgbufstate => featdetGetInfoTixVFlgbufstate,
			getInfoTixVThdstate => featdetGetInfoTixVThdstate,
			getInfoTkst => featdetGetInfoTkst,

			getCornerinfoShift => featdetGetCornerinfoShift,
			getCornerinfoScoreMin => featdetGetCornerinfoScoreMin,
			getCornerinfoScoreMax => featdetGetCornerinfoScoreMax,

			reqInvSetCorner => reqInvFeatdetSetCorner,
			ackInvSetCorner => ackInvFeatdetSetCorner,

			setCornerLinNotLog => featdetSetCornerLinNotLog,
			setCornerThd => featdetSetCornerThd,

			reqInvSetThd => reqInvFeatdetSetThd,
			ackInvSetThd => ackInvFeatdetSetThd,

			setThdLvlFirst => featdetSetThdLvlFirst,
			setThdLvlSecond => featdetSetThdLvlSecond,

			reqInvTriggerThd => reqInvFeatdetTriggerThd,
			ackInvTriggerThd => ackInvFeatdetTriggerThd,

			reqGrrdabbufFromCamacq => reqGrrdabbufCamacqToFeatdet,
			ackGrrdabbufFromCamacq => ackGrrdabbufCamacqToFeatdet,

			reqGrrdcdbufFromCamacq => reqGrrdcdbufCamacqToFeatdet,

			dneGrrdabbufFromCamacq => dneGrrdabbufCamacqToFeatdet,

			avllenGrrdabbufFromCamacq => avllenGrrdabbufCamacqToFeatdet,

			ackGrrdcdbufFromCamacq => ackGrrdcdbufCamacqToFeatdet,
			dneGrrdcdbufFromCamacq => dneGrrdcdbufCamacqToFeatdet,

			dGrrdabbufFromCamacq => dGrrdabbufCamacqToFeatdet,

			avllenGrrdcdbufFromCamacq => avllenGrrdcdbufCamacqToFeatdet,

			strbDGrrdabbufFromCamacq => strbDGrrdabbufCamacqToFeatdet,

			dGrrdcdbufFromCamacq => dGrrdcdbufCamacqToFeatdet,
			strbDGrrdcdbufFromCamacq => strbDGrrdcdbufCamacqToFeatdet,

			reqGrrdefbufFromCamacq => reqGrrdefbufCamacqToFeatdet,
			ackGrrdefbufFromCamacq => ackGrrdefbufCamacqToFeatdet,
			dneGrrdefbufFromCamacq => dneGrrdefbufCamacqToFeatdet,

			avllenGrrdefbufFromCamacq => avllenGrrdefbufCamacqToFeatdet,

			dGrrdefbufFromCamacq => dGrrdefbufCamacqToFeatdet,
			strbDGrrdefbufFromCamacq => strbDGrrdefbufCamacqToFeatdet,

			reqFlgbufToHostif => reqFlgbufFeatdetToHostif,
			ackFlgbufToHostif => ackFlgbufFeatdetToHostif,
			dneFlgbufToHostif => dneFlgbufFeatdetToHostif,
			avllenFlgbufToHostif => avllenFlgbufFeatdetToHostif,

			dFlgbufToHostif => dFlgbufFeatdetToHostif,
			strbDFlgbufToHostif => strbDFlgbufFeatdetToHostif,

			strb_dbg => featdetStrb_dbg
		);

	myHostif : Hostif
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,
			commok => commok,
			reqReset => reqResetFromHostif,

			reqInvLaserSet => reqInvLaserSet,
			ackInvLaserSet => ackInvLaserSet,

			laserSetL => laserSetL,
			laserSetR => laserSetR,

			pwmonifGetTixVState => pwmonifGetTixVState,
			pwmonifGetRxleft => pwmonifGetRxleft,
			pwmonifGetLenRxdata => pwmonifGetLenRxdata,
			pwmonifGetRxdata => pwmonifGetRxdata,

			reqInvPwmonifRx => reqInvPwmonifRx,
			ackInvPwmonifRx => ackInvPwmonifRx,

			pwmonifRxLen => pwmonifRxLen,
			pwmonifRxTo => pwmonifRxTo,

			reqInvPwmonifTx => reqInvPwmonifTx,
			ackInvPwmonifTx => ackInvPwmonifTx,

			pwmonifTxLenData => pwmonifTxLenData,
			pwmonifTxData => pwmonifTxData,

			reqInvPwmonifTxrx => reqInvPwmonifTxrx,
			ackInvPwmonifTxrx => ackInvPwmonifTxrx,

			pwmonifTxrxLenTxdata => pwmonifTxrxLenTxdata,
			pwmonifTxrxTxdata => pwmonifTxrxTxdata,
			pwmonifTxrxRxlen => pwmonifTxrxRxlen,
			pwmonifTxrxRxto => pwmonifTxrxRxto,

			stateGetTixVIcclState => stateGetTixVIcclState,

			stepGetInfoTixVState => stepGetInfoTixVState,
			stepGetInfoAngle => stepGetInfoAngle,

			reqInvStepMoveto => reqInvStepMoveto,
			ackInvStepMoveto => ackInvStepMoveto,

			stepMovetoAngle => stepMovetoAngle,
			stepMovetoTstep => stepMovetoTstep,

			reqInvStepSet => reqInvStepSet,
			ackInvStepSet => ackInvStepSet,

			stepSetRng => stepSetRng,
			stepSetCcwNotCw => stepSetCcwNotCw,
			stepSetTstep => stepSetTstep,

			reqInvStepZero => reqInvStepZero,
			ackInvStepZero => ackInvStepZero,

			tkclksrcGetTkstTkst => tkclksrcGetTkstTkst,

			reqInvTkclksrcSetTkst => reqInvTkclksrcSetTkst,
			ackInvTkclksrcSetTkst => ackInvTkclksrcSetTkst,

			tkclksrcSetTkstTkst => tkclksrcSetTkstTkst,

			reqInvCamacqSetGrrd => reqInvCamacqSetGrrd,
			ackInvCamacqSetGrrd => ackInvCamacqSetGrrd,

			camacqSetGrrdRng => camacqSetGrrdRng,
			camacqSetGrrdRedNotGray => camacqSetGrrdRedNotGray,

			camacqGetGrrdinfoTixVGrrdbufstate => camacqGetGrrdinfoTixVGrrdbufstate,
			camacqGetGrrdinfoTkst => camacqGetGrrdinfoTkst,

			reqInvCamacqSetPvw => reqInvCamacqSetPvw,
			ackInvCamacqSetPvw => ackInvCamacqSetPvw,

			camacqSetPvwRng => camacqSetPvwRng,
			camacqSetPvwRawNotBin => camacqSetPvwRawNotBin,
			camacqSetPvwGrayNotRgb => camacqSetPvwGrayNotRgb,

			camacqGetPvwinfoTixVPvwbufstate => camacqGetPvwinfoTixVPvwbufstate,
			camacqGetPvwinfoTkst => camacqGetPvwinfoTkst,

			reqInvCamifSetRng => reqInvCamifSetRng,
			ackInvCamifSetRng => ackInvCamifSetRng,

			camifSetRngRng => camifSetRngRng,

			reqInvCamifSetReg => reqInvCamifSetReg,
			ackInvCamifSetReg => ackInvCamifSetReg,

			camifSetRegAddr => camifSetRegAddr,
			camifSetRegVal => camifSetRegVal,

			reqInvCamifSetRegaddr => reqInvCamifSetRegaddr,
			ackInvCamifSetRegaddr => ackInvCamifSetRegaddr,

			camifSetRegaddrAddr => camifSetRegaddrAddr,

			reqInvCamifGetReg => reqInvCamifGetReg,
			ackInvCamifGetReg => ackInvCamifGetReg,

			camifGetRegVal => camifGetRegVal,

			reqInvCamifModReg => reqInvCamifModReg,
			ackInvCamifModReg => ackInvCamifModReg,

			camifModRegAddr => camifModRegAddr,
			camifModRegMask => camifModRegMask,
			camifModRegVal => camifModRegVal,

			reqInvFeatdetSet => reqInvFeatdetSet,
			ackInvFeatdetSet => ackInvFeatdetSet,

			featdetSetRng => featdetSetRng,
			featdetSetThdNotCorner => featdetSetThdNotCorner,
			featdetSetThdDeltaNotAbs => featdetSetThdDeltaNotAbs,

			featdetGetInfoTixVFlgbufstate => featdetGetInfoTixVFlgbufstate,
			featdetGetInfoTixVThdstate => featdetGetInfoTixVThdstate,
			featdetGetInfoTkst => featdetGetInfoTkst,

			featdetGetCornerinfoShift => featdetGetCornerinfoShift,
			featdetGetCornerinfoScoreMin => featdetGetCornerinfoScoreMin,
			featdetGetCornerinfoScoreMax => featdetGetCornerinfoScoreMax,

			reqInvFeatdetSetCorner => reqInvFeatdetSetCorner,
			ackInvFeatdetSetCorner => ackInvFeatdetSetCorner,

			featdetSetCornerLinNotLog => featdetSetCornerLinNotLog,
			featdetSetCornerThd => featdetSetCornerThd,

			reqInvFeatdetSetThd => reqInvFeatdetSetThd,
			ackInvFeatdetSetThd => ackInvFeatdetSetThd,

			featdetSetThdLvlFirst => featdetSetThdLvlFirst,
			featdetSetThdLvlSecond => featdetSetThdLvlSecond,

			reqInvFeatdetTriggerThd => reqInvFeatdetTriggerThd,
			ackInvFeatdetTriggerThd => ackInvFeatdetTriggerThd,

			reqPvwabufFromCamacq => reqPvwabufCamacqToHostif,
			ackPvwabufFromCamacq => ackPvwabufCamacqToHostif,
			dnePvwabufFromCamacq => dnePvwabufCamacqToHostif,

			avllenPvwabufFromCamacq => avllenPvwabufCamacqToHostif,

			dPvwabufFromCamacq => dPvwabufCamacqToHostif,
			strbDPvwabufFromCamacq => strbDPvwabufCamacqToHostif,

			reqPvwbbufFromCamacq => reqPvwbbufCamacqToHostif,
			ackPvwbbufFromCamacq => ackPvwbbufCamacqToHostif,
			dnePvwbbufFromCamacq => dnePvwbbufCamacqToHostif,

			avllenPvwbbufFromCamacq => avllenPvwbbufCamacqToHostif,

			reqFlgbufFromFeatdet => reqFlgbufFeatdetToHostif,

			dPvwbbufFromCamacq => dPvwbbufCamacqToHostif,

			ackFlgbufFromFeatdet => ackFlgbufFeatdetToHostif,

			strbDPvwbbufFromCamacq => strbDPvwbbufCamacqToHostif,

			dneFlgbufFromFeatdet => dneFlgbufFeatdetToHostif,

			avllenFlgbufFromFeatdet => avllenFlgbufFeatdetToHostif,

			dFlgbufFromFeatdet => dFlgbufFeatdetToHostif,
			strbDFlgbufFromFeatdet => strbDFlgbufFeatdetToHostif,

			rdyRx => rdyRx,
			enRx => enRx,

			rx => rx,
			strbRx => strbRx,

			rdyTx => rdyTx,
			enTx => enTx,

			tx => tx,
			strbTx => strbTx,

			stateOp_dbg => open
		);

	myLaser : Laser
		generic map (
			fMclk => fMclk
		)
		port map (
			reset => reset,
			mclk => mclk,

			reqInvSet => reqInvLaserSet,
			ackInvSet => ackInvLaserSet,

			setL => laserSetL,
			setR => laserSetR,

			nss => cs,
			sclk => sclk,
			mosi => mosi
		);

	myPwmonif : Pwmonif
		generic map (
			fMclk => fMclk,
			fSclk => 9600,

			toRx => 100
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			getTixVState => pwmonifGetTixVState,
			getRxleft => pwmonifGetRxleft,
			getLenRxdata => pwmonifGetLenRxdata,
			getRxdata => pwmonifGetRxdata,

			reqInvRx => reqInvPwmonifRx,
			ackInvRx => ackInvPwmonifRx,

			rxLen => pwmonifRxLen,
			rxTo => pwmonifRxTo,

			reqInvTx => reqInvPwmonifTx,
			ackInvTx => ackInvPwmonifTx,

			txLenData => pwmonifTxLenData,
			txData => pwmonifTxData,

			reqInvTxrx => reqInvPwmonifTxrx,
			ackInvTxrx => ackInvPwmonifTxrx,

			txrxLenTxdata => pwmonifTxrxLenTxdata,
			txrxTxdata => pwmonifTxrxTxdata,
			txrxRxlen => pwmonifTxrxRxlen,
			txrxRxto => pwmonifTxrxRxto,

			rxd => pmnd_rxd,
			txd => pmnd_txd
		);

	myRgbled4 : Rgbled4
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,
			rgb => rgb4,
			r => led4_r,
			g => led4_g,
			b => open
		);

	myRgbled5 : Rgbled5
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,
			rgb => rgb5,
			r => led5_r,
			g => led5_g,
			b => open
		);

	myState : State
		port map (
			reset => reset,
			tkclk => tkclk,

			commok => commok,
			camrng => camrng,

			rgb => rgb4,

			getTixVIcclState => stateGetTixVIcclState
		);

	myStep : Step
		generic map (
			fMclk => fMclk -- in kHz
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			getInfoTixVState => stepGetInfoTixVState,
			getInfoAngle => stepGetInfoAngle,

			reqInvMoveto => reqInvStepMoveto,
			ackInvMoveto => ackInvStepMoveto,

			movetoAngle => stepMovetoAngle,
			movetoTstep => stepMovetoTstep,

			reqInvSet => reqInvStepSet,
			ackInvSet => ackInvStepSet,

			setRng => stepSetRng,
			setCcwNotCw => stepSetCcwNotCw,
			setTstep => stepSetTstep,

			reqInvZero => reqInvStepZero,
			ackInvZero => ackInvStepZero,

			nslp => nslp,
			m0 => m0,
			dir => dir,
			step0 => step0,
			nflt => nflt
		);

	myTkclksrc : Tkclksrc
		generic map (
			fMclk => fMclk
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			getTkstTkst => tkclksrcGetTkstTkst,

			reqInvSetTkst => reqInvTkclksrcSetTkst,
			ackInvSetTkst => ackInvTkclksrcSetTkst,

			setTkstTkst => tkclksrcSetTkstTkst
		);

	------------------------------------------------------------------------
	-- implementation: reset (rst)
	------------------------------------------------------------------------

	-- IP impl.rst.wiring --- BEGIN
	reset <= '1' when stateRst=stateRstReset else '0';
	-- IP impl.rst.wiring --- END

	-- IP impl.rst.rising --- BEGIN
	process (extresetn, mclk, stateRst)
		-- IP impl.rst.vars --- BEGIN
		constant imax: natural := 16;
		variable i: natural range 0 to imax := 0;
		-- IP impl.rst.vars --- END

	begin
		if extresetn='0' then
			stateRst <= stateRstReset;

			i := 0;

		elsif rising_edge(mclk) then
			if stateRst=stateRstReset then
				i := i + 1;

				if i=imax then
					stateRst <= stateRstRun;
				end if;

			elsif stateRst=stateRstRun then
				if reqResetFromHostif='1' or reqResetBtn1='1' then
					i := 0;
					stateRst <= stateRstReset;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.rst.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- IBEGIN
	--dbg0 <= enRx;
	--dbg1 <= strbRx;
	-- IP impl.oth.cust --- IEND

end Top;
