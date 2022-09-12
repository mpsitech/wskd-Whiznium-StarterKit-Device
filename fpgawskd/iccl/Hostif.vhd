-- file Hostif.vhd
-- Hostif axihostif_Easy_v2_0 easy model host interface implementation
-- copyright: (C) 2017-2020 MPSI Technologies GmbH
-- author: Catherine Johnson (auto-generation)
-- date created: 1 Dec 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Iccl.all;

entity Hostif is
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
end Hostif;

architecture Hostif of Hostif is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Crc8005_32_v1_0 is
		port (
			reset: in std_logic;
			mclk: in std_logic;

			req: in std_logic;
			ack: out std_logic;
			dne: out std_logic;

			captNotFin: in std_logic;

			d: in std_logic_vector(31 downto 0);
			lsbD: in std_logic_vector(1 downto 0);

			strbD: in std_logic;
			crc: out std_logic_vector(15 downto 0)
		);
	end component;

	component Axirx_v2_0 is
		port (
			reset: in std_logic;
			mclk: in std_logic;

			req: in std_logic;
			ack: out std_logic;
			dne: out std_logic;

			len: in std_logic_vector(21 downto 0);

			d: out std_logic_vector(31 downto 0);
			strbD: out std_logic;

			rdyRx: out std_logic;
			enRx: in std_logic;

			rx: in std_logic_vector(31 downto 0);
			strbRx: in std_logic
		);
	end component;

	component Timeout_v1_0 is
		generic (
			twait: natural range 1 to 10000 := 100
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			tkclk: in std_logic;

			restart: in std_logic;
			timeout: out std_logic
		);
	end component;

	component Axitx_v2_0 is
		port (
			reset: in std_logic;
			mclk: in std_logic;

			req: in std_logic;
			ack: out std_logic;
			dne: out std_logic;

			len: in std_logic_vector(21 downto 0);

			d: in std_logic_vector(31 downto 0);
			strbD: out std_logic;

			rdyTx: out std_logic;
			enTx: in std_logic;

			tx: out std_logic_vector(31 downto 0);
			strbTx: in std_logic
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	--- main operation
	type stateOp_t is (
		stateOpIdle,
		stateOpRxopA, stateOpRxopB, stateOpRxopC, stateOpRxopD, stateOpRxopE,
		stateOpVoidinv,
		stateOpPrepTxA, stateOpPrepTxB,
		stateOpTxA, stateOpTxB, stateOpTxC, stateOpTxD, stateOpTxE, stateOpTxF,
		stateOpTxbufA, stateOpTxbufB, stateOpTxbufC, stateOpTxbufD, stateOpTxbufE,
		stateOpTxbufF, stateOpTxbufG, stateOpTxbufH, stateOpTxbufI, stateOpTxbufJ,
		stateOpTxbufK,
		stateOpPrepRx,
		stateOpRxA, stateOpRxB, stateOpRxC, stateOpRxD,
		stateOpCopyRxA, stateOpCopyRxB,
		stateOpPrepRxbuf,
		stateOpRxbufA, stateOpRxbufB, stateOpRxbufC, stateOpRxbufD, stateOpRxbufE,
		stateOpTxackA, stateOpTxackB
	);
	signal stateOp: stateOp_t := stateOpIdle;

	constant sizeOpbuf: natural := 8; -- rounded up from 7
	constant lsbOpbuf: std_logic_vector(1 downto 0) := "10";
	type opbuf_t is array (0 to sizeOpbuf-1) of std_logic_vector(7 downto 0);
	signal opbuf: opbuf_t;

	constant sizeRxbuf: natural := 40;
	type rxbuf_t is array (0 to sizeRxbuf-1) of std_logic_vector(7 downto 0);
	signal rxbuf: rxbuf_t;

	constant sizeTxbuf: natural := 40;
	type txbuf_t is array (0 to sizeTxbuf-1) of std_logic_vector(7 downto 0);
	signal txbuf: txbuf_t;

	signal commok_sig: std_logic;
	
	signal reqReset_sig: std_logic;

	signal ackVoidinv: std_logic;
	signal ackInv: std_logic;

	signal reqTxbuf: std_logic;
	signal ackTxbuf: std_logic;
	signal dneTxbuf: std_logic;

	signal avllenTxbuf: natural range 0 to 65535; -- in 256byte blocks, i.e. max. 24MB-256byte

	signal dTxbuf: std_logic_vector(31 downto 0);
	signal strbDTxbuf: std_logic;

	signal reqRxbuf: std_logic;
	signal ackRxbuf: std_logic;
	signal dneRxbuf: std_logic;

	signal avllenRxbuf: natural range 0 to 65535;

	signal dRxbuf: std_logic_vector(31 downto 0);
	signal strbDRxbuf: std_logic;

	signal arxlen: std_logic_vector(21 downto 0);
	signal atxlen: std_logic_vector(21 downto 0);

	signal atxd: std_logic_vector(31 downto 0);

	signal crccaptNotFin: std_logic;

	signal crcd: std_logic_vector(31 downto 0);
	signal lsbCrcd: std_logic_vector(1 downto 0);

	signal strbCrcd: std_logic;
	signal torestart: std_logic;

	signal laserSetL_sig: std_logic_vector(15 downto 0);
	signal laserSetR_sig: std_logic_vector(15 downto 0);

	signal pwmonifRxLen_sig: std_logic_vector(7 downto 0);
	signal pwmonifRxTo_sig: std_logic_vector(15 downto 0);

	signal pwmonifTxLenData_sig: std_logic_vector(7 downto 0);
	signal pwmonifTxData_sig: std_logic_vector(255 downto 0);

	signal pwmonifTxrxLenTxdata_sig: std_logic_vector(7 downto 0);
	signal pwmonifTxrxTxdata_sig: std_logic_vector(255 downto 0);
	signal pwmonifTxrxRxlen_sig: std_logic_vector(7 downto 0);
	signal pwmonifTxrxRxto_sig: std_logic_vector(15 downto 0);

	signal stepMovetoAngle_sig: std_logic_vector(15 downto 0);
	signal stepMovetoTstep_sig: std_logic_vector(7 downto 0);

	signal stepSetRng_sig: std_logic_vector(7 downto 0);
	signal stepSetCcwNotCw_sig: std_logic_vector(7 downto 0);
	signal stepSetTstep_sig: std_logic_vector(7 downto 0);

	signal tkclksrcSetTkstTkst_sig: std_logic_vector(31 downto 0);

	signal camacqSetGrrdRng_sig: std_logic_vector(7 downto 0);
	signal camacqSetGrrdRedNotGray_sig: std_logic_vector(7 downto 0);

	signal camacqSetPvwRng_sig: std_logic_vector(7 downto 0);
	signal camacqSetPvwRawNotBin_sig: std_logic_vector(7 downto 0);
	signal camacqSetPvwGrayNotRgb_sig: std_logic_vector(7 downto 0);

	signal camifSetRngRng_sig: std_logic_vector(7 downto 0);

	signal camifSetRegAddr_sig: std_logic_vector(15 downto 0);
	signal camifSetRegVal_sig: std_logic_vector(7 downto 0);

	signal camifSetRegaddrAddr_sig: std_logic_vector(15 downto 0);

	signal camifModRegAddr_sig: std_logic_vector(15 downto 0);
	signal camifModRegMask_sig: std_logic_vector(7 downto 0);
	signal camifModRegVal_sig: std_logic_vector(7 downto 0);

	signal featdetSetRng_sig: std_logic_vector(7 downto 0);
	signal featdetSetThdNotCorner_sig: std_logic_vector(7 downto 0);
	signal featdetSetThdDeltaNotAbs_sig: std_logic_vector(7 downto 0);

	signal featdetSetCornerLinNotLog_sig: std_logic_vector(7 downto 0);
	signal featdetSetCornerThd_sig: std_logic_vector(7 downto 0);

	signal featdetSetThdLvlFirst_sig: std_logic_vector(7 downto 0);
	signal featdetSetThdLvlSecond_sig: std_logic_vector(7 downto 0);

	---- myCrc
	signal crc: std_logic_vector(15 downto 0);

	---- myRx
	signal arxd: std_logic_vector(31 downto 0);
	signal strbArxd: std_logic;

	---- myTimeout
	signal timeout: std_logic;

	---- myTimeout2
	signal timeout2: std_logic;

	---- myTx
	signal strbAtxd: std_logic;

	---- handshake
	-- op to myCrc
	signal reqCrc: std_logic;
	signal ackCrc: std_logic;
	signal dneCrc: std_logic;

	-- op to myRx
	signal reqArx: std_logic;
	signal ackArx: std_logic;
	signal dneArx: std_logic;

	-- op to myTx
	signal reqAtx: std_logic;
	signal ackAtx: std_logic;
	signal dneAtx: std_logic;

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myCrc : Crc8005_32_v1_0
		port map (
			reset => reset,
			mclk => mclk,

			req => reqCrc,
			ack => ackCrc,
			dne => dneCrc,

			captNotFin => crccaptNotFin,

			d => crcd,
			lsbD => lsbCrcd,

			strbD => strbCrcd,
			crc => crc
		);

	myRx : Axirx_v2_0
		port map (
			reset => reset,
			mclk => mclk,

			req => reqArx,
			ack => ackArx,
			dne => dneArx,

			len => arxlen,

			d => arxd,
			strbD => strbArxd,

			rdyRx => rdyRx,
			enRx => enRx,

			rx => rx,
			strbRx => strbRx
		);

	myTimeout : Timeout_v1_0
		generic map (
			twait => 100
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			restart => torestart,
			timeout => timeout
		);

	myTimeout2 : Timeout_v1_0
		generic map (
			twait => 1000
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			restart => torestart,
			timeout => timeout2
		);

	myTx : Axitx_v2_0
		port map (
			reset => reset,
			mclk => mclk,

			req => reqAtx,
			ack => ackAtx,
			dne => dneAtx,

			len => atxlen,

			d => atxd,
			strbD => strbAtxd,

			rdyTx => rdyTx,
			enTx => enTx,

			tx => tx,
			strbTx => strbTx
		);

	------------------------------------------------------------------------
	-- implementation: main operation 
	------------------------------------------------------------------------

	commok <= commok_sig;
	reqReset <= reqReset_sig;

	-- tx/ret command
	reqInvCamifGetReg <= '1' when (stateOp=stateOpVoidinv and opbuf(ixOpbufController)=tixVIcclControllerCamif and opbuf(ixOpbufCommand)=tixVCamifCommandGetReg) else '0';

	ackVoidinv <= ackInvCamifGetReg when (opbuf(ixOpbufController)=tixVIcclControllerCamif and opbuf(ixOpbufCommand)=tixVCamifCommandGetReg)
				else '0';

	-- rx/inv command
	reqInvCamacqSetGrrd <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerCamacq and opbuf(ixOpbufCommand)=tixVCamacqCommandSetGrrd) else '0';
	reqInvCamacqSetPvw <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerCamacq and opbuf(ixOpbufCommand)=tixVCamacqCommandSetPvw) else '0';
	reqInvCamifSetRng <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerCamif and opbuf(ixOpbufCommand)=tixVCamifCommandSetRng) else '0';
	reqInvCamifSetReg <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerCamif and opbuf(ixOpbufCommand)=tixVCamifCommandSetReg) else '0';
	reqInvCamifSetRegaddr <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerCamif and opbuf(ixOpbufCommand)=tixVCamifCommandSetRegaddr) else '0';
	reqInvCamifModReg <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerCamif and opbuf(ixOpbufCommand)=tixVCamifCommandModReg) else '0';
	reqInvFeatdetSet <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerFeatdet and opbuf(ixOpbufCommand)=tixVFeatdetCommandSet) else '0';
	reqInvFeatdetSetCorner <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerFeatdet and opbuf(ixOpbufCommand)=tixVFeatdetCommandSetCorner) else '0';
	reqInvFeatdetSetThd <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerFeatdet and opbuf(ixOpbufCommand)=tixVFeatdetCommandSetThd) else '0';
	reqInvFeatdetTriggerThd <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerFeatdet and opbuf(ixOpbufCommand)=tixVFeatdetCommandTriggerThd) else '0';
	reqInvLaserSet <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerLaser and opbuf(ixOpbufCommand)=tixVLaserCommandSet) else '0';
	reqInvPwmonifRx <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerPwmonif and opbuf(ixOpbufCommand)=tixVPwmonifCommandRx) else '0';
	reqInvPwmonifTx <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerPwmonif and opbuf(ixOpbufCommand)=tixVPwmonifCommandTx) else '0';
	reqInvPwmonifTxrx <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerPwmonif and opbuf(ixOpbufCommand)=tixVPwmonifCommandTxrx) else '0';
	reqInvStepMoveto <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerStep and opbuf(ixOpbufCommand)=tixVStepCommandMoveto) else '0';
	reqInvStepSet <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerStep and opbuf(ixOpbufCommand)=tixVStepCommandSet) else '0';
	reqInvStepZero <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerStep and opbuf(ixOpbufCommand)=tixVStepCommandZero) else '0';
	reqInvTkclksrcSetTkst <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVIcclControllerTkclksrc and opbuf(ixOpbufCommand)=tixVTkclksrcCommandSetTkst) else '0';

	ackInv <= ackInvCamacqSetGrrd when (opbuf(ixOpbufController)=tixVIcclControllerCamacq and opbuf(ixOpbufCommand)=tixVCamacqCommandSetGrrd)
				else ackInvCamacqSetPvw when (opbuf(ixOpbufController)=tixVIcclControllerCamacq and opbuf(ixOpbufCommand)=tixVCamacqCommandSetPvw)
				else ackInvCamifSetRng when (opbuf(ixOpbufController)=tixVIcclControllerCamif and opbuf(ixOpbufCommand)=tixVCamifCommandSetRng)
				else ackInvCamifSetReg when (opbuf(ixOpbufController)=tixVIcclControllerCamif and opbuf(ixOpbufCommand)=tixVCamifCommandSetReg)
				else ackInvCamifSetRegaddr when (opbuf(ixOpbufController)=tixVIcclControllerCamif and opbuf(ixOpbufCommand)=tixVCamifCommandSetRegaddr)
				else ackInvCamifModReg when (opbuf(ixOpbufController)=tixVIcclControllerCamif and opbuf(ixOpbufCommand)=tixVCamifCommandModReg)
				else ackInvFeatdetSet when (opbuf(ixOpbufController)=tixVIcclControllerFeatdet and opbuf(ixOpbufCommand)=tixVFeatdetCommandSet)
				else ackInvFeatdetSetCorner when (opbuf(ixOpbufController)=tixVIcclControllerFeatdet and opbuf(ixOpbufCommand)=tixVFeatdetCommandSetCorner)
				else ackInvFeatdetSetThd when (opbuf(ixOpbufController)=tixVIcclControllerFeatdet and opbuf(ixOpbufCommand)=tixVFeatdetCommandSetThd)
				else ackInvFeatdetTriggerThd when (opbuf(ixOpbufController)=tixVIcclControllerFeatdet and opbuf(ixOpbufCommand)=tixVFeatdetCommandTriggerThd)
				else ackInvLaserSet when (opbuf(ixOpbufController)=tixVIcclControllerLaser and opbuf(ixOpbufCommand)=tixVLaserCommandSet)
				else ackInvPwmonifRx when (opbuf(ixOpbufController)=tixVIcclControllerPwmonif and opbuf(ixOpbufCommand)=tixVPwmonifCommandRx)
				else ackInvPwmonifTx when (opbuf(ixOpbufController)=tixVIcclControllerPwmonif and opbuf(ixOpbufCommand)=tixVPwmonifCommandTx)
				else ackInvPwmonifTxrx when (opbuf(ixOpbufController)=tixVIcclControllerPwmonif and opbuf(ixOpbufCommand)=tixVPwmonifCommandTxrx)
				else ackInvStepMoveto when (opbuf(ixOpbufController)=tixVIcclControllerStep and opbuf(ixOpbufCommand)=tixVStepCommandMoveto)
				else ackInvStepSet when (opbuf(ixOpbufController)=tixVIcclControllerStep and opbuf(ixOpbufCommand)=tixVStepCommandSet)
				else ackInvStepZero when (opbuf(ixOpbufController)=tixVIcclControllerStep and opbuf(ixOpbufCommand)=tixVStepCommandZero)
				else ackInvTkclksrcSetTkst when (opbuf(ixOpbufController)=tixVIcclControllerTkclksrc and opbuf(ixOpbufCommand)=tixVTkclksrcCommandSetTkst)
				else '0';

	-- tx buffer
	reqFlgbufFromFeatdet <= reqTxbuf when opbuf(ixOpbufBuffer)=tixWIcclBufferFlgbufFeatdetToHostif else '0';
	reqPvwabufFromCamacq <= reqTxbuf when opbuf(ixOpbufBuffer)=tixWIcclBufferPvwabufCamacqToHostif else '0';
	reqPvwbbufFromCamacq <= reqTxbuf when opbuf(ixOpbufBuffer)=tixWIcclBufferPvwbbufCamacqToHostif else '0';

	ackTxbuf <= ackFlgbufFromFeatdet when opbuf(ixOpbufBuffer)=tixWIcclBufferFlgbufFeatdetToHostif
				else ackPvwabufFromCamacq when opbuf(ixOpbufBuffer)=tixWIcclBufferPvwabufCamacqToHostif
				else ackPvwbbufFromCamacq when opbuf(ixOpbufBuffer)=tixWIcclBufferPvwbbufCamacqToHostif
				else '0';

	dneFlgbufFromFeatdet <= dneTxbuf when opbuf(ixOpbufBuffer)=tixWIcclBufferFlgbufFeatdetToHostif else '0';
	dnePvwabufFromCamacq <= dneTxbuf when opbuf(ixOpbufBuffer)=tixWIcclBufferPvwabufCamacqToHostif else '0';
	dnePvwbbufFromCamacq <= dneTxbuf when opbuf(ixOpbufBuffer)=tixWIcclBufferPvwbbufCamacqToHostif else '0';

	avllenTxbuf <= to_integer(unsigned(avllenFlgbufFromFeatdet)) when opbuf(ixOpbufBuffer)=tixWIcclBufferFlgbufFeatdetToHostif
				else to_integer(unsigned(avllenPvwabufFromCamacq)) when opbuf(ixOpbufBuffer)=tixWIcclBufferPvwabufCamacqToHostif
				else to_integer(unsigned(avllenPvwbbufFromCamacq)) when opbuf(ixOpbufBuffer)=tixWIcclBufferPvwbbufCamacqToHostif
				else 0;

	dTxbuf <= dFlgbufFromFeatdet(7 downto 0) & dFlgbufFromFeatdet(15 downto 8) & dFlgbufFromFeatdet(23 downto 16) & dFlgbufFromFeatdet(31 downto 24) when opbuf(ixOpbufBuffer)=tixWIcclBufferFlgbufFeatdetToHostif
				else dPvwabufFromCamacq(7 downto 0) & dPvwabufFromCamacq(15 downto 8) & dPvwabufFromCamacq(23 downto 16) & dPvwabufFromCamacq(31 downto 24) when opbuf(ixOpbufBuffer)=tixWIcclBufferPvwabufCamacqToHostif
				else dPvwbbufFromCamacq(7 downto 0) & dPvwbbufFromCamacq(15 downto 8) & dPvwbbufFromCamacq(23 downto 16) & dPvwbbufFromCamacq(31 downto 24) when opbuf(ixOpbufBuffer)=tixWIcclBufferPvwbbufCamacqToHostif
				else (others => '0');

	strbDFlgbufFromFeatdet <= strbDTxbuf when opbuf(ixOpbufBuffer)=tixWIcclBufferFlgbufFeatdetToHostif else '0';
	strbDPvwabufFromCamacq <= strbDTxbuf when opbuf(ixOpbufBuffer)=tixWIcclBufferPvwabufCamacqToHostif else '0';
	strbDPvwbbufFromCamacq <= strbDTxbuf when opbuf(ixOpbufBuffer)=tixWIcclBufferPvwbbufCamacqToHostif else '0';

	-- rx buffer

	ackRxbuf <= '0';

	avllenRxbuf <= 0;

	-- IP impl.op.wiring --- BEGIN
	laserSetL <= laserSetL_sig;
	laserSetR <= laserSetR_sig;

	pwmonifRxLen <= pwmonifRxLen_sig;
	pwmonifRxTo <= pwmonifRxTo_sig;

	pwmonifTxLenData <= pwmonifTxLenData_sig;
	pwmonifTxData <= pwmonifTxData_sig;

	pwmonifTxrxLenTxdata <= pwmonifTxrxLenTxdata_sig;
	pwmonifTxrxTxdata <= pwmonifTxrxTxdata_sig;
	pwmonifTxrxRxlen <= pwmonifTxrxRxlen_sig;
	pwmonifTxrxRxto <= pwmonifTxrxRxto_sig;

	stepMovetoAngle <= stepMovetoAngle_sig;
	stepMovetoTstep <= stepMovetoTstep_sig;

	stepSetRng <= stepSetRng_sig;
	stepSetCcwNotCw <= stepSetCcwNotCw_sig;
	stepSetTstep <= stepSetTstep_sig;

	tkclksrcSetTkstTkst <= tkclksrcSetTkstTkst_sig;

	camacqSetGrrdRng <= camacqSetGrrdRng_sig;
	camacqSetGrrdRedNotGray <= camacqSetGrrdRedNotGray_sig;

	camacqSetPvwRng <= camacqSetPvwRng_sig;
	camacqSetPvwRawNotBin <= camacqSetPvwRawNotBin_sig;
	camacqSetPvwGrayNotRgb <= camacqSetPvwGrayNotRgb_sig;

	camifSetRngRng <= camifSetRngRng_sig;

	camifSetRegAddr <= camifSetRegAddr_sig;
	camifSetRegVal <= camifSetRegVal_sig;

	camifSetRegaddrAddr <= camifSetRegaddrAddr_sig;

	camifModRegAddr <= camifModRegAddr_sig;
	camifModRegMask <= camifModRegMask_sig;
	camifModRegVal <= camifModRegVal_sig;

	featdetSetRng <= featdetSetRng_sig;
	featdetSetThdNotCorner <= featdetSetThdNotCorner_sig;
	featdetSetThdDeltaNotAbs <= featdetSetThdDeltaNotAbs_sig;

	featdetSetCornerLinNotLog <= featdetSetCornerLinNotLog_sig;
	featdetSetCornerThd <= featdetSetCornerThd_sig;

	featdetSetThdLvlFirst <= featdetSetThdLvlFirst_sig;
	featdetSetThdLvlSecond <= featdetSetThdLvlSecond_sig;
	-- IP impl.op.wiring --- END

	reqCrc <= '1' when (stateOp=stateOpRxopA or stateOp=stateOpRxopB or stateOp=stateOpRxopC or stateOp=stateOpRxopD or stateOp=stateOpRxopE
				or stateOp=stateOpRxA or stateOp=stateOpRxB or stateOp=stateOpRxC or stateOp=stateOpRxD
				-- or stateOp=stateOpTxA or stateOp=stateOpTxB or stateOp=stateOpTxC or stateOp=stateOpTxD or stateOp=stateOpTxE or stateOp=stateOpTxF
				or stateOp=stateOpTxbufB or stateOp=stateOpTxbufC or stateOp=stateOpTxbufD or stateOp=stateOpTxbufE or stateOp=stateOpTxbufF
				or stateOp=stateOpTxbufG or stateOp=stateOpTxbufH or stateOp=stateOpTxbufI or stateOp=stateOpTxbufJ
				or stateOp=stateOpRxbufA or stateOp=stateOpRxbufB or stateOp=stateOpRxbufC or stateOp=stateOpRxbufD) else '0';

	crccaptNotFin <= '1' when (stateOp=stateOpRxopA or stateOp=stateOpRxopB or stateOp=stateOpRxopC
				or stateOp=stateOpRxA or stateOp=stateOpRxB or stateOp=stateOpRxC
				-- or stateOp=stateOpTxA or stateOp=stateOpTxB or stateOp=stateOpTxC
				or stateOp=stateOpTxbufB or stateOp=stateOpTxbufC or stateOp=stateOpTxbufD or stateOp=stateOpTxbufE or stateOp=stateOpTxbufF or stateOp=stateOpTxbufG
				or stateOp=stateOpRxbufA or stateOp=stateOpRxbufB or stateOp=stateOpRxbufC) else '0';

	strbCrcd <= '1' when (stateOp=stateOpRxopC or stateOp=stateOpRxC or stateOp=stateOpTxB or stateOp=stateOpTxbufC or stateOp=stateOpRxbufC) else '0';

	reqArx <= '1' when (stateOp=stateOpRxopA or stateOp=stateOpRxopB or stateOp=stateOpRxopC or stateOp=stateOpRxopD
				or stateOp=stateOpRxA or stateOp=stateOpRxB or stateOp=stateOpRxC
				or stateOp=stateOpRxbufA or stateOp=stateOpRxbufB or stateOp=stateOpRxbufC) else '0';

	reqAtx <= '1' when (stateOp=stateOpTxA or stateOp=stateOpTxB or stateOp=stateOpTxC or stateOp=stateOpTxD or stateOp=stateOpTxE or stateOp=stateOpTxF
				or stateOp=stateOpTxbufB or stateOp=stateOpTxbufC or stateOp=stateOpTxbufD or stateOp=stateOpTxbufE or stateOp=stateOpTxbufF or stateOp=stateOpTxbufG or stateOp=stateOpTxbufH
				or stateOp=stateOpTxbufI or stateOp=stateOpTxbufJ
				or stateOp=stateOpTxackA or stateOp=stateOpTxackB) else '0';

	stateOp_dbg <= x"00" when stateOp=stateOpIdle
				else x"10" when stateOp=stateOpRxopA
				else x"11" when stateOp=stateOpRxopB
				else x"12" when stateOp=stateOpRxopC
				else x"13" when stateOp=stateOpRxopD
				else x"14" when stateOp=stateOpRxopE
				else x"20" when stateOp=stateOpVoidinv
				else x"30" when stateOp=stateOpPrepTxA
				else x"31" when stateOp=stateOpPrepTxB
				else x"40" when stateOp=stateOpTxA
				else x"41" when stateOp=stateOpTxB
				else x"42" when stateOp=stateOpTxC
				else x"43" when stateOp=stateOpTxD
				else x"44" when stateOp=stateOpTxE
				else x"45" when stateOp=stateOpTxF
				else x"50" when stateOp=stateOpTxbufA
				else x"51" when stateOp=stateOpTxbufB
				else x"52" when stateOp=stateOpTxbufC
				else x"53" when stateOp=stateOpTxbufD
				else x"54" when stateOp=stateOpTxbufE
				else x"55" when stateOp=stateOpTxbufF
				else x"56" when stateOp=stateOpTxbufG
				else x"57" when stateOp=stateOpTxbufH
				else x"58" when stateOp=stateOpTxbufI
				else x"59" when stateOp=stateOpTxbufJ
				else x"5A" when stateOp=stateOpTxbufK
				else x"60" when stateOp=stateOpPrepRx
				else x"70" when stateOp=stateOpRxA
				else x"71" when stateOp=stateOpRxB
				else x"72" when stateOp=stateOpRxC
				else x"73" when stateOp=stateOpRxD
				else x"80" when stateOp=stateOpCopyRxA
				else x"81" when stateOp=stateOpCopyRxB
				else x"90" when stateOp=stateOpPrepRxbuf
				else x"A0" when stateOp=stateOpRxbufA
				else x"A1" when stateOp=stateOpRxbufB
				else x"A2" when stateOp=stateOpRxbufC
				else x"A3" when stateOp=stateOpRxbufD
				else x"A4" when stateOp=stateOpRxbufE
				else x"B0" when stateOp=stateOpTxackA
				else x"B1" when stateOp=stateOpTxackB
				else x"FF";

	process (reset, mclk, stateOp)
		variable wordcnt: natural range 0 to 4194304;

		variable wordcntLast: natural range 0 to 4194304; -- (potentially incomplete) last word to be included in CRC
		variable lsb: std_logic_vector(1 downto 0); -- lsbCrcd for this last word

		variable length: std_logic_vector(15 downto 0);

	begin
		if reset='1' then
			stateOp <= stateOpIdle;
			torestart <= '0';
			crcd <= (others => '0');
			lsbCrcd <= (others => '0');
			arxlen <= (others => '0');
			atxlen <= (others => '0');
			atxd <= (others => '0');
			crcd <= (others => '0');
			lsbCrcd <= (others => '0');
			commok_sig <= '0';
			reqReset_sig <= '0';
			reqTxbuf <= '0';
			dneTxbuf <= '0';
			strbDTxbuf <= '0';
			reqRxbuf <= '0';
			dneRxbuf <= '0';
			dRxbuf <= (others => '0');
			strbDRxbuf <= '0';

			laserSetL_sig <= (others => '0');
			laserSetR_sig <= (others => '0');
			pwmonifRxLen_sig <= (others => '0');
			pwmonifRxTo_sig <= (others => '0');
			pwmonifTxLenData_sig <= x"32";
			pwmonifTxData_sig <= (others => '0');
			pwmonifTxrxLenTxdata_sig <= x"32";
			pwmonifTxrxTxdata_sig <= (others => '0');
			pwmonifTxrxRxlen_sig <= (others => '0');
			pwmonifTxrxRxto_sig <= (others => '0');
			stepMovetoAngle_sig <= (others => '0');
			stepMovetoTstep_sig <= x"60";
			stepSetRng_sig <= fls8;
			stepSetCcwNotCw_sig <= fls8;
			stepSetTstep_sig <= x"60";
			tkclksrcSetTkstTkst_sig <= (others => '0');
			camacqSetGrrdRng_sig <= fls8;
			camacqSetGrrdRedNotGray_sig <= fls8;
			camacqSetPvwRng_sig <= fls8;
			camacqSetPvwRawNotBin_sig <= fls8;
			camacqSetPvwGrayNotRgb_sig <= fls8;
			camifSetRngRng_sig <= fls8;
			camifSetRegAddr_sig <= (others => '0');
			camifSetRegVal_sig <= (others => '0');
			camifSetRegaddrAddr_sig <= (others => '0');
			camifModRegAddr_sig <= (others => '0');
			camifModRegMask_sig <= (others => '0');
			camifModRegVal_sig <= (others => '0');
			featdetSetRng_sig <= fls8;
			featdetSetThdNotCorner_sig <= fls8;
			featdetSetThdDeltaNotAbs_sig <= fls8;
			featdetSetCornerLinNotLog_sig <= (others => '0');
			featdetSetCornerThd_sig <= (others => '0');
			featdetSetThdLvlFirst_sig <= (others => '0');
			featdetSetThdLvlSecond_sig <= (others => '0');

		elsif rising_edge(mclk) then
			if stateOp=stateOpIdle then
				arxlen <= std_logic_vector(to_unsigned(sizeOpbuf/4, 22));
				crcd <= (others => '0');
				lsbCrcd <= "11";
				atxd <= (others => '0');
				reqTxbuf <= '0';
				dneTxbuf <= '0';
				strbDTxbuf <= '0';
				reqRxbuf <= '0';
				dneRxbuf <= '0';
				dRxbuf <= (others => '0');
				strbDRxbuf <= '0';

				wordcnt := 0;

				torestart <= '1';

				if ackArx='0' then
					wordcntLast := sizeOpbuf/4 - 1;

					stateOp <= stateOpRxopA;
				end if;

