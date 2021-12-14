transcript on
if ![file isdirectory Digital_filters_iputf_libs] {
	file mkdir Digital_filters_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
vlib Digital_filters_iputf_libs/nco_ii_0
vmap nco_ii_0 ./Digital_filters_iputf_libs/nco_ii_0
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 

file copy -force D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/nco15bit_nco_ii_0_sin.hex ./

vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/mentor/asj_nco_mob_rw.v"   -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/mentor/asj_nco_isdr.v"     -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/mentor/asj_nco_apr_dxx.v"  -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/mentor/asj_dxx_g.v"        -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/mentor/asj_dxx.v"          -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/mentor/asj_gal.v"          -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/mentor/asj_nco_as_m_cen.v" -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/mentor/asj_altqmcpipe.v"   -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/submodules/nco15bit_nco_ii_0.v"       -work nco_ii_0
vlog "D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/nco15bit/simulation/nco15bit.v"                                         

vlog -sv -work work +incdir+D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/src/models {D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/src/models/CIC_filter.sv}

vlog -sv -work work +incdir+D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/src/models {D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/src/models/FIR_filter.sv}

vlog -sv -work work +incdir+D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/src/models {D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/src/models/IIR_filter.sv}

vlog -sv -work work +incdir+D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/src/testbenches {D:/Yehor/FPGA_Development/FPGA_digital_filters/Quartus/src/testbenches/tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -L nco_ii_0 -voptargs="+acc"  tb

add wave *
view structure
view signals
run 1000 us
