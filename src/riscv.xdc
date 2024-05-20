## Source: https://reference.digilentinc.com/_media/reference/programmable-logic/pynq-z1/pynq-z1_c.zip
##


##LEDs

set_property -dict {PACKAGE_PIN R14 IOSTANDARD LVCMOS33} [get_ports {en_dmem}]




##Switches

set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {rst}]

## Clock signal 125 MHz

set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports CLK_125MHZ_FPGA]
create_clock -period 8.000 -name CLK_125MHZ_FPGA -waveform {0.000 4.000} [get_ports CLK_125MHZ_FPGA]

set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]