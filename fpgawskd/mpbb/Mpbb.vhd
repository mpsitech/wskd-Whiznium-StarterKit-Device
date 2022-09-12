-- file Mpbb.vhd
-- enclustra Mercury+ base board global constants and types
-- copyright: (C) 2017-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 8 Jun 2022
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Dbecore is
	constant fls8: std_logic_vector(7 downto 0) := x"AA";
	constant fls16: std_logic_vector(15 downto 0) := x"AAAA";
	constant fls32: std_logic_vector(31 downto 0) := x"AAAAAAAA";

	constant tru8: std_logic_vector(7 downto 0) := x"55";
	constant tru16: std_logic_vector(15 downto 0) := x"5555";
	constant tru32: std_logic_vector(31 downto 0) := x"55555555";

	constant ixOpbufBuffer: natural := 0;
	constant ixOpbufController: natural := 1;
	constant ixOpbufCommand: natural := 2;
	constant ixOpbufLength: natural := 3;
	constant ixOpbufCrc: natural := 5;
end Dbecore;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Mpbb is
end Mpbb;
