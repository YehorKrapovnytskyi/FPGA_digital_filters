
cp -f D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/nco15bit_nco_ii_0_sin.hex ./

ncvlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/nco15bit_nco_ii_0.v" -work nco_ii_0 -cdslib <<nco_ii_0>>
ncvlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/nco15bit.v"                                                        
