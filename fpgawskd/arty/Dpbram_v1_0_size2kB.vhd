-- file Dpbram_v1_0_size2kB.vhd
-- Dpbram_v1_0_size2kB dpbram_v1_0 implementation
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

entity Dpbram_v1_0_size2kB is
	port (
		clkA: in std_logic;

		enA: in std_logic;
		weA: in std_logic;

		aA: in std_logic_vector(10 downto 0);
		drdA: out std_logic_vector(7 downto 0);
		dwrA: in std_logic_vector(7 downto 0);

		clkB: in std_logic;

		enB: in std_logic;
		weB: in std_logic;

		aB: in std_logic_vector(10 downto 0);
		drdB: out std_logic_vector(7 downto 0);
		dwrB: in std_logic_vector(7 downto 0)
	);
end Dpbram_v1_0_size2kB;

architecture Dpbram_v1_0_size2kB of Dpbram_v1_0_size2kB is

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myBram : RAMB16_S9_S9
		generic map (
			WRITE_MODE_A => "WRITE_FIRST",
			WRITE_MODE_B => "WRITE_FIRST",
			SIM_COLLISION_CHECK => "ALL"
		)
		port map (
			DOA => drdA,
			DOB => drdB,
			DOPA => open,
			DOPB => open,
			ADDRA => aA,
			ADDRB => aB,
			CLKA => clkA,
			CLKB => clkB,
			DIA => dwrA,
			DIB => dwrB,
			DIPA => (others => '0'),
			DIPB => (others => '0'),
			ENA => enA,
			ENB => enB,
			SSRA => '0',
			SSRB => '0',
			WEA => weA,
			WEB => weB
		);

end Dpbram_v1_0_size2kB;
