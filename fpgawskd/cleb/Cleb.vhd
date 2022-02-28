-- file Cleb.vhd
-- Lattice CrossLink-NX Evaluation Board global constants and types
-- copyright: (C) 2017-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 24 Dec 2021
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

package Cleb is
	constant tixVClebControllerLaser: std_logic_vector(7 downto 0) := x"01";
	constant tixVClebControllerState: std_logic_vector(7 downto 0) := x"02";
	constant tixVClebControllerStep: std_logic_vector(7 downto 0) := x"03";
	constant tixVClebControllerTkclksrc: std_logic_vector(7 downto 0) := x"04";

	constant tixVClebStateNc: std_logic_vector(7 downto 0) := x"00";
	constant tixVClebStateReady: std_logic_vector(7 downto 0) := x"01";
	constant tixVClebStateActive: std_logic_vector(7 downto 0) := x"02";

	constant tixWClebBufferCmdretToHostif: std_logic_vector(7 downto 0) := x"01";
	constant tixWClebBufferHostifToCmdinv: std_logic_vector(7 downto 0) := x"02";

	constant tixVLaserCommandSet: std_logic_vector(7 downto 0) := x"00";

	constant tixVStateCommandGet: std_logic_vector(7 downto 0) := x"00";

	constant tixVStepCommandGetInfo: std_logic_vector(7 downto 0) := x"00";
	constant tixVStepCommandMoveto: std_logic_vector(7 downto 0) := x"01";
	constant tixVStepCommandSet: std_logic_vector(7 downto 0) := x"02";
	constant tixVStepCommandZero: std_logic_vector(7 downto 0) := x"03";

	constant tixVTkclksrcCommandGetTkst: std_logic_vector(7 downto 0) := x"00";
	constant tixVTkclksrcCommandSetTkst: std_logic_vector(7 downto 0) := x"01";
end Cleb;
