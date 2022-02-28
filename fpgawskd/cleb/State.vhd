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

		getTixVClebState: out std_logic_vector(7 downto 0);

		stateLed_dbg: out std_logic_vector(7 downto 0)
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

	-- IP sigs.led.cust --- INSERT

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- implementation: LED control (led)
	------------------------------------------------------------------------

	-- IP impl.led.wiring --- BEGIN
	stateLed_dbg <= x"00" when stateLed=stateLedOn
				else x"10" when stateLed=stateLedOff
				else (others => '1');
	-- IP impl.led.wiring --- END

	-- IP impl.led.rising --- BEGIN
	process (reset, tkclk, stateLed)
		-- IP impl.led.vars --- BEGIN
		-- IP impl.led.vars --- END

	begin
		if reset='1' then
			-- IP impl.led.asyncrst --- BEGIN
			stateLed <= stateLedOn;
			-- IP impl.led.asyncrst --- END

		elsif rising_edge(tkclk) then
			if stateLed=stateLedOn then
				-- IP impl.led.on.ext --- INSERT

				if i=1000 then
					-- IP impl.led.on.prepOff --- INSERT

					stateLed <= stateLedOff;
				end if;

			elsif stateLed=stateLedOff then
				-- IP impl.led.off.ext --- INSERT

				if i=4000 then
					-- IP impl.led.off.prepOn --- INSERT

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
