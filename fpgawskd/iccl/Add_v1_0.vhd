-- file Add_v1_0.vhd
-- Add_v1_0 module implementation
-- copyright: (C) 2021 MPSI Technologies GmbH
-- author: Alexander Wirthmueller
-- date created: 25 Aug 2021
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Add_v1_0 is
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

		a: in std_logic_vector(wA - 1 downto 0);
		b: in std_logic_vector(wB - 1 downto 0);
		s: out std_logic_vector(wS - 1 downto 0)
	);
end Add_v1_0;

architecture Add_v1_0 of Add_v1_0 is

begin
	process (reset, mclk)
	begin
		if reset='1' then
			s <= (others => '0');

		elsif rising_edge(mclk) then
			if ce='1' then
				if not signNotUnsign then
					s <= std_logic_vector(resize(unsigned(a), wS) + resize(unsigned(b), wS));
				else
					s <= std_logic_vector(resize(signed(a), wS) + resize(signed(b), wS));
				end if;
			end if;
		end if;
	end process;
end Add_v1_0;
