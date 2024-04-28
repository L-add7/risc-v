module fetch2decode(
    input               clk,
    input               rst,
    input               stall_from_ld_2clk_i,
    input               stall_from_ld_1clk_i,
    input               flush,

    input        [31:0]   pc_i,

    output  reg  [31:0]   pc_o
);

    always @(posedge clk or posedge rst) begin
        if(rst)
            pc_o <= 32'd0;
        else if(stall_from_ld_2clk_i || stall_from_ld_1clk_i || flush)
            pc_o <= 32'd0;
        else
            pc_o <= pc_i;
    end
    
endmodule //fetch2decode
