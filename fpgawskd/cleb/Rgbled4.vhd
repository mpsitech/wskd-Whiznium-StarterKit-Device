-- file Rgbled4.vhd
-- Rgbled4 other module implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 24 Dec 2021
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Cleb.all;

entity Rgbled4 is
	port (
		reset: in std_logic;
		mclk: in std_logic;
		tkclk: in std_logic;
		rgb: in std_logic_vector(23 downto 0);
		r: out std_logic;
		g: out std_logic;
		b: out std_logic;

		stateBlue_dbg: out std_logic_vector(7 downto 0);
		stateGreen_dbg: out std_logic_vector(7 downto 0);
		stateRed_dbg: out std_logic_vector(7 downto 0)
	);
end Rgbled4;

architecture Rgbled4 of Rgbled4 is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- blue LED PWM (blue)
	type stateBlue_t is (
		stateBlueOn,
		stateBlueOff
	);
	signal stateBlue: stateBlue_t := stateBlueOn;

	-- IP sigs.blue.cust --- INSERT

	---- green LED PWM (green)
	type stateGreen_t is (
		stateGreenOn,
		stateGreenOff
	);
	signal stateGreen: stateGreen_t := stateGreenOn;

	-- IP sigs.green.cust --- INSERT

	---- red LED PWM (red)
	type stateRed_t is (
		stateRedOn,
		stateRedOff
	);
	signal stateRed: stateRed_t := stateRedOn;

	-- IP sigs.red.cust --- INSERT

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- implementation: blue LED PWM (blue)
	------------------------------------------------------------------------

	-- IP impl.blue.wiring --- BEGIN
	stateBlue_dbg <= x"00" when stateBlue=stateBlueOn
				else x"10" when stateBlue=stateBlueOff
				else (others => '1');
	-- IP impl.blue.wiring --- END

	-- IP impl.blue.rising --- BEGIN
	process (reset, tkclk, stateBlue)
		-- IP impl.blue.vars --- BEGIN
		-- IP impl.blue.vars --- END

	begin
		if reset='1' then
			-- IP impl.blue.asyncrst --- BEGIN
			stateBlue <= stateBlueOn;
			-- IP impl.blue.asyncrst --- END

		elsif rising_edge(tkclk) then
			if stateBlue=stateBlueOn then
				-- IP impl.blue.on --- INSERT

			elsif stateBlue=stateBlueOff then
				-- IP impl.blue.off --- INSERT
			end if;
		end if;
	end process;
	-- IP impl.blue.rising --- END

	------------------------------------------------------------------------
	-- implementation: green LED PWM (green)
	------------------------------------------------------------------------

	-- IP impl.green.wiring --- BEGIN
	stateGreen_dbg <= x"00" when stateGreen=stateGreenOn
				else x"10" when stateGreen=stateGreenOff
				else (others => '1');
	-- IP impl.green.wiring --- END

	-- IP impl.green.rising --- BEGIN
	process (reset, tkclk, stateGreen)
		-- IP impl.green.vars --- BEGIN
		-- IP impl.green.vars --- END

	begin
		if reset='1' then
			-- IP impl.green.asyncrst --- BEGIN
			stateGreen <= stateGreenOn;
			-- IP impl.green.asyncrst --- END

		elsif rising_edge(tkclk) then
			if stateGreen=stateGreenOn then
				-- IP impl.green.on --- INSERT

			elsif stateGreen=stateGreenOff then
				-- IP impl.green.off --- INSERT
			end if;
		end if;
	end process;
	-- IP impl.green.rising --- END

	------------------------------------------------------------------------
	-- implementation: red LED PWM (red)
	------------------------------------------------------------------------

	-- IP impl.red.wiring --- BEGIN
	stateRed_dbg <= x"00" when stateRed=stateRedOn
				else x"10" when stateRed=stateRedOff
				else (others => '1');
	-- IP impl.red.wiring --- END

	-- IP impl.red.rising --- BEGIN
	process (reset, tkclk, stateRed)
		-- IP impl.red.vars --- BEGIN
		-- IP impl.red.vars --- END

	begin
		if reset='1' then
			-- IP impl.red.asyncrst --- BEGIN
			stateRed <= stateRedOn;
			-- IP impl.red.asyncrst --- END

		elsif rising_edge(tkclk) then
			if stateRed=stateRedOn then
				-- IP impl.red.on --- INSERT

			elsif stateRed=stateRedOff then
				-- IP impl.red.off --- INSERT
			end if;
		end if;
	end process;
	-- IP impl.red.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Rgbled4;
