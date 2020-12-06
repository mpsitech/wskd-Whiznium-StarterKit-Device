-- file Bcdfreq_v1_0.vhd
-- Bcdfreq_v1_0 module implementation
-- author: Alexander Wirthmueller
-- copyright: (C) 2020 MPSI Technologies GmbH
-- date created: 6 Jan 2020
-- date modified: 4 Feb 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Bcdfreq_v1_0 is
	generic (
		fMclk: natural range 1 to 1000000 := 50000
	);
	port (
		reset: in std_logic;
		mclk: in std_logic;

		high: in std_logic_vector(3 downto 0);
		low: in std_logic_vector(3 downto 0);
		
		freq: out std_logic
	);
end Bcdfreq_v1_0;

architecture Bcdfreq_v1_0 of Bcdfreq_v1_0 is

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpLoad,
		stateOpTen,
		stateOpOne
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal freq_sig: std_logic;

begin

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	freq <= freq_sig;

	process (reset, mclk)
		constant imax: natural := fMclk/100/2; -- 5us wait for tens
		variable i: natural range 0 to imax; -- tens
		
		constant jmax: natural := fMclk/1000/2; -- 500ns wait for ones
		variable j: natural range 0 to jmax; -- ones

		variable high_lcl, low_lcl: std_logic_vector(3 downto 0);

		variable ten: natural range 0 to 15; -- ensure compatibility with (wrong) BCD values A..F
		variable one: natural range 0 to 15;

	begin
		if reset='1' then
			stateOp <= stateOpInit;

			freq_sig <= '0';
			
			i := 0;
			j := 0;
			high_lcl := (others => '0');
			low_lcl := (others => '0');
			ten := 0;
			one := 0;
			
		elsif rising_edge(mclk) then
			if stateOp=stateOpInit then
				freq_sig <= '0';
				
				i := 0;
				j := 0;
				high_lcl := (others => '0');
				low_lcl := (others => '0');
				ten := 0;
				one := 0;

				stateOp <= stateOpLoad;

			elsif stateOp=stateOpLoad then
				freq_sig <= '0';
				
				high_lcl := high;
				low_lcl := low;

				if (high_lcl/="0000" or low_lcl/="0000") then
					i := 0;

					ten := 0;

					stateOp <= stateOpTen;
				end if;

			elsif stateOp=stateOpTen then
				if ten >= to_integer(unsigned(high_lcl)) then
					j := 0;
				
					one := 0;

					stateOp <= stateOpOne;
					
				else
					i := i + 1;
					
					if i=imax then
						i := 0;

						ten := ten + 1;
					end if;
				end if;
					
			elsif stateOp=stateOpOne then
				if one >= to_integer(unsigned(low_lcl)) then
					if freq_sig='0' then
						freq_sig <= '1';
						
						i := 0;
						
						ten := 0;
						
						stateOp <= stateOpTen;

					else
						stateOp <= stateOpLoad;
					end if;
				
				else
					j := j + 1;
					
					if j=jmax then
						j := 0;
						
						one := one + 1;
					end if;
				end if;
			end if;
		end if;
	end process;

end Bcdfreq_v1_0;
