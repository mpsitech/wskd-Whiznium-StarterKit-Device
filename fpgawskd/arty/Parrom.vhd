-- file Parrom.vhd
-- Parrom other module implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Catherine Johnson (auto-generation)
-- date created: 1 Dec 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.Dbecore.all;
use work.Arty.all;

entity Parrom is
	port (
		clk: in std_logic;
		en: in std_logic;
		we: in std_logic;
		a: in std_logic_vector(10 downto 0);
		drd: out std_logic_vector(7 downto 0);
		dwr: in std_logic_vector(7 downto 0)
	);
end Parrom;

architecture Parrom of Parrom is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myBram : RAMB16_S9
		generic map (
			WRITE_MODE => "WRITE_FIRST",
			INIT_00 => x"003630360001083100033730001A343000FF183000FF17300003033100420830",
			INIT_01 => x"0001173700781537005A033700A0043700E021360012333600E23236000E3136",
			INIT_02 => x"003301360008003600123137000A01390010063900020539001A053700600B37",
			INIT_03 => x"00133536007C193A0000183A0043133A00501C4700201B370052203600602D30",
			INIT_04 => x"0000063C0098053C0028043C0034013C00DE6050000122360040343600033636",
			INIT_05 => x"00001238001011380000103800400B3C009C0A3C001C093C0000083C0007073C",
			INIT_06 => x"0000004300002E3000580E3000FF043000000030001A05400002014000640837",
			INIT_07 => x"0060113A00261E3A00301B3A0028103A00300F3A00A7005000000E4400051F50",
			INIT_08 => x"000C06580026055800120458000F0358000F0258001401580023005800141F3A",
			INIT_09 => x"00000E5800030D5800080C58000D0B5800080A58000509580005085800080758",
			INIT_0A => x"0003165800011558000014580003135800071258000911580003105800000F58",
			INIT_0B => x"00291E58000E1D5800081C5800061B5800051A5800081958000D185800081758",
			INIT_0C => x"0008265800262558004624580028235800152258001121580011205800171F58",
			INIT_0D => x"00062E5800242D5800242C5800222B5800242A58002629580064285800262758",
			INIT_0E => x"0022365800223558002434580026335800243258004231580040305800222F58",
			INIT_0F => x"00FF805100CE3D5800423C5800283B5800263A58002439580044385800263758",
			INIT_10 => x"0009885100098751000986510024855100258451001483510000825100F28151",
			INIT_11 => x"0046905100568F51003D8E5100428D5100B28C5100E08B5100548A5100758951",
			INIT_12 => x"00049851000197510003965100F0955100F09451007093510004925100F89151",
			INIT_13 => x"000881540001805400389E5100829D5100069C5100009B5100049A5100129951",
			INIT_14 => x"0091895400878854007D87540071865400658554005184540028835400148254",
			INIT_15 => x"001E8153001D905400EA8F5400DD8E5400CD8D5400B88C5400AA8B54009A8A54",
			INIT_16 => x"00108953006C8853007C875300888653007E8553000A845300088353005B8253",
			INIT_17 => x"00F88B5500008A550010895500108455004083550006805500988B5300018A53",
			INIT_18 => x"0008065300300553000804530000035300100253003001530008005300401D50",
			INIT_19 => x"00000000000208300000255000060C5300040B5300300A530008095300160753",
			INIT_20 => x"00000038001115380011143800062138004020380007073C0069363000713530",
			INIT_21 => x"000A0838009F073800070638003F0538000A0438000003380000023800000138",
			INIT_22 => x"0004133800B00F3800070E38001C0D38000B0C3800980B3800070A3800200938",
			INIT_23 => x"0002134700C30630001C02300006044000000C3700120937002B123600041836",
			INIT_24 => x"00462038000003350083015000012438002C374800200C4600370B46000C0744"
		)
		port map (
			DO => drd,
			DOP => open,
			ADDR => a,
			CLK => clk,
			DI => dwr,
			DIP => (others => '0'),
			EN => en,
			SSR => '0',
			WE => we
		);

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Parrom;
