-- file Axitx_v2_0.vhd
-- Axitx_v2_0 module implementation
-- copyright: (C) 2017-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller
-- date created: 6 Mar 2017
-- date modified: 10 Feb 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Axitx_v2_0 is
	port(
		reset: in std_logic;

		mclk: in std_logic;

		req: in std_logic;
		ack: out std_logic;
		dne: out std_logic;

		len: in std_logic_vector(21 downto 0); -- in words, max. 2^22-1

		d: in std_logic_vector(31 downto 0);
		strbD: out std_logic;

		rdyTx: out std_logic;
		enTx: in std_logic;

		tx: out std_logic_vector(31 downto 0);
		strbTx: in std_logic
	);
end Axitx_v2_0;

architecture Axitx_v2_0 of Axitx_v2_0 is

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- send operation (send)
	type stateSend_t is (
		stateSendInit,
		stateSendWaitStartA, stateSendWaitStartB,
		stateSendLoad,
		stateSendDataA, stateSendDataB,
		stateSendDoneA, stateSendDoneB,
		stateSendErr
	);
	signal stateSend: stateSend_t := stateSendInit;

	signal tx_sig: std_logic_vector(31 downto 0);

begin

	------------------------------------------------------------------------
	-- implementation: send operation (send)
	------------------------------------------------------------------------

	tx <= tx_sig;

	ack <= '1' when (stateSend=stateSendLoad or stateSend=stateSendDataA or stateSend=stateSendDataB or stateSend=stateSendDoneA or stateSend=stateSendDoneB) else '0';

	dne <= '1' when stateSend=stateSendDoneB else '0';

	strbD <= '0' when stateSend=stateSendDataB else '1';

	rdyTx <= '1' when (stateSend=stateSendWaitStartA or stateSend=stateSendWaitStartB) else '0';

	process (reset, mclk, stateSend)
		variable wordcnt: natural range 0 to 4194303;

		constant tstrblow: natural := 4;
		variable i: natural range 0 to tstrblow;

	begin
		if reset='1' then
			stateSend <= stateSendInit;
			tx_sig <= x"FFFFFFFF";

		elsif rising_edge(mclk) then
			if (stateSend=stateSendInit or req='0') then
				tx_sig <= (others => '1');

				wordcnt := 0;

				if req='0' then
					stateSend <= stateSendInit;
				else
					stateSend <= stateSendWaitStartA;
				end if;

			elsif stateSend=stateSendWaitStartA then
				if to_integer(unsigned(len))=0 then
					stateSend <= stateSendDoneB;
				elsif enTx='0' then
					stateSend <= stateSendWaitStartB;
				end if;

			elsif stateSend=stateSendWaitStartB then
				if enTx='1' then
					stateSend <= stateSendLoad;
				end if;

			elsif stateSend=stateSendLoad then
				tx_sig <= d;

				wordcnt := wordcnt + 1; -- word count put out for send

				stateSend <= stateSendDataA;

			elsif stateSend=stateSendDataA then
				if wordcnt=to_integer(unsigned(len)) then
					stateSend <= stateSendDoneA;
				elsif enTx='0' then
					stateSend <= stateSendErr;
				elsif strbTx='1' then
					i := 0;
					stateSend <= stateSendDataB;
				end if;

			elsif stateSend=stateSendDataB then
				if i<tstrblow then
					i := i + 1;
				end if;

				if i=tstrblow then
					if enTx='0' then
						stateSend <= stateSendErr;
					elsif strbTx='0' then
						stateSend <= stateSendLoad;
					end if;
				end if;

			elsif stateSend=stateSendDoneA then
				if enTx='0' then
					stateSend <= stateSendDoneB;
				end if;

			elsif stateSend=stateSendDoneB then
				-- if req='0' then
				-- 	stateSend <= stateSendInit;
				-- end if;

			elsif stateSend=stateSendErr then
				-- if req='0' then
				-- 	stateSend <= stateSendInit;
				-- end if;
			end if;
		end if;
	end process;

end Axitx_v2_0;
