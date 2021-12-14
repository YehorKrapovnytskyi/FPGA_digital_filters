
file copy -force D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/nco15bit_nco_ii_0_sin.hex ./

vlog -v2k5 "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/aldec/asj_nco_mob_rw.v"   -work nco_ii_0
vlog -v2k5 "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/aldec/asj_nco_isdr.v"     -work nco_ii_0
vlog -v2k5 "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/aldec/asj_nco_apr_dxx.v"  -work nco_ii_0
vlog -v2k5 "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/aldec/asj_dxx_g.v"        -work nco_ii_0
vlog -v2k5 "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/aldec/asj_dxx.v"          -work nco_ii_0
vlog -v2k5 "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/aldec/asj_gal.v"          -work nco_ii_0
vlog -v2k5 "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/aldec/asj_nco_as_m_cen.v" -work nco_ii_0
vlog -v2k5 "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/aldec/asj_altqmcpipe.v"   -work nco_ii_0
vlog -v2k5 "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/nco15bit_nco_ii_0.v"      -work nco_ii_0
vlog -v2k5 "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/nco15bit.v"                                        
