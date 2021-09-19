module direct_form_fir(
        input                                          i_clk,
        input                                          i_reset,
        input                                          i_filter_en,
        input      [INPUT_DATA_WIDTH - 1 : 0]  signed  i_fir_data,
        output reg [OUTPUT_DATA_WIDTH - 1 : 0] signed  o_fir_data);

    // Constants declaration

    localparam INPUT_INPUT_DATA_WIDTH = 16;
    localparam OUTPUT_DATA_WIDTH = 32;
    localparam FILTER_ORDER = 15;
    integer i;

    // intermediate variables declaration

    reg signed [OUTPUT_DATA_WIDTH - 1 : 0] accumulator_data;
    reg signed [INPUT_DATA_WIDTH - 1 : 0]  filter_taps         [FILTER_ORDER + 1];
    reg signed [OUTPUT_DATA_WIDTH - 1 : 0] multiplied_data     [FILTER_ORDER + 1];
    reg signed [INPUT_DATA_WIDTH - 1 : 0]  filter coefficients [FILTER_ORDER + 1];

    // Filter tapped delay line logic

    always @(posedge i_clk, negedge i_reset) begin
        for (i = 0; i < FILTER_ORDER + 1; i = i + 1) begin
            if (!i_reset) filter_taps <= 0;
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

    always @(posedge i_clk, negedge i_reset) begin 
        for (i = 0; i < FILTER_ORDER + 1; i = i + 1) begin
            if (!i_reset) multiplied_data[i] <= {INPUT_DATA_WIDTH{1'b0}};
            else begin  
                if (i_filter_en) multiplied_data[i] <= filter_taps[i] * filter coefficients[i];
            end    
        end    
    end

    // Accumulation and output phase

    always @(*) begin
        for (i = 0; i < FILTER_ORDER + 1 ; i = i + 1) begin 
            accumulator_data = accumulator_data + multiplied_data[i];
        end
    end

    always @(posedge i_clk, negedge i_reset) begin
        if (!i_reset) o_fir_data <= 0;
        else begin 
            if (i_filter_en) o_fir_data <= accumulator_data;
        end
    end        
                

endmodule


    




