-- file Arty_ip_v1_0.vhd
-- Arty_ip_v1_0 zynq_ip_v1_0 wrapper implementation
-- copyright: (C) 2016-2020 MPSI Technologies GmbH
-- author: Catherine Johnson (auto-generation)
-- date created: 1 Dec 2020
-- IP header --- ABOVE

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Dbecore.all;
use work.Arty.all;

entity Arty_ip_v1_0 is
	generic (
		C_S00_AXI_DATA_WIDTH: integer := 32;
		C_S00_AXI_ADDR_WIDTH: integer := 4
	);
	port (
		s00_axi_aclk: in std_logic;
		s00_axi_aresetn: in std_logic;
		s00_axi_awaddr: in std_logic_vector(3 downto 0);
		s00_axi_awprot: in std_logic_vector(2 downto 0);
		s00_axi_awvalid: in std_logic;
		s00_axi_awready: out std_logic;
		s00_axi_wdata: in std_logic_vector(31 downto 0);
		s00_axi_wstrb: in std_logic_vector(3 downto 0);
		s00_axi_wvalid: in std_logic;
		s00_axi_wready: out std_logic;
		s00_axi_bresp: out std_logic_vector(1 downto 0);
		s00_axi_bvalid: out std_logic;
		s00_axi_bready: in std_logic;
		s00_axi_araddr: in std_logic_vector(3 downto 0);
		s00_axi_arprot: in std_logic_vector(2 downto 0);
		s00_axi_arvalid: in std_logic;
		s00_axi_arready: out std_logic;
		s00_axi_rdata: out std_logic_vector(31 downto 0);
		s00_axi_rresp: out std_logic_vector(1 downto 0);
		s00_axi_rvalid: out std_logic;
		s00_axi_rready: in std_logic;

		sw: in std_logic_vector(1 downto 0);
		led: out std_logic_vector(3 downto 0);
		dbg0: out std_logic;
		dbg1: out std_logic;
		dbg2: out std_logic;
		dbg3: out std_logic;
		dbg4: out std_logic;
		dbg5: out std_logic;
		pclk: in std_logic;
		href: in std_logic;
		vsync: in std_logic;
		d2: in std_logic;
		d3: in std_logic;
		d4: in std_logic;
		d5: in std_logic;
		d6: in std_logic;
		d7: in std_logic;
		d8: in std_logic;
		d9: in std_logic;
		rst: out std_logic;
		pwdn: out std_logic;
		xclk: out std_logic;
		sioc: out std_logic;
		siod: inout std_logic;
		btn0: in std_logic;
		btn1: in std_logic;
		cs0: out std_logic;
		cs1: out std_logic;
		sclk: out std_logic;
		mosi: out std_logic;
		extclk: in std_logic;
		led4_r: out std_logic;
		led4_g: out std_logic;
		led4_b: out std_logic;
		led5_r: out std_logic;
		led5_g: out std_logic;
		led5_b: out std_logic;
		step1: out std_logic;
		step2: out std_logic;
		step3: out std_logic;
		step4: out std_logic
	);
end Arty_ip_v1_0;

