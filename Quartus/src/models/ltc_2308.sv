module ltc_2308 (i_clk,
                i_reset,
                i_measure_ch,
                o_measure_done,
                o_measure_data,
                ADC_CONVST,
                ADC_SCK,
                ADC_SDI,
                ADC_SDO);
                
                
                
    
    
    // Timing and useful params definition with 40 MHz input clock -> 1/(40 * 10e6) = 25ns
    
    localparam CHANNEL_NUM      =    8;
    localparam DATA_BITS_NUM    =    12;
    localparam PROGRAM_BITS_NUM =    6;
    
    localparam tWHCONV          =    3;
    localparam tCONV            =    64;
    
    localparam tHCONVST           =  3;
    
    localparam tCONVST_HIGH_START =  0; 	
    localparam tCONVST_HIGH_END   =  tCONVST_HIGH_START+ tWHCONV; 

    localparam tCONFIG_START      =  tCONVST_HIGH_END;
    localparam tCONFIG_END        =  tCLK_START+ PROGRAM_BITS_NUM - 1; 	

    localparam tCLK_START         =  tCONVST_HIGH_START + tCONV;
    localparam tCLK_END           =  tCLK_START + DATA_BITS_NUM;

    localparam tDONE              =  tCLK_END + tHCONVST;

    localparam UNI_MODE           =  1'b1;  
    localparam SLP_MODE           =  1'b0;   
    localparam SD                 =  1'b1;
    
    //Input and output ports definition
    
    input logic                           i_clk; 
    input logic                           i_reset;
    input logic  [2 : 0]                  i_measure_ch;
    input logic                           ADC_SDO;
    
    
    output logic                          ADC_SCK;
    output logic                          ADC_CONVST = 0;
    output logic                          ADC_SDI;
    output logic [DATA_BITS_NUM - 1 : 0]  o_measure_data;
    output logic                          o_measure_done = 0;
    
    // Intermediate variables declaration
    
    logic                           clk_enable = 1'b0;

    logic  [15:0]                   tick;

    logic  [DATA_BITS_NUM-1:0]      read_data;
    
    logic  [3:0]                    write_pos;

    logic  [PROGRAM_BITS_NUM-1:0]   config_cmd; 
    
    logic                           config_init;   
    
    logic                           config_enable;  
    
    logic                           config_done;

    logic  [2:0]                    sdi_index;	
    
    
    
    assign config_cmd = {SD, i_measure_ch, UNI_MODE, SLP_MODE};
    
    assign config_init = (tick == tCONFIG_START);
    
    assign config_enable = (tick > tCLK_START && tick <= tCONFIG_END);
    
    assign config_done = (tick > tCONFIG_END);
    										  
    assign ADC_SCK = clk_enable & i_clk;
    
    
    //main counter definition 
    
    always @(posedge i_clk, negedge i_reset) begin
        if (~i_reset) tick <= 0;
        else if (tick < tDONE) tick <= tick + 1;
        else tick <= 0;
    end
    
    
    //ADC_CONVST logic definition
    
    always @(negedge i_clk, negedge i_reset) begin
        if (~i_reset) ADC_CONVST <= 0;
        else ADC_CONVST <= (tick >= tCONVST_HIGH_START && tick < tCONVST_HIGH_END);
    end
    
    //clk_enable logic definition
    
    always @(negedge i_clk, negedge i_reset) begin
        if (~i_reset) clk_enable <= 0;
        else if (tick >= tCLK_START && tick < tCLK_END) clk_enable <= 1;
        else clk_enable <= 0;
    end
    
    // read data sequence definition
    
    always @ (negedge i_clk, negedge i_reset) begin // posedge??
        if (~i_reset) begin
            read_data <= 0;
            write_pos <= DATA_BITS_NUM-1;
        end else if (tick == 2) begin
            read_data <= 0;
            write_pos <= DATA_BITS_NUM-1;
        end else if (clk_enable) begin
            read_data[write_pos] <= ADC_SDO;
            write_pos <= write_pos - 1;
        end
    end
    
    // output data latching 
    
    always @ (posedge i_clk, negedge i_reset) begin
        if (~i_reset) begin
            o_measure_done <= 1'b0;
            o_measure_data <= 0;
        end else if (tick == tDONE) begin
            o_measure_done <= 1'b1;
            o_measure_data <= read_data;
        end else
            o_measure_done <= 1'b0;
    end
    
    // SDI logic definition
    
    always @(negedge i_clk) begin
        if (config_init) begin
            ADC_SDI <= config_cmd[PROGRAM_BITS_NUM-1];
            sdi_index <= PROGRAM_BITS_NUM-2;
        end else if (config_enable) begin
            ADC_SDI <= config_cmd[sdi_index];
            sdi_index <= sdi_index - 1;
        end else if (config_done)
            ADC_SDI <= 1'b0;
    end
    
endmodule
    