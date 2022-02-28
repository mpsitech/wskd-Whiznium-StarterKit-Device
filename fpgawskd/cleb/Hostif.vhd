-- file Hostif.vhd
-- Hostif uarthostif_Easy_v1_0 easy model host interface implementation
-- copyright: (C) 2017-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 24 Dec 2021
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Cleb.all;

entity Hostif is
	generic (
		fMclk: natural range 1 to 1000000 := 50000;
		fSclk: natural range 100 to 50000000 := 5000000
	);
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

		stateGetTixVClebState: in std_logic_vector(7 downto 0);

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

		rxd: in std_logic;
		txd: out std_logic
	);
end Hostif;

architecture Hostif of Hostif is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Crc8005_v1_0 is
		port (
			reset: in std_logic;
			mclk: in std_logic;

			req: in std_logic;
			ack: out std_logic;
			dne: out std_logic;

			captNotFin: in std_logic;

			d: in std_logic_vector(7 downto 0);
			strbD: in std_logic;

			crc: out std_logic_vector(15 downto 0)
		);
	end component;

	component Uartrx_v1_1 is
		generic (
			fMclk: natural range 1 to 1000000 := 100000;
			fSclk: natural range 100 to 50000000 := 9600
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;

			req: in std_logic;
			ack: out std_logic;
			dne: out std_logic;

			len: in std_logic_vector(16 downto 0);

			d: out std_logic_vector(7 downto 0);
			strbD: out std_logic;

			burst: in std_logic;
			rxd: in std_logic
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

	component Uarttx_v1_0 is
		generic (
			fMclk: natural range 1 to 1000000 := 100000;

			fSclk: natural range 100 to 50000000 := 9600;
			Nstop: natural range 1 to 8 := 1
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;

			req: in std_logic;
			ack: out std_logic;
			dne: out std_logic;

			len: in std_logic_vector(16 downto 0);

			d: in std_logic_vector(7 downto 0);
			strbD: out std_logic;

			txd: out std_logic
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

	constant sizeOpbuf: natural := 7;
	type opbuf_t is array (0 to sizeOpbuf-1) of std_logic_vector(7 downto 0);
	signal opbuf: opbuf_t;

	constant sizeRxbuf: natural := 7;
	type rxbuf_t is array (0 to sizeRxbuf-1) of std_logic_vector(7 downto 0);
	signal rxbuf: rxbuf_t;

	constant sizeTxbuf: natural := 6;
	type txbuf_t is array (0 to sizeTxbuf-1) of std_logic_vector(7 downto 0);
	signal txbuf: txbuf_t;

	signal commok_sig: std_logic;
	
	signal reqReset_sig: std_logic;

	signal ackVoidinv: std_logic;
	signal ackInv: std_logic;

	signal reqTxbuf: std_logic;
	signal ackTxbuf: std_logic;
	signal dneTxbuf: std_logic;

	signal avllenTxbuf: natural range 0 to 65534;

	signal dTxbuf: std_logic_vector(7 downto 0);
	signal strbDTxbuf: std_logic;

	signal reqRxbuf: std_logic;
	signal ackRxbuf: std_logic;
	signal dneRxbuf: std_logic;

	signal avllenRxbuf: natural range 0 to 65534;

	signal dRxbuf: std_logic_vector(7 downto 0);
	signal strbDRxbuf: std_logic;

	signal crccaptNotFin: std_logic;

	signal crcd: std_logic_vector(7 downto 0);
	signal strbCrcd: std_logic;

	signal torestart: std_logic;
	signal urxlen: std_logic_vector(16 downto 0);
	signal urxburst: std_logic;
	signal utxlen: std_logic_vector(16 downto 0);

	signal utxd: std_logic_vector(7 downto 0);

	signal laserSetL_sig: std_logic_vector(15 downto 0);
	signal laserSetR_sig: std_logic_vector(15 downto 0);

	signal stepMovetoAngle_sig: std_logic_vector(15 downto 0);
	signal stepMovetoTstep_sig: std_logic_vector(7 downto 0);

	signal stepSetRng_sig: std_logic_vector(7 downto 0);
	signal stepSetCcwNotCw_sig: std_logic_vector(7 downto 0);
	signal stepSetTstep_sig: std_logic_vector(7 downto 0);

	signal tkclksrcSetTkstTkst_sig: std_logic_vector(31 downto 0);

	---- myCrc
	signal crc: std_logic_vector(15 downto 0);

	---- myRx
	signal urxd: std_logic_vector(7 downto 0);
	signal strbUrxd: std_logic;

	---- myTimeout
	signal timeout: std_logic;

	---- myTimeout2
	signal timeout2: std_logic;

	---- myTx
	signal strbUtxd: std_logic;

	---- handshake
	-- op to myCrc
	signal reqCrc: std_logic;
	signal ackCrc: std_logic;
	signal dneCrc: std_logic;

	-- op to myRx
	signal reqUrx: std_logic;
	signal ackUrx: std_logic;
	signal dneUrx: std_logic;

	-- op to myTx
	signal reqUtx: std_logic;
	signal ackUtx: std_logic;
	signal dneUtx: std_logic;

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myCrc : Crc8005_v1_0
		port map (
			reset => reset,
			mclk => mclk,

			req => reqCrc,
			ack => ackCrc,
			dne => dneCrc,

			captNotFin => crccaptNotFin,

			d => crcd,
			strbD => strbCrcd,

			crc => crc
		);

	myRx : Uartrx_v1_1
		generic map (
			fMclk => fMclk,
			fSclk => fSclk
		)
		port map (
			reset => reset,
			mclk => mclk,

			req => reqUrx,
			ack => ackUrx,
			dne => dneUrx,

			len => urxlen,

			d => urxd,
			strbD => strbUrxd,

			burst => urxburst,
			rxd => rxd
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

	myTx : Uarttx_v1_0
		generic map (
			fMclk => fMclk,

			fSclk => fSclk,
			Nstop => 1
		)
		port map (
			reset => reset,
			mclk => mclk,

			req => reqUtx,
			ack => ackUtx,
			dne => dneUtx,

			len => utxlen,

			d => utxd,
			strbD => strbUtxd,

			txd => txd
		);

	------------------------------------------------------------------------
	-- implementation: main operation 
	------------------------------------------------------------------------

	commok <= commok_sig;
	reqReset <= reqReset_sig;

	-- tx/ret command

	ackVoidinv <= '0';

	-- rx/inv command
	reqInvLaserSet <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVClebControllerLaser and opbuf(ixOpbufCommand)=tixVLaserCommandSet) else '0';
	reqInvStepMoveto <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVClebControllerStep and opbuf(ixOpbufCommand)=tixVStepCommandMoveto) else '0';
	reqInvStepSet <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVClebControllerStep and opbuf(ixOpbufCommand)=tixVStepCommandSet) else '0';
	reqInvStepZero <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVClebControllerStep and opbuf(ixOpbufCommand)=tixVStepCommandZero) else '0';
	reqInvTkclksrcSetTkst <= '1' when (stateOp=stateOpCopyRxB and opbuf(ixOpbufController)=tixVClebControllerTkclksrc and opbuf(ixOpbufCommand)=tixVTkclksrcCommandSetTkst) else '0';

	ackInv <= ackInvLaserSet when (opbuf(ixOpbufController)=tixVClebControllerLaser and opbuf(ixOpbufCommand)=tixVLaserCommandSet)
				else ackInvStepMoveto when (opbuf(ixOpbufController)=tixVClebControllerStep and opbuf(ixOpbufCommand)=tixVStepCommandMoveto)
				else ackInvStepSet when (opbuf(ixOpbufController)=tixVClebControllerStep and opbuf(ixOpbufCommand)=tixVStepCommandSet)
				else ackInvStepZero when (opbuf(ixOpbufController)=tixVClebControllerStep and opbuf(ixOpbufCommand)=tixVStepCommandZero)
				else ackInvTkclksrcSetTkst when (opbuf(ixOpbufController)=tixVClebControllerTkclksrc and opbuf(ixOpbufCommand)=tixVTkclksrcCommandSetTkst)
				else '0';

	-- tx buffer

	ackTxbuf <= '0';

	avllenTxbuf <= 0;

	dTxbuf <= (others => '0');

	-- rx buffer

	ackRxbuf <= '0';

	avllenRxbuf <= 0;

	-- IP impl.op.wiring --- BEGIN
	laserSetL <= laserSetL_sig;
	laserSetR <= laserSetR_sig;

	stepMovetoAngle <= stepMovetoAngle_sig;
	stepMovetoTstep <= stepMovetoTstep_sig;

	stepSetRng <= stepSetRng_sig;
	stepSetCcwNotCw <= stepSetCcwNotCw_sig;
	stepSetTstep <= stepSetTstep_sig;

	tkclksrcSetTkstTkst <= tkclksrcSetTkstTkst_sig;
	-- IP impl.op.wiring --- END

	reqCrc <= '1' when (stateOp=stateOpRxopA or stateOp=stateOpRxopB or stateOp=stateOpRxopC or stateOp=stateOpRxopD or stateOp=stateOpRxopE
				or stateOp=stateOpRxA or stateOp=stateOpRxB or stateOp=stateOpRxC or stateOp=stateOpRxD
				or stateOp=stateOpTxA or stateOp=stateOpTxB or stateOp=stateOpTxC or stateOp=stateOpTxD or stateOp=stateOpTxE or stateOp=stateOpTxF
				or stateOp=stateOpTxbufB or stateOp=stateOpTxbufC or stateOp=stateOpTxbufD or stateOp=stateOpTxbufE or stateOp=stateOpTxbufF
				or stateOp=stateOpTxbufG or stateOp=stateOpTxbufH or stateOp=stateOpTxbufI or stateOp=stateOpTxbufJ
				or stateOp=stateOpRxbufA or stateOp=stateOpRxbufB or stateOp=stateOpRxbufC or stateOp=stateOpRxbufD) else '0';

	crccaptNotFin <= '1' when (stateOp=stateOpRxopA or stateOp=stateOpRxopB or stateOp=stateOpRxopC
				or stateOp=stateOpRxA or stateOp=stateOpRxB or stateOp=stateOpRxC
				or stateOp=stateOpTxA or stateOp=stateOpTxB or stateOp=stateOpTxC
				or stateOp=stateOpTxbufB or stateOp=stateOpTxbufC or stateOp=stateOpTxbufD or stateOp=stateOpTxbufE or stateOp=stateOpTxbufF or stateOp=stateOpTxbufG
				or stateOp=stateOpRxbufA or stateOp=stateOpRxbufB or stateOp=stateOpRxbufC) else '0';

	strbCrcd <= '1' when (stateOp=stateOpRxopC or stateOp=stateOpRxC or stateOp=stateOpTxB or stateOp=stateOpTxbufC or stateOp=stateOpRxbufC) else '0';

	reqUrx <= '1' when (stateOp=stateOpRxopA or stateOp=stateOpRxopB or stateOp=stateOpRxopC or stateOp=stateOpRxopD
				or stateOp=stateOpRxA or stateOp=stateOpRxB or stateOp=stateOpRxC
				or stateOp=stateOpRxbufA or stateOp=stateOpRxbufB or stateOp=stateOpRxbufC) else '0';

	reqUtx <= '1' when (stateOp=stateOpTxA or stateOp=stateOpTxB or stateOp=stateOpTxC or stateOp=stateOpTxD or stateOp=stateOpTxE or stateOp=stateOpTxF
				or stateOp=stateOpTxbufB or stateOp=stateOpTxbufC or stateOp=stateOpTxbufD or stateOp=stateOpTxbufE or stateOp=stateOpTxbufF or stateOp=stateOpTxbufG or stateOp=stateOpTxbufH
				or stateOp=stateOpTxbufI or stateOp=stateOpTxbufJ
				or stateOp=stateOpTxackA or stateOp=stateOpTxackB) else '0';

	stateOp_dbg <= x"00" when stateOp=stateOpIdle
				else x"10" when stateOp=stateOpRxopA
				else x"11" when stateOp=stateOpRxopB
				else x"12" when stateOp=stateOpRxopC
				else x"13" when stateOp=stateOpRxopD
				else x"14" when stateOp=stateOpRxopE
				else x"20" when stateOp=stateOpPrepTxA
				else x"21" when stateOp=stateOpPrepTxB
				else x"30" when stateOp=stateOpTxA
				else x"31" when stateOp=stateOpTxB
				else x"32" when stateOp=stateOpTxC
				else x"33" when stateOp=stateOpTxD
				else x"34" when stateOp=stateOpTxE
				else x"35" when stateOp=stateOpTxF
				else x"40" when stateOp=stateOpTxbufA
				else x"41" when stateOp=stateOpTxbufB
				else x"42" when stateOp=stateOpTxbufC
				else x"43" when stateOp=stateOpTxbufD
				else x"44" when stateOp=stateOpTxbufE
				else x"45" when stateOp=stateOpTxbufF
				else x"46" when stateOp=stateOpTxbufG
				else x"47" when stateOp=stateOpTxbufH
				else x"48" when stateOp=stateOpTxbufI
				else x"49" when stateOp=stateOpTxbufJ
				else x"4A" when stateOp=stateOpTxbufK
				else x"50" when stateOp=stateOpPrepRx
				else x"60" when stateOp=stateOpRxA
				else x"61" when stateOp=stateOpRxB
				else x"62" when stateOp=stateOpRxC
				else x"63" when stateOp=stateOpRxD
				else x"70" when stateOp=stateOpCopyRxA
				else x"71" when stateOp=stateOpCopyRxB
				else x"80" when stateOp=stateOpPrepRxbuf
				else x"90" when stateOp=stateOpRxbufA
				else x"91" when stateOp=stateOpRxbufB
				else x"92" when stateOp=stateOpRxbufC
				else x"93" when stateOp=stateOpRxbufD
				else x"94" when stateOp=stateOpRxbufE
				else x"A0" when stateOp=stateOpTxackA
				else x"A1" when stateOp=stateOpTxackB
				else x"FF";

	process (reset, mclk, stateOp)
		variable i: natural range 0 to 65536;
		variable icrc: natural range 0 to 65536; -- for tx and txbuf

		variable x: std_logic_vector(16 downto 0);

	begin
		if reset='1' then
			stateOp <= stateOpIdle;
			torestart <= '0';
			crcd <= (others => '0');
			utxd <= (others => '0');
			commok_sig <= '0';
			reqReset_sig <= '0';
			reqTxbuf <= '0';
			dneTxbuf <= '0';
			strbDTxbuf <= '0';
			reqRxbuf <= '0';
			dneRxbuf <= '0';
			dRxbuf <= x"00";
			strbDRxbuf <= '0';

			laserSetL_sig <= (others => '0');
			laserSetR_sig <= (others => '0');
			stepMovetoAngle_sig <= (others => '0');
			stepMovetoTstep_sig <= x"60";
			stepSetRng_sig <= fls8;
			stepSetCcwNotCw_sig <= fls8;
			stepSetTstep_sig <= x"60";
			tkclksrcSetTkstTkst_sig <= (others => '0');

		elsif rising_edge(mclk) then
			if stateOp=stateOpIdle then
				urxlen <= std_logic_vector(to_unsigned(sizeOpbuf, 17));
				urxburst <= '0';
				crcd <= (others => '0');
				utxd <= (others => '0');
				reqTxbuf <= '0';
				dneTxbuf <= '0';
				strbDTxbuf <= '0';
				reqRxbuf <= '0';
				dneRxbuf <= '0';
				dRxbuf <= x"00";
				strbDRxbuf <= '0';

				i := 0;

				torestart <= '1';

				if ackUrx='0' then
					stateOp <= stateOpRxopA;
				end if;