architecture Arty_ip_v1_0 of Arty_ip_v1_0 is

	------------------------------------------------------------------------
	-- component declarations
	------------------------------------------------------------------------

	component Arty_ip_v2_0_S00_AXI is
		generic (
			C_S_AXI_DATA_WIDTH: integer := 32;
			C_S_AXI_ADDR_WIDTH: integer := 4
		);
		port (
			S_AXI_ACLK: in std_logic;
			S_AXI_ARESETN: in std_logic;
			S_AXI_AWADDR: in std_logic_vector(3 downto 0);
			S_AXI_AWPROT: in std_logic_vector(2 downto 0);
			S_AXI_AWVALID: in std_logic;
			S_AXI_AWREADY: out std_logic;
			S_AXI_WDATA: in std_logic_vector(31 downto 0);
			S_AXI_WSTRB: in std_logic_vector(3 downto 0);
			S_AXI_WVALID: in std_logic;
			S_AXI_WREADY: out std_logic;
			S_AXI_BRESP: out std_logic_vector(1 downto 0);
			S_AXI_BVALID: out std_logic;
			S_AXI_BREADY: in std_logic;
			S_AXI_ARADDR: in std_logic_vector(3 downto 0);
			S_AXI_ARPROT: in std_logic_vector(2 downto 0);
			S_AXI_ARVALID: in std_logic;
			S_AXI_ARREADY: out std_logic;
			S_AXI_RDATA: out std_logic_vector(31 downto 0);
			S_AXI_RRESP: out std_logic_vector(1 downto 0);
			S_AXI_RVALID: out std_logic;
			S_AXI_RREADY: in std_logic;

			sw: in std_logic_vector(1 downto 0);
			led: out std_logic_vector(3 downto 0);
			dbg0: out std_logic;
			dbg1: out std_logic;
			dbg2: out std_logic;
			dbg3: out std_logic;
			dbg4: out std_logic;
			dbg5: out std_logic;
			pclk: in std_logic;
			href: in std_logic;
			vsync: in std_logic;
			d2: in std_logic;
			d3: in std_logic;
			d4: in std_logic;
			d5: in std_logic;
			d6: in std_logic;
			d7: in std_logic;
			d8: in std_logic;
			d9: in std_logic;
			rst: out std_logic;
			pwdn: out std_logic;
			xclk: out std_logic;
			sioc: out std_logic;
			siod: inout std_logic;
			btn0: in std_logic;
			btn1: in std_logic;
			cs0: out std_logic;
			cs1: out std_logic;
			sclk: out std_logic;
			mosi: out std_logic;
			extclk: in std_logic;
			led4_r: out std_logic;
			led4_g: out std_logic;
			led4_b: out std_logic;
			led5_r: out std_logic;
			led5_g: out std_logic;
			led5_b: out std_logic;
			step1: out std_logic;
			step2: out std_logic;
			step3: out std_logic;
			step4: out std_logic
		);
	end component;

	------------------------------------------------------------------------
	-- signal declarations
	------------------------------------------------------------------------

	---- other
	-- IP sigs.oth.cust --- INSERT

begin

	------------------------------------------------------------------------
	-- sub-module instantiation
	------------------------------------------------------------------------

	myArty_ip_AXI : Arty_ip_v2_0_S00_AXI
		generic map (
			C_S_AXI_DATA_WIDTH => 32,
			C_S_AXI_ADDR_WIDTH => 4
		)
		port map (
			S_AXI_ACLK => s00_axi_aclk,
			S_AXI_ARESETN => s00_axi_aresetn,
			S_AXI_AWADDR => s00_axi_awaddr,
			S_AXI_AWPROT => s00_axi_awprot,
			S_AXI_AWVALID => s00_axi_awvalid,
			S_AXI_AWREADY => s00_axi_awready,
			S_AXI_WDATA => s00_axi_wdata,
			S_AXI_WSTRB => s00_axi_wstrb,
			S_AXI_WVALID => s00_axi_wvalid,
			S_AXI_WREADY => s00_axi_wready,
			S_AXI_BRESP => s00_axi_bresp,
			S_AXI_BVALID => s00_axi_bvalid,
			S_AXI_BREADY => s00_axi_bready,
			S_AXI_ARADDR => s00_axi_araddr,
			S_AXI_ARPROT => s00_axi_arprot,
			S_AXI_ARVALID => s00_axi_arvalid,
			S_AXI_ARREADY => s00_axi_arready,
			S_AXI_RDATA => s00_axi_rdata,
			S_AXI_RRESP => s00_axi_rresp,
			S_AXI_RVALID => s00_axi_rvalid,
			S_AXI_RREADY => s00_axi_rready,

			sw => sw,
			led => led,
			dbg0 => dbg0,
			dbg1 => dbg1,
			dbg2 => dbg2,
			dbg3 => dbg3,
			dbg4 => dbg4,
			dbg5 => dbg5,
			pclk => pclk,
			href => href,
			vsync => vsync,
			d2 => d2,
			d3 => d3,
			d4 => d4,
			d5 => d5,
			d6 => d6,
			d7 => d7,
			d8 => d8,
			d9 => d9,
			rst => rst,
			pwdn => pwdn,
			xclk => xclk,
			sioc => sioc,
			siod => siod,
			btn0 => btn0,
			btn1 => btn1,
			cs0 => cs0,
			cs1 => cs1,
			sclk => sclk,
			mosi => mosi,
			extclk => extclk,
			led4_r => led4_r,
			led4_g => led4_g,
			led4_b => led4_b,
			led5_r => led5_r,
			led5_g => led5_g,
			led5_b => led5_b,
			step1 => step1,
			step2 => step2,
			step3 => step3,
			step4 => step4
		);

	------------------------------------------------------------------------
	-- implementation: other 
	------------------------------------------------------------------------

	
	-- IP impl.oth.cust --- INSERT

end Arty_ip_v1_0;


