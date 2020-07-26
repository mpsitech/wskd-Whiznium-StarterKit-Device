-- file I2c.vhd
-- I2c other module implementation
-- author Catherine Johnson
-- date created: 16 May 2020
-- date modified: 16 May 2020

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.Dbecore.all;
use work.Arty.all;

entity I2c is
	generic (
		fMclk: natural range 1 to 1000000; -- in kHz

		clkFastNotStd: std_logic := '1'; -- 1Mbps/400kbps vs. 100kbps
		clkFastplusNotFast: std_logic := '0'; -- 1Mbps vs. 400kbps

		devaddr: std_logic_vector(7 downto 0) := "01111000" -- 0x78, not 0x3C as in Linux version
	);
	port (
		reset: in std_logic;
		mclk: in std_logic;

		req: in std_logic;
		ack: out std_logic;
		dne: out std_logic;

		readNotWrite: in std_logic;
		regaddr: in std_logic_vector(15 downto 0);
		send: in std_logic_vector(7 downto 0);
		recv: out std_logic_vector(7 downto 0);

		scl: out std_logic;
		sda: inout std_logic
	);
end I2c;

architecture I2c of I2c is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- transfer operation (xfer)
	type stateXfer_t is (
		stateXferInit,
		stateXferStartA, stateXferStartB,
		stateXferBitA, stateXferBitB,
		stateXferAckA, stateXferAckB,
		stateXferRestart,
		stateXferStopA, stateXferStopB, stateXferStopC,
		stateXferDone
	);
	signal stateXfer: stateXfer_t := stateXferInit;

	signal ack_sig: std_logic;
	signal dne_sig: std_logic;
	signal recv_sig: std_logic_vector(7 downto 0);
	signal scl_sig: std_logic;
	signal sda_sig: std_logic;

	-- IP sigs.xfer.cust --- INSERT

	---- myIobuf
	signal sda_in: std_logic;

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myIobuf : IOBUF
		port map (
			O => sda_in,
			IO => sda,
			I => '0',
			T => sda_sig
		);

	------------------------------------------------------------------------
	-- implementation: transfer operation (xfer)
	------------------------------------------------------------------------

	-- IP impl.xfer.wiring --- BEGIN
	ack_sig <= '0' when stateXfer=stateXferInit else '1';
	ack <= ack_sig;
	dne_sig <= '1' when stateXfer=stateXferDone else '0';
	dne <= dne_sig;
	recv <= recv_sig;
	scl_sig <= '0' when (stateXfer=stateXferBitA or stateXfer=stateXferAckA or stateXfer=stateXferRestart
				 or stateXfer=stateXferStopA) else '1';
	scl <= scl_sig;
	-- IP impl.xfer.wiring --- END

	-- IP impl.xfer.rising --- BEGIN
	process (reset, mclk, stateXfer)
		-- IP impl.xfer.vars --- RBEGIN
		variable recvraw: std_logic_vector(7 downto 0);

		variable bytecnt: natural range 0 to 5;

		variable bitcnt: natural range 0 to 8;

		variable imax: natural range 0 to (fMclk/400)/2;
		variable i: natural range 0 to (fMclk/400)/2;
		-- IP impl.xfer.vars --- REND

	begin
		if reset='1' then
			-- IP impl.xfer.asyncrst --- BEGIN
			stateXfer <= stateXferInit;
			recv_sig <= (others => '0');
			sda_sig <= '0';
			-- IP impl.xfer.asyncrst --- END

		elsif rising_edge(mclk) then
			if (stateXfer=stateXferInit or req='0') then
				-- IP impl.xfer.syncrst --- RBEGIN
				recv_sig <= (others => '0');
				sda_sig <= '1';

				recvraw := (others => '0');
				bytecnt := 0;
				bitcnt := 0;

				if clkFastNotStd='0' then
					imax := (fMclk/100)/2;
				else
					if clkFastplusNotFast='1' then
						imax := (fMclk/1000)/2;
					else
						imax := (fMclk/400)/2;
					end if;
				end if;

				i := 0;
				-- IP impl.xfer.syncrst --- REND

				if req='0' then
					stateXfer <= stateXferInit;

				else
					stateXfer <= stateXferStartA;
				end if;

			elsif stateXfer=stateXferStartA then
				i := i + 1; -- IP impl.xfer.startA.ext --- ILINE

				if i=imax then
					-- IP impl.xfer.startA.step --- IBEGIN
					i := 0;

					sda_sig <= '0';
					-- IP impl.xfer.startA.step --- IEND

					stateXfer <= stateXferStartB;
				end if;

			elsif stateXfer=stateXferStartB then
				i := i + 1; -- IP impl.xfer.startB.ext --- ILINE

				if i=imax then
					-- IP impl.xfer.startB.step --- IBEGIN
					i := 0;

					bitcnt := 0;
					-- IP impl.xfer.startB.step --- IEND

					stateXfer <= stateXferBitA;
				end if;

			elsif stateXfer=stateXferBitA then
				-- IP impl.xfer.bitA.ext --- IBEGIN
				if bytecnt=0 then
					if bitcnt=7 then
						sda_sig <= readNotWrite;
					else
						sda_sig <= devaddr(7-bitcnt);
					end if;
				elsif bytecnt=1 then
					sda_sig <= regaddr(15-bitcnt);
				elsif bytecnt=2 then
					sda_sig <= regaddr(7-bitcnt);
				elsif bytecnt=3 then
					if readNotWrite='1' then
						if bitcnt=7 then
							sda_sig <= '1';
						else
							sda_sig <= devaddr(7-bitcnt);
						end if;
					else
						sda_sig <= send(7-bitcnt);
					end if;
				else
					sda_sig <= '1';
				end if;

				i := i + 1;
				-- IP impl.xfer.bitA.ext --- IEND

				if i=imax then
					i := 0; -- IP impl.xfer.bitA.step --- ILINE

					stateXfer <= stateXferBitB;
				end if;

			elsif stateXfer=stateXferBitB then
				-- IP impl.xfer.bitB.ext --- IBEGIN
				if bytecnt=4 then
					recvraw(7-bitcnt) := sda_in;
				end if;

				i := i + 1;
				-- IP impl.xfer.bitB.ext --- IEND

				if i=imax then
					-- IP impl.xfer.bitB.step --- IBEGIN
					i := 0;

					bitcnt := bitcnt + 1;
					-- IP impl.xfer.bitB.step --- IEND

					if bitcnt=8 then
						stateXfer <= stateXferAckA;

					else
						stateXfer <= stateXferBitA;
					end if;
				end if;

			elsif stateXfer=stateXferAckA then
				-- IP impl.xfer.ackA.ext --- IBEGIN
				if (readNotWrite='1' and bytecnt=3) then
					sda_sig <= '0';
				else
					sda_sig <= '1';
				end if;

				i := i + 1;
				-- IP impl.xfer.ackA.ext --- IEND

				if i=imax then
					i := 0; -- IP impl.xfer.ackA.step --- ILINE

					stateXfer <= stateXferAckB;
				end if;

			elsif stateXfer=stateXferAckB then
				i := i + 1; -- IP impl.xfer.ackB.ext --- ILINE

				if i=imax then
					-- IP impl.xfer.ackB.step --- IBEGIN
					i := 0;

					bitcnt := 0;

					bytecnt := bytecnt + 1;
					-- IP impl.xfer.ackB.step --- IEND

					if bytecnt=3 then
						if readNotWrite='1' then
							stateXfer <= stateXferRestart;

						else
							stateXfer <= stateXferBitA;
						end if;

					elsif ((bytecnt=4 and readNotWrite='0') or (bytecnt=5 and readNotWrite='1')) then
						sda_sig <= '0'; -- IP impl.xfer.ackB.prepStop --- ILINE

						stateXfer <= stateXferStopA;

					else
						stateXfer <= stateXferBitA;
					end if;
				end if;

			elsif stateXfer=stateXferRestart then
				i := i + 1; -- IP impl.xfer.restart.ext --- ILINE

				if i=imax then
					i := 0; -- IP impl.xfer.restart.step --- ILINE

					stateXfer <= stateXferStartA;
				end if;

			elsif stateXfer=stateXferStopA then
				i := i + 1; -- IP impl.xfer.stopA.ext --- ILINE

				if i=imax then
					i := 0; -- IP impl.xfer.stopA.step --- ILINE

					stateXfer <= stateXferStopB;
				end if;

			elsif stateXfer=stateXferStopB then
				i := i + 1; -- IP impl.xfer.stopB.ext --- ILINE

				if i=imax then
					-- IP impl.xfer.stopB.step --- IBEGIN
					i := 0;
					sda_sig <= '1';
					-- IP impl.xfer.stopB.step --- IEND

					stateXfer <= stateXferStopC;
				end if;

			elsif stateXfer=stateXferStopC then
				i := i + 1; -- IP impl.xfer.stopC.ext --- ILINE

				if i=imax then
					-- IP impl.xfer.stopC.step --- IBEGIN
					if readNotWrite='1' then
						recv_sig <= recvraw;
					end if;
					-- IP impl.xfer.stopC.step --- IEND

					stateXfer <= stateXferDone;
				end if;

			elsif stateXfer=stateXferDone then
				if req='0' then
					stateXfer <= stateXferInit;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.xfer.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end I2c;


