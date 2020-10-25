-- file Arty.vhd
-- Digilent Arty Z7 global constants and types
-- author Catherine Johnson
-- date created: 17 Oct 2020
-- date modified: 17 Oct 2020

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

package Arty is
	constant tixVControllerCamacq: std_logic_vector(7 downto 0) := x"01";
	constant tixVControllerCamif: std_logic_vector(7 downto 0) := x"02";
	constant tixVControllerFeatdet: std_logic_vector(7 downto 0) := x"03";
	constant tixVControllerLaser: std_logic_vector(7 downto 0) := x"04";
	constant tixVControllerState: std_logic_vector(7 downto 0) := x"05";
	constant tixVControllerStep: std_logic_vector(7 downto 0) := x"06";
	constant tixVControllerTkclksrc: std_logic_vector(7 downto 0) := x"07";

	constant tixVStateNc: std_logic_vector(7 downto 0) := x"00";
	constant tixVStateReady: std_logic_vector(7 downto 0) := x"01";
	constant tixVStateActive: std_logic_vector(7 downto 0) := x"02";

	constant tixWBufferCmdretToHostif: std_logic_vector(7 downto 0) := x"01";
	constant tixWBufferHostifToCmdinv: std_logic_vector(7 downto 0) := x"02";
	constant tixWBufferFlgbufFeatdetToHostif: std_logic_vector(7 downto 0) := x"04";
	constant tixWBufferPvwabufCamacqToHostif: std_logic_vector(7 downto 0) := x"08";
	constant tixWBufferPvwbbufCamacqToHostif: std_logic_vector(7 downto 0) := x"10";

	constant tixVCamacqCommandSetGrrd: std_logic_vector(7 downto 0) := x"00";
	constant tixVCamacqCommandGetGrrdinfo: std_logic_vector(7 downto 0) := x"01";
	constant tixVCamacqCommandSetPvw: std_logic_vector(7 downto 0) := x"02";
	constant tixVCamacqCommandGetPvwinfo: std_logic_vector(7 downto 0) := x"03";

	constant tixVCamifCommandSetRng: std_logic_vector(7 downto 0) := x"00";
	constant tixVCamifCommandSetReg: std_logic_vector(7 downto 0) := x"01";
	constant tixVCamifCommandSetRegaddr: std_logic_vector(7 downto 0) := x"02";
	constant tixVCamifCommandGetReg: std_logic_vector(7 downto 0) := x"03";
	constant tixVCamifCommandModReg: std_logic_vector(7 downto 0) := x"04";

	constant tixVFeatdetCommandSet: std_logic_vector(7 downto 0) := x"00";
	constant tixVFeatdetCommandGetInfo: std_logic_vector(7 downto 0) := x"01";
	constant tixVFeatdetCommandGetCornerinfo: std_logic_vector(7 downto 0) := x"02";
	constant tixVFeatdetCommandSetCorner: std_logic_vector(7 downto 0) := x"03";
	constant tixVFeatdetCommandSetThd: std_logic_vector(7 downto 0) := x"04";
	constant tixVFeatdetCommandTriggerThd: std_logic_vector(7 downto 0) := x"05";

	constant tixVLaserCommandSet: std_logic_vector(7 downto 0) := x"00";

	constant tixVStateCommandGet: std_logic_vector(7 downto 0) := x"00";

	constant tixVStepCommandGetInfo: std_logic_vector(7 downto 0) := x"00";
	constant tixVStepCommandMoveto: std_logic_vector(7 downto 0) := x"01";
	constant tixVStepCommandSet: std_logic_vector(7 downto 0) := x"02";
	constant tixVStepCommandZero: std_logic_vector(7 downto 0) := x"03";

	constant tixVTkclksrcCommandGetTkst: std_logic_vector(7 downto 0) := x"00";
	constant tixVTkclksrcCommandSetTkst: std_logic_vector(7 downto 0) := x"01";
end Arty;

