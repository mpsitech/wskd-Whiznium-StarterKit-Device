-- file Mult_v1_0.vhd
-- Mult_v1_0 module implementation
-- copyright: (C) 2021 MPSI Technologies GmbH
-- author: Alexander Wirthmueller
-- date created: 25 Aug 2021
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mult_v1_0 is
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

		a: in std_logic_vector(wA - 1 downto 0);
		b: in std_logic_vector(wB - 1 downto 0);
		p: out std_logic_vector(wP - 1 downto 0)
	);
end Mult_v1_0;

architecture Mult_v1_0 of Mult_v1_0 is

begin
	process (reset, mclk)
	begin
		if reset='1' then
			p <= (others => '0');

		elsif rising_edge(mclk) then
			if ce='1' then
				if not signNotUnsign then
					p <= std_logic_vector(resize(unsigned(a), wA) * resize(unsigned(b), wB));
				else
					p <= std_logic_vector(resize(signed(a), wA) * resize(signed(b), wB));
				end if;
			end if;
		end if;
	end process;
end Mult_v1_0;