-- RX OP BEGIN
			elsif stateOp=stateOpRxopA then
				if (ackCrc='1' and ackArx='1') then
					stateOp <= stateOpRxopB;

				elsif timeout='1' then
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpRxopB then
				if ackArx='0' then
					stateOp <= stateOpIdle;

				elsif strbArxd='1' then
					for i in 0 to 3 loop
						opbuf(4*wordcnt+i) <= arxd((4-i)*8-1 downto (3-i)*8);
					end loop;

					if wordcnt=wordcntLast then
						lsbCrcd <= lsbOpbuf;
					end if;

					crcd <= arxd;

					if (wordcnt=0 and arxd(31 downto 24)=x"FF") then
						reqReset_sig <= '1';
					else
						torestart <= '1';

						stateOp <= stateOpRxopC;
					end if;
				end if;

			elsif stateOp=stateOpRxopC then -- strbCrcd='1'
				if strbArxd='0' then
					wordcnt := wordcnt + 1;
					stateOp <= stateOpRxopB;

				elsif dneArx='1' then
					stateOp <= stateOpRxopD;

				elsif timeout='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpRxopD then
				if dneCrc='1' then
					if crc=x"0000" then
						commok_sig <= '1';
						stateOp <= stateOpRxopE;
					else
						commok_sig <= '0';
						stateOp <= stateOpIdle;
					end if;
				end if;

			elsif stateOp=stateOpRxopE then
				length := opbuf(ixOpbufLength) & opbuf(ixOpbufLength+1);

				if opbuf(ixOpbufBuffer)=tixWIcclBufferCmdretToHostif then
					-- length: 2 bytes of CRC included, but excluded from CRC calculation
					if length(1 downto 0)="00" then
						lsb := "01";
					elsif length(1 downto 0)="01" then
						lsb := "10";
					elsif length(1 downto 0)="10" then
						lsb := "11";
					else
						lsb := "00";
					end if;

					wordcntLast := to_integer(unsigned(length(15 downto 2)));

					if (wordcntLast>0 and length(1 downto 0)/="00") then
						wordcntLast := wordcntLast - 1;
					end if;

					if wordcntLast=0 then
						lsbCrcd <= lsb;
					else
						lsbCrcd <= "11";
					end if;

					if length(1 downto 0)="00" then
						atxlen <= "00000000" & length(15 downto 2);
					else
						atxlen <= "00000000" & std_logic_vector(unsigned(length(15 downto 2)) + 1);
					end if;

					wordcnt := 0;

					if ( (opbuf(ixOpbufController)=tixVIcclControllerCamif and (opbuf(ixOpbufCommand)=tixVCamifCommandGetReg)) ) then

						stateOp <= stateOpVoidinv;

					elsif ( (opbuf(ixOpbufController)=tixVIcclControllerCamacq and (opbuf(ixOpbufCommand)=tixVCamacqCommandGetGrrdinfo or opbuf(ixOpbufCommand)=tixVCamacqCommandGetPvwinfo))
								or (opbuf(ixOpbufController)=tixVIcclControllerFeatdet and (opbuf(ixOpbufCommand)=tixVFeatdetCommandGetInfo or opbuf(ixOpbufCommand)=tixVFeatdetCommandGetCornerinfo))
								or (opbuf(ixOpbufController)=tixVIcclControllerPwmonif and (opbuf(ixOpbufCommand)=tixVPwmonifCommandGet))
								or (opbuf(ixOpbufController)=tixVIcclControllerState and (opbuf(ixOpbufCommand)=tixVStateCommandGet))
								or (opbuf(ixOpbufController)=tixVIcclControllerStep and (opbuf(ixOpbufCommand)=tixVStepCommandGetInfo))
								or (opbuf(ixOpbufController)=tixVIcclControllerTkclksrc and (opbuf(ixOpbufCommand)=tixVTkclksrcCommandGetTkst)) ) then

						stateOp <= stateOpPrepTxA;

					else
						stateOp <= stateOpIdle;
					end if;

				elsif opbuf(ixOpbufBuffer)=tixWIcclBufferHostifToCmdinv then
					if ( (opbuf(ixOpbufController)=tixVIcclControllerCamacq and (opbuf(ixOpbufCommand)=tixVCamacqCommandSetGrrd or opbuf(ixOpbufCommand)=tixVCamacqCommandSetPvw))
								or (opbuf(ixOpbufController)=tixVIcclControllerCamif and (opbuf(ixOpbufCommand)=tixVCamifCommandSetRng or opbuf(ixOpbufCommand)=tixVCamifCommandSetReg or opbuf(ixOpbufCommand)=tixVCamifCommandSetRegaddr or opbuf(ixOpbufCommand)=tixVCamifCommandModReg))
								or (opbuf(ixOpbufController)=tixVIcclControllerFeatdet and (opbuf(ixOpbufCommand)=tixVFeatdetCommandSet or opbuf(ixOpbufCommand)=tixVFeatdetCommandSetCorner or opbuf(ixOpbufCommand)=tixVFeatdetCommandSetThd or opbuf(ixOpbufCommand)=tixVFeatdetCommandTriggerThd))
								or (opbuf(ixOpbufController)=tixVIcclControllerLaser and (opbuf(ixOpbufCommand)=tixVLaserCommandSet))
								or (opbuf(ixOpbufController)=tixVIcclControllerPwmonif and (opbuf(ixOpbufCommand)=tixVPwmonifCommandRx or opbuf(ixOpbufCommand)=tixVPwmonifCommandTx or opbuf(ixOpbufCommand)=tixVPwmonifCommandTxrx))
								or (opbuf(ixOpbufController)=tixVIcclControllerStep and (opbuf(ixOpbufCommand)=tixVStepCommandMoveto or opbuf(ixOpbufCommand)=tixVStepCommandSet or opbuf(ixOpbufCommand)=tixVStepCommandZero))
								or (opbuf(ixOpbufController)=tixVIcclControllerTkclksrc and (opbuf(ixOpbufCommand)=tixVTkclksrcCommandSetTkst)) ) then

						-- length: 2 bytes of CRC included, also included in CRC calculation
						if length(1 downto 0)="00" then
							lsb := "11";
						elsif length(1 downto 0)="01" then
							lsb := "00";
						elsif length(1 downto 0)="10" then
							lsb := "01";
						else
							lsb := "10";
						end if;

						wordcntLast := to_integer(unsigned(length(15 downto 2)));

						if (wordcntLast>0 and length(1 downto 0)="00") then
							wordcntLast := wordcntLast - 1;
						end if;

						if wordcntLast=0 then
							lsbCrcd <= lsb;
						else
							lsbCrcd <= "11";
						end if;

						if length(1 downto 0)="00" then
							arxlen <= "00000000" & length(15 downto 2);
						else
							arxlen <= "00000000" & std_logic_vector(unsigned(length(15 downto 2)) + 1);
						end if;

						wordcnt := 0;

						stateOp <= stateOpPrepRx;

					else
						stateOp <= stateOpIdle;
					end if;

				elsif avllenTxbuf/=0 then
					-- length: in 256 byte blocks, 2 bytes of CRC excluded
					if length=std_logic_vector(to_unsigned(avllenTxbuf, 16)) then
						wordcntLast := to_integer(unsigned(length) & "000000");

						lsbCrcd <= "11";

						atxlen <= std_logic_vector(to_unsigned(wordcntLast + 1, 22));

						reqTxbuf <= '1';

						wordcnt := 0;

						stateOp <= stateOpTxbufA;

					else
						stateOp <= stateOpIdle;
					end if;

				elsif avllenRxbuf/=0 then
					-- length: in 256 byte blocks, 2 bytes of CRC excluded
					if length=std_logic_vector(to_unsigned(avllenRxbuf, 16)) then
						wordcntLast := to_integer(unsigned(length) & "000000");

						lsbCrcd <= "11";

						atxlen <= std_logic_vector(to_unsigned(wordcntLast + 1, 22));

						reqRxbuf <= '1';
						strbDRxbuf <= '0';

						wordcnt := 0;

						stateOp <= stateOpPrepRxbuf;

					else
						stateOp <= stateOpIdle;
					end if;
				end if;
