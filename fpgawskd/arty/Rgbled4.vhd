-- file Rgbled4.vhd
-- Rgbled4 other module implementation
-- author Catherine Johnson
-- date created: 17 Oct 2020
-- date modified: 17 Oct 2020

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Arty.all;

entity Rgbled4 is
	port (
		reset: in std_logic;
		mclk: in std_logic;
		tkclk: in std_logic;
		rgb: in std_logic_vector(23 downto 0);
		r: out std_logic;
		g: out std_logic;
		b: out std_logic
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

	-- IP impl.blue.wiring --- RBEGIN
	b <= '1' when stateBlue=stateBlueOn else '0';
	-- IP impl.blue.wiring --- REND

	-- IP impl.blue.rising --- BEGIN
	process (reset, tkclk, stateBlue)
		-- IP impl.blue.vars --- RBEGIN
		variable i: natural range 0 to 256;
		-- IP impl.blue.vars --- REND

	begin
		if reset='1' then
			-- IP impl.blue.asyncrst --- RBEGIN
			if rgb(7 downto 0)=x"00" then
				stateBlue <= stateBlueOff;
			else
				stateBlue <= stateBlueOn;
			end if;
			
			i := 0;
			-- IP impl.blue.asyncrst --- REND

		elsif rising_edge(tkclk) then
			if stateBlue=stateBlueOn then
				-- IP impl.blue.on --- IBEGIN
				i := i + 1;

				if i=256 then
					i := 0;
				elsif i >= to_integer(unsigned(rgb(7 downto 0))) then
					stateBlue <= stateBlueOff;
				end if;
				-- IP impl.blue.on --- IEND

			elsif stateBlue=stateBlueOff then
				-- IP impl.blue.off --- IBEGIN
				i := i + 1;

				if i=256 then
					i := 0;

					if rgb(7 downto 0)/=x"00" then
						stateBlue <= stateBlueOn;
					end if;
				end if;
				-- IP impl.blue.off --- IEND
			end if;
		end if;
	end process;
	-- IP impl.blue.rising --- END

	------------------------------------------------------------------------
	-- implementation: green LED PWM (green)
	------------------------------------------------------------------------

	-- IP impl.green.wiring --- RBEGIN
	g <= '1' when stateGreen=stateGreenOn else '0';
	-- IP impl.green.wiring --- REND

	-- IP impl.green.rising --- BEGIN
	process (reset, tkclk, stateGreen)
		-- IP impl.green.vars --- RBEGIN
		variable i: natural range 0 to 256;
		-- IP impl.green.vars --- REND

	begin
		if reset='1' then
			-- IP impl.green.asyncrst --- RBEGIN
			if rgb(15 downto 8)=x"00" then
				stateGreen <= stateGreenOff;
			else
				stateGreen <= stateGreenOn;
			end if;

			i := 0;
			-- IP impl.green.asyncrst --- REND

		elsif rising_edge(tkclk) then
			if stateGreen=stateGreenOn then
				-- IP impl.green.on --- IBEGIN
				i := i + 1;

				if i=256 then
					i := 0;
				elsif i >= to_integer(unsigned(rgb(15 downto 8))) then
					stateGreen <= stateGreenOff;
				end if;
				-- IP impl.green.on --- IEND

			elsif stateGreen=stateGreenOff then
				-- IP impl.green.off --- IBEGIN
				i := i + 1;

				if i=256 then
					i := 0;

					if rgb(15 downto 8)/=x"00" then
						stateGreen <= stateGreenOn;
					end if;
				end if;
				-- IP impl.green.off --- IEND
			end if;
		end if;
	end process;
	-- IP impl.green.rising --- END

	------------------------------------------------------------------------
	-- implementation: red LED PWM (red)
	------------------------------------------------------------------------

	-- IP impl.red.wiring --- RBEGIN
	r <= '1' when stateRed=stateRedOn else '0';
	-- IP impl.red.wiring --- REND

	-- IP impl.red.rising --- BEGIN
	process (reset, tkclk, stateRed)
		-- IP impl.red.vars --- RBEGIN
		variable i: natural range 0 to 256;
		-- IP impl.red.vars --- REND

	begin
		if reset='1' then
			-- IP impl.red.asyncrst --- RBEGIN
			if rgb(23 downto 16)=x"00" then
				stateRed <= stateRedOff;
			else
				stateRed <= stateRedOn;
			end if;

			i := 0;
			-- IP impl.red.asyncrst --- REND

		elsif rising_edge(tkclk) then
			if stateRed=stateRedOn then
				-- IP impl.red.on --- IBEGIN
				i := i + 1;

				if i=256 then
					i := 0;
				elsif i >= to_integer(unsigned(rgb(23 downto 16))) then
					stateRed <= stateRedOff;
				end if;
				-- IP impl.red.on --- IEND

			elsif stateRed=stateRedOff then
				-- IP impl.red.off --- IBEGIN
				i := i + 1;

				if i=256 then
					i := 0;

					if rgb(23 downto 16)/=x"00" then
						stateRed <= stateRedOn;
					end if;
				end if;
				-- IP impl.red.off --- IEND
			end if;
		end if;
	end process;
	-- IP impl.red.rising --- END

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Rgbled4;


