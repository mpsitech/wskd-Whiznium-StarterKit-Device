-- file Spbram_v1_0_size2kB.vhd
-- Spbram_v1_0_size2kB spbram_v1_0 implementation
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

entity Spbram_v1_0_size2kB is
	port (
		clk: in std_logic;

		en: in std_logic;
		we: in std_logic;

		a: in std_logic_vector(10 downto 0);
		drd: out std_logic_vector(7 downto 0);
		dwr: in std_logic_vector(7 downto 0)
	);
end Spbram_v1_0_size2kB;

architecture Spbram_v1_0_size2kB of Spbram_v1_0_size2kB is

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myBram : RAMB16_S9
		generic map (
			WRITE_MODE => "WRITE_FIRST"
		)
		port map (
			DO => drd,
			DOP => open,
			ADDR => a,
			CLK => clk,
			DI => dwr,
			DIP => (others => '0'),
			EN => en,
			SSR => '0',
			WE => we
		);

end Spbram_v1_0_size2kB;