-- RX OP END

			elsif stateOp=stateOpVoidinv then
				if ackVoidinv='1' then
					stateOp <= stateOpPrepTxA;
				end if;

-- TX BEGIN
			elsif stateOp=stateOpPrepTxA then -- arrive here if buffer=cmdretToHostif
				if opbuf(ixOpbufController)=tixVIcclControllerCamacq then
					if opbuf(ixOpbufCommand)=tixVCamacqCommandGetGrrdinfo then
						txbuf(0) <= camacqGetGrrdinfoTixVGrrdbufstate;
						for i in 0 to 3 loop
							txbuf(1+i) <= camacqGetGrrdinfoTkst((4-i)*8-1 downto (3-i)*8);
						end loop;
					elsif opbuf(ixOpbufCommand)=tixVCamacqCommandGetPvwinfo then
						txbuf(0) <= camacqGetPvwinfoTixVPvwbufstate;
						for i in 0 to 3 loop
							txbuf(1+i) <= camacqGetPvwinfoTkst((4-i)*8-1 downto (3-i)*8);
						end loop;
					end if;

				elsif opbuf(ixOpbufController)=tixVIcclControllerCamif then
					if opbuf(ixOpbufCommand)=tixVCamifCommandGetReg then
						txbuf(0) <= camifGetRegVal;
					end if;

				elsif opbuf(ixOpbufController)=tixVIcclControllerFeatdet then
					if opbuf(ixOpbufCommand)=tixVFeatdetCommandGetInfo then
						txbuf(0) <= featdetGetInfoTixVFlgbufstate;
						txbuf(1) <= featdetGetInfoTixVThdstate;
						for i in 0 to 3 loop
							txbuf(2+i) <= featdetGetInfoTkst((4-i)*8-1 downto (3-i)*8);
						end loop;
					elsif opbuf(ixOpbufCommand)=tixVFeatdetCommandGetCornerinfo then
						txbuf(0) <= featdetGetCornerinfoShift;
						txbuf(1) <= featdetGetCornerinfoScoreMin;
						txbuf(2) <= featdetGetCornerinfoScoreMax;
					end if;

				elsif opbuf(ixOpbufController)=tixVIcclControllerPwmonif then
					if opbuf(ixOpbufCommand)=tixVPwmonifCommandGet then
						txbuf(0) <= pwmonifGetTixVState;
						txbuf(1) <= pwmonifGetRxleft;
						txbuf(2) <= pwmonifGetLenRxdata;
						for i in 0 to 31 loop
							txbuf(3+i) <= pwmonifGetRxdata((32-i)*8-1 downto (31-i)*8);
						end loop;
					end if;

				elsif opbuf(ixOpbufController)=tixVIcclControllerState then
					if opbuf(ixOpbufCommand)=tixVStateCommandGet then
						txbuf(0) <= stateGetTixVIcclState;
					end if;

				elsif opbuf(ixOpbufController)=tixVIcclControllerStep then
					if opbuf(ixOpbufCommand)=tixVStepCommandGetInfo then
						txbuf(0) <= stepGetInfoTixVState;
						for i in 0 to 1 loop
							txbuf(1+i) <= stepGetInfoAngle((2-i)*8-1 downto (1-i)*8);
						end loop;
					end if;

				elsif opbuf(ixOpbufController)=tixVIcclControllerTkclksrc then
					if opbuf(ixOpbufCommand)=tixVTkclksrcCommandGetTkst then
						for i in 0 to 3 loop
							txbuf(i) <= tkclksrcGetTkstTkst((4-i)*8-1 downto (3-i)*8);
						end loop;
					end if;

				end if;

				-- for now, Tx CRC is disabled, 0xAAAA takes its place
				txbuf(to_integer(unsigned(length))-2) <= x"AA";
				txbuf(to_integer(unsigned(length))-1) <= x"AA";

				stateOp <= stateOpPrepTxB;

			elsif stateOp=stateOpPrepTxB then
				for i in 0 to 3 loop
					atxd((4-i)*8-1 downto (3-i)*8) <= txbuf(i);
					--crcd((4-i)*8-1 downto (3-i)*8) <= txbuf(i);
				end loop;

				torestart <= '1';

				stateOp <= stateOpTxA;

			elsif stateOp=stateOpTxA then -- reqCrc='1', captNotFin='1'
				--if (ackCrc='1' and ackAtx='1') then
				if ackAtx='1' then
					torestart <= '1';					
					stateOp <= stateOpTxB;

				elsif timeout2='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpTxB then -- strbCrcd='1'
				if ackAtx='0' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				elsif dneAtx='1' then
					stateOp <= stateOpIdle;

				elsif strbAtxd='0' then
					wordcnt := wordcnt + 1;

					for i in 0 to 3 loop
						atxd((4-i)*8-1 downto (3-i)*8) <= txbuf(4*wordcnt + i);
						crcd((4-i)*8-1 downto (3-i)*8) <= txbuf(4*wordcnt + i);
					end loop;

					stateOp <= stateOpTxC;

				elsif timeout='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpTxC then
				if ackAtx='0' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				elsif strbAtxd='1' then
					torestart <= '1';
					stateOp <= stateOpTxB;
				end if;

