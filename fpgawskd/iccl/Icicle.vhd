-- file Icicle.vhd
-- Microchip PolarFire Soc Icicle Kit global constants and types
-- copyright: (C) 2017-2021 MPSI Technologies GmbH
-- author: Catherine Johnson (auto-generation)
-- date created: 1 Dec 2020
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

package Icicle is
	constant tixVIcicleControllerCamacq: std_logic_vector(7 downto 0) := x"01";
	constant tixVIcicleControllerCamif: std_logic_vector(7 downto 0) := x"02";
	constant tixVIcicleControllerFeatdet: std_logic_vector(7 downto 0) := x"03";
	constant tixVIcicleControllerLaser: std_logic_vector(7 downto 0) := x"04";
	constant tixVIcicleControllerState: std_logic_vector(7 downto 0) := x"05";
	constant tixVIcicleControllerStep: std_logic_vector(7 downto 0) := x"06";
	constant tixVIcicleControllerTkclksrc: std_logic_vector(7 downto 0) := x"07";

	constant tixVIcicleStateNc: std_logic_vector(7 downto 0) := x"00";
	constant tixVIcicleStateReady: std_logic_vector(7 downto 0) := x"01";
	constant tixVIcicleStateActive: std_logic_vector(7 downto 0) := x"02";

	constant tixWIcicleBufferCmdretToHostif: std_logic_vector(7 downto 0) := x"01";
	constant tixWIcicleBufferHostifToCmdinv: std_logic_vector(7 downto 0) := x"02";
	constant tixWIcicleBufferFlgbufFromFeatdet: std_logic_vector(7 downto 0) := x"04";
	constant tixWIcicleBufferPvwabufFromCamacq: std_logic_vector(7 downto 0) := x"08";
	constant tixWIcicleBufferPvwbbufFromCamacq: std_logic_vector(7 downto 0) := x"10";
	constant tixVleCamacqCommandSetGrrd: std_logic_vector(7 downto 0) := x"00";
	constant tixVleCamacqCommandGetGrrdinfo: std_logic_vector(7 downto 0) := x"01";
	constant tixVleCamacqCommandSetPvw: std_logic_vector(7 downto 0) := x"02";
	constant tixVleCamacqCommandGetPvwinfo: std_logic_vector(7 downto 0) := x"03";

	constant tixVleCamifCommandSetRng: std_logic_vector(7 downto 0) := x"00";
	constant tixVleCamifCommandSetReg: std_logic_vector(7 downto 0) := x"01";
	constant tixVleCamifCommandSetRegaddr: std_logic_vector(7 downto 0) := x"02";
	constant tixVleCamifCommandGetReg: std_logic_vector(7 downto 0) := x"03";
	constant tixVleCamifCommandModReg: std_logic_vector(7 downto 0) := x"04";

	constant tixVleFeatdetCommandSet: std_logic_vector(7 downto 0) := x"00";
	constant tixVleFeatdetCommandGetInfo: std_logic_vector(7 downto 0) := x"01";
	constant tixVleFeatdetCommandGetCornerinfo: std_logic_vector(7 downto 0) := x"02";
	constant tixVleFeatdetCommandSetCorner: std_logic_vector(7 downto 0) := x"03";
	constant tixVleFeatdetCommandSetThd: std_logic_vector(7 downto 0) := x"04";
	constant tixVleFeatdetCommandTriggerThd: std_logic_vector(7 downto 0) := x"05";

	constant tixVleLaserCommandSet: std_logic_vector(7 downto 0) := x"00";

	constant tixVleStateCommandGet: std_logic_vector(7 downto 0) := x"00";

	constant tixVleStepCommandGetInfo: std_logic_vector(7 downto 0) := x"00";
	constant tixVleStepCommandMoveto: std_logic_vector(7 downto 0) := x"01";
	constant tixVleStepCommandSet: std_logic_vector(7 downto 0) := x"02";
	constant tixVleStepCommandZero: std_logic_vector(7 downto 0) := x"03";

	constant tixVleTkclksrcCommandGetTkst: std_logic_vector(7 downto 0) := x"00";
	constant tixVleTkclksrcCommandSetTkst: std_logic_vector(7 downto 0) := x"01";
end Icicle;