-- RX OP BEGIN
			elsif stateOp=stateOpRxopA then
				if (ackCrc='1' and ackUrx='1') then
					stateOp <= stateOpRxopB;

				elsif timeout='1' then
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpRxopB then
				if ackUrx='0' then
					stateOp <= stateOpIdle;

				elsif strbUrxd='1' then
					opbuf(i) <= urxd;

					crcd <= urxd;

					if (i=0 and urxd=x"FF") then
						reqReset_sig <= '1';
					else
						torestart <= '1';

						stateOp <= stateOpRxopC;
					end if;
				end if;

			elsif stateOp=stateOpRxopC then -- strbCrcd='1'
				if strbUrxd='0' then
					i := i + 1;

					stateOp <= stateOpRxopB;

				elsif dneUrx='1' then
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
						urxburst <= '1';
						stateOp <= stateOpRxopE;
					else
						commok_sig <= '0';
						stateOp <= stateOpIdle;
					end if;
				end if;

			elsif stateOp=stateOpRxopE then
				if opbuf(ixOpbufBuffer)=tixWClebBufferCmdretToHostif then
					urxburst <= '0';

					if ( 0=1 ) then

						stateOp <= stateOpVoidinv;

					elsif ( (opbuf(ixOpbufController)=tixVClebControllerState and (opbuf(ixOpbufCommand)=tixVStateCommandGet))
								or (opbuf(ixOpbufController)=tixVClebControllerStep and (opbuf(ixOpbufCommand)=tixVStepCommandGetInfo))
								or (opbuf(ixOpbufController)=tixVClebControllerTkclksrc and (opbuf(ixOpbufCommand)=tixVTkclksrcCommandGetTkst)) ) then

						stateOp <= stateOpPrepTxA;
					end if;

				elsif opbuf(ixOpbufBuffer)=tixWClebBufferHostifToCmdinv then
					if ( (opbuf(ixOpbufController)=tixVClebControllerLaser and (opbuf(ixOpbufCommand)=tixVLaserCommandSet))
								or (opbuf(ixOpbufController)=tixVClebControllerStep and (opbuf(ixOpbufCommand)=tixVStepCommandMoveto or opbuf(ixOpbufCommand)=tixVStepCommandSet or opbuf(ixOpbufCommand)=tixVStepCommandZero))
								or (opbuf(ixOpbufController)=tixVClebControllerTkclksrc and (opbuf(ixOpbufCommand)=tixVTkclksrcCommandSetTkst)) ) then

						urxlen <= "0" & opbuf(ixOpbufLength) & opbuf(ixOpbufLength+1); -- 2 bytes of CRC included

						i := 0;

						stateOp <= stateOpPrepRx;

					else
						stateOp <= stateOpIdle;
					end if;

				elsif avllenTxbuf/=0 then
					urxburst <= '0';

					i := 0;

					icrc := avllenTxbuf;
					x := std_logic_vector(to_unsigned(avllenTxbuf + 2, 17));

					if (opbuf(ixOpbufLength)=x(15 downto 8) and opbuf(ixOpbufLength+1)=x(7 downto 0)) then
						utxlen <= x;

						reqTxbuf <= '1';

						stateOp <= stateOpTxbufA;

					else
						stateOp <= stateOpIdle;
					end if;

				elsif avllenRxbuf/=0 then
					i := 0;

					icrc := avllenRxbuf;
					x := std_logic_vector(to_unsigned(avllenRxbuf + 2, 17));

					if (opbuf(ixOpbufLength)=x(15 downto 8) and opbuf(ixOpbufLength+1)=x(7 downto 0)) then
						urxlen <= x;

						reqRxbuf <= '1';
						strbDRxbuf <= '0';

						stateOp <= stateOpPrepRxbuf;

					else
						stateOp <= stateOpIdle;
					end if;

				else
					stateOp <= stateOpIdle;
				end if;
