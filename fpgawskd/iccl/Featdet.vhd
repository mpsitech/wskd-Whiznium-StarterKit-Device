-- file Featdet.vhd
-- Featdet easy model controller implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Catherine Johnson (auto-generation)
-- date created: 1 Dec 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Iccl.all;

entity Featdet is
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
end Featdet;

architecture Featdet of Featdet is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Add_v1_0 is
		generic (
			signNotUnsign: boolean := false;

			wA: natural range 1 to 128 := 8;
			wB: natural range 1 to 128 := 8;
			wS: natural range 1 to 128 := 9
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			ce: in std_logic;

			a: in std_logic_vector(wA-1 downto 0);
			b: in std_logic_vector(wB-1 downto 0);
			s: out std_logic_vector(wS-1 downto 0)
		);
	end component;

	component Sub_v1_0 is
		generic (
			signNotUnsign: boolean := false;

			wA: natural range 1 to 128 := 8;
			wB: natural range 1 to 128 := 8;
			wD: natural range 1 to 128 := 9
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			ce: in std_logic;

			a: in std_logic_vector(wA-1 downto 0);
			b: in std_logic_vector(wB-1 downto 0);
			d: out std_logic_vector(wD-1 downto 0)
		);
	end component;

	component Dpsram_size96kB_p8 is
		port (
			CLK: in std_logic;

			A_BLK_EN: in std_logic;
			A_WEN: in std_logic;

			A_ADDR: in std_logic_vector(16 downto 0);
			A_DOUT: out std_logic_vector(7 downto 0);
			A_DIN: in std_logic_vector(7 downto 0);

			B_BLK_EN: in std_logic;
			B_WEN: in std_logic;

			B_ADDR: in std_logic_vector(14 downto 0);
			B_DOUT: out std_logic_vector(31 downto 0);
			B_DIN: in std_logic_vector(31 downto 0)
		);
	end component;

	component Dpsram_size2kB_p8 is
		port (
			CLK: in std_logic;

			A_BLK_EN: in std_logic;
			A_WEN: in std_logic;

			A_ADDR: in std_logic_vector(10 downto 0);
			A_DOUT: out std_logic_vector(7 downto 0);
			A_DIN: in std_logic_vector(7 downto 0);

			B_BLK_EN: in std_logic;
			B_WEN: in std_logic;

			B_ADDR: in std_logic_vector(10 downto 0);
			B_DOUT: out std_logic_vector(7 downto 0);
			B_DIN: in std_logic_vector(7 downto 0)
		);
	end component;

	component Mult_v1_0 is
		generic (
			signNotUnsign: boolean := false;

			wA: natural range 1 to 128 := 8;
			wB: natural range 1 to 128 := 8;
			wP: natural range 1 to 128 := 16
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;
			ce: in std_logic;

			a: in std_logic_vector(wA-1 downto 0);
			b: in std_logic_vector(wB-1 downto 0);
			p: out std_logic_vector(wP-1 downto 0)
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	constant tixVFlgbufstateIdle: std_logic_vector(7 downto 0) := x"00";
	constant tixVFlgbufstateEmpty: std_logic_vector(7 downto 0) := x"01";
	constant tixVFlgbufstateFull: std_logic_vector(7 downto 0) := x"02";

	constant tixVThdstateIdle: std_logic_vector(7 downto 0) := x"00";
	constant tixVThdstateWaitfirst: std_logic_vector(7 downto 0) := x"01";
	constant tixVThdstateWaitsecond: std_logic_vector(7 downto 0) := x"02";
	constant tixVThdstateDone: std_logic_vector(7 downto 0) := x"03";

	---- Harris score pipeline copy operation (copy)
	type stateCopy_t is (
		stateCopyInit,
		stateCopyRun
	);
	signal stateCopy: stateCopy_t := stateCopyInit;

	signal colsumX: std_logic_vector(104 downto 0); -- 5x 21bits
	signal colsumY: std_logic_vector(104 downto 0); -- 5x 21bits
	signal colsumXY: std_logic_vector(104 downto 0); -- 5x 21bits

	-- IP sigs.copy.cust --- INSERT

	---- Harris corner detection and score pipeline operation (corner)
	type stateCorner_t is (
		stateCornerInit,
		stateCornerDiff,
		stateCornerPipe,
		stateCornerStep
	);
	signal stateCorner: stateCorner_t := stateCornerInit;

	signal ceScore: std_logic;
	signal abcde: natural;
	signal dx: std_logic_vector(44 downto 0); -- 5x 9bits
	signal dy: std_logic_vector(44 downto 0); -- 5y 9bits

	-- IP sigs.corner.cust --- INSERT

	---- Harris score result exponent/mantissa transform (exp)
	type stateExp_t is (
		stateExpInit,
		stateExpRun
	);
	signal stateExp: stateExp_t := stateExpInit;

	signal rexp: std_logic_vector(7 downto 0);
	signal rshift: natural range 0 to 39;

	-- IP sigs.exp.cust --- INSERT

	---- Harris score third term 5/128 multiplier (factk)
	type stateFactk_t is (
		stateFactkInit,
		stateFactkRun
	);
	signal stateFactk: stateFactk_t := stateFactkInit;

	signal termIIIk: std_logic_vector(43 downto 0);

	-- IP sigs.factk.cust --- INSERT

	---- flagging operation, also managing flgbuf (flg)
	type stateFlg_t is (
		stateFlgInit,
		stateFlgWaitTrig,
		stateFlgInv,
		stateFlgTrylock,
		stateFlgWaitFrame,
		stateFlgReady,
		stateFlgLdthd,
		stateFlgStcorner,
		stateFlgStthd,
		stateFlgDoneA, stateFlgDoneB, stateFlgDoneC
	);
	signal stateFlg: stateFlg_t := stateFlgInit;

	signal ackInvTriggerThd_sig: std_logic;

	signal tixVThdstate: std_logic_vector(7 downto 0);
	signal tkst: std_logic_vector(31 downto 0);

	signal enFlgbuf: std_logic;
	signal weFlgbuf: std_logic;

	signal aFlgbuf_vec: std_logic_vector(16 downto 0);
	signal aFlgbuf: natural range 0 to 98304;

	signal dwrFlgbuf: std_logic_vector(7 downto 0);
	signal thdrun: std_logic;
	signal thdSecondNotFirst: std_logic;
	signal cornerrun: std_logic;
	signal drdThd: std_logic_vector(7 downto 0);

	-- IP sigs.flg.cust --- INSERT

	---- flgbuf mutex management (flgbuf)
	type stateFlgbuf_t is (
		stateFlgbufInit,
		stateFlgbufReady,
		stateFlgbufAck
	);
	signal stateFlgbuf: stateFlgbuf_t := stateFlgbufInit;

	type lock_t is (lockIdle, lockBufB, lockFlg);
	signal flgbufLock: lock_t;
	signal flgbufFull: std_logic;

	-- IP sigs.flgbuf.cust --- INSERT

	---- flgbuf B/hostif-facing operation (flgbufB)
	type stateFlgbufB_t is (
		stateFlgbufBInit,
		stateFlgbufBReady,
		stateFlgbufBTrylock,
		stateFlgbufBReadA, stateFlgbufBReadB,
		stateFlgbufBDone
	);
	signal stateFlgbufB: stateFlgbufB_t := stateFlgbufBInit;

	signal tixVFlgbufstate: std_logic_vector(7 downto 0);
	signal enFlgbufB: std_logic;

	signal aFlgbufB_vec: std_logic_vector(14 downto 0);
	signal aFlgbufB: natural range 0 to 24576;

	signal ackFlgbufToHostif_sig: std_logic;

	-- IP sigs.flgbufB.cust --- INSERT

	---- Harris score pipeline forward operation (fwd)
	type stateFwd_t is (
		stateFwdInit,
		stateFwdRun
	);
	signal stateFwd: stateFwd_t := stateFwdInit;

	signal xsqr4p1: std_logic_vector(17 downto 0);
	signal xsqr4p2: std_logic_vector(17 downto 0);

	signal colsumX4p1: std_logic_vector(20 downto 0);
	signal colsumX4p2: std_logic_vector(20 downto 0);

	signal ysqr4p1: std_logic_vector(17 downto 0);
	signal ysqr4p2: std_logic_vector(17 downto 0);

	signal colsumY4p1: std_logic_vector(20 downto 0);
	signal colsumY4p2: std_logic_vector(20 downto 0);

	signal xy4p1: std_logic_vector(17 downto 0);
	signal xy4p2: std_logic_vector(17 downto 0);

	signal colsumXY4p1: std_logic_vector(20 downto 0);
	signal colsumXY4p2: std_logic_vector(20 downto 0);

	signal diffI_IIp1: std_logic_vector(46 downto 0);

	-- IP sigs.fwd.cust --- INSERT

	---- intermediate result streaming operation, also handling imd{ab/cd/ef}buf (imdstream)
	type stateImdstream_t is (
		stateImdstreamInit,
		stateImdstreamWaitFrame,
		stateImdstreamSkipA, stateImdstreamSkipB,
		stateImdstreamStartrowA, stateImdstreamStartrowB, stateImdstreamStartrowC,
		stateImdstreamLSA, stateImdstreamLSB,
		stateImdstreamLSC, stateImdstreamLSD,
		stateImdstreamStoprow
	);
	signal stateImdstream: stateImdstream_t := stateImdstreamInit;

	signal shift: natural range 0 to 47;
	signal scoreMin: std_logic_vector(7 downto 0);
	signal scoreMax: std_logic_vector(7 downto 0);

	signal enImdbuf: std_logic;
	signal enImdabbuf: std_logic;
	signal weImdabbuf: std_logic;

	signal aImdabbuf_vec: std_logic_vector(10 downto 0);
	signal aImdabbuf: natural range 0 to 2048;

	signal dwrImdabbuf: std_logic_vector(7 downto 0);
	signal enImdcdbuf: std_logic;
	signal weImdcdbuf: std_logic;

	signal aImdcdbuf_vec: std_logic_vector(10 downto 0);
	signal aImdcdbuf: natural range 0 to 2048;

	signal dwrImdcdbuf: std_logic_vector(7 downto 0);
	signal enImdefbuf: std_logic;
	signal weImdefbuf: std_logic;

	signal aImdefbuf_vec: std_logic_vector(10 downto 0);
	signal aImdefbuf: natural range 0 to 2048;

	signal dwrImdefbuf: std_logic_vector(7 downto 0);

	signal dImdstream: std_logic_vector(39 downto 0);
	signal strbDImdstream: std_logic;

	-- IP sigs.imdstream.cust --- INSERT

	---- maximum selection (maxsel)
	type stateMaxsel_t is (
		stateMaxselInit,
		stateMaxselImd,
		stateMaxselMax,
		stateMaxselAct,
		stateMaxselStore
	);
	signal stateMaxsel: stateMaxsel_t := stateMaxselInit;

	signal dCorner: std_logic_vector(7 downto 0);
	signal strbDCorner: std_logic;

	-- IP sigs.maxsel.cust --- INSERT

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpInvSet,
		stateOpInv,
		stateOpRun
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal streamrun: std_logic;
	signal ackInvSet_sig: std_logic;
	signal thdNotCorner: std_logic;
	signal thdDeltaNotAbs: std_logic;
	signal ackInvSetCorner_sig: std_logic;
	signal cornerLinNotLog: std_logic;
	signal cornerThd: natural range 0 to 255;
	signal ackInvSetThd_sig: std_logic;

	signal thdLvlFirst: std_logic_vector(7 downto 0);
	signal thdLvlSecond: std_logic_vector(7 downto 0);

	-- IP sigs.op.cust --- INSERT

	---- streaming operation, also handling grrd{ab/cd/ef}bufFromCamacq (stream)
	type stateStream_t is (
		stateStreamInit,
		stateStreamWaitFrame,
		stateStreamSkipA, stateStreamSkipB,
		stateStreamStartrowA, stateStreamStartrowB,
		stateStreamLoadAceA, stateStreamLoadAceB,
		stateStreamLoadBdfA, stateStreamLoadBdfB,
		stateStreamStoprow
	);
	signal stateStream: stateStream_t := stateStreamInit;

	signal reqGrrdbuf: std_logic;
	signal ackGrrdbuf: std_logic;

	signal strbDGrrdbuf: std_logic;

	signal dStream: std_logic_vector(47 downto 0);
	signal strbDStream: std_logic;

	-- IP sigs.stream.cust --- INSERT

	---- threshold detection (thd)
	type stateThd_t is (
		stateThdInit,
		stateThdLASA, stateThdLASB,
		stateThdDone
	);
	signal stateThd: stateThd_t := stateThdInit;

	signal dwrThd: std_logic_vector(7 downto 0);
	signal strbDwrThd: std_logic;

	signal strbDrdThd: std_logic;

	-- IP sigs.thd.cust --- INSERT

	---- myColsumXA1
	signal colsumXA1: std_logic_vector(18 downto 0);

	---- myColsumXA2
	signal colsumXA2: std_logic_vector(18 downto 0);

	---- myColsumXB
	signal colsumXB: std_logic_vector(20 downto 0);

	---- myColsumXC
	signal colsumXC: std_logic_vector(20 downto 0);

	---- myColsumXYA1
	signal colsumXYA1: std_logic_vector(18 downto 0);

	---- myColsumXYA2
	signal colsumXYA2: std_logic_vector(18 downto 0);

	---- myColsumXYB
	signal colsumXYB: std_logic_vector(20 downto 0);

	---- myColsumXYC
	signal colsumXYC: std_logic_vector(20 downto 0);

	---- myColsumYA1
	signal colsumYA1: std_logic_vector(18 downto 0);

	---- myColsumYA2
	signal colsumYA2: std_logic_vector(18 downto 0);

	---- myColsumYB
	signal colsumYB: std_logic_vector(20 downto 0);

	---- myColsumYC
	signal colsumYC: std_logic_vector(20 downto 0);

	---- myDiffI_II
	signal diffI_II: std_logic_vector(46 downto 0);

	---- myFlgbuf
	signal drdFlgbuf: std_logic_vector(7 downto 0);

	---- myImdabbuf
	signal drdImdabbuf: std_logic_vector(7 downto 0);

	---- myImdcdbuf
	signal drdImdcdbuf: std_logic_vector(7 downto 0);

	---- myImdefbuf
	signal drdImdefbuf: std_logic_vector(7 downto 0);

	---- myR
	signal r: std_logic_vector(47 downto 0);

	---- mySumIII
	signal sumIII: std_logic_vector(23 downto 0);

	---- mySumX
	signal sumX: std_logic_vector(22 downto 0);

	---- mySumXA
	signal sumXA: std_logic_vector(21 downto 0);

	---- mySumXB
	signal sumXB: std_logic_vector(21 downto 0);

	---- mySumXC
	signal sumXC: std_logic_vector(22 downto 0);

	---- mySumXY
	signal sumXY: std_logic_vector(22 downto 0);

	---- mySumXYA
	signal sumXYA: std_logic_vector(21 downto 0);

	---- mySumXYB
	signal sumXYB: std_logic_vector(21 downto 0);

	---- mySumXYC
	signal sumXYC: std_logic_vector(22 downto 0);

	---- mySumY
	signal sumY: std_logic_vector(22 downto 0);

	---- mySumYA
	signal sumYA: std_logic_vector(21 downto 0);

	---- mySumYB
	signal sumYB: std_logic_vector(21 downto 0);

	---- mySumYC
	signal sumYC: std_logic_vector(22 downto 0);

	---- myTermI
	signal termI: std_logic_vector(45 downto 0);

	---- myTermII
	signal termII: std_logic_vector(45 downto 0);

	---- myTermIII
	signal termIII: std_logic_vector(47 downto 0);

	---- handshake
	-- flg to flgbuf
	signal reqFlgToFlgbufLock: std_logic;
	signal ackFlgToFlgbufLock: std_logic;
	signal dnyFlgToFlgbufLock: std_logic;

	-- flg to flgbuf
	signal reqFlgToFlgbufSetFull: std_logic;
	signal ackFlgToFlgbufSetFull: std_logic;

	-- flgbufB to flgbuf
	signal reqFlgbufBToFlgbufLock: std_logic;
	signal ackFlgbufBToFlgbufLock: std_logic;
	signal dnyFlgbufBToFlgbufLock: std_logic;

	-- flgbufB to flgbuf
	signal reqFlgbufBToFlgbufClear: std_logic;
	signal ackFlgbufBToFlgbufClear: std_logic;

	---- other
	signal mclkn: std_logic;
	signal xsqr: std_logic_vector(89 downto 0); -- 5x 18bits, set by modules xsqr0 to xsqr4
	signal ysqr: std_logic_vector(89 downto 0); -- 5x 18bits, set by modules ysqr0 to ysqr4
	signal xy: std_logic_vector(89 downto 0); -- 5x 18bits, set by modules xy0 to xy4
	-- IP sigs.oth.cust --- IBEGIN
	constant tixVCamacqGrrdbufstateIdle: std_logic_vector(7 downto 0) := x"00";
	constant tixVCamacqGrrdbufstateEmpty: std_logic_vector(7 downto 0) := x"01";
	constant tixVCamacqGrrdbufstateStream: std_logic_vector(7 downto 0) := x"02";
	constant tixVCamacqGrrdbufstatePause: std_logic_vector(7 downto 0) := x"03";
	constant tixVCamacqGrrdbufstateEndfr: std_logic_vector(7 downto 0) := x"04";
	-- IP sigs.oth.cust --- IEND

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myColsumXA1 : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 18,
			wB => 18,
			wS => 19
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => xsqr(89 downto 72),
			b => xsqr(71 downto 54),
			s => colsumXA1
		);

	myColsumXA2 : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 18,
			wB => 18,
			wS => 19
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => xsqr(53 downto 36),
			b => xsqr(35 downto 18),
			s => colsumXA2
		);

	myColsumXB : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 19,
			wB => 19,
			wS => 20
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => colsumXA1,
			b => colsumXA2,
			s => colsumXB
		);

	myColsumXC : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 20,
			wB => 18,
			wS => 21
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => colsumXB,
			b => xsqr4p2,
			s => colsumXC
		);

	myColsumXYA1 : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 18,
			wB => 18,
			wS => 19
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => xy(89 downto 72),
			b => xy(71 downto 54),
			s => colsumXYA1
		);

	myColsumXYA2 : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 18,
			wB => 18,
			wS => 19
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => xy(53 downto 36),
			b => xy(35 downto 18),
			s => colsumXYA2
		);

	myColsumXYB : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 19,
			wB => 19,
			wS => 20
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => colsumXYA1,
			b => colsumXYA2,
			s => colsumXYB
		);

	myColsumXYC : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 20,
			wB => 18,
			wS => 21
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => colsumXYB,
			b => xy4p2,
			s => colsumXYC
		);

	myColsumYA1 : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 18,
			wB => 18,
			wS => 19
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => ysqr(89 downto 72),
			b => ysqr(71 downto 54),
			s => colsumYA1
		);

	myColsumYA2 : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 18,
			wB => 18,
			wS => 19
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => ysqr(53 downto 36),
			b => ysqr(35 downto 18),
			s => colsumYA2
		);

	myColsumYB : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 19,
			wB => 19,
			wS => 20
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => colsumYA1,
			b => colsumYA2,
			s => colsumYB
		);

	myColsumYC : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 20,
			wB => 18,
			wS => 21
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => colsumYB,
			b => ysqr4p2,
			s => colsumYC
		);

	myDiffI_II : Sub_v1_0
		generic map (
			signNotUnsign => true,

			wA => 46,
			wB => 46,
			wD => 47
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => termI,
			b => termII,
			d => diffI_II
		);

	myFlgbuf : Dpsram_size96kB_p8
		port map (
			CLK => mclk,

			A_BLK_EN => enFlgbuf,
			A_WEN => weFlgbuf,

			A_ADDR => aFlgbuf_vec,
			A_DOUT => drdFlgbuf,
			A_DIN => dwrFlgbuf,

			B_BLK_EN => enFlgbufB,
			B_WEN => '0',

			B_ADDR => aFlgbufB_vec,
			B_DOUT => dFlgbufToHostif,
			B_DIN => (others => '0')
		);

	myImdabbuf : Dpsram_size2kB_p8
		port map (
			CLK => mclk,

			A_BLK_EN => enImdabbuf,
			A_WEN => weImdabbuf,

			A_ADDR => aImdabbuf_vec,
			A_DOUT => drdImdabbuf,
			A_DIN => dwrImdabbuf,

			B_BLK_EN => '0',
			B_WEN => '0',

			B_ADDR => (others => '0'),
			B_DOUT => open,
			B_DIN => (others => '0')
		);

	myImdcdbuf : Dpsram_size2kB_p8
		port map (
			CLK => mclk,

			A_BLK_EN => enImdcdbuf,
			A_WEN => weImdcdbuf,

			A_ADDR => aImdcdbuf_vec,
			A_DOUT => drdImdcdbuf,
			A_DIN => dwrImdcdbuf,

			B_BLK_EN => '0',
			B_WEN => '0',

			B_ADDR => (others => '0'),
			B_DOUT => open,
			B_DIN => (others => '0')
		);

	myImdefbuf : Dpsram_size2kB_p8
		port map (
			CLK => mclk,

			A_BLK_EN => enImdefbuf,
			A_WEN => weImdefbuf,

			A_ADDR => aImdefbuf_vec,
			A_DOUT => drdImdefbuf,
			A_DIN => dwrImdefbuf,

			B_BLK_EN => '0',
			B_WEN => '0',

			B_ADDR => (others => '0'),
			B_DOUT => open,
			B_DIN => (others => '0')
		);

	myR : Sub_v1_0
		generic map (
			signNotUnsign => true,

			wA => 47,
			wB => 44,
			wD => 48
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => diffI_IIp1,
			b => termIIIk,
			d => r
		);

	mySumIII : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 23,
			wB => 23,
			wS => 24
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => sumX,
			b => sumY,
			s => sumIII
		);

	mySumX : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 23,
			wB => 21,
			wS => 23
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => sumXC,
			b => colsumX4p2,
			s => sumX
		);

	mySumXA : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 21,
			wB => 21,
			wS => 22
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => colsumX(104 downto 84),
			b => colsumX(83 downto 63),
			s => sumXA
		);

	mySumXB : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 21,
			wB => 21,
			wS => 22
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => colsumX(62 downto 42),
			b => colsumX(41 downto 21),
			s => sumXB
		);

	mySumXC : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 22,
			wB => 22,
			wS => 23
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => sumXA,
			b => sumXB,
			s => sumXC
		);

	mySumXY : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 23,
			wB => 21,
			wS => 23
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => sumXYC,
			b => colsumXY4p2,
			s => sumXY
		);

	mySumXYA : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 21,
			wB => 21,
			wS => 22
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => colsumXY(104 downto 84),
			b => colsumXY(83 downto 63),
			s => sumXYA
		);

	mySumXYB : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 21,
			wB => 21,
			wS => 22
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => colsumXY(62 downto 42),
			b => colsumXY(41 downto 21),
			s => sumXYB
		);

	mySumXYC : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 22,
			wB => 22,
			wS => 23
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => sumXYA,
			b => sumXYB,
			s => sumXYC
		);

	mySumY : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 23,
			wB => 21,
			wS => 23
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => sumYC,
			b => colsumY4p2,
			s => sumY
		);

	mySumYA : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 21,
			wB => 21,
			wS => 22
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => colsumY(104 downto 84),
			b => colsumY(83 downto 63),
			s => sumYA
		);

	mySumYB : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 21,
			wB => 21,
			wS => 22
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => colsumY(62 downto 42),
			b => colsumY(41 downto 21),
			s => sumYB
		);

	mySumYC : Add_v1_0
		generic map (
			signNotUnsign => true,

			wA => 22,
			wB => 22,
			wS => 23
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => sumYA,
			b => sumYB,
			s => sumYC
		);

	myTermI : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 23,
			wB => 23,
			wP => 46
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => sumX,
			b => sumY,
			p => termI
		);

	myTermII : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 23,
			wB => 23,
			wP => 46
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => sumXY,
			b => sumXY,
			p => termII
		);

	myTermIII : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 24,
			wB => 24,
			wP => 48
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => sumIII,
			b => sumIII,
			p => termIII
		);

	myXsqr0 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dx(44 downto 36),
			b => dx(44 downto 36),
			p => xsqr(89 downto 72)
		);

	myXsqr1 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dx(35 downto 27),
			b => dx(35 downto 27),
			p => xsqr(71 downto 54)
		);

	myXsqr2 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dx(26 downto 18),
			b => dx(26 downto 18),
			p => xsqr(53 downto 36)
		);

	myXsqr3 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dx(17 downto 9),
			b => dx(17 downto 9),
			p => xsqr(35 downto 18)
		);

	myXsqr4 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dx(8 downto 0),
			b => dx(8 downto 0),
			p => xsqr(17 downto 0)
		);

	myXy0 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dx(44 downto 36),
			b => dy(44 downto 36),
			p => xy(89 downto 72)
		);

	myXy1 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dx(35 downto 27),
			b => dy(35 downto 27),
			p => xy(71 downto 54)
		);

	myXy2 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dx(26 downto 18),
			b => dy(26 downto 18),
			p => xy(53 downto 36)
		);

	myXy3 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dx(17 downto 9),
			b => dy(17 downto 9),
			p => xy(35 downto 18)
		);

	myXy4 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dx(8 downto 0),
			b => dy(8 downto 0),
			p => xy(17 downto 0)
		);

	myYsqr0 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dy(44 downto 36),
			b => dy(44 downto 36),
			p => ysqr(89 downto 72)
		);

	myYsqr1 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dy(35 downto 27),
			b => dy(35 downto 27),
			p => ysqr(71 downto 54)
		);

	myYsqr2 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dy(26 downto 18),
			b => dy(26 downto 18),
			p => ysqr(53 downto 36)
		);

	myYsqr3 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dy(17 downto 9),
			b => dy(17 downto 9),
			p => ysqr(35 downto 18)
		);

	myYsqr4 : Mult_v1_0
		generic map (
			signNotUnsign => true,

			wA => 9,
			wB => 9,
			wP => 18
		)
		port map (
			reset => reset,
			mclk => mclk,
			ce => ceScore,

			a => dy(8 downto 0),
			b => dy(8 downto 0),
			p => ysqr(17 downto 0)
		);

	------------------------------------------------------------------------
	-- implementation: Harris score pipeline copy operation (copy)
	------------------------------------------------------------------------

	-- IP impl.copy.wiring --- BEGIN
	-- IP impl.copy.wiring --- END

	-- IP impl.copy.rising --- BEGIN
	process (reset, mclk, stateCopy)
		-- IP impl.copy.vars --- RBEGIN
		-- IP impl.copy.vars --- REND

	begin
		if reset='1' then
			-- IP impl.copy.asyncrst --- BEGIN
			stateCopy <= stateCopyInit;
			colsumX <= (others => '0');
			colsumY <= (others => '0');
			colsumXY <= (others => '0');
			-- IP impl.copy.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateCopy=stateCopyInit or cornerrun='0') then
				-- IP impl.copy.syncrst --- BEGIN
				colsumX <= (others => '0');
				colsumY <= (others => '0');
				colsumXY <= (others => '0');

				-- IP impl.copy.syncrst --- END

				if cornerrun='0' then
					stateCopy <= stateCopyInit;

				else
					stateCopy <= stateCopyRun;
				end if;

			elsif stateCopy=stateCopyRun then
				-- IP impl.copy.run --- IBEGIN
				if ceScore='1' then
					-- eabcd
					if abcde=0 then
						colsumX((4-4+1)*21-1 downto (4-4)*21) <= colsumXC;
						colsumY((4-4+1)*21-1 downto (4-4)*21) <= colsumYC;
						colsumXY((4-4+1)*21-1 downto (4-4)*21) <= colsumXYC;
					elsif abcde=1 then
						colsumX((4-0+1)*21-1 downto (4-0)*21) <= colsumXC;
						colsumY((4-0+1)*21-1 downto (4-0)*21) <= colsumYC;
						colsumXY((4-0+1)*21-1 downto (4-0)*21) <= colsumXYC;
					elsif abcde=2 then
						colsumX((4-1+1)*21-1 downto (4-1)*21) <= colsumXC;
						colsumY((4-1+1)*21-1 downto (4-1)*21) <= colsumYC;
						colsumXY((4-1+1)*21-1 downto (4-1)*21) <= colsumXYC;
					elsif abcde=3 then
						colsumX((4-2+1)*21-1 downto (4-2)*21) <= colsumXC;
						colsumY((4-2+1)*21-1 downto (4-2)*21) <= colsumYC;
						colsumXY((4-2+1)*21-1 downto (4-2)*21) <= colsumXYC;
					elsif abcde=4 then
						colsumX((4-3+1)*21-1 downto (4-3)*21) <= colsumXC;
						colsumY((4-3+1)*21-1 downto (4-3)*21) <= colsumYC;
						colsumXY((4-3+1)*21-1 downto (4-3)*21) <= colsumXYC;
					end if;
				end if;
				-- IP impl.copy.run --- IEND
			end if;
		end if;
	end process;
	-- IP impl.copy.rising --- END

	------------------------------------------------------------------------
	-- implementation: Harris corner detection and score pipeline operation (corner)
	------------------------------------------------------------------------

	-- IP impl.corner.wiring --- RBEGIN
	ceScore <= '1' when stateCorner=stateCornerPipe else '0';

	stateCorner_dbg <= x"00" when stateCorner=stateCornerInit
				else x"10" when stateCorner=stateCornerDiff
				else x"20" when stateCorner=stateCornerPipe
				else x"30" when stateCorner=stateCornerStep
				else (others => '1');
	-- IP impl.corner.wiring --- REND

	-- IP impl.corner.rising --- BEGIN
	process (reset, mclk, stateCorner)
		-- IP impl.corner.vars --- RBEGIN
		variable dStream_prev: std_logic_vector(47 downto 0);
		-- IP impl.corner.vars --- REND

	begin
		if reset='1' then
			-- IP impl.corner.asyncrst --- BEGIN
			stateCorner <= stateCornerInit;
			abcde <= 0;
			dx <= (others => '0');
			dy <= (others => '0');
			-- IP impl.corner.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateCorner=stateCornerInit or cornerrun='0') then
				-- IP impl.corner.syncrst --- BEGIN
				abcde <= 0;
				dx <= (others => '0');
				dy <= (others => '0');

				-- IP impl.corner.syncrst --- END

				if cornerrun='0' then
					stateCorner <= stateCornerInit;

				else
					stateCorner <= stateCornerDiff;
				end if;

			elsif stateCorner=stateCornerDiff then
				if strbDStream='1' then
					-- IP impl.corner.diff --- IBEGIN
					-- dx(44 downto 36) <= std_logic_vector(signed("0" & dStream(39 downto 32)) - signed("0" & dStream_prev(39 downto 32)));
					-- dy(44 downto 36) <= std_logic_vector(signed("0" & dStream(39 downto 32)) - signed("0" & dStream(47 downto 40)));
					-- ...
					-- dx(8 downto 0) <= std_logic_vector(signed("0" & dStream(7 downto 0)) - signed("0" & dStream_prev(7 downto 0)));
					-- dy(8 downto 0) <= std_logic_vector(signed("0" & dStream(7 downto 0)) - signed("0" & dStream(15 downto 8)));

					for i in 0 to 4 loop
						dx((4-i+1)*9-1 downto (4-i)*9) <= std_logic_vector(signed("0" & dStream((4-i+1)*8-1 downto (4-i)*8)) - signed("0" & dStream_prev((4-i+1)*8-1 downto (4-i)*8)));
						dy((4-i+1)*9-1 downto (4-i)*9) <= std_logic_vector(signed("0" & dStream((4-i+1)*8-1 downto (4-i)*8)) - signed("0" & dStream((4-i+2)*8-1 downto (4-i+1)*8)));
					end loop;

					dStream_prev := dStream;
					-- IP impl.corner.diff --- IEND

					stateCorner <= stateCornerPipe;
				end if;

			elsif stateCorner=stateCornerPipe then
				stateCorner <= stateCornerStep;

			elsif stateCorner=stateCornerStep then
				-- IP impl.corner.step --- IBEGIN
				if abcde=4 then
					abcde <= 0;
				else
					abcde <= abcde + 1;
				end if;
				-- IP impl.corner.step --- IEND

				stateCorner <= stateCornerDiff;
			end if;
		end if;
	end process;
	-- IP impl.corner.rising --- END

	------------------------------------------------------------------------
	-- implementation: Harris score result exponent/mantissa transform (exp)
	------------------------------------------------------------------------

	-- IP impl.exp.wiring --- BEGIN
	-- IP impl.exp.wiring --- END

	-- IP impl.exp.rising --- BEGIN
	process (reset, mclk, stateExp)
		-- IP impl.exp.vars --- RBEGIN
		variable msb: natural range 0 to 47;
		-- IP impl.exp.vars --- REND

	begin
		if reset='1' then
			-- IP impl.exp.asyncrst --- BEGIN
			stateExp <= stateExpInit;
			rexp <= (others => '0');
			rshift <= 0;
			-- IP impl.exp.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateExp=stateExpInit or cornerrun='0') then
				-- IP impl.exp.syncrst --- BEGIN
				rexp <= (others => '0');
				rshift <= 0;

				-- IP impl.exp.syncrst --- END

				if cornerrun='0' then
					stateExp <= stateExpInit;

				else
					stateExp <= stateExpRun;
				end if;

			elsif stateExp=stateExpRun then
				-- IP impl.exp.run --- IBEGIN
				if ceScore='1' then
					for i in 0 to 47 loop
						if r(i)='1' then
							msb := i;
						end if;
					end loop;

					if cornerLinNotLog='0' then
						if msb<2 then
							rexp <= "000000" & r(1 downto 0);
						elsif msb=47 then
							rexp <= (others => '0');
						else
							rexp <= std_logic_vector(to_unsigned(msb-1, 6)) & r(msb-1 downto msb-2);
						end if;

					else
						if (msb<7 or msb=47) then
							rshift <= 0;
						else
							rshift <= msb - 7;
						end if;
	
						if msb=47 then
							rexp <= (others => '0');
						elsif msb<shift then
							rexp <= (others => '0');
						elsif msb>shift+7 then
							rexp <= (others => '1');
						else
							rexp <= r(shift+7 downto shift);
						end if;
					end if;
				end if;
				-- IP impl.exp.run --- IEND
			end if;
		end if;
	end process;
	-- IP impl.exp.rising --- END

	------------------------------------------------------------------------
	-- implementation: Harris score third term 5/128 multiplier (factk)
	------------------------------------------------------------------------

	-- IP impl.factk.wiring --- BEGIN
	-- IP impl.factk.wiring --- END

	-- IP impl.factk.rising --- BEGIN
	process (reset, mclk, stateFactk)
		-- IP impl.factk.vars --- RBEGIN
		variable x: unsigned(50 downto 0);
		-- IP impl.factk.vars --- REND

	begin
		if reset='1' then
			-- IP impl.factk.asyncrst --- BEGIN
			stateFactk <= stateFactkInit;
			termIIIk <= (others => '0');
			-- IP impl.factk.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateFactk=stateFactkInit or cornerrun='0') then
				-- IP impl.factk.syncrst --- BEGIN
				termIIIk <= (others => '0');

				-- IP impl.factk.syncrst --- END

				if cornerrun='0' then
					stateFactk <= stateFactkInit;

				else
					stateFactk <= stateFactkRun;
				end if;

			elsif stateFactk=stateFactkRun then
				-- IP impl.factk.run --- IBEGIN
				if ceScore='1' then
					x := unsigned('0' & termIII & "00") + unsigned("000" & termIII); -- x5
					termIIIk <= std_logic_vector(x(50 downto 7)); -- /128
				end if;
				-- IP impl.factk.run --- IEND
			end if;
		end if;
	end process;
	-- IP impl.factk.rising --- END

	------------------------------------------------------------------------
	-- implementation: flagging operation, also managing flgbuf (flg)
	------------------------------------------------------------------------

	-- IP impl.flg.wiring --- RBEGIN
	ackInvTriggerThd <= '1' when stateFlg=stateFlgInv else '0';

	getInfoTixVThdstate <= tixVThdstate;
	getInfoTkst <= tkst;

	enFlgbuf <= '1' when (stateFlg=stateFlgLdthd or stateFlg=stateFlgStcorner or stateFlg=stateFlgStthd) else '0';

	aFlgbuf_vec <= std_logic_vector(to_unsigned(aFlgbuf, 17));

	cornerrun <= '1' when (thdNotCorner='0' and (stateFlg=stateFlgReady or stateFlg=stateFlgStcorner)) else '0';
	thdrun <= '1' when (thdNotCorner='1' and (stateFlg=stateFlgReady or stateFlg=stateFlgLdthd or stateFlg=stateFlgStthd)) else '0';

	reqFlgToFlgbufSetFull <= '1' when stateFlg=stateFlgDoneB else '0';

	stateFlg_dbg <= x"00" when stateFlg=stateFlgInit
		else x"10" when stateFlg=stateFlgWaitTrig
		else x"20" when stateFlg=stateFlgInv
		else x"30" when stateFlg=stateFlgTrylock
		else x"40" when stateFlg=stateFlgWaitFrame
		else x"50" when stateFlg=stateFlgReady
		else x"60" when stateFlg=stateFlgLdthd
		else x"70" when stateFlg=stateFlgStthd
		else x"80" when stateFlg=stateFlgDoneA
		else x"81" when stateFlg=stateFlgDoneB
		else x"82" when stateFlg=stateFlgDoneC
		else x"FF";
	-- IP impl.flg.wiring --- REND

	-- IP impl.flg.rising --- BEGIN
	process (reset, mclk, stateFlg)
		-- IP impl.flg.vars --- RBEGIN
		-- concerns thd
		-- sequence for aFlgbuf = a0Flgbuf + arowFlgbuf + acolFlgbuf: 0-128-256-...-640, 1-129-...-641, ..., 127-...-767, ..., 768-..., ...
		variable a0FlgbufRd: natural range 0 to 98304; -- 0-768-1536-...-97536(-98304)
		variable arowFlgbufRd: natural range 0 to 768; -- 0-128-256-...-640(-768)
		variable acolFlgbufRd: natural range 0 to 128; -- 0-1-2-...-127(-128)

		variable a0FlgbufWr: natural range 0 to 98304; -- 0-768-1536-...-97536(-98304)
		variable arowFlgbufWr: natural range 0 to 768; -- 0-128-256-...-640(-768)
		variable acolFlgbufWr: natural range 0 to 128; -- 0-1-2-...-127(-128)
		-- IP impl.flg.vars --- REND

	begin
		if reset='1' then
			-- IP impl.flg.asyncrst --- RBEGIN
			stateFlg <= stateFlgInit;

			tixVThdstate <= tixVThdstateIdle;
			tkst <= (others => '0');
			aFlgbuf <= 0;
			dwrFlgbuf <= (others => '0');
			thdSecondNotFirst <= '0';
			reqFlgToFlgbufLock <= '0';
			drdThd <= (others => '0');
			-- IP impl.flg.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (stateFlg=stateFlgInit or streamrun='0') then
				-- IP impl.flg.syncrst --- RBEGIN
				tkst <= (others => '0');
				aFlgbuf <= 0;
				dwrFlgbuf <= (others => '0');
				thdSecondNotFirst <= '0';
				drdThd <= (others => '0');
				-- IP impl.flg.syncrst --- REND

				if streamrun='0' then
					-- IP impl.flg.init.off --- IBEGIN
					tixVThdstate <= tixVThdstateIdle;
					reqFlgToFlgbufLock <= '0';
					-- IP impl.flg.init.off --- IEND

					stateFlg <= stateFlgInit;

				else
					if thdNotCorner='0' then
						-- IP impl.flg.init.corner --- IBEGIN
						tixVThdstate <= tixVThdstateIdle;
						reqFlgToFlgbufLock <= '1';
						-- IP impl.flg.init.corner --- IEND

						stateFlg <= stateFlgTrylock;

					else
						-- IP impl.flg.init.thd --- IBEGIN
						tixVThdstate <= tixVThdstateWaitfirst;
						reqFlgToFlgbufLock <= '0';
						-- IP impl.flg.init.thd --- IEND

						stateFlg <= stateFlgWaitTrig;
					end if;
				end if;

			elsif stateFlg=stateFlgWaitTrig then
				if reqInvTriggerThd='1' then
					stateFlg <= stateFlgInv;
				end if;

			elsif stateFlg=stateFlgInv then
				if reqInvTriggerThd='0' then
					if thdSecondNotFirst='0' then
						reqFlgToFlgbufLock <= '1'; -- IP impl.flg.inv.trigFirst --- ILINE

						stateFlg <= stateFlgTrylock;

					else
						stateFlg <= stateFlgWaitFrame;
					end if;
				end if;

			elsif stateFlg=stateFlgTrylock then
				if ackFlgToFlgbufLock='1' then
					reqFlgToFlgbufLock <= '0'; -- IP impl.flg.trylock.ack --- ILINE

					stateFlg <= stateFlgWaitFrame;

				elsif dnyFlgToFlgbufLock='1' then
					reqFlgToFlgbufLock <= '0'; -- IP impl.flg.trylock.dny --- ILINE

					stateFlg <= stateFlgInit;
				end if;

			elsif stateFlg=stateFlgWaitFrame then
				if camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstateEmpty then
					-- IP impl.flg.waitFrame.tkst --- IBEGIN
					if thdSecondNotFirst='0' then
						tkst <= camacqGetGrrdinfoTkst;
					end if;

					aFlgbuf <= 0;
					-- IP impl.flg.waitFrame.tkst --- IEND

					if thdNotCorner='0' then
						weFlgbuf <= '1'; -- IP impl.flg.waitFrame.corner --- ILINE

						stateFlg <= stateFlgReady;

					else
						-- IP impl.flg.waitFrame.thd --- IBEGIN
						-- start off by loading first byte
						a0FlgbufRd := 0;
						arowFlgbufRd := 0;
						acolFlgbufRd := 0;
	
						a0FlgbufWr := 0;
						arowFlgbufWr := 0;
						acolFlgbufWr := 0;

						weFlgbuf <= '0';
						-- IP impl.flg.waitFrame.thd --- IEND

						stateFlg <= stateFlgLdthd;
					end if;
				end if;

			elsif stateFlg=stateFlgReady then
				if strbDCorner='1' then
					dwrFlgbuf <= dCorner; -- IP impl.flg.ready.prepStcorner --- ILINE

					stateFlg <= stateFlgStcorner;

				elsif strbDrdThd='1' then
					-- IP impl.flg.ready.prepLdthd --- IBEGIN
					weFlgbuf <= '0';

					aFlgbuf <= a0FlgbufRd + arowFlgbufRd + acolFlgbufRd; -- load always is one address ahead
					-- IP impl.flg.ready.prepLdthd --- IEND

					stateFlg <= stateFlgLdthd;

				elsif strbDwrThd='1' then
					-- IP impl.flg.ready.prepStthd --- IBEGIN
					weFlgbuf <= '1';

					aFlgbuf <= a0FlgbufWr + arowFlgbufWr + acolFlgbufWr;
					dwrFlgbuf <= dwrThd;
					-- IP impl.flg.ready.prepStthd --- IEND

					stateFlg <= stateFlgStthd;
				end if;

			elsif stateFlg=stateFlgLdthd then
				-- IP impl.flg.ldthd --- IBEGIN
				drdThd <= drdFlgbuf;

				arowFlgbufRd := arowFlgbufRd + 128;

				if arowFlgbufRd=768 then
					arowFlgbufRd := 0;

					acolFlgbufRd := acolFlgbufRd + 1;

					if acolFlgbufRd=128 then
						acolFlgbufRd := 0;

						a0FlgbufRd := a0FlgbufRd + 768;

						if a0FlgbufRd=98304 then
							a0FlgbufRd := 0;
						end if;
					end if;
				end if;
				-- IP impl.flg.ldthd --- IEND

				stateFlg <= stateFlgReady;

			elsif stateFlg=stateFlgStcorner then
				aFlgbuf <= aFlgbuf + 1; -- IP impl.flg.stcorner.ext --- ILINE

				if aFlgbuf=97664 then
					-- 98304 - 5*1024/8 -- IP impl.flg.stcorner.cmt --- ILINE

					stateFlg <= stateFlgDoneB;

				else
					stateFlg <= stateFlgReady;
				end if;

			elsif stateFlg=stateFlgStthd then
				arowFlgbufWr := arowFlgbufWr + 128; -- IP impl.flg.stthd.ext --- ILINE

				if arowFlgbufWr=768 then
					-- IP impl.flg.stthd.lastRow --- IBEGIN
					arowFlgbufWr := 0;

					acolFlgbufWr := acolFlgbufWr + 1;
					-- IP impl.flg.stthd.lastRow --- IEND

					if acolFlgbufWr=128 then
						-- IP impl.flg.stthd.lastCol --- IBEGIN
						acolFlgbufWr := 0;

						a0FlgbufWr := a0FlgbufWr + 768;
						-- IP impl.flg.stthd.lastCol --- IEND

						if a0FlgbufWr=98304 then
							stateFlg <= stateFlgDoneA;

						else
							stateFlg <= stateFlgReady;
						end if;

					else
						stateFlg <= stateFlgReady;
					end if;

				else
					stateFlg <= stateFlgReady;
				end if;

			elsif stateFlg=stateFlgDoneA then
				if (thdDeltaNotAbs='0' or thdSecondNotFirst='1') then
					tixVThdstate <= tixVThdstateDone; -- IP impl.flg.doneA.final --- ILINE

					stateFlg <= stateFlgDoneB;

				else
					-- IP impl.flg.doneA.second --- IBEGIN
					thdSecondNotFirst <= '1';

					tixVThdstate <= tixVThdstateWaitsecond;
					-- IP impl.flg.doneA.second --- IEND

					stateFlg <= stateFlgWaitTrig;
				end if;

			elsif stateFlg=stateFlgDoneB then
				if ackFlgToFlgbufSetFull='1' then
					stateFlg <= stateFlgDoneC;
				end if;

			elsif stateFlg=stateFlgDoneC then
				if flgbufFull='0' then
					stateFlg <= stateFlgInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.flg.rising --- END

	------------------------------------------------------------------------
	-- implementation: flgbuf mutex management (flgbuf)
	------------------------------------------------------------------------

	-- IP impl.flgbuf.wiring --- RBEGIN
	stateFlgbuf_dbg <= x"00" when stateFlgbuf=stateFlgbufInit
		else x"10" when stateFlgbuf=stateFlgbufReady
		else x"20" when stateFlgbuf=stateFlgbufAck
		else x"FF";
	-- IP impl.flgbuf.wiring --- REND

	-- IP impl.flgbuf.rising --- BEGIN
	process (reset, mclk, stateFlgbuf)
		-- IP impl.flgbuf.vars --- BEGIN
		-- IP impl.flgbuf.vars --- END

	begin
		if reset='1' then
			-- IP impl.flgbuf.asyncrst --- BEGIN
			stateFlgbuf <= stateFlgbufInit;
			flgbufLock <= lockIdle;
			flgbufFull <= '0';
			ackFlgToFlgbufLock <= '0';
			dnyFlgToFlgbufLock <= '0';
			ackFlgToFlgbufSetFull <= '0';
			ackFlgbufBToFlgbufLock <= '0';
			dnyFlgbufBToFlgbufLock <= '0';
			ackFlgbufBToFlgbufClear <= '0';
			-- IP impl.flgbuf.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateFlgbuf=stateFlgbufInit or streamrun='0') then
				-- IP impl.flgbuf.syncrst --- BEGIN
				flgbufLock <= lockIdle;
				flgbufFull <= '0';
				ackFlgToFlgbufLock <= '0';
				dnyFlgToFlgbufLock <= '0';
				ackFlgToFlgbufSetFull <= '0';
				ackFlgbufBToFlgbufLock <= '0';
				dnyFlgbufBToFlgbufLock <= '0';
				ackFlgbufBToFlgbufClear <= '0';

				-- IP impl.flgbuf.syncrst --- END

				if streamrun='0' then
					stateFlgbuf <= stateFlgbufInit;

				else
					stateFlgbuf <= stateFlgbufReady;
				end if;

			elsif stateFlgbuf=stateFlgbufReady then
				if reqFlgToFlgbufLock='1' then
					-- IP impl.flgbuf.ready.flgLock --- IBEGIN
					if flgbufLock=lockIdle then
						flgbufLock <= lockFlg;
						flgbufFull <= '0';
						ackFlgToFlgbufLock <= '1';
					elsif flgbufLock=lockBufB then
						dnyFlgToFlgbufLock <= '1';
					elsif flgbufLock=lockFlg then
						flgbufLock <= lockIdle; -- unlock
						ackFlgToFlgbufLock <= '1';
					end if;
					-- IP impl.flgbuf.ready.flgLock --- IEND

					stateFlgbuf <= stateFlgbufAck;

				elsif reqFlgToFlgbufSetFull='1' then
					-- IP impl.flgbuf.ready.flgFull --- IBEGIN
					if flgbufLock=lockFlg then
						flgbufLock <= lockIdle;
						flgbufFull <= '1';
						ackFlgToFlgbufSetFull <= '1';
					end if;
					-- IP impl.flgbuf.ready.flgFull --- IEND

					stateFlgbuf <= stateFlgbufAck;

				elsif reqFlgbufBToFlgbufLock='1' then
					-- IP impl.flgbuf.ready.flgbufBLock --- IBEGIN
					if flgbufLock=lockIdle then
						flgbufLock <= lockBufB;
						ackFlgbufBToFlgbufLock <= '1';
					elsif flgbufLock=lockBufB then
						flgbufLock <= lockIdle; -- unlock
						ackFlgbufBToFlgbufLock <= '1';
					elsif flgbufLock=lockFlg then
						dnyFlgbufBToFlgbufLock <= '1';
					end if;
					-- IP impl.flgbuf.ready.flgbufBLock --- IEND

					stateFlgbuf <= stateFlgbufAck;

				elsif reqFlgbufBToFlgbufClear='1' then
					-- IP impl.flgbuf.ready.flgbufBClear --- IBEGIN
					if flgbufLock=lockBufB then
						flgbufLock <= lockIdle;
						flgbufFull <= '0';
						ackFlgbufBToFlgbufClear <= '1';
					end if;
					-- IP impl.flgbuf.ready.flgbufBClear --- IEND

					stateFlgbuf <= stateFlgbufAck;
				end if;

			elsif stateFlgbuf=stateFlgbufAck then
				if ((ackFlgToFlgbufLock='1' or dnyFlgToFlgbufLock='1') and reqFlgToFlgbufLock='0') then
					-- IP impl.flgbuf.ack.flgLock --- IBEGIN
					ackFlgToFlgbufLock <= '0';
					dnyFlgToFlgbufLock <= '0';
					-- IP impl.flgbuf.ack.flgLock --- IEND

					stateFlgbuf <= stateFlgbufReady;

				elsif (ackFlgToFlgbufSetFull='1' and reqFlgToFlgbufSetFull='0') then
					ackFlgToFlgbufSetFull <= '0'; -- IP impl.flgbuf.ack.flgFull --- ILINE

					stateFlgbuf <= stateFlgbufReady;

				elsif ((ackFlgbufBToFlgbufLock='1' or dnyFlgbufBToFlgbufLock='1') and reqFlgbufBToFlgbufLock='0') then
					-- IP impl.flgbuf.ack.flgbufBLock --- IBEGIN
					ackFlgbufBToFlgbufLock <= '0';
					dnyFlgbufBToFlgbufLock <= '0';
					-- IP impl.flgbuf.ack.flgbufBLock --- IEND

					stateFlgbuf <= stateFlgbufReady;

				elsif (ackFlgbufBToFlgbufClear='1' and reqFlgbufBToFlgbufClear='0') then
					ackFlgbufBToFlgbufClear <= '0'; -- IP impl.flgbuf.ack.flgbufBClear --- ILINE

					stateFlgbuf <= stateFlgbufReady;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.flgbuf.rising --- END

	------------------------------------------------------------------------
	-- implementation: flgbuf B/hostif-facing operation (flgbufB)
	------------------------------------------------------------------------

	-- IP impl.flgbufB.wiring --- RBEGIN
	enFlgbufB <= '1' when (flgbufLock=lockBufB and strbDFlgbufToHostif='0' and stateFlgbufB=stateFlgbufBReadA) else '0';

	aFlgbufB_vec <= std_logic_vector(to_unsigned(aFlgbufB, 15));

	tixVFlgbufstate <= tixVFlgbufstateFull when (flgbufLock=lockIdle and flgbufFull='1')
				else tixVFlgbufstateEmpty when streamrun='1'
				else tixVFlgbufstateIdle;

	getInfoTixVFlgbufstate <= tixVFlgbufstate;

	avllenFlgbufToHostif <= std_logic_vector(to_unsigned(384, 9)) when (flgbufLock=lockIdle and flgbufFull='1')
				else (others => '0');

	ackFlgbufToHostif <= ackFlgbufToHostif_sig;

	stateFlgbufB_dbg <= x"00" when stateFlgbufB=stateFlgbufBInit
		else x"10" when stateFlgbufB=stateFlgbufBReady
		else x"20" when stateFlgbufB=stateFlgbufBTrylock
		else x"30" when stateFlgbufB=stateFlgbufBReadA
		else x"31" when stateFlgbufB=stateFlgbufBReadB
		else x"40" when stateFlgbufB=stateFlgbufBDone
		else x"FF";
	-- IP impl.flgbufB.wiring --- REND

	-- IP impl.flgbufB.rising --- BEGIN
	process (reset, mclk, stateFlgbufB)
		-- IP impl.flgbufB.vars --- BEGIN
		-- IP impl.flgbufB.vars --- END

	begin
		if reset='1' then
			-- IP impl.flgbufB.asyncrst --- RBEGIN
			stateFlgbufB <= stateFlgbufBInit;
			aFlgbufB <= 0;
			ackFlgbufToHostif_sig <= '0';
			reqFlgbufBToFlgbufLock <= '0';
			reqFlgbufBToFlgbufClear <= '0';
			-- IP impl.flgbufB.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (stateFlgbufB=stateFlgbufBInit or streamrun='0') then
				-- IP impl.flgbufB.syncrst --- RBEGIN
				aFlgbufB <= 0;
				ackFlgbufToHostif_sig <= '0';
				reqFlgbufBToFlgbufLock <= '0';
				reqFlgbufBToFlgbufClear <= '0';

				-- IP impl.flgbufB.syncrst --- REND

				if streamrun='0' then
					stateFlgbufB <= stateFlgbufBInit;

				else
					stateFlgbufB <= stateFlgbufBReady;
				end if;

			elsif stateFlgbufB=stateFlgbufBReady then
				if (tixVFlgbufstate=tixVFlgbufstateFull and reqFlgbufToHostif='1') then
					reqFlgbufBToFlgbufLock <= '1'; -- IP impl.flgbufB.ready.prep --- ILINE

					stateFlgbufB <= stateFlgbufBTrylock;
				end if;

			elsif stateFlgbufB=stateFlgbufBTrylock then
				if ackFlgbufBToFlgbufLock='1' then
					reqFlgbufBToFlgbufLock <= '0'; -- IP impl.flgbufB.trylock.ack --- ILINE

					stateFlgbufB <= stateFlgbufBReadA;

				elsif dnyFlgbufBToFlgbufLock='1' then
					stateFlgbufB <= stateFlgbufBInit;
				end if;

			elsif stateFlgbufB=stateFlgbufBReadA then
				if flgbufLock=lockBufB then
					if dneFlgbufToHostif='1' then
						-- IP impl.flgbufB.readA.dne --- IBEGIN
						reqFlgbufBToFlgbufClear <= '1';
						ackFlgbufToHostif_sig <= '0';
						-- IP impl.flgbufB.readA.dne --- IEND

						stateFlgbufB <= stateFlgbufBDone;

					elsif reqFlgbufToHostif='0' then
						-- IP impl.flgbufB.readA.cnc --- IBEGIN
						reqFlgbufBToFlgbufLock <= '1'; -- unlock
						ackFlgbufToHostif_sig <= '0';
						-- IP impl.flgbufB.readA.cnc --- IEND

						stateFlgbufB <= stateFlgbufBDone;

					elsif strbDFlgbufToHostif='0' then
						ackFlgbufToHostif_sig <= '1'; -- IP impl.flgbufB.readA.step --- ILINE

						stateFlgbufB <= stateFlgbufBReadB;
					end if;
				end if;

			elsif stateFlgbufB=stateFlgbufBReadB then
				if flgbufLock=lockBufB then
					if reqFlgbufToHostif='0' then
						-- IP impl.flgbufB.readB.cnc --- IBEGIN
						reqFlgbufBToFlgbufLock <= '1'; -- unlock
						ackFlgbufToHostif_sig <= '0';
						-- IP impl.flgbufB.readB.cnc --- IEND

						stateFlgbufB <= stateFlgbufBDone;

					elsif strbDFlgbufToHostif='1' then
						aFlgbufB <= aFlgbufB + 1; -- IP impl.flgbufB.readB.inc --- ILINE

						stateFlgbufB <= stateFlgbufBReadA;
					end if;
				end if;

			elsif stateFlgbufB=stateFlgbufBDone then
				if (ackFlgbufBToFlgbufLock='1' or ackFlgbufBToFlgbufClear='1') then
					stateFlgbufB <= stateFlgbufBInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.flgbufB.rising --- END

	------------------------------------------------------------------------
	-- implementation: Harris score pipeline forward operation (fwd)
	------------------------------------------------------------------------

	-- IP impl.fwd.wiring --- BEGIN
	-- IP impl.fwd.wiring --- END

	-- IP impl.fwd.rising --- BEGIN
	process (reset, mclk, stateFwd)
		-- IP impl.fwd.vars --- BEGIN
		-- IP impl.fwd.vars --- END

	begin
		if reset='1' then
			-- IP impl.fwd.asyncrst --- BEGIN
			stateFwd <= stateFwdInit;
			xsqr4p1 <= (others => '0');
			xsqr4p2 <= (others => '0');
			colsumX4p1 <= (others => '0');
			colsumX4p2 <= (others => '0');
			ysqr4p1 <= (others => '0');
			ysqr4p2 <= (others => '0');
			colsumY4p1 <= (others => '0');
			colsumY4p2 <= (others => '0');
			xy4p1 <= (others => '0');
			xy4p2 <= (others => '0');
			colsumXY4p1 <= (others => '0');
			colsumXY4p2 <= (others => '0');
			diffI_IIp1 <= (others => '0');
			-- IP impl.fwd.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateFwd=stateFwdInit or cornerrun='0') then
				-- IP impl.fwd.syncrst --- BEGIN
				xsqr4p1 <= (others => '0');
				xsqr4p2 <= (others => '0');
				colsumX4p1 <= (others => '0');
				colsumX4p2 <= (others => '0');
				ysqr4p1 <= (others => '0');
				ysqr4p2 <= (others => '0');
				colsumY4p1 <= (others => '0');
				colsumY4p2 <= (others => '0');
				xy4p1 <= (others => '0');
				xy4p2 <= (others => '0');
				colsumXY4p1 <= (others => '0');
				colsumXY4p2 <= (others => '0');
				diffI_IIp1 <= (others => '0');

				-- IP impl.fwd.syncrst --- END

				if cornerrun='0' then
					stateFwd <= stateFwdInit;

				else
					stateFwd <= stateFwdRun;
				end if;

			elsif stateFwd=stateFwdRun then
				-- IP impl.fwd.run --- IBEGIN
				if ceScore='1' then
					xsqr4p1 <= xsqr(89 downto 72);
					xsqr4p2 <= xsqr4p1;

					colsumX4p1 <= colsumX(104 downto 84);
					colsumX4p2 <= colsumX4p1;

					ysqr4p1 <= ysqr(89 downto 72);
					ysqr4p2 <= ysqr4p1;

					colsumY4p1 <= colsumY(104 downto 84);
					colsumY4p2 <= colsumY4p1;

					xy4p1 <= xy(89 downto 72);
					xy4p2 <= xy4p1;

					colsumXY4p1 <= colsumXY(104 downto 84);
					colsumXY4p2 <= colsumXY4p1;

					diffI_IIp1 <= diffI_II;
				end if;
				-- IP impl.fwd.run --- IEND
			end if;
		end if;
	end process;
	-- IP impl.fwd.rising --- END

	------------------------------------------------------------------------
	-- implementation: intermediate result streaming operation, also handling imd{ab/cd/ef}buf (imdstream)
	------------------------------------------------------------------------

	-- IP impl.imdstream.wiring --- RBEGIN
	enImdbuf <= '1' when (stateImdstream=stateImdstreamStartrowC or stateImdstream=stateImdstreamLSB or stateImdstream=stateImdstreamLSD) else '0';

	enImdabbuf <= enImdbuf;
	aImdabbuf_vec <= std_logic_vector(to_unsigned(aImdabbuf, 11));

	enImdcdbuf <= enImdbuf;
	aImdcdbuf_vec <= std_logic_vector(to_unsigned(aImdcdbuf, 11));

	enImdefbuf <= enImdbuf;
	aImdefbuf_vec <= std_logic_vector(to_unsigned(aImdefbuf, 11));

	strbDImdstream <= '1' when stateImdstream=stateImdstreamLSD else '0';

	getCornerinfoScoreMin <= scoreMin;
	getCornerinfoScoreMax <= scoreMax;

	stateImdstream_dbg <= x"00" when stateImdstream=stateImdstreamInit
		else (others => '1');
	-- IP impl.imdstream.wiring --- REND

	-- IP impl.imdstream.rising --- BEGIN
	process (reset, mclk, stateImdstream)
		-- IP impl.imdstream.vars --- RBEGIN
		variable row: natural range 0 to 6;
		variable col: natural range 0 to 1024;

		constant a0Bdf: natural := 1024;

		variable shift_lcl: natural range 0 to 47;

		variable scoreMin_lcl: std_logic_vector(7 downto 0);
		variable scoreMax_lcl: std_logic_vector(7 downto 0);

		constant imax: natural := 89; -- pipeline latency (4x22 + 1 to account for ceScore being active only one in four mclk cycles)
		variable i: natural range 0 to imax;
				-- IP impl.imdstream.vars --- REND

	begin
		if reset='1' then
			-- IP impl.imdstream.asyncrst --- RBEGIN
			stateImdstream <= stateImdstreamInit;
			shift <= 0;
			scoreMin <= (others => '1');
			scoreMax <= (others => '0');
			weImdabbuf <= '0';
			aImdabbuf <= 0;
			dwrImdabbuf <= (others => '0');
			weImdcdbuf <= '0';
			aImdcdbuf <= 0;
			dwrImdcdbuf <= (others => '0');
			weImdefbuf <= '0';
			aImdefbuf <= 0;
			dwrImdefbuf <= (others => '0');
			dImdstream <= (others => '0');

			row := 0;
			col := 0;
			shift_lcl := 0;
			scoreMin_lcl := (others => '1');
			scoreMax_lcl := (others => '0');
			i := 0;
			-- IP impl.imdstream.asyncrst --- REND

		elsif rising_edge(mclk) then
			if (stateImdstream=stateImdstreamInit or cornerrun='0') then
				-- IP impl.imdstream.syncrst --- RBEGIN
				weImdabbuf <= '0';
				aImdabbuf <= 0;
				dwrImdabbuf <= (others => '0');
				weImdcdbuf <= '0';
				aImdcdbuf <= 0;
				dwrImdcdbuf <= (others => '0');
				weImdefbuf <= '0';
				aImdefbuf <= 0;
				dwrImdefbuf <= (others => '0');
				dImdstream <= (others => '0');

				row := 0;
				col := 0;
				shift_lcl := 0;
				scoreMin_lcl := (others => '1');
				scoreMax_lcl := (others => '0');
				i := 0;
				-- IP impl.imdstream.syncrst --- REND

				if cornerrun='0' then
					stateImdstream <= stateImdstreamInit;

				else
					stateImdstream <= stateImdstreamWaitFrame;
				end if;

			elsif stateImdstream=stateImdstreamWaitFrame then
				if camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstateEmpty then
					row := 0; -- IP impl.imdstream.waitFrame --- ILINE

					stateImdstream <= stateImdstreamSkipA;
				end if;

			elsif stateImdstream=stateImdstreamSkipA then
				if camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstateStream then
					stateImdstream <= stateImdstreamSkipB;
				end if;

			elsif stateImdstream=stateImdstreamSkipB then
				if camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstatePause then
					row := row + 1; -- IP impl.imdstream.skipB.inc --- ILINE

					if row=5 then
						stateImdstream <= stateImdstreamStartrowA;

					else
						stateImdstream <= stateImdstreamSkipA;
					end if;
				end if;

			elsif stateImdstream=stateImdstreamStartrowA then
				if camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstateStream then
					i := 0; -- IP impl.imdstream.startrowA --- ILINE

					stateImdstream <= stateImdstreamStartrowB;
				end if;

			elsif stateImdstream=stateImdstreamStartrowB then
				i := i + 1; -- IP impl.imdstream.startrowB.ext --- ILINE

				if i=imax then
					-- IP impl.imdstream.startrowB --- IBEGIN
					col := 0;

					weImdabbuf <= '0';
					aImdabbuf <= col;
					weImdcdbuf <= '0';
					aImdcdbuf <= col;
					weImdefbuf <= '0';
					aImdefbuf <= col;
					-- IP impl.imdstream.startrowB --- IEND

					stateImdstream <= stateImdstreamStartrowC;
				end if;

			elsif stateImdstream=stateImdstreamStartrowC then
				stateImdstream <= stateImdstreamLSA;

			elsif stateImdstream=stateImdstreamLSA then
				-- IP impl.imdstream.LSA --- IBEGIN

				-- load
				if row=0 then
					-- (bcdefa)
					dImdstream(31 downto 24) <= drdImdcdbuf;
					dImdstream(15 downto 8) <= drdImdefbuf;
				elsif row=1 then
					-- (cdefab)
					dImdstream(39 downto 32) <= drdImdcdbuf;
					dImdstream(23 downto 16) <= drdImdefbuf;
					dImdstream(7 downto 0) <= drdImdabbuf;
				elsif row=2 then
					-- (defabc)
					dImdstream(31 downto 24) <= drdImdefbuf;
					dImdstream(15 downto 8) <= drdImdabbuf;
				elsif row=3 then
					-- (efabcd)
					dImdstream(39 downto 32) <= drdImdefbuf;
					dImdstream(23 downto 16) <= drdImdabbuf;
					dImdstream(7 downto 0) <= drdImdcdbuf;
				elsif row=4 then
					-- (fabcde)
					dImdstream(31 downto 24) <= drdImdabbuf;
					dImdstream(15 downto 8) <= drdImdcdbuf;
				else
					-- (abcdef)
					dImdstream(39 downto 32) <= drdImdabbuf;
					dImdstream(23 downto 16) <= drdImdcdbuf;
					dImdstream(7 downto 0) <= drdImdefbuf;
				end if;

				-- store
				if row=1 then
					-- (cdefab)
					weImdabbuf <= '1';
					aImdabbuf <= a0Bdf + col;
					dwrImdabbuf <= rexp;
				elsif row=3 then
					-- (efabcd)
					weImdcdbuf <= '1';
					aImdcdbuf <= a0Bdf + col;
					dwrImdcdbuf <= rexp;
				elsif row=5 then
					-- (abcdef)
					weImdefbuf <= '1';
					aImdefbuf <= a0Bdf + col;
					dwrImdefbuf <= rexp;
				end if;

				-- preparation for next load
				if row=0 then
					-- (bcdefa)
					weImdabbuf <= '0';
					aImdabbuf <= a0Bdf + col;
					weImdcdbuf <= '0';
					aImdcdbuf <= a0Bdf + col;
					weImdefbuf <= '0';
					aImdefbuf <= a0Bdf + col;
				elsif row=1 then
					-- (cdefab)
					weImdcdbuf <= '0';
					aImdcdbuf <= a0Bdf + col;
					weImdefbuf <= '0';
					aImdefbuf <= a0Bdf + col;
				elsif row=2 then
					-- (defabc)
					weImdabbuf <= '0';
					aImdabbuf <= a0Bdf + col;
					weImdcdbuf <= '0';
					aImdcdbuf <= a0Bdf + col;
					weImdefbuf <= '0';
					aImdefbuf <= a0Bdf + col;
				elsif row=3 then
					-- (efabcd)
					weImdabbuf <= '0';
					aImdabbuf <= a0Bdf + col;
					weImdefbuf <= '0';
					aImdefbuf <= a0Bdf + col;
				elsif row=4 then
					-- (fabcde)
					weImdabbuf <= '0';
					aImdabbuf <= a0Bdf + col;
					weImdcdbuf <= '0';
					aImdcdbuf <= a0Bdf + col;
					weImdefbuf <= '0';
					aImdefbuf <= a0Bdf + col;
				else
					-- (abcdef)
					weImdabbuf <= '0';
					aImdabbuf <= a0Bdf + col;
					weImdcdbuf <= '0';
					aImdcdbuf <= a0Bdf + col;
				end if;
				-- IP impl.imdstream.LSA --- IEND

				stateImdstream <= stateImdstreamLSB;

			elsif stateImdstream=stateImdstreamLSB then
				stateImdstream <= stateImdstreamLSC;

			elsif stateImdstream=stateImdstreamLSC then
				-- IP impl.imdstream.LSC --- IBEGIN

				-- load
				if row=0 then
					-- (bcdefa)
					dImdstream(39 downto 32) <= drdImdabbuf;
					dImdstream(23 downto 16) <= drdImdcdbuf;
					dImdstream(7 downto 0) <= drdImdefbuf;
				elsif row=1 then
					-- (cdefab)
					dImdstream(31 downto 24) <= drdImdcdbuf;
					dImdstream(15 downto 8) <= drdImdefbuf;
				elsif row=2 then
					-- (defabc)
					dImdstream(39 downto 32) <= drdImdcdbuf;
					dImdstream(23 downto 16) <= drdImdefbuf;
					dImdstream(7 downto 0) <= drdImdabbuf;
				elsif row=3 then
					-- (efabcd)
					dImdstream(31 downto 24) <= drdImdefbuf;
					dImdstream(15 downto 8) <= drdImdabbuf;
				elsif row=4 then
					-- (fabcde)
					dImdstream(39 downto 32) <= drdImdefbuf;
					dImdstream(23 downto 16) <= drdImdabbuf;
					dImdstream(7 downto 0) <= drdImdcdbuf;
				else
					-- (abcdef)
					dImdstream(31 downto 24) <= drdImdabbuf;
					dImdstream(15 downto 8) <= drdImdcdbuf;
				end if;

				-- min/max update
				if unsigned(rexp)<unsigned(scoreMin_lcl) then
					scoreMin_lcl := rexp;
				end if;
				
				if unsigned(rexp)>unsigned(scoreMax_lcl) then
					scoreMax_lcl := rexp;
				end if;
				
				if rshift>shift_lcl then
					shift_lcl := rshift;
				end if;

				-- store
				if row=0 then
					-- (bcdefa)
					weImdabbuf <= '1';
					aImdabbuf <= col;
					dwrImdabbuf <= rexp;
				elsif row=2 then
					-- (defabc)
					weImdcdbuf <= '1';
					aImdcdbuf <= col;
					dwrImdcdbuf <= rexp;
				elsif row=4 then
					-- (fabcde)
					weImdefbuf <= '1';
					aImdefbuf <= col;
					dwrImdefbuf <= rexp;
				end if;

				col := col + 1;

				if col/=1024 then
					-- preparation for next load
					if row=0 then
						-- (bcdefa)
						weImdcdbuf <= '0';
						aImdcdbuf <= col;
						weImdefbuf <= '0';
						aImdefbuf <= col;
					elsif row=1 then
						-- (cdefab)
						weImdabbuf <= '0';
						aImdabbuf <= col;
						weImdcdbuf <= '0';
						aImdcdbuf <= col;
						weImdefbuf <= '0';
						aImdefbuf <= col;
					elsif row=2 then
						-- (defabc)
						weImdabbuf <= '0';
						aImdabbuf <= col;
						weImdefbuf <= '0';
						aImdefbuf <= col;
					elsif row=3 then
						-- (efabcd)
						weImdabbuf <= '0';
						aImdabbuf <= col;
						weImdcdbuf <= '0';
						aImdcdbuf <= col;
						weImdefbuf <= '0';
						aImdefbuf <= col;
					elsif row=4 then
						-- (fabcde)
						weImdabbuf <= '0';
						aImdabbuf <= col;
						weImdcdbuf <= '0';
						aImdcdbuf <= col;
					else
						-- (abcdef)
						weImdabbuf <= '0';
						aImdabbuf <= col;
						weImdcdbuf <= '0';
						aImdcdbuf <= col;
						weImdefbuf <= '0';
						aImdefbuf <= col;
					end if;
				end if;
				-- IP impl.imdstream.LSC --- IEND

				stateImdstream <= stateImdstreamLSD;

			elsif stateImdstream=stateImdstreamLSD then
				if col=1024 then
					stateImdstream <= stateImdstreamStoprow;

				else
					stateImdstream <= stateImdstreamLSA;
				end if;

			elsif stateImdstream=stateImdstreamStoprow then
				if camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstatePause then
					 -- IP impl.imdstream.stoprow.incRow --- IBEGIN
					row := row + 1;

					if row=6 then
						row := 0;
					end if;
					 -- IP impl.imdstream.stoprow.incRow --- IEND

					stateImdstream <= stateImdstreamStartrowA;

				elsif camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstateEndfr then
					-- IP impl.imdstream.stoprow.updScore --- IBEGIN
					if shift_lcl>=40 then
						shift <= 40;
					else
						shift <= shift_lcl;
					end if;

					scoreMin <= scoreMin_lcl;
					scoreMax <= scoreMax_lcl;
					-- IP impl.imdstream.stoprow.updScore --- IEND

					stateImdstream <= stateImdstreamInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.imdstream.rising --- END

	------------------------------------------------------------------------
	-- implementation: maximum selection (maxsel)
	------------------------------------------------------------------------

	-- IP impl.maxsel.wiring --- RBEGIN
	strbDCorner <= '1' when stateMaxsel=stateMaxselStore else '0';

	stateMaxsel_dbg <= x"00" when stateMaxsel=stateMaxselInit
				else x"10" when stateMaxsel=stateMaxselImd
				else x"20" when stateMaxsel=stateMaxselMax
				else x"30" when stateMaxsel=stateMaxselAct
				else x"40" when stateMaxsel=stateMaxselStore
				else (others => '1');
	-- IP impl.maxsel.wiring --- REND

	-- IP impl.maxsel.rising --- BEGIN
	process (reset, mclk, stateMaxsel)
		-- IP impl.maxsel.vars --- RBEGIN
		variable d0_1, d0_2, d0_3, d0_4, d1_2, d1_3, d1_4, d2_3, d2_4, d3_4: signed(8 downto 0);
		variable ge0_1, ge0_2, ge0_3, ge0_4, ge1_2, ge1_3, ge1_4, ge2_3, ge2_4, ge3_4: boolean;
		variable eq0, eq1, eq2, eq3, eq4: boolean; -- equal to any of the other elements

		type maximds_t is array (0 to 4) of std_logic_vector(7 downto 0);
		variable maximds: maximds_t;

		type ixMaximds_t is array (0 to 4) of natural range 0 to 4;
		variable ixMaximds: ixMaximds_t;

		type unqMaximds_t is array (0 to 4) of boolean;
		variable unqMaximds: unqMaximds_t;

		variable e0_1, e0_2, e0_3, e0_4, e1_2, e1_3, e1_4, e2_3, e2_4, e3_4: signed(8 downto 0);
		variable gf0_1, gf0_2, gf0_3, gf0_4, gf1_2, gf1_3, gf1_4, gf2_3, gf2_4, gf3_4: boolean;
		variable er0, er1, er2, er3, er4: boolean; -- equal to any of the other elements

		variable ixMax: natural range 0 to 4;
		variable unqMax: boolean;

		variable col: natural range 0 to 4;

		variable i: natural range 0 to 8;

		variable flag: std_logic;
		-- IP impl.maxsel.vars --- REND

	begin
		if reset='1' then
			-- IP impl.maxsel.asyncrst --- BEGIN
			stateMaxsel <= stateMaxselInit;
			dCorner <= (others => '0');
			-- IP impl.maxsel.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateMaxsel=stateMaxselInit or cornerrun='0') then
				-- IP impl.maxsel.syncrst --- RBEGIN
				dCorner <= (others => '0');

				for j in 0 to 4 loop
					maximds(j) := (others => '0');
					ixMaximds(j) := 0;
					unqMaximds(j) := false;
				end loop;

				ixMax := 0;
				unqMax := false;

				col := 0;

				i := 0;
				-- IP impl.maxsel.syncrst --- REND

				if cornerrun='0' then
					stateMaxsel <= stateMaxselInit;

				else
					stateMaxsel <= stateMaxselImd;
				end if;

			elsif stateMaxsel=stateMaxselImd then
				if strbDImdstream='1' then
					-- IP impl.maxsel.imd.maxEl --- IBEGIN
					-- find maximum element in incoming column
					d0_1 := signed('0' & dImdstream(39 downto 32)) - signed('0' & dImdstream(31 downto 24));
					ge0_1 := (d0_1(8) = '0');
					d0_2 := signed('0' & dImdstream(39 downto 32)) - signed('0' & dImdstream(23 downto 16));
					ge0_2 := (d0_2(8) = '0');
					d0_3 := signed('0' & dImdstream(39 downto 32)) - signed('0' & dImdstream(15 downto 8));
					ge0_3 := (d0_3(8) = '0');
					d0_4 := signed('0' & dImdstream(39 downto 32)) - signed('0' & dImdstream(7 downto 0));
					ge0_4 := (d0_4(8) = '0');

					eq0 := ((d0_1 = 0) or (d0_2 = 0) or (d0_3 = 0) or (d0_4 = 0));

					d1_2 := signed('0' & dImdstream(31 downto 24)) - signed('0' & dImdstream(23 downto 16));
					ge1_2 := (d1_2(8) = '0');
					d1_3 := signed('0' & dImdstream(31 downto 24)) - signed('0' & dImdstream(15 downto 8));
					ge1_3 := (d1_3(8) = '0');
					d1_4 := signed('0' & dImdstream(31 downto 24)) - signed('0' & dImdstream(7 downto 0));
					ge1_4 := (d1_4(8) = '0');

					eq1 := ((d0_1 = 0) or (d1_2 = 0) or (d1_3 = 0) or (d1_4 = 0));

					d2_3 := signed('0' & dImdstream(23 downto 16)) - signed('0' & dImdstream(15 downto 8));
					ge2_3 := (d2_3(8) = '0');
					d2_4 := signed('0' & dImdstream(23 downto 16)) - signed('0' & dImdstream(7 downto 0));
					ge2_4 := (d2_4(8) = '0');

					eq2 := ((d0_2 = 0) or (d1_2 = 0) or (d2_3 = 0) or (d2_4 = 0));

					d3_4 := signed('0' & dImdstream(15 downto 8)) - signed('0' & dImdstream(7 downto 0));
					ge3_4 := (d3_4(8) = '0');

					eq3 := ((d0_3 = 0) or (d1_3 = 0) or (d2_3 = 0) or (d3_4 = 0));

					eq4 := ((d0_4 = 0) or (d1_4 = 0) or (d2_4 = 0) or (d3_4 = 0));

					if (ge0_1 and ge0_2 and ge0_3 and ge0_4) then
						maximds(col) := dImdstream(39 downto 32);
						ixMaximds(col) := 0;
						unqMaximds(col) := eq0;

					elsif (not ge0_1 and ge1_2 and ge1_3 and ge1_4) then
						maximds(col) := dImdstream(31 downto 24);
						ixMaximds(col) := 1;
						unqMaximds(col) := eq1;

					elsif (not ge0_2 and not ge1_2 and ge2_3 and ge2_4) then
						maximds(col) := dImdstream(23 downto 16);
						ixMaximds(col) := 2;
						unqMaximds(col) := eq2;

					elsif (not ge0_3 and not ge1_3 and not ge2_3 and ge3_4) then
						maximds(col) := dImdstream(15 downto 8);
						ixMaximds(col) := 3;
						unqMaximds(col) := eq3;

					else
						maximds(col) := dImdstream(7 downto 0);
						ixMaximds(col) := 4;
						unqMaximds(col) := eq4;
					end if;
					-- IP impl.maxsel.imd.maxEl --- IEND

					stateMaxsel <= stateMaxselMax;
				end if;

			elsif stateMaxsel=stateMaxselMax then
				-- IP impl.maxsel.max --- IBEGIN
				-- find maximum among columns
				-- insufficient to just check if new maximd is max because current max might be overwritten (with a non-max)
				e0_1 := signed('0' & maximds(0)) - signed('0' & maximds(1));
				gf0_1 := (e0_1(8) = '0');
				e0_2 := signed('0' & maximds(0)) - signed('0' & maximds(2));
				gf0_2 := (e0_2(8) = '0');
				e0_3 := signed('0' & maximds(0)) - signed('0' & maximds(3));
				gf0_3 := (e0_3(8) = '0');
				e0_4 := signed('0' & maximds(0)) - signed('0' & maximds(4));
				gf0_4 := (e0_4(8) = '0');

				er0 := ((e0_1 = 0) or (e0_2 = 0) or (e0_3 = 0) or (e0_4 = 0));

				e1_2 := signed('0' & maximds(1)) - signed('0' & maximds(2));
				gf1_2 := (e1_2(8) = '0');
				e1_3 := signed('0' & maximds(1)) - signed('0' & maximds(3));
				gf1_3 := (e1_3(8) = '0');
				e1_4 := signed('0' & maximds(1)) - signed('0' & maximds(4));
				gf1_4 := (e1_4(8) = '0');

				er1 := ((e0_1 = 0) or (e1_2 = 0) or (e1_3 = 0) or (e1_4 = 0));

				e2_3 := signed('0' & maximds(2)) - signed('0' & maximds(3));
				gf2_3 := (e2_3(8) = '0');
				e2_4 := signed('0' & maximds(2)) - signed('0' & maximds(4));
				gf2_4 := (e2_4(8) = '0');

				er2 := ((e0_2 = 0) or (e1_2 = 0) or (e2_3 = 0) or (e2_4 = 0));

				e3_4 := signed('0' & maximds(3)) - signed('0' & maximds(4));
				gf3_4 := (e3_4(8) = '0');

				er3 := ((e0_3 = 0) or (e1_3 = 0) or (e2_3 = 0) or (e3_4 = 0));

				er4 := ((e0_4 = 0) or (e1_4 = 0) or (e2_4 = 0) or (e3_4 = 0));

				if (gf0_1 and gf0_2 and gf0_3 and gf0_4) then
					ixMax := 0;
					unqMax := er0;

				elsif (not gf0_1 and gf1_2 and gf1_3 and gf1_4) then
					ixMax := 1;
					unqMax := er1;

				elsif (not gf0_2 and not gf1_2 and gf2_3 and gf2_4) then
					ixMax := 2;
					unqMax := er2;

				elsif (not gf0_3 and not gf1_3 and not gf2_3 and gf3_4) then
					ixMax := 3;
					unqMax := er3;

				else
					ixMax := 4;
					unqMax := er4;
				end if;
				-- IP impl.maxsel.max --- IEND

				stateMaxsel <= stateMaxselAct;

			elsif stateMaxsel=stateMaxselAct then
				-- IP impl.maxsel.act.ext --- IBEGIN
				flag := '0';

