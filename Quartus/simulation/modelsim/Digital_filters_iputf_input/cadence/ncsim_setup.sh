
cp -f D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/submodules/nco11bit_nco_ii_0_sin.hex ./

ncvlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/submodules/nco11bit_nco_ii_0.v" -work nco_ii_0 -cdslib <<nco_ii_0>>
ncvlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/nco11bit.v"                                                        