-- RX OP END

			elsif stateOp=stateOpVoidinv then
				if ackVoidinv='1' then
					stateOp <= stateOpPrepTxA;
				end if;

-- TX BEGIN
			elsif stateOp=stateOpPrepTxA then -- arrive here if buffer=cmdretToHostif
				if opbuf(ixOpbufController)=tixVClebControllerState then
					if opbuf(ixOpbufCommand)=tixVStateCommandGet then
						txbuf(0) <= stateGetTixVClebState;
					end if;

				elsif opbuf(ixOpbufController)=tixVClebControllerStep then
					if opbuf(ixOpbufCommand)=tixVStepCommandGetInfo then
						txbuf(0) <= stepGetInfoTixVState;
						for i in 0 to 1 loop
							txbuf(1+i) <= stepGetInfoAngle((2-i)*8-1 downto (1-i)*8);
						end loop;
					end if;

				elsif opbuf(ixOpbufController)=tixVClebControllerTkclksrc then
					if opbuf(ixOpbufCommand)=tixVTkclksrcCommandGetTkst then
						for i in 0 to 3 loop
							txbuf(i) <= tkclksrcGetTkstTkst((4-i)*8-1 downto (3-i)*8);
						end loop;
					end if;

				end if;

				utxlen <= "0" & opbuf(ixOpbufLength) & opbuf(ixOpbufLength+1); -- 2 bytes of CRC included

				x := "0" & opbuf(ixOpbufLength) & opbuf(ixOpbufLength+1);
				icrc := to_integer(unsigned(x)) - 2;

				stateOp <= stateOpPrepTxB;

			elsif stateOp=stateOpPrepTxB then
				i := 0;

				utxd <= txbuf(0);
				crcd <= txbuf(0);

				stateOp <= stateOpTxA;

			elsif stateOp=stateOpTxA then -- reqCrc='1', captNotFin='1'
				if (ackCrc='1' and ackUtx='1') then
					stateOp <= stateOpTxB;
				end if;

			elsif stateOp=stateOpTxB then -- strbCrcd='1'
				if strbUtxd='0' then
					i := i + 1;

					if i=icrc then
						stateOp <= stateOpTxD;
					else
						utxd <= txbuf(i);
						crcd <= txbuf(i);

						stateOp <= stateOpTxC;
					end if;
				end if;

			elsif stateOp=stateOpTxC then
				if ackUtx='0' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				elsif strbUtxd='1' then
					stateOp <= stateOpTxB;
				end if;

			elsif stateOp=stateOpTxD then -- captNotFin='0'
				if dneCrc='1' then
					utxd <= (crc(15 downto 8) and x"55") or ((not crc(15 downto 8)) and x"AA");
					stateOp <= stateOpTxF;
				end if;

			elsif stateOp=stateOpTxE then
				if dneUtx='1' then
					stateOp <= stateOpIdle;

				elsif strbUtxd='0' then
					utxd <= (crc(7 downto 0) and x"55") or ((not crc(7 downto 0)) and x"AA"); -- i increment not required, only one byte left

					stateOp <= stateOpTxF;
				end if;

			elsif stateOp=stateOpTxF then
				if ackUtx='0' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				elsif strbUtxd='1' then
					stateOp <= stateOpTxE;
				end if;