--			elsif stateOp=stateOpTxD then -- captNotFin='0'
--				if dneCrc='1' then
--					atxd <= (crc(15 downto 8) and x"55") or ((not crc(15 downto 8)) and x"AA");
--					stateOp <= stateOpTxF;
--				end if;

--			elsif stateOp=stateOpTxE then
--				if ackAtx='0' then
--					commok_sig <= '0';
--					stateOp <= stateOpIdle;

--				elsif dneAtx='1' then
--					stateOp <= stateOpIdle;

--				elsif strbAtxd='0' then
--					atxd <= (crc(7 downto 0) and x"55") or ((not crc(7 downto 0)) and x"AA"); -- i increment not required, only one byte left
--					stateOp <= stateOpTxF;

--				elsif timeout='1' then
--					commok_sig <= '0';
--					stateOp <= stateOpIdle;
	
--				else
--					torestart <= '0';
--				end if;

--			elsif stateOp=stateOpTxF then
--				if ackAtx='0' then
--					commok_sig <= '0';
--					stateOp <= stateOpIdle;

--				elsif strbAtxd='1' then
--					torestart <= '1';
--					stateOp <= stateOpTxE;
--				end if;
-- TX END

-- TX BUFFER BEGIN
			elsif stateOp=stateOpTxbufA then
				if ackTxbuf='1' then
					wordcnt := 0;

					atxd <= dTxbuf;

					torestart <= '1';
					stateOp <= stateOpTxbufB;
				end if;

			elsif stateOp=stateOpTxbufB then -- reqCrc='1', captNotFin='1'
				crcd <= atxd;

				if (ackCrc='1' and ackAtx='1') then
					torestart <= '1';
					stateOp <= stateOpTxbufC;

				elsif timeout2='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpTxbufC then -- strbCrcd='1'
				if ackAtx='0' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				elsif strbAtxd='0' then
					strbDTxbuf <= '1';

					wordcnt := wordcnt + 1; -- number of words put out to be tx'ed

					if wordcnt=wordcntLast then
						stateOp <= stateOpTxbufH; -- only CRC left for tx
					else
						stateOp <= stateOpTxbufD;
					end if;

				elsif timeout='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;
	
				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpTxbufD then
				strbDTxbuf <= '0';

				stateOp <= stateOpTxbufF;

			elsif stateOp=stateOpTxbufE then
				atxd <= dTxbuf;

				stateOp <= stateOpTxbufG;

			elsif stateOp=stateOpTxbufF then
				stateOp <= stateOpTxbufE;

			elsif stateOp=stateOpTxbufG then
				crcd <= atxd;

				if ackAtx='0' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				elsif strbAtxd='1' then
					torestart <= '1';
					stateOp <= stateOpTxbufC;
				end if;

			elsif stateOp=stateOpTxbufH then -- captNotFin='0'
				if dneCrc='1' then
					atxd(31 downto 16) <= (crc and x"5555") or ((not crc) and x"AAAA");
					atxd(15 downto 0) <= (others => '0');

					stateOp <= stateOpTxbufJ;
				end if;

			elsif stateOp=stateOpTxbufI then
				if ackAtx='0' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				elsif dneAtx='1' then
					dneTxbuf <= '1';
					stateOp <= stateOpTxbufK;

				elsif timeout='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;
	
				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpTxbufJ then
				if ackAtx='0' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				elsif strbAtxd='1' then
					torestart <= '1';
					stateOp <= stateOpTxbufI;
				end if;

			elsif stateOp=stateOpTxbufK then
				if ackTxbuf='0' then
					stateOp <= stateOpIdle;
				end if;
