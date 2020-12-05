-- file Crc8005_32_v1_0.vhd
-- Crc8005_32_v1_0 crcspec_32_v1_0 implementation
-- copyright: (C) 2020 MPSI Technologies GmbH
-- author: Catherine Johnson (auto-generation)
-- date created: 1 Dec 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Crc8005_32_v1_0 is
	port (
		reset: in std_logic;
		mclk: in std_logic;

		req: in std_logic;
		ack: out std_logic;
		dne: out std_logic;

		captNotFin: in std_logic;

		d: in std_logic_vector(31 downto 0);
		lsbD: in std_logic_vector(1 downto 0);

		strbD: in std_logic;
		crc: out std_logic_vector(15 downto 0)
	);
end Crc8005_32_v1_0;

architecture Crc8005_32_v1_0 of Crc8005_32_v1_0 is

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- main operation (op)
	type stateOp_t is (
		stateOpInit,
		stateOpCaptA, stateOpCaptB, stateOpCaptC,
		stateOpDone
	);
	signal stateOp: stateOp_t := stateOpInit;

	signal crc_sig: std_logic_vector(15 downto 0);

begin

	------------------------------------------------------------------------
	-- implementation: main operation (op)
	------------------------------------------------------------------------

	ack <= '1' when (stateOp=stateOpCaptA or stateOp=stateOpCaptB or stateOp=stateOpCaptC or stateOp=stateOpDone) else '0';
	dne <= '1' when stateOp=stateOpDone else '0';

	crc <= crc_sig;
	
	process (reset, mclk)
		variable crc_int: std_logic_vector(15 downto 0);

		variable dinc: std_logic_vector(31 downto 0);

		variable imax: natural range 0 to 3;
		variable i: natural range 0 to 3;

	begin
		if reset='1' then
			stateOp <= stateOpInit;

			crc_sig <= x"0000";

			crc_int := x"0000";
			dinc := (others => '0');

		elsif rising_edge(mclk) then
			if (stateOp=stateOpInit or req='0') then
				crc_sig <= x"0000";

				crc_int := x"0000";
				dinc := (others => '0');

				if (req='1' and captNotFin='1') then
					stateOp <= stateOpCaptA;
				else
					stateOp <= stateOpInit;
				end if;

			elsif stateOp=stateOpCaptA then
				if captNotFin='0' then
					stateOp <= stateOpDone;

				elsif strbD='1' then
					dinc := d;

					imax := to_integer(unsigned(lsbD));
					i := 0;

					stateOp <= stateOpCaptB;
				end if;

			elsif stateOp=stateOpCaptB then
				crc_int := crc_sig;

				crc_sig(15) <= dinc((3-i)*8+7) xor dinc((3-i)*8+6) xor dinc((3-i)*8+5) xor dinc((3-i)*8+4) xor dinc((3-i)*8+3) xor dinc((3-i)*8+2) xor dinc((3-i)*8+1) xor dinc((3-i)*8+0) xor crc_int(7) xor crc_int(8) xor crc_int(9) xor crc_int(10) xor crc_int(11) xor crc_int(12) xor crc_int(13) xor crc_int(14) xor crc_int(15);
				crc_sig(14) <= crc_int(6);
				crc_sig(13) <= crc_int(5);
				crc_sig(12) <= crc_int(4);
				crc_sig(11) <= crc_int(3);
				crc_sig(10) <= crc_int(2);
				crc_sig(9) <= dinc((3-i)*8+7) xor crc_int(1) xor crc_int(15);
				crc_sig(8) <= dinc((3-i)*8+7) xor dinc((3-i)*8+6) xor crc_int(0) xor crc_int(14) xor crc_int(15);
				crc_sig(7) <= dinc((3-i)*8+6) xor dinc((3-i)*8+5) xor crc_int(13) xor crc_int(14);
				crc_sig(6) <= dinc((3-i)*8+5) xor dinc((3-i)*8+4) xor crc_int(12) xor crc_int(13);
				crc_sig(5) <= dinc((3-i)*8+4) xor dinc((3-i)*8+3) xor crc_int(11) xor crc_int(12);
				crc_sig(4) <= dinc((3-i)*8+3) xor dinc((3-i)*8+2) xor crc_int(10) xor crc_int(11);
				crc_sig(3) <= dinc((3-i)*8+2) xor dinc((3-i)*8+1) xor crc_int(9) xor crc_int(10);
				crc_sig(2) <= dinc((3-i)*8+1) xor dinc((3-i)*8+0) xor crc_int(8) xor crc_int(9);
				crc_sig(1) <= dinc((3-i)*8+7) xor dinc((3-i)*8+6) xor dinc((3-i)*8+5) xor dinc((3-i)*8+4) xor dinc((3-i)*8+3) xor dinc((3-i)*8+2) xor dinc((3-i)*8+1) xor crc_int(9) xor crc_int(10) xor crc_int(11) xor crc_int(12) xor crc_int(13) xor crc_int(14) xor crc_int(15);
				crc_sig(0) <= dinc((3-i)*8+7) xor dinc((3-i)*8+6) xor dinc((3-i)*8+5) xor dinc((3-i)*8+4) xor dinc((3-i)*8+3) xor dinc((3-i)*8+2) xor dinc((3-i)*8+1) xor dinc((3-i)*8+0) xor crc_int(8) xor crc_int(9) xor crc_int(10) xor crc_int(11) xor crc_int(12) xor crc_int(13) xor crc_int(14) xor crc_int(15);

				if i=imax then
					stateOp <= stateOpCaptC;
				else
					i := i + 1;
				end if;

			elsif stateOp=stateOpCaptC then
				if captNotFin='0' then
					stateOp <= stateOpDone;
				elsif strbD='0' then
					stateOp <= stateOpCaptA;
				end if;

			elsif stateOp=stateOpDone then
				-- if req='0' then
				-- 	stateOp <= stateOpInit;
				-- end if;
			end if;
		end if;
	end process;

end Crc8005_32_v1_0;


