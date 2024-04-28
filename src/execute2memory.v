module execute2memory(
    input               clk,
    input               rst,

    input    [31:0]     aluout_i,
    input    [4:0]      wa_i,
    input               we_i,

    input               dmemen_i ,
    input     [3:0]     dmemwe_i,

    input               wdata_sel_i,
    input     [3:0]     LD_sel_i,
    input     [31:0]    data2_i,

    output  reg     [31:0]     aluout_o,
    output  reg     [4:0]      wa_o,
    output  reg                we_o,

    output  reg                dmemen_o ,
    output  reg      [3:0]     dmemwe_o,

    output  reg                wdata_sel_o,
    output  reg      [3:0]     LD_sel_o,
    output  reg      [31:0]    data2_o

);  

always @(posedge clk or posedge rst) begin
    if(rst) begin
        aluout_o  <= 'd0;
        wa_o<= 'd0;
        we_o<= 'd0;
        dmemen_o<= 'd0;
        dmemwe_o<= 'd0;
        wdata_sel_o<= 'd0;
        LD_sel_o<= 'd0;
        data2_o<= 'd0;
    end else begin
        aluout_o  <= aluout_i;
        wa_o<= wa_i;
        we_o<= we_i;
        dmemen_o<= dmemen_i;
        dmemwe_o<= dmemwe_i;
        wdata_sel_o<= wdata_sel_i;
        LD_sel_o<= LD_sel_i;
        data2_o<= data2_i;
    end
end
    
endmodule //moduleName