--				if unqMax then
--					if (col=0 and ixMax=3 and unqMaximds(3) and unsigned(maximds(3))>cornerThd) then
--						flag := '1';
--					elsif (col=1 and ixMax=4 and unqMaximds(4) and unsigned(maximds(4))>cornerThd) then
--						flag := '1';
--					elsif (col=2 and ixMax=0 and unqMaximds(0) and unsigned(maximds(0))>cornerThd) then
--						flag := '1';
--					elsif (col=3 and ixMax=1 and unqMaximds(1) and unsigned(maximds(1))>cornerThd) then
--						flag := '1';
--					elsif (col=4 and ixMax=2 and unqMaximds(2) and unsigned(maximds(2))>cornerThd) then
--						flag := '1';
--					end if;
--				end if;
				if (col=0 and ixMax=3 and unsigned(maximds(3))>cornerThd) then
					flag := '1';
				elsif (col=1 and ixMax=4 and unsigned(maximds(4))>cornerThd) then
					flag := '1';
				elsif (col=2 and ixMax=0 and unsigned(maximds(0))>cornerThd) then
					flag := '1';
				elsif (col=3 and ixMax=1 and unsigned(maximds(1))>cornerThd) then
					flag := '1';
				elsif (col=4 and ixMax=2 and unsigned(maximds(2))>cornerThd) then
					flag := '1';
				end if;

				if col=4 then
					col := 0;
				else
					col := col + 1;
				end if;

				dCorner(7-i) <= flag;

				i := i + 1;
				-- IP impl.maxsel.act.ext --- IEND

				if i=8 then
					i := 0; -- IP impl.maxsel.act.toStore --- ILINE

					stateMaxsel <= stateMaxselStore;

				else
					stateMaxsel <= stateMaxselImd;
				end if;

			elsif stateMaxsel=stateMaxselStore then
				stateMaxsel <= stateMaxselImd;
			end if;
		end if;
	end process;
	-- IP impl.maxsel.rising --- END

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	-- IP impl.op.wiring --- BEGIN
	ackInvSet <= ackInvSet_sig;
	ackInvSetCorner <= ackInvSetCorner_sig;
	ackInvSetThd <= ackInvSetThd_sig;
	-- IP impl.op.wiring --- END

	-- IP impl.op.rising --- BEGIN
	process (reset, mclk, stateOp)
		-- IP impl.op.vars --- BEGIN
		-- IP impl.op.vars --- END

	begin
		if reset='1' then
			-- IP impl.op.asyncrst --- BEGIN
			stateOp <= stateOpInit;
			streamrun <= '0';
			ackInvSet_sig <= '0';
			thdNotCorner <= '0';
			thdDeltaNotAbs <= '0';
			ackInvSetCorner_sig <= '0';
			cornerLinNotLog <= '0';
			cornerThd <= 127;
			ackInvSetThd_sig <= '0';
			thdLvlFirst <= (others => '0');
			thdLvlSecond <= (others => '0');
			-- IP impl.op.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateOp=stateOpInit or (stateOp/=stateOpInv and stateOp/=stateOpInvSet and (reqInvSet='1' or reqInvSetCorner='1' or reqInvSetThd='1'))) then
				if reqInvSet='1' then
					streamrun <= '0'; -- IP impl.op.init.invSet --- ILINE

					stateOp <= stateOpInvSet;

				elsif reqInvSetCorner='1' then
					-- IP impl.op.init.invSetCorner --- IBEGIN
					if setCornerLinNotLog=tru8 then
						cornerLinNotLog <= '1';
					else
						cornerLinNotLog <= '0';
					end if;
					cornerThd <= to_integer(unsigned(setCornerThd));

					ackInvSetCorner_sig <= '1';
					-- IP impl.op.init.invSetCorner --- IEND

					stateOp <= stateOpInv;

				elsif reqInvSetThd='1' then
					-- IP impl.op.init.invSetThd --- IBEGIN
					thdLvlFirst <= setThdLvlFirst;
					thdLvlSecond <= setThdLvlSecond;

					ackInvSetThd_sig <= '1';
					-- IP impl.op.init.invSetThd --- IEND

					stateOp <= stateOpInv;

				elsif streamrun='1' then
					stateOp <= stateOpRun;

				else
					-- IP impl.op.syncrst --- RLINE

					stateOp <= stateOpInit;
				end if;

			elsif stateOp=stateOpInvSet then
				-- IP impl.op.invSet --- IBEGIN
				if setRng=tru8 then
					streamrun <= '1';
				else
					streamrun <= '0';
				end if;

				if setThdNotCorner=tru8 then
					thdNotCorner <= '1';
				else
					thdNotCorner <= '0';
				end if;
				
				if setThdDeltaNotAbs=tru8 then
					thdDeltaNotAbs <= '1';
				else
					thdDeltaNotAbs <= '0';
				end if;
				
				ackInvSet_sig <= '1';
				-- IP impl.op.invSet --- IEND

				stateOp <= stateOpInv;

			elsif stateOp=stateOpInv then
				if ((reqInvSet='0' and ackInvSet_sig='1') or (reqInvSetCorner='0' and ackInvSetCorner_sig='1') or (reqInvSetThd='0' and ackInvSetThd_sig='1')) then
					-- IP impl.op.inv --- IBEGIN
					ackInvSet_sig <= '0';
					ackInvSetCorner_sig <= '0';
					ackInvSetThd_sig <= '0';
					-- IP impl.op.inv --- IEND

					stateOp <= stateOpInit;
				end if;

			elsif stateOp=stateOpRun then
				-- IP impl.op.run --- INSERT
			end if;
		end if;
	end process;
	-- IP impl.op.rising --- END

	------------------------------------------------------------------------
	-- implementation: streaming operation, also handling grrd{ab/cd/ef}bufFromCamacq (stream)
	------------------------------------------------------------------------

	-- IP impl.stream.wiring --- RBEGIN
	reqGrrdabbufFromCamacq <= reqGrrdbuf;
	reqGrrdcdbufFromCamacq <= reqGrrdbuf;
	reqGrrdefbufFromCamacq <= reqGrrdbuf;

	ackGrrdbuf <= (ackGrrdabbufFromCamacq and ackGrrdcdbufFromCamacq and ackGrrdefbufFromCamacq);

	strbDGrrdabbufFromCamacq <= strbDGrrdbuf;
	strbDGrrdcdbufFromCamacq <= strbDGrrdbuf;
	strbDGrrdefbufFromCamacq <= strbDGrrdbuf;
	strbDGrrdbuf <= '1' when (stateStream=stateStreamLoadAceB or stateStream=stateStreamLoadBdfB) else '0';

	strbDStream <= '1' when stateStream=stateStreamLoadBdfB else '0';

	stateStream_dbg <= x"00" when stateStream=stateStreamInit
		else x"10" when stateStream=stateStreamWaitFrame
		else x"20" when stateStream=stateStreamSkipA
		else x"21" when stateStream=stateStreamSkipB
		else x"30" when stateStream=stateStreamStartrowA
		else x"31" when stateStream=stateStreamStartrowB
		else x"40" when stateStream=stateStreamLoadAceA
		else x"41" when stateStream=stateStreamLoadAceB
		else x"50" when stateStream=stateStreamLoadBdfA
		else x"51" when stateStream=stateStreamLoadBdfB
		else x"60" when stateStream=stateStreamStoprow
		else x"FF";
	-- IP impl.stream.wiring --- REND

	-- IP impl.stream.rising --- BEGIN
	process (reset, mclk, stateStream)
		-- IP impl.stream.vars --- RBEGIN
		variable row: natural range 0 to 6;
		variable col: natural range 0 to 1024;
		-- IP impl.stream.vars --- REND

	begin
		if reset='1' then
			-- IP impl.stream.asyncrst --- BEGIN
			stateStream <= stateStreamInit;
			reqGrrdbuf <= '0';
			dStream <= (others => '0');
			-- IP impl.stream.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateStream=stateStreamInit or streamrun='0') then
				-- IP impl.stream.syncrst --- RBEGIN
				reqGrrdbuf <= '0';
				dStream <= (others => '0');

				row := 0;
				col := 0;
				-- IP impl.stream.syncrst --- REND

				if streamrun='0' then
					stateStream <= stateStreamInit;

				else
					stateStream <= stateStreamWaitFrame;
				end if;

			elsif stateStream=stateStreamWaitFrame then
				if camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstateEmpty then
					row := 0; -- IP impl.stream.waitFrame --- ILINE

					stateStream <= stateStreamSkipA;
				end if;

			elsif stateStream=stateStreamSkipA then
				if camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstateStream then
					stateStream <= stateStreamSkipB;
				end if;

			elsif stateStream=stateStreamSkipB then
				if camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstatePause then
					row := row + 1; -- IP impl.stream.skipB.inc --- ILINE

					if row=5 then
						stateStream <= stateStreamStartrowA;

					else
						stateStream <= stateStreamSkipA;
					end if;
				end if;

			elsif stateStream=stateStreamStartrowA then
				if camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstateStream then
					reqGrrdbuf <= '1'; -- IP impl.stream.startrowA --- ILINE

					stateStream <= stateStreamStartrowB;
				end if;

			elsif stateStream=stateStreamStartrowB then
				if ackGrrdbuf='1' then
					col := 0; -- IP impl.stream.startrowB --- ILINE

					stateStream <= stateStreamLoadAceA;
				end if;

			elsif stateStream=stateStreamLoadAceA then
				-- IP impl.stream.loadAceA --- IBEGIN
				if row=0 then
					-- (bcdefa)
					dStream(39 downto 32) <= dGrrdcdbufFromCamacq;
					dStream(23 downto 16) <= dGrrdefbufFromCamacq;
					dStream(7 downto 0) <= dGrrdabbufFromCamacq;
				elsif row=1 then
					-- (cdefab)
					dStream(47 downto 40) <= dGrrdcdbufFromCamacq;
					dStream(31 downto 24) <= dGrrdefbufFromCamacq;
					dStream(15 downto 8) <= dGrrdabbufFromCamacq;
				elsif row=2 then
					-- (defabc)
					dStream(39 downto 32) <= dGrrdefbufFromCamacq;
					dStream(23 downto 16) <= dGrrdabbufFromCamacq;
					dStream(7 downto 0) <= dGrrdcdbufFromCamacq;
				elsif row=3 then
					-- (efabcd)
					dStream(47 downto 40) <= dGrrdefbufFromCamacq;
					dStream(31 downto 24) <= dGrrdabbufFromCamacq;
					dStream(15 downto 8) <= dGrrdcdbufFromCamacq;
				elsif row=4 then
					-- (fabcde)
					dStream(39 downto 32) <= dGrrdabbufFromCamacq;
					dStream(23 downto 16) <= dGrrdcdbufFromCamacq;
					dStream(7 downto 0) <= dGrrdefbufFromCamacq;
				else
					-- (abcdef)
					dStream(47 downto 40) <= dGrrdabbufFromCamacq;
					dStream(31 downto 24) <= dGrrdcdbufFromCamacq;
					dStream(15 downto 8) <= dGrrdefbufFromCamacq;
				end if;
				-- IP impl.stream.loadAceA --- IEND

				stateStream <= stateStreamLoadAceB;

			elsif stateStream=stateStreamLoadAceB then
				stateStream <= stateStreamLoadBdfA;

			elsif stateStream=stateStreamLoadBdfA then
				-- IP impl.stream.loadBdfA --- IBEGIN
				if row=0 then
					-- (bcdefa)
					dStream(47 downto 40) <= dGrrdabbufFromCamacq;
					dStream(31 downto 24) <= dGrrdcdbufFromCamacq;
					dStream(15 downto 8) <= dGrrdefbufFromCamacq;
				elsif row=1 then
					-- (cdefab)
					dStream(39 downto 32) <= dGrrdcdbufFromCamacq;
					dStream(23 downto 16) <= dGrrdefbufFromCamacq;
					dStream(7 downto 0) <= dGrrdabbufFromCamacq;
				elsif row=2 then
					-- (defabc)
					dStream(47 downto 40) <= dGrrdcdbufFromCamacq;
					dStream(31 downto 24) <= dGrrdefbufFromCamacq;
					dStream(15 downto 8) <= dGrrdabbufFromCamacq;
				elsif row=3 then
					-- (efabcd)
					dStream(39 downto 32) <= dGrrdefbufFromCamacq;
					dStream(23 downto 16) <= dGrrdabbufFromCamacq;
					dStream(7 downto 0) <= dGrrdcdbufFromCamacq;
				elsif row=4 then
					-- (fabcde)
					dStream(47 downto 40) <= dGrrdefbufFromCamacq;
					dStream(31 downto 24) <= dGrrdabbufFromCamacq;
					dStream(15 downto 8) <= dGrrdcdbufFromCamacq;
				else
					-- (abcdef)
					dStream(39 downto 32) <= dGrrdabbufFromCamacq;
					dStream(23 downto 16) <= dGrrdcdbufFromCamacq;
					dStream(7 downto 0) <= dGrrdefbufFromCamacq;
				end if;
				-- IP impl.stream.loadBdfA --- IEND

				stateStream <= stateStreamLoadBdfB;

			elsif stateStream=stateStreamLoadBdfB then
				col := col + 1; -- IP impl.stream.loadBdfB.ext --- ILINE

				if col=1024 then
					reqGrrdbuf <= '0'; -- IP impl.stream.loadBdfB.lastCol --- ILINE

					stateStream <= stateStreamStoprow;

				else
					stateStream <= stateStreamLoadAceA;
				end if;

			elsif stateStream=stateStreamStoprow then
				if camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstatePause then
					 -- IP impl.stream.stoprow.incRow --- IBEGIN
					row := row + 1;

					if row=6 then
						row := 0;
					end if;
					 -- IP impl.stream.stoprow.incRow --- IEND

					stateStream <= stateStreamStartrowA;

				elsif camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstateEndfr then
					stateStream <= stateStreamInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.stream.rising --- END

	------------------------------------------------------------------------
	-- implementation: threshold detection (thd)
	------------------------------------------------------------------------

	-- IP impl.thd.wiring --- RBEGIN
	stateThd_dbg <= x"00" when stateThd=stateThdInit
		else x"10" when stateThd=stateThdLASA
		else x"11" when stateThd=stateThdLASB
		else x"20" when stateThd=stateThdDone
		else x"FF";
	-- IP impl.thd.wiring --- REND

	-- IP impl.thd.rising --- BEGIN
	process (reset, mclk, stateThd)
		-- IP impl.thd.vars --- RBEGIN
		variable flg6A: std_logic_vector(47 downto 0);
		variable flg6B: std_logic_vector(47 downto 0);

		variable ab: natural range 0 to 1; -- accumulator used for 'adding' - 0: a, 1: b

		variable blk: natural range 0 to 127; -- (768-6)/6
		variable row: natural range 0 to 6;

		variable pre: std_logic;

		variable col: natural range 0 to 1024;

		variable byteL: natural range 0 to 6; -- byte to load (6 bytes with each 8 pixels)
		variable colA: natural range 0 to 8; -- actual column (pixel)
		variable byteS: natural range 0 to 6; -- byte to store (6 bytes with each 8 pixels)
		-- IP impl.thd.vars --- REND

	begin
		if reset='1' then
			-- IP impl.thd.asyncrst --- BEGIN
			stateThd <= stateThdInit;
			dwrThd <= (others => '0');
			strbDwrThd <= '0';
			strbDrdThd <= '0';
			-- IP impl.thd.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateThd=stateThdInit or thdrun='0') then
				-- IP impl.thd.syncrst --- RBEGIN
				strbDrdThd <= '0';
				dwrThd <= (others => '0');
				strbDwrThd <= '0';

				flg6A := (others => '0');
				flg6B := (others => '0');
				blk := 0;
				row := 0;
				col := 0;
				colA := 0;
				byteS := 6;
				-- IP impl.thd.syncrst --- REND

				if thdrun='0' then
					byteL := 6; -- IP impl.thd.init.stop --- ILINE

					stateThd <= stateThdInit;

				else
					-- IP impl.thd.init.start --- IBEGIN
					-- at this stage, camacqGetGrrdinfoTixVGrrdbufstate=tixVCamacqGrrdbufstateEmpty
					if thdSecondNotFirst='1' then
						-- initiate load
						ab := 1;
						pre := '1';
						byteL := 0; 

					else
						ab := 0;
						pre := '0';
						byteL := 6;
					end if;
					-- IP impl.thd.init.start --- IEND

					stateThd <= stateThdLASA;
				end if;

			elsif stateThd=stateThdLASA then
				-- IP impl.thd.LASA --- IBEGIN
				if strbDStream='1' then
					if row=0 then
						-- 'add' (compare)
						if thdSecondNotFirst='0' then
							if ab=0 then
								for abcdef in 0 to 5 loop -- f:0, a:5
									if (unsigned(dStream(8*(abcdef+1)-1 downto 8*abcdef)) > unsigned(thdLvlFirst)) then
										flg6A(8*abcdef + (8-colA) - 1) := '1';
									else
										flg6A(8*abcdef + (8-colA) - 1) := '0';
									end if;
								end loop;

							else
								for abcdef in 0 to 5 loop -- f:0, a:5
									if (unsigned(dStream(8*(abcdef+1)-1 downto 8*abcdef)) > unsigned(thdLvlFirst)) then
										flg6B(8*abcdef + (8-colA) - 1) := '1';
									else
										flg6B(8*abcdef + (8-colA) - 1) := '0';
									end if;
								end loop;
							end if;

						else
							if ab=0 then
								for abcdef in 0 to 5 loop -- f:0, a:5
									if ( (unsigned(dStream(8*(abcdef+1)-1 downto 8*abcdef)) > unsigned(thdLvlSecond)) and flg6A(8*abcdef + (8-colA) - 1)='1' ) then
										flg6A(8*abcdef + (8-colA) - 1) := '0';
									end if;
								end loop;
	
							else
								for abcdef in 0 to 5 loop -- f:0, a:5
									if ( (unsigned(dStream(8*(abcdef+1)-1 downto 8*abcdef)) > unsigned(thdLvlSecond)) and flg6B(8*abcdef + (8-colA) - 1)='1' ) then
										flg6B(8*abcdef + (8-colA) - 1) := '0';
									end if;
								end loop;
							end if;
						end if;

						colA := colA + 1;
						
						if colA=8 then
							colA := 0;

							byteS := 0; -- initiate store

							if thdSecondNotFirst='1' then
								byteL := 0; -- initiate load (after store)
							end if;

							if ab=1 then
								ab := 0;
							else
								ab := ab + 1;
							end if;
						end if;
					end if;

					-- increment, relies on exact number of 1024 strbDStream's per row, rows 0..762
					col := col + 1;

					if col=1024 then
						col := 0;

						row := row + 1;

						if row=6 then
							row := 0;

							blk := blk + 1;
						end if;
					end if;
				end if;

				if (strbDStream='1' or byteS<6 or byteL<6) then
					stateThd <= stateThdLASB;
				end if;

				if byteS<6 then
					-- store
					if ab=0 then
						dwrThd <= flg6B(8*(6-byteS)-1 downto 8*(6-byteS-1));
					else
						dwrThd <= flg6A(8*(6-byteS)-1 downto 8*(6-byteS-1));
					end if;
					strbDwrThd <= '1';

					byteS := byteS + 1;

				elsif byteL<6 then
					-- load
					if ab=0 then
						flg6B(8*(6-byteL)-1 downto 8*(6-byteL-1)) := drdThd;
					else
						flg6A(8*(6-byteL)-1 downto 8*(6-byteL-1)) := drdThd;
					end if;
					strbDrdThd <= '1';

					byteL := byteL + 1;
				end if;
				-- IP impl.thd.LASA --- IEND

			elsif stateThd=stateThdLASB then
				-- IP impl.thd.LASB.ext --- IBEGIN
				strbDrdThd <= '0';
				strbDwrThd <= '0';

				if (pre='1' and byteL=6) then
					ab := 0;
					pre := '0';
					byteL := 0;
				end if;
				-- IP impl.thd.LASB.ext --- IEND

				if (blk=127 and row=1 and byteS=6) then
					stateThd <= stateThdDone;

				else
					stateThd <= stateThdLASA;
				end if;

			elsif stateThd=stateThdDone then
				-- IP impl.thd.done --- INSERT
			end if;
		end if;
	end process;
	-- IP impl.thd.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- IBEGIN
	mclkn <= not mclk;

	strb_dbg <= ceScore & strbDStream & strbDwrThd & strbDrdThd;
	-- IP impl.oth.cust --- IEND

end Featdet;
