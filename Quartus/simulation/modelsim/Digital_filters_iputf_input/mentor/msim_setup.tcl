
file copy -force D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/submodules/nco11bit_nco_ii_0_sin.hex ./

vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/submodules/mentor/asj_nco_mob_rw.v"   -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/submodules/mentor/asj_nco_isdr.v"     -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/submodules/mentor/asj_nco_apr_dxx.v"  -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/submodules/mentor/asj_dxx_g.v"        -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/submodules/mentor/asj_dxx.v"          -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/submodules/mentor/asj_gal.v"          -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/submodules/mentor/asj_nco_as_m_cen.v" -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/submodules/mentor/asj_altqmcpipe.v"   -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/submodules/nco11bit_nco_ii_0.v"       -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco11bit/simulation/nco11bit.v"                                         