-- TX END

-- TX BUFFER BEGIN
			elsif stateOp=stateOpTxbufA then
				if ackTxbuf='1' then
					i := 0;

					utxd <= dTxbuf;

					stateOp <= stateOpTxbufB;
				end if;

			elsif stateOp=stateOpTxbufB then -- reqCrc='1', captNotFin='1'
				crcd <= dTxbuf;

				if (ackCrc='1' and ackUtx='1') then
					stateOp <= stateOpTxbufC;
				end if;

			elsif stateOp=stateOpTxbufC then -- strbCrcd='1'
				if strbUtxd='0' then
					strbDTxbuf <= '1';

					i := i + 1;

					if i=icrc then
						stateOp <= stateOpTxbufH;
					else
						stateOp <= stateOpTxbufD;
					end if;
				end if;

			elsif stateOp=stateOpTxbufD then
				strbDTxbuf <= '0';

				stateOp <= stateOpTxbufF;

			elsif stateOp=stateOpTxbufE then
				utxd <= dTxbuf;

				stateOp <= stateOpTxbufG;

			elsif stateOp=stateOpTxbufF then
				stateOp <= stateOpTxbufE;

			elsif stateOp=stateOpTxbufG then
				crcd <= utxd;

				if ackUtx='0' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				elsif strbUtxd='1' then
					stateOp <= stateOpTxbufC;
				end if;

			elsif stateOp=stateOpTxbufH then -- captNotFin='0'
				if dneCrc='1' then
					utxd <= (crc(15 downto 8) and x"55") or ((not crc(15 downto 8)) and x"AA");
					stateOp <= stateOpTxbufJ;
				end if;

			elsif stateOp=stateOpTxbufI then
				if dneUtx='1' then
					dneTxbuf <= '1';

					stateOp <= stateOpTxbufK;

				elsif strbUtxd='0' then
					utxd <= (crc(7 downto 0) and x"55") or ((not crc(7 downto 0)) and x"AA"); -- i increment not required, only one byte left

					stateOp <= stateOpTxbufJ;
				end if;

			elsif stateOp=stateOpTxbufJ then
				if ackUtx='0' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				elsif strbUtxd='1' then
					stateOp <= stateOpTxbufI;
				end if;

			elsif stateOp=stateOpTxbufK then
				if ackTxbuf='0' then
					stateOp <= stateOpIdle;
				end if;
