## Source: https://reference.digilentinc.com/_media/reference/programmable-logic/pynq-z1/pynq-z1_c.zip
##


##Switches

set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {rst}]

## Clock signal 125 MHz

set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports CLK_125MHZ_FPGA]
create_clock -period 8.000 -name CLK_125MHZ_FPGA -waveform {0.000 4.000} -add [get_ports CLK_125MHZ_FPGA]