-- TX BUFFER END

-- RX BEGIN
			elsif stateOp=stateOpPrepRx then -- arrive here if buffer=hostifToCmdinv
				if (ackCrc='0' and ackArx='0') then
					torestart <= '1';
					stateOp <= stateOpRxA;
				end if;

			elsif stateOp=stateOpRxA then
				if (ackCrc='1' and ackArx='1') then
					stateOp <= stateOpRxB;

				elsif timeout2='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpRxB then
				if ackArx='0' then
					stateOp <= stateOpIdle;

				elsif strbArxd='1' then
					for i in 0 to 3 loop
						rxbuf(4*wordcnt + i) <= arxd((4-i)*8-1 downto (3-i)*8);
					end loop;

					crcd <= arxd;

					torestart <= '1';
					stateOp <= stateOpRxC;
				end if;

			elsif stateOp=stateOpRxC then -- strbCrcd='1'
				if strbArxd='0' then
					wordcnt := wordcnt + 1;

					-- ex. wordcntLast=2
					-- DDDD DDDD DDCC, lsb="11"
					-- DDDD DDDD DCC , lsb="10"
					-- DDDD DDDD CC  , lsb="01"
					-- DDDD DDDC C   , lsb="00"

					if wordcnt=wordcntLast then
						lsbCrcd <= lsb;
					end if;

					stateOp <= stateOpRxB;

				elsif dneArx='1' then
					stateOp <= stateOpRxD;

				elsif timeout='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpRxD then
				if dneCrc='1' then
					if crc=x"0000" then
						commok_sig <= '1';
						stateOp <= stateOpCopyRxA;
					else
						commok_sig <= '0';
						stateOp <= stateOpIdle;
					end if;
				end if;

			elsif stateOp=stateOpCopyRxA then
				if opbuf(ixOpbufController)=tixVIcclControllerCamacq then
					if opbuf(ixOpbufCommand)=tixVCamacqCommandSetGrrd then
						camacqSetGrrdRng_sig <= rxbuf(0);
						camacqSetGrrdRedNotGray_sig <= rxbuf(1);
					elsif opbuf(ixOpbufCommand)=tixVCamacqCommandSetPvw then
						camacqSetPvwRng_sig <= rxbuf(0);
						camacqSetPvwRawNotBin_sig <= rxbuf(1);
						camacqSetPvwGrayNotRgb_sig <= rxbuf(2);
					end if;

				elsif opbuf(ixOpbufController)=tixVIcclControllerCamif then
					if opbuf(ixOpbufCommand)=tixVCamifCommandSetRng then
						camifSetRngRng_sig <= rxbuf(0);
					elsif opbuf(ixOpbufCommand)=tixVCamifCommandSetReg then
						for i in 0 to 1 loop
							camifSetRegAddr_sig((2-i)*8-1 downto (1-i)*8) <= rxbuf(i);
						end loop;
						camifSetRegVal_sig <= rxbuf(2);
					elsif opbuf(ixOpbufCommand)=tixVCamifCommandSetRegaddr then
						for i in 0 to 1 loop
							camifSetRegaddrAddr_sig((2-i)*8-1 downto (1-i)*8) <= rxbuf(i);
						end loop;
					elsif opbuf(ixOpbufCommand)=tixVCamifCommandModReg then
						for i in 0 to 1 loop
							camifModRegAddr_sig((2-i)*8-1 downto (1-i)*8) <= rxbuf(i);
						end loop;
						camifModRegMask_sig <= rxbuf(2);
						camifModRegVal_sig <= rxbuf(3);
					end if;

				elsif opbuf(ixOpbufController)=tixVIcclControllerFeatdet then
					if opbuf(ixOpbufCommand)=tixVFeatdetCommandSet then
						featdetSetRng_sig <= rxbuf(0);
						featdetSetThdNotCorner_sig <= rxbuf(1);
						featdetSetThdDeltaNotAbs_sig <= rxbuf(2);
					elsif opbuf(ixOpbufCommand)=tixVFeatdetCommandSetCorner then
						featdetSetCornerLinNotLog_sig <= rxbuf(0);
						featdetSetCornerThd_sig <= rxbuf(1);
					elsif opbuf(ixOpbufCommand)=tixVFeatdetCommandSetThd then
						featdetSetThdLvlFirst_sig <= rxbuf(0);
						featdetSetThdLvlSecond_sig <= rxbuf(1);
					end if;

				elsif opbuf(ixOpbufController)=tixVIcclControllerLaser then
					if opbuf(ixOpbufCommand)=tixVLaserCommandSet then
						for i in 0 to 1 loop
							laserSetL_sig((2-i)*8-1 downto (1-i)*8) <= rxbuf(i);
						end loop;
						for i in 0 to 1 loop
							laserSetR_sig((2-i)*8-1 downto (1-i)*8) <= rxbuf(2+i);
						end loop;
					end if;

				elsif opbuf(ixOpbufController)=tixVIcclControllerPwmonif then
					if opbuf(ixOpbufCommand)=tixVPwmonifCommandRx then
						pwmonifRxLen_sig <= rxbuf(0);
						for i in 0 to 1 loop
							pwmonifRxTo_sig((2-i)*8-1 downto (1-i)*8) <= rxbuf(1+i);
						end loop;
					elsif opbuf(ixOpbufCommand)=tixVPwmonifCommandTx then
						pwmonifTxLenData_sig <= rxbuf(0);
						for i in 0 to 31 loop
							pwmonifTxData_sig((32-i)*8-1 downto (31-i)*8) <= rxbuf(1+i);
						end loop;
					elsif opbuf(ixOpbufCommand)=tixVPwmonifCommandTxrx then
						pwmonifTxrxLenTxdata_sig <= rxbuf(0);
						for i in 0 to 31 loop
							pwmonifTxrxTxdata_sig((32-i)*8-1 downto (31-i)*8) <= rxbuf(1+i);
						end loop;
						pwmonifTxrxRxlen_sig <= rxbuf(33);
						for i in 0 to 1 loop
							pwmonifTxrxRxto_sig((2-i)*8-1 downto (1-i)*8) <= rxbuf(34+i);
						end loop;
					end if;

				elsif opbuf(ixOpbufController)=tixVIcclControllerStep then
					if opbuf(ixOpbufCommand)=tixVStepCommandMoveto then
						for i in 0 to 1 loop
							stepMovetoAngle_sig((2-i)*8-1 downto (1-i)*8) <= rxbuf(i);
						end loop;
						stepMovetoTstep_sig <= rxbuf(2);
					elsif opbuf(ixOpbufCommand)=tixVStepCommandSet then
						stepSetRng_sig <= rxbuf(0);
						stepSetCcwNotCw_sig <= rxbuf(1);
						stepSetTstep_sig <= rxbuf(2);
					end if;

				elsif opbuf(ixOpbufController)=tixVIcclControllerTkclksrc then
					if opbuf(ixOpbufCommand)=tixVTkclksrcCommandSetTkst then
						for i in 0 to 3 loop
							tkclksrcSetTkstTkst_sig((4-i)*8-1 downto (3-i)*8) <= rxbuf(i);
						end loop;
					end if;

				end if;

				stateOp <= stateOpCopyRxB;

			elsif stateOp=stateOpCopyRxB then
				if ackInv='1' then
					atxlen <= std_logic_vector(to_unsigned(1, 22)); -- tx 2x (0xAA) (CRC of empty set)
					atxd <= x"AAAA0000";

					stateOp <= stateOpTxackA;
				end if;
