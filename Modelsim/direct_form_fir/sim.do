transcript on
# Delete old compilation results
if { [file exists "work"] } {
    vdel -all
}

# Create new modelsim working library
vlib work

# Compile all the Verilog sources in current folder into working library
vlog  COMPLEX_ALU.v ALU.v MU.v testbench.v

# Open testbench module for simulation
vsim -t 1ns -voptargs="+acc" testbench

# Add all testbench signals to waveform diagram
add wave /testbench/i_clk
add wave /testbench/i_rst
add wave -radix unsigned /testbench/i_data_0
add wave -radix unsigned /testbench/i_data_1
add wave -radix unsigned /testbench/i_data_2
add wave -radix unsigned /testbench/i_data_3
add wave -radix unsigned /testbench/i_operation
add wave -radix unsigned /testbench/is_complex
add wave -radix signed /testbench/out_0
add wave -radix signed /testbench/out_1

add wave -radix signed /testbench/ALU1/o_ALU_out_0
add wave -radix signed /testbench/ALU1/o_ALU_out_1
add wave -radix signed /testbench/ALU1/o_Re
add wave -radix signed /testbench/ALU1/o_Im

onbreak resume


# Run simulation
configure wave -timelineunits ns
run -all
wave zoom full
