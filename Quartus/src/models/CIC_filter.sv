module CIC_filter(i_clk, 
                  i_reset,
                  i_filter_en,
                  i_cic_data,
                  o_cic_data
                  );


    localparam INPUT_DATA_WIDTH = 12;
    localparam OUTPUT_DATA_WIDTH = 20;
    localparam DELAY_NUM = 16;
    //localparam FILTER_ORDER = 2;
    
    integer i;
    
    input                                               i_clk;
    input                                               i_reset;
    input                                               i_filter_en;
    input      signed     [INPUT_DATA_WIDTH - 1 : 0]    i_cic_data;
    output reg signed     [OUTPUT_DATA_WIDTH - 1 : 0]   o_cic_data;
    
    // intermediate variables declaration

    logic signed [INPUT_DATA_WIDTH - 1 : 0]   cic_data_ff;
    logic signed [OUTPUT_DATA_WIDTH - 1 : 0]  first_integrator;
    logic signed [OUTPUT_DATA_WIDTH - 1 : 0]  first_comb;
    logic signed [OUTPUT_DATA_WIDTH - 1 : 0]  second_integrator;
    logic signed [OUTPUT_DATA_WIDTH - 1 : 0]  second_comb;
    
    logic signed [OUTPUT_DATA_WIDTH - 1 : 0]  first_comb_mem  [DELAY_NUM - 1 : 0] ;
    logic signed [OUTPUT_DATA_WIDTH - 1 : 0]  second_comb_mem [DELAY_NUM - 1 : 0] ;
    
    //input stage
    
    always_ff @(posedge i_clk, negedge i_reset) begin
        if (~i_reset) cic_data_ff <= 0;
        else begin
            if (i_filter_en) cic_data_ff <= i_cic_data;
        end
    end
    
    
    //first integrator stage
    
    always_ff @(posedge i_clk, negedge i_reset) begin
        if (~i_reset) first_integrator <= 0;
        else begin
            if (i_filter_en) first_integrator <= first_integrator + cic_data_ff;
        end
    end
    
    //first comb stage
    
    always_ff @(posedge i_clk, negedge i_reset) begin
        for (i = 0; i < (DELAY_NUM); i = i + 1) begin
            if (!i_reset) first_comb_mem[i] <= 0;
            else begin
                if (i_filter_en) begin 
                    if (i == 0) begin
                        first_comb_mem[i] <= first_integrator;   
                    end else begin
                        first_comb_mem[i] <= first_comb_mem[i - 1];    
                    end
                end    
            end            
        end    
    end
    
    assign first_comb = first_integrator - first_comb_mem[DELAY_NUM - 1];
    
    //second integrator stage
    
    always_ff @(posedge i_clk, negedge i_reset) begin
        if (~i_reset) second_integrator <= 0;
        else begin
            if (i_filter_en) second_integrator <= second_integrator + first_comb;
        end
    end
    
    //first comb stage
    
    always_ff @(posedge i_clk, negedge i_reset) begin
        for (i = 0; i < (DELAY_NUM); i = i + 1) begin
            if (!i_reset) second_comb_mem[i] <= 0;
            else begin
                if (i_filter_en) begin 
                    if (i == 0) begin
                        second_comb_mem[i] <= second_integrator;   
                    end else begin
                        second_comb_mem[i] <= second_comb_mem[i - 1];    
                    end
                end    
            end            
        end    
    end
    
    assign second_comb = second_integrator - second_comb_mem[DELAY_NUM - 1];
    
    
    //output stage
    
    always_ff @(posedge i_clk, negedge i_reset) begin
        if (~i_reset) o_cic_data <= 0;
        else begin
            if (i_filter_en) o_cic_data <= second_comb;
        end
    end
                  
endmodule