-- RX END

-- RX BUFFER BEGIN
			elsif stateOp=stateOpPrepRxbuf then
				if (ackCrc='0' and ackArx='0' and ackRxbuf='1') then
					torestart <= '1';
					stateOp <= stateOpRxbufA;
				end if;

			elsif stateOp=stateOpRxbufA then
				if (ackCrc='1' and ackArx='1') then
					stateOp <= stateOpRxbufB;

				elsif timeout2='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpRxbufB then
				if ackArx='0' then
					stateOp <= stateOpIdle;

				elsif strbArxd='1' then
					dRxbuf <= arxd;
					strbDRxbuf <= '1';

					crcd <= arxd;

					torestart <= '1';
					stateOp <= stateOpRxbufC;
				end if;

			elsif stateOp=stateOpRxbufC then -- strbCrcd='1'
				if strbArxd='0' then
					wordcnt := wordcnt + 1;

					if wordcnt=wordcntLast then
						lsbCrcd <= "01";
					else
						strbDRxbuf <= '0';
					end if;

					stateOp <= stateOpRxbufB;

				elsif dneArx='1' then
					stateOp <= stateOpRxbufD;

				elsif timeout='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpRxbufD then
				if dneCrc='1' then
					if crc=x"0000" then
						dneRxbuf <= '1';
						commok_sig <= '1';
						stateOp <= stateOpRxbufE;
					else
						commok_sig <= '0';
						stateOp <= stateOpIdle;
					end if;
				end if;

			elsif stateOp=stateOpRxbufE then
				if ackRxbuf='0' then
					reqRxbuf <= '0';

					atxlen <= std_logic_vector(to_unsigned(1, 22)); -- tx 2x (0xAA) (CRC of empty set)
					atxd <= x"AAAA0000";

					torestart <= '1';
					stateOp <= stateOpTxackA;
				end if;
-- RX BUFFER END

			elsif stateOp=stateOpTxackA then
				if ackAtx='1' then
					stateOp <= stateOpTxackB;

				elsif timeout2='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpTxackB then
				if dneAtx='1' then
					stateOp <= stateOpIdle;
				end if;
			end if;
		end if;
	end process;

end Hostif;
