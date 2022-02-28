-- file Laser.vhd
-- Laser easy model controller implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 24 Dec 2021
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Cleb.all;

entity Laser is
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
		mosi: out std_logic;

		stateOp_dbg: out std_logic_vector(7 downto 0)
	);
end Laser;

architecture Laser of Laser is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Spimaster_v1_0 is
		generic (
			fMclk: natural range 1 to 1000000 := 100000;

			cpol: std_logic := '0';
			cpha: std_logic := '0';

			nssByteNotXfer: std_logic := '0';

			fSclk: natural range 1 to 50000000 := 10000000;
			Nstop: natural range 1 to 8 := 1
		);
		port (
			reset: in std_logic;
			mclk: in std_logic;

			req: in std_logic;
			ack: out std_logic;
			dne: out std_logic;

			len: in std_logic_vector(16 downto 0);

			send: in std_logic_vector(7 downto 0);
			strbSend: out std_logic;

			recv: out std_logic_vector(7 downto 0);
			strbRecv: out std_logic;

			nss: out std_logic;
			sclk: out std_logic;
			mosi: out std_logic;
			miso: in std_logic
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpPrepA, stateOpPrepB, stateOpPrepC, stateOpPrepD,
		stateOpWait,
		stateOpIdle,
		stateOpSetA, stateOpSetB, stateOpSetC, stateOpSetD,
		stateOpInv
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal ackInvSet_sig: std_logic;
	signal spilen: std_logic_vector(16 downto 0);
	signal spisend: std_logic_vector(7 downto 0);

	-- IP sigs.op.cust --- INSERT

	---- mySpi
	signal strbSpisend: std_logic;

	---- handshake
	-- op to mySpi
	signal reqSpi: std_logic;
	signal dneSpi: std_logic;

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	mySpi : Spimaster_v1_0
		generic map (
			fMclk => fMclk,

			cpol => '0',
			cpha => '1',

			nssByteNotXfer => '0',

			fSclk => 8333333,
			Nstop => 1
		)
		port map (
			reset => reset,
			mclk => mclk,

			req => reqSpi,
			ack => open,
			dne => dneSpi,

			len => spilen,

			send => spisend,
			strbSend => strbSpisend,

			recv => open,
			strbRecv => open,

			nss => nss,
			sclk => sclk,
			mosi => mosi,
			miso => '0'
		);

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	-- IP impl.op.wiring --- BEGIN
	ackInvSet <= ackInvSet_sig;

	stateOp_dbg <= x"00" when stateOp=stateOpInit
				else x"10" when stateOp=stateOpPrepA
				else x"11" when stateOp=stateOpPrepB
				else x"12" when stateOp=stateOpPrepC
				else x"13" when stateOp=stateOpPrepD
				else x"20" when stateOp=stateOpWait
				else x"30" when stateOp=stateOpIdle
				else x"40" when stateOp=stateOpSetA
				else x"41" when stateOp=stateOpSetB
				else x"42" when stateOp=stateOpSetC
				else x"43" when stateOp=stateOpSetD
				else x"50" when stateOp=stateOpInv
				else (others => '1');
	-- IP impl.op.wiring --- END

	-- IP impl.op.rising --- BEGIN
	process (reset, mclk, stateOp)
		-- IP impl.op.vars --- BEGIN
		constant sizeTxbuf: natural := 2;
		type txbuf_t is array(0 to sizeTxbuf-1) of std_logic_vector(7 downto 0);
		variable txbuf: txbuf_t := (x"00",x"00");

		variable bytecnt: natural range 0 to sizeTxbuf := 0;

		constant imax: natural := fMclk*8/1000; -- 8us
		variable i: natural range 0 to imax := 0;

		variable rNotL: boolean := false;
		-- IP impl.op.vars --- END

	begin
		if reset='1' then
			-- IP impl.op.asyncrst --- BEGIN
			stateOp <= stateOpInit;
			spilen <= (others => '0');
			spisend <= (others => '0');
			reqSpi <= '0';
			-- IP impl.op.asyncrst --- END

		elsif rising_edge(mclk) then
			if stateOp=stateOpInit then
				-- IP impl.op.syncrst --- BEGIN
				spilen <= (others => '0');
				spisend <= (others => '0');
				reqSpi <= '0';

				txbuf := (x"00",x"00");
				bytecnt := 0;
				i := 0;
				rNotL := false;
				-- IP impl.op.syncrst --- END

				stateOp <= stateOpPrepC;

			elsif stateOp=stateOpPrepA then
				if dneSpi='1' then
					-- IP impl.op.prepA.done --- INSERT

					stateOp <= stateOpWait;

				elsif strbSpisend='0' then
					stateOp <= stateOpPrepB;
				end if;

			elsif stateOp=stateOpPrepB then
				-- IP impl.op.prepB --- INSERT

				stateOp <= stateOpPrepC;

			elsif stateOp=stateOpPrepC then
				-- IP impl.op.prepC --- INSERT

				stateOp <= stateOpPrepD;

			elsif stateOp=stateOpPrepD then
				if strbSpisend='1' then
					stateOp <= stateOpPrepA;
				end if;

			elsif stateOp=stateOpWait then
				-- IP impl.op.wait.ext --- INSERT

				if i=imax then
					-- IP impl.op.wait.done --- INSERT

					stateOp <= stateOpIdle;
				end if;

			elsif stateOp=stateOpIdle then
				if reqInvSet='1' then
					-- IP impl.op.idle.prepL --- INSERT

					stateOp <= stateOpSetC;
				end if;

			elsif stateOp=stateOpSetA then
				if dneSpi='1' then
					-- IP impl.op.setA.spioff --- INSERT

					if not rNotL then
						-- IP impl.op.setA.prepR --- INSERT

						stateOp <= stateOpSetC;

					else
						stateOp <= stateOpInv;
					end if;

				elsif strbSpisend='0' then
					stateOp <= stateOpSetB;
				end if;

			elsif stateOp=stateOpSetB then
				-- IP impl.op.setB --- INSERT

				stateOp <= stateOpSetC;

			elsif stateOp=stateOpSetC then
				-- IP impl.op.setC --- INSERT

				stateOp <= stateOpSetD;

			elsif stateOp=stateOpSetD then
				if strbSpisend='1' then
					stateOp <= stateOpSetA;
				end if;

			elsif stateOp=stateOpInv then
				if reqInvSet='0' then
					stateOp <= stateOpIdle;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.op.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Laser;
