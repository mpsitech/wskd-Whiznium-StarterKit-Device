# file Arty.xdc
# Digilent Arty Z7 pin mapping and constraints
# copyright: (C) 2017-2020 MPSI Technologies GmbH
# author: Catherine Johnson (auto-generation)
# date created: 1 Dec 2020
# IP header --- ABOVE

# bank34 3.3V
set_property PACKAGE_PIN W14 [get_ports cs];
set_property PACKAGE_PIN P19 [get_ports csi_clk_n];
set_property PACKAGE_PIN N18 [get_ports csi_clk_p];
set_property PACKAGE_PIN W20 [get_ports csi_d0_n];
set_property PACKAGE_PIN V20 [get_ports csi_d0_p];
set_property PACKAGE_PIN U20 [get_ports csi_d1_n];
set_property PACKAGE_PIN T20 [get_ports csi_d1_p];
set_property PACKAGE_PIN T14 [get_ports dbg0];
set_property PACKAGE_PIN U12 [get_ports dbg1];
set_property PACKAGE_PIN U13 [get_ports dbg2];
set_property PACKAGE_PIN V13 [get_ports dbg3];
set_property PACKAGE_PIN V15 [get_ports dbg4];
set_property PACKAGE_PIN T15 [get_ports dbg5];
set_property PACKAGE_PIN T10 [get_ports dir];
set_property PACKAGE_PIN R14 [get_ports {led[0]}];
set_property PACKAGE_PIN P14 [get_ports {led[1]}];
set_property PACKAGE_PIN V12 [get_ports m0];
set_property PACKAGE_PIN Y14 [get_ports mosi];
set_property PACKAGE_PIN W16 [get_ports nslp];
set_property PACKAGE_PIN W15 [get_ports pmnd_txd];
set_property PACKAGE_PIN R17 [get_ports scl];
set_property PACKAGE_PIN V16 [get_ports sclk];
set_property PACKAGE_PIN T16 [get_ports sda];
set_property PACKAGE_PIN W13 [get_ports step0];

# bank35 3.3V
set_property PACKAGE_PIN D20 [get_ports btn0];
set_property PACKAGE_PIN D19 [get_ports btn1];
set_property PACKAGE_PIN H16 [get_ports extclk];
set_property PACKAGE_PIN N16 [get_ports {led[2]}];
set_property PACKAGE_PIN M14 [get_ports {led[3]}];
set_property PACKAGE_PIN L15 [get_ports led4_b];
set_property PACKAGE_PIN G17 [get_ports led4_g];
set_property PACKAGE_PIN N15 [get_ports led4_r];
set_property PACKAGE_PIN G14 [get_ports led5_b];
set_property PACKAGE_PIN L14 [get_ports led5_g];
set_property PACKAGE_PIN M15 [get_ports led5_r];
set_property PACKAGE_PIN H15 [get_ports pmnd_rxd];

# banks
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 0]];
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];

# IP clks --- BEGIN
# clocks
#create_generated_clock -name rxclk -source [get_ports/get_pins xxxxx] -edges {a b c} [get_pins root/myArty_ip_AXI/myTop/myCamacq/myBufgRxclk/O];
# IP clks --- END
