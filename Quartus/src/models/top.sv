module top(FPGA_CLK1_50, SW, ADC_CONVST, ADC_SCK, ADC_SDI, ADC_SDO, ARDUINO_IO, o_data_fir, o_data_iir, o_data_cic);

    
    parameter  INPUT_DATA_WIDTH  = 16;
    parameter  OUTPUT_DATA_WIDTH = 28;
	parameter  CIC_DATA_WIDTH = 20;
    
	localparam PHASE_10KHz = 85899346;
	localparam PHASE_60KHz = 515396076;
    
    input  logic                                    FPGA_CLK1_50;
    input  logic  [3:0]                             SW;
    input  logic                                    ADC_SDO;
    
    output logic                                    ADC_CONVST;
    output logic                                    ADC_SCK;
    output                                          ADC_SDI; 
    output logic signed [OUTPUT_DATA_WIDTH - 1 : 0] o_data_fir, o_data_iir;
    output logic signed [CIC_DATA_WIDTH - 1 : 0]    o_data_cic;
    output logic signed [15 : 0]                    ARDUINO_IO;
      

    FIR_filter fir (
		.i_clk(FPGA_CLK1_50), 
		.i_reset(SW[0]),
    	.i_filter_en(1'b1),
    	.i_fir_data(ADC_SDO),
    	.o_fir_data(o_data_fir)
	 );
     
     CIC_filter cic (
		.i_clk(FPGA_CLK1_50), 
		.i_reset(SW[0]),
    	.i_filter_en(1'b1),
    	.i_cic_data(ADC_SDO),
    	.o_cic_data(o_data_cic)
	 );
     
     IIR_filter iir (
        .i_clk(FPGA_CLK1_50),
        .i_clk_enable(1'b1),
        .i_reset(SW[0]),
        .i_iir_data(ADC_SDO),
        .o_iir_data(o_data_iir)
     );
     
     
endmodule     