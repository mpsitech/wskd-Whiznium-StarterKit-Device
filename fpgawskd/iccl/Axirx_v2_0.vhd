-- file Axirx_v2_0.vhd
-- Axirx_v2_0 module implementation
-- copyright: (C) 2017-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller
-- date created: 6 Mar 2017
-- date modified: 10 Feb 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Axirx_v2_0 is
	port(
		reset: in std_logic;

		mclk: in std_logic;

		req: in std_logic;
		ack: out std_logic;
		dne: out std_logic;

		len: in std_logic_vector(21 downto 0); -- in words, max. 2^22-1

		d: out std_logic_vector(31 downto 0);
		strbD: out std_logic;

		rdyRx: out std_logic;
		enRx: in std_logic;

		rx: in std_logic_vector(31 downto 0);
		strbRx: in std_logic
	);
end Axirx_v2_0;

architecture Axirx_v2_0 of Axirx_v2_0 is

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- receive operation
	type stateRecv_t is (
		stateRecvInit,
		stateRecvWaitStartA, stateRecvWaitStartB,
		stateRecvDataA, stateRecvDataB,
		stateRecvDoneA, stateRecvDoneB,
		stateRecvErr
	);
	signal stateRecv: stateRecv_t := stateRecvInit;

	signal d_sig: std_logic_vector(31 downto 0);

begin

	------------------------------------------------------------------------
	-- implementation: receive operation (recv)
	------------------------------------------------------------------------

	ack <= '1' when (stateRecv=stateRecvDataA or stateRecv=stateRecvDataB or stateRecv=stateRecvDoneA or stateRecv=stateRecvDoneB) else '0';

	dne <= '1' when stateRecv=stateRecvDoneB else '0';

	d <= d_sig;
	strbD <= '0' when stateRecv=stateRecvDataA else '1';

	rdyRx <= '1' when (stateRecv=stateRecvWaitStartA or stateRecv=stateRecvWaitStartB) else '0';

	process (reset, mclk)
		variable wordcnt: natural range 0 to 4194303;

		constant tstrbhigh: natural := 2;
		variable i: natural range 0 to tstrbhigh;

	begin
		if reset='1' then
			stateRecv <= stateRecvInit;
			d_sig <= (others => '0');

		elsif rising_edge(mclk) then
			if (stateRecv=stateRecvInit or req='0') then
				d_sig <= (others => '0');

				wordcnt := 0;

				if req='0' then
					stateRecv <= stateRecvInit;
				else
					stateRecv <= stateRecvWaitStartA;
				end if;

			elsif stateRecv=stateRecvWaitStartA then
				if to_integer(unsigned(len))=0 then
					stateRecv <= stateRecvDoneB;
				elsif enRx='0' then
					stateRecv <= stateRecvWaitStartB;
				end if;

			elsif stateRecv=stateRecvWaitStartB then
				if enRx='1' then
					stateRecv <= stateRecvDataA;
				end if;

			elsif stateRecv=stateRecvDataA then
				if enRx='0' then
					stateRecv <= stateRecvErr;

				elsif strbRx='1' then
					d_sig <= rx;

					wordcnt := wordcnt + 1; -- word count received

					if wordcnt=to_integer(unsigned(len)) then
						stateRecv <= stateRecvDoneA;
					else
						i := 0;
						stateRecv <= stateRecvDataB;
					end if;
				end if;

			elsif stateRecv=stateRecvDataB then
				if i<tstrbhigh then
					i := i + 1;
				end if;

				if i=tstrbhigh then
					if strbRx='0' then
						stateRecv <= stateRecvDataA;
					end if;
				end if;

			elsif stateRecv=stateRecvDoneA then
				if enRx='0' then
					stateRecv <= stateRecvDoneB;
				end if;

			elsif stateRecv=stateRecvDoneB then
				-- if req='0' then
				-- 	stateRecv <= stateRecvInit;
				-- end if;

			elsif stateRecv=stateRecvErr then
				-- if req='0' then
				-- 	stateRecv <= stateRecvInit;
				-- end if;
			end if;
		end if;
	end process;

end Axirx_v2_0;