-- TX BUFFER END

-- RX BEGIN
			elsif stateOp=stateOpPrepRx then -- arrive here if buffer=hostifToCmdinv
				if (ackCrc='0' and ackUrx='0') then
					torestart <= '1';

					stateOp <= stateOpRxA;
				end if;

			elsif stateOp=stateOpRxA then
				if (ackCrc='1' and ackUrx='1') then
					stateOp <= stateOpRxB;

				elsif timeout2='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpRxB then
				if ackUrx='0' then
					stateOp <= stateOpIdle;

				elsif strbUrxd='1' then
					rxbuf(i) <= urxd;

					crcd <= urxd;

					torestart <= '1';

					stateOp <= stateOpRxC;
				end if;

			elsif stateOp=stateOpRxC then -- strbCrcd='1'
				if strbUrxd='0' then
					i := i + 1;

					stateOp <= stateOpRxB;

				elsif dneUrx='1' then
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
				if opbuf(ixOpbufController)=tixVClebControllerLaser then
					if opbuf(ixOpbufCommand)=tixVLaserCommandSet then
						for i in 0 to 1 loop
							laserSetL_sig((2-i)*8-1 downto (1-i)*8) <= rxbuf(i);
						end loop;
						for i in 0 to 1 loop
							laserSetR_sig((2-i)*8-1 downto (1-i)*8) <= rxbuf(2+i);
						end loop;
					end if;

				elsif opbuf(ixOpbufController)=tixVClebControllerStep then
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

				elsif opbuf(ixOpbufController)=tixVClebControllerTkclksrc then
					if opbuf(ixOpbufCommand)=tixVTkclksrcCommandSetTkst then
						for i in 0 to 3 loop
							tkclksrcSetTkstTkst_sig((4-i)*8-1 downto (3-i)*8) <= rxbuf(i);
						end loop;
					end if;

				end if;

				stateOp <= stateOpCopyRxB;

			elsif stateOp=stateOpCopyRxB then
				if ackInv='1' then
					utxlen <= "0" & x"0002"; -- tx 2x (0xAA) (CRC of empty set)
					utxd <= x"AA";
					stateOp <= stateOpTxackA;
				end if;
