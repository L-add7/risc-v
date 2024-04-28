module pc_reg(
    input                   clk,
    input                   rst,

    input       [31:0]      pc_i_jump,
    input                   stall_from_ld_2clk_i,
    input                   stall_from_ld_1clk_i,
    input                   pc_jump,
    input                   predict_miss,
    input       [31:0]      pc_not_jump,

    output reg  [31:0]      pc_o

);
    reg     stall_from_ld_2clk_d;
    always @(posedge clk) begin
        stall_from_ld_2clk_d <= stall_from_ld_2clk_i;
    end
    always @(posedge clk or posedge rst) begin
        if(rst)
            pc_o <= 32'h0;
        else if(pc_jump)
            pc_o <= pc_i_jump;
        else if(predict_miss)
            pc_o <= pc_not_jump + 4;
        else if(stall_from_ld_2clk_i)
            pc_o <= pc_o - 4 ;
        else if(stall_from_ld_1clk_i && (stall_from_ld_2clk_d == 1'b0))
            pc_o <= pc_o - 4 ;
        else 
            pc_o <= pc_o + 4;
    end
    
endmodule //pc_reg

