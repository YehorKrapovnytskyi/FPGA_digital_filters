module nco(i_clk, i_reset, i_phase, o_nco_sin);

    parameter WIDTH = 32;

    input               i_clk; 
    input               i_reset;
    input [WIDTH - 1:0] i_phase;
    output reg [7:0]    sin;
    output     [7:0]    acc;

    reg [7:0] rom [255:0];
    reg [WIDTH - 1:0] acc32;

    initial $readmemh("mem.txt", rom);


    always @(posedge i_clk, negedge i_reset)
    begin
        if (~i_reset) acc32 <= 0;      
        else acc32 <= acc32 + i_phase;
    end

    assign acc = acc32[WIDTH-1:WIDTH-8];

    always @(posedge i_clk) sin <= rom[acc];

endmodule
