module FIR_filter     (i_clk, 
                       i_reset,
                       i_filter_en,
                       i_fir_data,
                       o_fir_data
                       );
                       
    // Constants declaration

    localparam INPUT_DATA_WIDTH =   12;
    localparam OUTPUT_DATA_WIDTH =  28;
    localparam COEFFICIENTS_WIDTH = 16;
    localparam FILTER_ORDER =       15;

    integer i;
    
    //Input and Output ports declaration
        
    input                                               i_clk;
    input                                               i_reset;
    input                                               i_filter_en;
    input      signed     [INPUT_DATA_WIDTH - 1 : 0]    i_fir_data;
    output reg signed     [OUTPUT_DATA_WIDTH - 1 : 0]   o_fir_data;

    // intermediate variables declaration

    reg signed [OUTPUT_DATA_WIDTH - 1 : 0]   accumulator_data;
    reg signed [INPUT_DATA_WIDTH - 1 : 0]    filter_taps         [FILTER_ORDER + 1];
    reg signed [OUTPUT_DATA_WIDTH - 1 : 0]   multiplied_data     [FILTER_ORDER + 1];
    reg signed [COEFFICIENTS_WIDTH - 1 : 0]  filter_coefficients [FILTER_ORDER + 1];
    
    initial $readmemh("coefficients.txt", filter_coefficients);

    // Filter tapped delay line logic

    always_ff @(posedge i_clk, negedge i_reset) begin
        for (i = 0; i < (FILTER_ORDER + 1); i = i + 1) begin
            if (!i_reset) filter_taps[i] <= 0;
            else begin
                if (i_filter_en) begin 
                    if (i == 0) begin
                        filter_taps[i] <= i_fir_data;   
                    end else begin
                        filter_taps[i] <= filter_taps[i - 1];    
                    end
                end    
            end            
        end    
    end

    // Filter multiplied_data logic

    always_ff @(posedge i_clk, negedge i_reset) begin 
        for (i = 0; i < FILTER_ORDER + 1; i = i + 1) begin
            if (!i_reset) multiplied_data[i] <= {INPUT_DATA_WIDTH{1'b0}};
            else begin  
                if (i_filter_en) multiplied_data[i] <= filter_taps[i] * filter_coefficients[i];
            end    
        end    
    end

    // Accumulation and output phase

    always_ff @(posedge i_clk, negedge i_reset) begin
        if (!i_reset) o_fir_data <= 0;
        else begin 
            if (i_filter_en) o_fir_data <= multiplied_data[0] + multiplied_data[1] + 
                multiplied_data[2] + multiplied_data[3] + multiplied_data[4] + multiplied_data[5] +
                multiplied_data[6] + multiplied_data[7] + multiplied_data[8] + multiplied_data[9] +
                multiplied_data[10] + multiplied_data[11] + multiplied_data[12] + multiplied_data[13]
                + multiplied_data[14] + multiplied_data[15];
        end
    end                    
	 
endmodule
