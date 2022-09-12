-- file Parrom.vhd
-- Parrom other module implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Catherine Johnson (auto-generation)
-- date created: 1 Dec 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.Dbecore.all;
use work.Arty.all;

entity Parrom is
	port (
		clk: in std_logic;
		en: in std_logic;
		we: in std_logic;
		a: in std_logic_vector(10 downto 0);
		drd: out std_logic_vector(7 downto 0);
		dwr: in std_logic_vector(7 downto 0)
	);
end Parrom;

architecture Parrom of Parrom is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myBram : RAMB16_S9
		generic map (
			WRITE_MODE => "WRITE_FIRST",
			INIT_00 => x"0094563000202E30003C2C3000041830002A0D30003B0C300000023000010030",
			INIT_01 => x"0000A131007E6A3100A0683100025A3100C64C3100004C300028763000C87430",
			INIT_02 => x"0001783600044C3600044A3600014836001816340005143400028A3200218832",
			INIT_03 => x"00031737000116370002153700021437000308370010063700317E3600317C36",
			INIT_04 => x"000031370089303700002F3700462E3700002D3700002C37003F1D37003D1C37",
			INIT_05 => x"00115F3700005E3700005D37000240370005353700FE34370001333700083237",
			INIT_06 => x"000F6E3700176D37001A6C37001B6B37001B6A37001B6937001B683700016037",
			INIT_07 => x"00017D3700087C3700007B3700897A3700007937004678370000773700007637",
			INIT_08 => x"000F883700A584370006833700F582370003813700D9803700027F3700237E37",
			INIT_09 => x"0043923700F5903700068F3700878E3700058D3700EB8C3700038B3700D98A37",
			INIT_0A => x"000000000000000000000000000000000001003A0036B03700A19637007A9437"
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

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Parrom;
