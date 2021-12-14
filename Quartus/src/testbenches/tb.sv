`timescale 1us / 1ps
module tb;

    parameter       INPUT_DATA_WIDTH  = 16;
    parameter       OUTPUT_DATA_WIDTH = 32;
	parameter       CIC_DATA_WIDTH = 24;
    
	localparam PHASE_10KHz = 85899346;
	localparam PHASE_60KHz = 515396076;

	logic signed [INPUT_DATA_WIDTH - 2 : 0]  sine_10KHz, sine_60KHz;
	logic signed [INPUT_DATA_WIDTH - 1 : 0]  sine_adder;
    logic signed [OUTPUT_DATA_WIDTH - 1 : 0] o_data_fir , o_data_iir;   
    logic signed [CIC_DATA_WIDTH - 1 : 0]    o_data_cic; 
    logic i_clk, i_reset;
	
	nco15bit nco_10kHz(
		.clk(i_clk),      			// clk.clk
		.clken(1'b1),     			//  in.clken
		.phi_inc_i(PHASE_10KHz),    //    .phi_inc_i
		.fsin_o(sine_10KHz),			// out.fsin_o
		.out_valid(), 					//    .out_valid
		.reset_n(i_reset)    		// rst.reset_n
	);
	
	nco15bit nco_60kHz(
		.clk(i_clk),      			// clk.clk
		.clken(1'b1),     			//  in.clken
		.phi_inc_i(PHASE_60KHz),  //    .phi_inc_i
		.fsin_o(sine_60KHz),      // out.fsin_o
		.out_valid(), 					//    .out_valid
		.reset_n(i_reset)    	   // rst.reset_n
	);
	
	
	assign sine_adder = sine_10KHz + sine_60KHz;
	


    FIR_filter fir (
		.i_clk(i_clk), 
		.i_reset(i_reset),
    	.i_filter_en(1'b1),
    	.i_fir_data(sine_adder),
    	.o_fir_data(o_data_fir)
	 );
     
     CIC_filter cic (
		.i_clk(i_clk), 
		.i_reset(i_reset),
    	.i_filter_en(1'b1),
    	.i_cic_data(sine_adder),
    	.o_cic_data(o_data_cic)
	 );
     
     IIR_filter iir (
        .i_clk(i_clk),
        .i_clk_enable(1'b1),
        .i_reset(i_reset),
        .i_filter_data(sine_adder),
        .o_filter_data(o_data_iir)
     );
     

    initial begin
		i_clk = 0;
        forever #1 i_clk = ~i_clk;
	    $finish;
    end
	 
    initial begin
        i_reset = 1'b0;
        #10;
        i_reset = 1'b1;
    end

endmodule