-- RX END

-- RX BUFFER BEGIN
			elsif stateOp=stateOpPrepRxbuf then
				if (ackCrc='0' and ackUrx='0' and ackRxbuf='1') then
					torestart <= '1';

					stateOp <= stateOpRxbufA;
				end if;

			elsif stateOp=stateOpRxbufA then
				if (ackCrc='1' and ackUrx='1') then
					stateOp <= stateOpRxbufB;

				elsif timeout2='1' then
					commok_sig <= '0';
					stateOp <= stateOpIdle;

				else
					torestart <= '0';
				end if;

			elsif stateOp=stateOpRxbufB then
				if ackUrx='0' then
					stateOp <= stateOpIdle;

				elsif strbUrxd='1' then
					dRxbuf <= urxd;
					strbDRxbuf <= '1';

					crcd <= urxd;

					torestart <= '1';

					stateOp <= stateOpRxbufC;
				end if;

			elsif stateOp=stateOpRxbufC then -- strbCrcd='1'
				if strbUrxd='0' then
					i := i + 1;

					if i<icrc then
						strbDRxbuf <= '0';
					end if;

					stateOp <= stateOpRxbufB;

				elsif dneUrx='1' then
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

					utxlen <= "0" & x"0002"; -- tx 2x (0xAA) (CRC of empty set)
					utxd <= x"AA";
					stateOp <= stateOpTxackA;
				end if;
-- RX BUFFER END

			elsif stateOp=stateOpTxackA then
				if ackUtx='1' then
					stateOp <= stateOpTxackB;
				end if;

			elsif stateOp=stateOpTxackB then
				if dneUtx='1' then
					stateOp <= stateOpIdle;
				end if;
			end if;
		end if;
	end process;

end Hostif;
