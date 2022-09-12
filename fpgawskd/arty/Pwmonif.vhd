-- file Uart_Easy_v1_0.vhd
-- Uart_Easy_v1_0 module implementation
-- copyright: (C) 2022 MPSI Technologies GmbH
-- author: Alexander Wirthmueller
-- date created: 5 Jun 2022
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Uart is
	generic (
		fMclk: natural range 1 to 1000000 := 50000;
		fSclk: natural range 100 to 50000000 := 5000000;

		toRx: natural range 1 to 10000 := 100
	);
	port (
		reset: in std_logic;
		mclk: in std_logic;
		tkclk: in std_logic;

		getTixVState: out std_logic_vector(7 downto 0);
		getRxleft: out std_logic_vector(7 downto 0);
		getLenRxdata: out std_logic_vector(7 downto 0);
		getRxdata: out std_logic_vector(255 downto 0);

		reqInvRx: in std_logic;
		ackInvRx: out std_logic;

		rxLen: in std_logic_vector(7 downto 0);

		reqInvTx: in std_logic;
		ackInvTx: out std_logic;

		txLenData: in std_logic_vector(7 downto 0);
		txData: in std_logic_vector(255 downto 0);

		reqInvTxrx: in std_logic;
		ackInvTxrx: out std_logic;

		txrxLenTxdata: in std_logic_vector(7 downto 0);
		txrxTxdata: in std_logic_vector(255 downto 0);

		txrxRxlen: in std_logic_vector(7 downto 0);

		rxd: in std_logic;
		txd: out std_logic
	);
end Uart;

