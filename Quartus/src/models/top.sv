module top(FPGA_CLK1_50, SW, 
           ADC_CONVST,
           ADC_SCK,
           ADC_SDI,
           ADC_SDO,
           LED;
           o_data_fir,
           o_data_iir,
           o_data_cic);

    
    parameter  INPUT_DATA_WIDTH  = 12;
    parameter  OUTPUT_DATA_WIDTH = 28;
	parameter  CIC_DATA_WIDTH = 20;
    
    // input and output ports declaration
    
    
    input  logic                                    FPGA_CLK1_50;
    input  logic        [3:0]                       SW;
    input  logic                                    ADC_SDO;
    
    output logic                                    ADC_CONVST;
    output logic                                    ADC_SCK;
    output logic                                    ADC_SDI; 
    output logic signed [OUTPUT_DATA_WIDTH - 1 : 0] o_data_fir, o_data_iir;
    output logic signed [CIC_DATA_WIDTH - 1 : 0]    o_data_cic;
    output logic        [7:0]                       LED;
    
    // intermediate variables declaration
    
    logic                                       reset_n; 
    logic                                       sys_clk;   
    logic                                       filter_enable       = 1'b0;
    
    logic                                       fifo_full;
    logic                                       fifo_empty;
    logic                                       fifo_write_req;
    logic                                       fifo_read_ack       = 1'b0;
    
    logic           [INPUT_DATA_WIDTH - 1 : 0]  fifo_in_data;
    logic           [INPUT_DATA_WIDTH - 1 : 0]  fifo_out_data;
    
    logic                                       adc_data_valid      = 1'b0;
    logic signed    [11:0]                      adc_data;
    logic                                       adc_measure_done;
    logic                                       adc_measure_done_ff = 1'b0;
    
    logic           [6:0]                       tick_cnt            = 8'd0;
    
    
    
    
    
    assign reset_n = SW[0];
    
    assign sys_clk = FPGA_CLK1_50;
    
    assign fifo_write_req = adc_measure_done & ~adc_measure_done_ff & ~fifo_full;
    
    
    
    
    // modules instantiation
    
    pll sys_pll (
		.refclk(sys_clk),                //  refclk.clk
		.rst(~reset_n),                  //  reset.reset
		.outclk_0(adc_clk),              //  outclk0.clk
		.locked(LED[0])                  //  locked.export
	);
    
    
    ltc_2308 ltc_2308_ADC (
        .i_clk(adc_clk),
        .i_reset(reset_n),
        .i_measure_ch(1'b0),
        .o_measure_done(adc_measure_done),
        .o_measure_data(fifo_in_data),
        .ADC_CONVST(ADC_CONVST),
        .ADC_SCK(ADC_SCK),
        .ADC_SDI(ADC_SDI),
        .ADC_SDO(ADC_SDO)
    );
    
    fifo ADC_fifo (
        .aclr(~reset_n),
        .data(fifo_in_data),
        .rdclk(sys_clk),
        .rdreq(fifo_read_ack),
        .wrclk(adc_clk),
        .wrreq(fifo_write_req),
        .q(fifo_out_data),
        .rdempty(fifo_empty),
        .wrfull(fifo_full)
    );

    FIR_filter fir (
		.i_clk(FPGA_CLK1_50), 
		.i_reset(reset_n),
    	.i_filter_en(filter_enable),
    	.i_fir_data(adc_data),
    	.o_fir_data(o_data_fir)
	 );
     
     
     CIC_filter cic (
		.i_clk(FPGA_CLK1_50), 
		.i_reset(reset_n),
    	.i_filter_en(filter_enable),
    	.i_cic_data(adc_data),
    	.o_cic_data(o_data_cic)
	 );
     
     
     IIR_filter iir (
        .i_clk(FPGA_CLK1_50),
        .i_clk_enable(filter_enable),
        .i_reset(reset_n),
        .i_iir_data(adc_data),
        .o_iir_data(o_data_iir)
     );
     
     //////////////////////////
     
     always @(posedge adc_clk, negedge reset_n) begin
        if (~reset_n) adc_measure_done_ff <= 1'b0;
        else adc_measure_done_ff <= adc_measure_done;
     end
     
     
     
     always @(posedge sys_clk, negedge sys_rst_n) begin 
        if (~sys_rst_n) begin
            tick_cnt       <= 8'd0;
            fifo_read_ack  <= 1'b0;
            adc_data       <= 12'd0;
            adc_data_valid <= 1'b0;
            filter_enable  <= 1'b0; 
        end else begin
            tick_cnt       <= tick_cnt + 1'b1;
            fifo_read_ack  <= 1'b0;
            adc_data_valid <= 1'b0;
            if (7'd99 == tick_cnt) begin
                tick_cnt       <= 7'd0;
                adc_data_valid <= ~fifo_empty;
                fifo_read_ack  <= ~fifo_empty;
                filter_enable  <= ~fifo_empty; 
                adc_data       <= fifo_out_data - 12'd2048;
            end       
        end 
     end
       
     
     
endmodule     