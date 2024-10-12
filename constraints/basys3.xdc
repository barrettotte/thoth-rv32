# XDC constraints for Basys 3 Artix-7 board
# Modified from https://github.com/Digilent/digilent-xdc/blob/master/Basys-3-Master.xdc

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

## SPI configuration mode options for QSPI boot, can be used for all designs
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

## Clock (100MHz)
set_property -dict { PACKAGE_PIN W5  IOSTANDARD LVCMOS33 } [get_ports {clk_i}]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0.0 5.0} [get_ports {clk_i}]

# Center button
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports {reset_i}]

## LED 0-7
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports {q_o[0]}]
set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports {q_o[1]}]
set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports {q_o[2]}]
set_property -dict { PACKAGE_PIN V19 IOSTANDARD LVCMOS33 } [get_ports {q_o[3]}]
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports {q_o[4]}]
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports {q_o[5]}]
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports {q_o[6]}]
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports {q_o[7]}]

# Switches 0-7
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33 } [get_ports {d_i[0]}]
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports {d_i[1]}]
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports {d_i[2]}]
set_property -dict { PACKAGE_PIN W17 IOSTANDARD LVCMOS33 } [get_ports {d_i[3]}]
set_property -dict { PACKAGE_PIN W15 IOSTANDARD LVCMOS33 } [get_ports {d_i[4]}]
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports {d_i[5]}]
set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports {d_i[6]}]
set_property -dict { PACKAGE_PIN W13 IOSTANDARD LVCMOS33 } [get_ports {d_i[7]}]