architecture Uart of Uart is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

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

	constant tixVStateIdle: std_logic_vector(7 downto 0) := x"00";
	constant tixVStateTx: std_logic_vector(7 downto 0) := x"01";
	constant tixVStateRx: std_logic_vector(7 downto 0) := x"02";
	constant tixVStateDone: std_logic_vector(7 downto 0) := x"03";
	constant tixVStateTo: std_logic_vector(7 downto 0) := x"04";

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpInv,
		stateOpXfer
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal ackInvRx_sig: std_logic;
	signal ackInvTx_sig: std_logic;
	signal ackInvTxrx_sig: std_logic;

	signal rx: std_logic;
	signal tx: std_logic;

	constant sizeBuf: natural := 32;

	signal utxlen: std_logic_vector(16 downto 0);
	signal txdata_sig: std_logic_vector(255 downto 0);

	signal urxlen: std_logic_vector(16 downto 0);

	---- transfer operation (xfer)
	type stateXfer_t is (
		stateXferInit,
		stateXferTxA, stateXferTxB, stateXferTxC, stateXferTxD, stateXferTxE,
		stateXferRxA, stateXferRxB, stateXferRxC, stateXferRxD, stateXferRxE,
		stateXferDone
	);
	signal stateXfer: stateXfer_t := stateXferInit;

	signal tixVState: std_logic_vector(7 downto 0);
	signal rxleft: std_logic_vector(7 downto 0);

	signal lenRxdata: std_logic_vector(7 downto 0);
	signal rxdata: std_logic_vector(255 downto 0);

	signal torestart: std_logic;

	signal urxburst: std_logic;

	signal utxd: std_logic_vector(7 downto 0);

	---- myRx
	signal urxd: std_logic_vector(7 downto 0);
	signal strbUrxd: std_logic;

	---- myTimeout
	signal timeout: std_logic;

	---- myTx
	signal strbUtxd: std_logic;

	---- handshake

	-- xfer to myRx
	signal reqUrx: std_logic;
	signal ackUrx: std_logic;
	signal dneUrx: std_logic;

	-- xfer to myTx
	signal reqUtx: std_logic;
	signal ackUtx: std_logic;
	signal dneUtx: std_logic;

	-- op to xfer
	signal reqOpToXferRun: std_logic;
	signal ackOpToXferRun: std_logic;
	signal dneOpToXferRun: std_logic;

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

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

			burst => '0',
			rxd => rxd
		);

	myTimeout : Timeout_v1_0
		generic map (
			twait => toRx
		)
		port map (
			reset => reset,
			mclk => mclk,
			tkclk => tkclk,

			restart => torestart,
			timeout => timeout
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
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	ackInvRx <= ackInvRx_sig;
	ackInvTx <= ackInvTx_sig;
	ackInvTxrx <= ackInvTxrx_sig;

	reqOpToXferRun <= '1' when stateOp=stateOpInv or stateOp=stateOpXfer else '0';

	process (reset, mclk, stateOp)

	begin
		if reset='1' then
			stateOp <= stateOpInit;
			ackInvRx_sig <= '0';
			ackInvTx_sig <= '0';
			ackInvTxrx_sig <= '0';
			rx <= '0';
			tx <= '0';
			utxlen <= (others => '0');
			txdata_sig <= (others => '0');
			urxlen <= (others => '0');

		elsif rising_edge(mclk) then
			if stateOp=stateOpInit then
				if reqInvRx='1' then
					ackInvRx_sig <= '1';
					ackInvTx_sig <= '0';
					ackInvTxrx_sig <= '0';

					rx <= '1';
					tx <= '0';
					utxlen <= (others => '0');
					urxlen <= B"0_0000_0000" & rxLen;

					stateOp <= stateOpInv;

				elsif reqInvTx='1' then
					ackInvRx_sig <= '0';
					ackInvTx_sig <= '1';
					ackInvTxrx_sig <= '0';

					rx <= '0';
					tx <= '1';
					utxlen <= B"0_0000_0000" & txLenData;
					txdata_sig <= txData;
					urxlen <= (others => '0');

					stateOp <= stateOpInv;

				elsif reqInvTxrx='1' then
					ackInvRx_sig <= '0';
					ackInvTx_sig <= '0';
					ackInvTxrx_sig <= '1';

					rx <= '1';
					tx <= '1';
					utxlen <= B"0_0000_0000" & txrxLenTxdata;
					txdata_sig <= txrxTxdata;
					urxlen <= B"0_0000_0000" & txrxRxlen;

					stateOp <= stateOpInv;

				else
					ackInvRx_sig <= '0';
					ackInvTx_sig <= '0';
					ackInvTxrx_sig <= '0';
					rx <= '0';
					tx <= '0';
					utxlen <= (others => '0');
					txdata_sig <= (others => '0');
					urxlen <= (others => '0');

					stateOp <= stateOpInit;
				end if;

			elsif stateOp=stateOpInv then
				if ackOpToXferRun='1' and ((reqInvRx='0' and ackInvRx_sig='1') or (reqInvTx='0' and ackInvTx_sig='1') or (reqInvTxrx='0' and ackInvTxrx_sig='1')) then
					ackInvRx_sig <= '0';
					ackInvTx_sig <= '0';
					ackInvTxrx_sig <= '0';

					stateOp <= stateOpXfer;
				end if;

			elsif stateOp=stateOpXfer then
				if dneOpToXferRun='1' then
					stateOp <= stateOpInit;
				end if;
			end if;
		end if;
	end process;

	------------------------------------------------------------------------
	-- implementation: transfer operation (xfer)
	------------------------------------------------------------------------

	getTixVState <= tixVState;
	getRxleft <= rxleft;
	getLenRxdata <= urxlen(7 downto 0);
	getRxdata <= rxdata;

	reqUrx <= '1' when stateXfer=stateXferRxB or stateXfer=stateXferRxC or stateXfer=stateXferRxD else '0';

	reqUtx <= '1' when stateXfer=stateXferTxB or stateXfer=stateXferTxC or stateXfer=stateXferTxD else '0';

	ackOpToXferRun <= '0' when stateXfer=stateXferInit else '1';
	dneOpToXferRun <= '1' when stateXfer=stateXferDone else '0';

	process (reset, mclk, stateXfer)
		variable bytecnt: natural range 0 to sizeBuf;

	begin
		if reset='1' then
			stateXfer <= stateXferInit;
			tixVState <= (others => '0');
			rxleft <= (others => '0');
			rxdata <= (others => '0');
			torestart <= '0';
			utxd <= (others => '0');

			bytecnt := 0;

		elsif rising_edge(mclk) then
			if stateXfer=stateXferInit then
				torestart <= '0';
				utxd <= (others => '0');

				if reqOpToXferRun='1' then
					if tx='1' then
						tixVState <= tixVStateTx;

						stateXfer <= stateXferTxA;

					elsif rx='1' then
						tixVState <= tixVStateRx;

						stateXfer <= stateXferRxA;

					else
						stateXfer <= stateXferDone;
					end if;
				end if;

			elsif stateXfer=stateXferTxA then
				if to_integer(unsigned(utxlen))=0 then
					stateXfer <= stateXferTxE;

				else
					utxd <= txdata_sig(sizeBuf*8-1 downto (sizeBuf-1)*8);

					bytecnt := 0;

					stateXfer <= stateXferTxB;
				end if;

			elsif stateXfer=stateXferTxB then
				if ackUtx='1' then
					stateXfer <= stateXferTxC;
				end if;

			elsif stateXfer=stateXferTxC then
				if dneUtx='1' then
					stateXfer <= stateXferTxE;

				elsif strbUtxd='0' then
					bytecnt := bytecnt + 1;

					utxd <= txdata_sig((sizeBuf-bytecnt)*8-1 downto (sizeBuf-bytecnt-1)*8);

					stateXfer <= stateXferTxD;
				end if;

			elsif stateXfer=stateXferTxD then
				if strbUtxd='1' then
					stateXfer <= stateXferTxC;
				end if;

			elsif stateXfer=stateXferTxE then
				if ackUtx='0' then
					if rx='1' then
						tixVState <= tixVStateRx;

						stateXfer <= stateXferRxA;

					else
						tixVState <= tixVStateDone;

						stateXfer <= stateXferDone;
					end if;
				end if;

			elsif stateXfer=stateXferRxA then
				if to_integer(unsigned(urxlen))=0 then
					stateXfer <= stateXferRxE;

				else
					bytecnt := 0;
					rxleft <= urxlen(7 downto 0);

					torestart <= '1';

					stateXfer <= stateXferRxB;
				end if;

			elsif stateXfer=stateXferRxB then
				if ackUrx='1' then
					stateXfer <= stateXferRxC;

				elsif timeout='1' then
					tixVState <= tixVStateTo;

					stateXfer <= stateXferDone;

				else
					torestart <= '0';
				end if;

			elsif stateXfer=stateXferRxC then
				if strbUrxd='1' then
					rxdata((sizeBuf-bytecnt)*8-1 downto (sizeBuf-bytecnt-1)*8) <= urxd;

					torestart <= '1';

					stateXfer <= stateXferRxD;
				end if;

			elsif stateXfer=stateXferRxD then
				if strbUrxd='0' then
					bytecnt := bytecnt + 1;
					rxleft <= std_logic_vector(unsigned(urxlen(7 downto 0)) - to_unsigned(bytecnt, 8));

					stateXfer <= stateXferRxC;

				elsif dneUrx='1' then
					rxleft <= (others => '0');

					stateXfer <= stateXferRxE;

				elsif timeout='1' then
					tixVState <= tixVStateTo;

					stateXfer <= stateXferDone;

				else
					torestart <= '0';
				end if;

			elsif stateXfer=stateXferRxE then
				if ackUrx='0' then
					tixVState <= tixVStateDone;

					stateXfer <= stateXferDone;
				end if;

			elsif stateXfer=stateXferDone then
				if reqOpToXferRun='0' then
					stateXfer <= stateXferInit;
				end if;
			end if;
		end if;
	end process;
end Uart;
