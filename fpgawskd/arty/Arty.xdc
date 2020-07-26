# file Arty.xdc
# Digilent Arty Z7 pin mapping and constraints
# author Catherine Johnson
# date created: 16 May 2020
# modified: 16 May 2020

# bank34 3.3V
set_property PACKAGE_PIN Y18 [get_ports d2];
set_property PACKAGE_PIN U18 [get_ports d3];
set_property PACKAGE_PIN Y19 [get_ports d4];
set_property PACKAGE_PIN U19 [get_ports d5];
set_property PACKAGE_PIN Y16 [get_ports d6];
set_property PACKAGE_PIN W18 [get_ports d7];
set_property PACKAGE_PIN Y17 [get_ports d8];
set_property PACKAGE_PIN W19 [get_ports d9];
set_property PACKAGE_PIN T14 [get_ports dbg0];
set_property PACKAGE_PIN T15 [get_ports dbg1];
set_property PACKAGE_PIN V17 [get_ports dbg2];
set_property PACKAGE_PIN V18 [get_ports dbg3];
set_property PACKAGE_PIN R17 [get_ports dbg4];
set_property PACKAGE_PIN R14 [get_ports dbg5];
set_property PACKAGE_PIN Y14 [get_ports href];
set_property PACKAGE_PIN V13 [get_ports mosi];
set_property PACKAGE_PIN V16 [get_ports pclk];
set_property PACKAGE_PIN V12 [get_ports pwdn];
set_property PACKAGE_PIN T11 [get_ports rst];
set_property PACKAGE_PIN U14 [get_ports sclk];
set_property PACKAGE_PIN T10 [get_ports sioc];
set_property PACKAGE_PIN W13 [get_ports siod];
set_property PACKAGE_PIN N18 [get_ports step1];
set_property PACKAGE_PIN U15 [get_ports step3];
set_property PACKAGE_PIN W16 [get_ports vsync];
set_property PACKAGE_PIN W14 [get_ports xclk];

# bank35 3.3V
set_property PACKAGE_PIN D20 [get_ports btn0];
set_property PACKAGE_PIN D19 [get_ports btn1];
set_property PACKAGE_PIN J18 [get_ports cs0];
set_property PACKAGE_PIN G15 [get_ports cs1];
set_property PACKAGE_PIN H16 [get_ports extclk];
set_property PACKAGE_PIN L15 [get_ports led4_b];
set_property PACKAGE_PIN G17 [get_ports led4_g];
set_property PACKAGE_PIN N15 [get_ports led4_r];
set_property PACKAGE_PIN G14 [get_ports led5_b];
set_property PACKAGE_PIN L14 [get_ports led5_g];
set_property PACKAGE_PIN M15 [get_ports led5_r];
set_property PACKAGE_PIN M18 [get_ports step2];
set_property PACKAGE_PIN K18 [get_ports step4];

# banks
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];

# IP clks --- BEGIN
# clocks
# a clock by the name of clk_fpga_0 is generated automatically with the correct timing
# IP clks --- END

