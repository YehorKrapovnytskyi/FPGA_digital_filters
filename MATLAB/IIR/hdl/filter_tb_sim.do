onbreak resume
onerror resume
vsim -novopt work.filter_tb
add wave sim:/filter_tb/u_IIR_filter/i_clk
add wave sim:/filter_tb/u_IIR_filter/i_clk_enable
add wave sim:/filter_tb/u_IIR_filter/i_reset
add wave sim:/filter_tb/u_IIR_filter/i_filter_data
add wave sim:/filter_tb/u_IIR_filter/o_filter_data
add wave sim:/filter_tb/o_filter_data_ref
run -all
