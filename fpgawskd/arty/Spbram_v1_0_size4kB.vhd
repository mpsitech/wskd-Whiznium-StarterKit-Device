-- file Spbram_v1_0_size4kB.vhd
-- Spbram_v1_0_size4kB spbram_v1_0 implementation
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

entity Spbram_v1_0_size4kB is
	port (
		clk: in std_logic;

		en: in std_logic;
		we: in std_logic;

		a: in std_logic_vector(11 downto 0);
		drd: out std_logic_vector(7 downto 0);
		dwr: in std_logic_vector(7 downto 0)
	);
end Spbram_v1_0_size4kB;

architecture Spbram_v1_0_size4kB of Spbram_v1_0_size4kB is

	-- IP sigs --- BEGIN
	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	signal en0: std_logic := '0';
	signal en1: std_logic := '0';

	signal drd0: std_logic_vector(7 downto 0) := (others => '0');
	signal drd1: std_logic_vector(7 downto 0) := (others => '0');
	-- IP sigs --- END

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myBram0 : RAMB16_S9
		generic map (
			WRITE_MODE => "WRITE_FIRST"
		)
		port map (
			DO => drd0,
			DOP => open,
			ADDR => a(10 downto 0),
			CLK => clk,
			DI => dwr,
			DIP => (others => '0'),
			EN => en0,
			SSR => '0',
			WE => we
		);

	myBram1 : RAMB16_S9
		generic map (
			WRITE_MODE => "WRITE_FIRST"
		)
		port map (
			DO => drd1,
			DOP => open,
			ADDR => a(10 downto 0),
			CLK => clk,
			DI => dwr,
			DIP => (others => '0'),
			EN => en1,
			SSR => '0',
			WE => we
		);

	-- IP impl --- BEGIN
	------------------------------------------------------------------------
	-- implementation
	------------------------------------------------------------------------

	en0 <= '1' when (a(11 downto 11)="0" and en='1') else '0';
	en1 <= '1' when (a(11 downto 11)="1" and en='1') else '0';

	drd <= drd0 when a(11 downto 11)="0"
		else drd1 when a(11 downto 11)="1"
		else (others => '0');
	-- IP impl --- END

end Spbram_v1_0_size4kB;

