-- file State.vhd
-- State easy model controller implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 24 Dec 2021
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Cleb.all;

entity State is
	port (
		reset: in std_logic;
		tkclk: in std_logic;

		commok: in std_logic;
		camrng: in std_logic;

		rgb: out std_logic_vector(23 downto 0);

		getTixVClebState: out std_logic_vector(7 downto 0)
	);
end State;

architecture State of State is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	constant tixVClebStateNc: std_logic_vector(7 downto 0) := x"00";
	constant tixVClebStateReady: std_logic_vector(7 downto 0) := x"01";
	constant tixVClebStateActive: std_logic_vector(7 downto 0) := x"02";

	---- LED control (led)
	type stateLed_t is (
		stateLedOn,
		stateLedOff
	);
	signal stateLed: stateLed_t := stateLedOn;

	-- IP sigs.led.cust --- IBEGIN
	signal red: std_logic_vector(7 downto 0);
	signal green: std_logic_vector(7 downto 0);
	signal blue: std_logic_vector(7 downto 0);
	-- IP sigs.led.cust --- IEND

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- implementation: LED control (led)
	------------------------------------------------------------------------

	-- IP impl.led.wiring --- RBEGIN
	rgb <= red & green & blue;
	
	red <= x"7F" when stateLed = stateLedOn else x"00";
	green <= x"7F";
	blue <= (others => '0');

	stateLed_dbg <= x"00" when stateLed=stateLedOn
				else x"10" when stateLed=stateLedOff
				else (others => '1');
	-- IP impl.led.wiring --- REND

	-- IP impl.led.rising --- BEGIN
	process (reset, tkclk, stateLed)
		-- IP impl.led.vars --- RBEGIN
		variable i: natural range 0 to 4000;
		-- IP impl.led.vars --- REND

	begin
		if reset='1' then
			-- IP impl.led.asyncrst --- RBEGIN
			stateLed <= stateLedOn;
			
			i := 0;
			-- IP impl.led.asyncrst --- REND

		elsif rising_edge(tkclk) then
			if stateLed=stateLedOn then
				i := i + 1; -- IP impl.led.on.ext --- ILINE

				if i=1000 then
					i := 0; -- IP impl.led.on.prepOff --- ILINE

					stateLed <= stateLedOff;
				end if;

			elsif stateLed=stateLedOff then
				i := i + 1; -- IP impl.led.off.ext --- ILINE

				if i=4000 then
					i := 0; -- IP impl.led.off.prepOn --- ILINE

					stateLed <= stateLedOn;
				end if;
			end if;
		end if;
	end process;
	-- IP impl.led.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end State;
