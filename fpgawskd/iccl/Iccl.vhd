-- file Iccl.vhd
-- Microchip PolarFire Soc Icicle kit global constants and types
-- copyright: (C) 2017-2020 MPSI Technologies GmbH
-- author: Alexander Wirthmueller (auto-generation)
-- date created: 23 Oct 2021
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

package Iccl is
	constant tixVIcclControllerCamacq: std_logic_vector(7 downto 0) := x"01";
	constant tixVIcclControllerCamif: std_logic_vector(7 downto 0) := x"02";
	constant tixVIcclControllerFeatdet: std_logic_vector(7 downto 0) := x"03";
	constant tixVIcclControllerLaser: std_logic_vector(7 downto 0) := x"04";
	constant tixVIcclControllerState: std_logic_vector(7 downto 0) := x"05";
	constant tixVIcclControllerStep: std_logic_vector(7 downto 0) := x"06";
	constant tixVIcclControllerTkclksrc: std_logic_vector(7 downto 0) := x"07";

	constant tixVIcclStateNc: std_logic_vector(7 downto 0) := x"00";
	constant tixVIcclStateReady: std_logic_vector(7 downto 0) := x"01";
	constant tixVIcclStateActive: std_logic_vector(7 downto 0) := x"02";

	constant tixWIcclBufferCmdretToHostif: std_logic_vector(7 downto 0) := x"01";
	constant tixWIcclBufferHostifToCmdinv: std_logic_vector(7 downto 0) := x"02";
	constant tixWIcclBufferFlgbufFeatdetToHostif: std_logic_vector(7 downto 0) := x"04";
	constant tixWIcclBufferPvwabufCamacqToHostif: std_logic_vector(7 downto 0) := x"08";
	constant tixWIcclBufferPvwbbufCamacqToHostif: std_logic_vector(7 downto 0) := x"10";

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
end Iccl;
