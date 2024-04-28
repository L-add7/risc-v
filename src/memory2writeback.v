module memory2writeback(
    input                           clk,
    input                           rst,

    input               [3:0]       dmemwe_i,
    input                           dmemen_i,
    input                [4:0]      wa_i,
    input                           we_i,
    input                [31:0]     wdata_i,
    input                [31:0]     dmemdata_i,
    input                [3:0]      LD_sel_i   ,

    output  reg         [3:0]       dmemwe_o,
    output  reg                     dmemen_o,
    output  reg          [4:0]      wa_o,
    output  reg                     we_o,
    output  reg          [31:0]     wdata_o,
    output  reg          [31:0]     dmemdata_o,
    output  reg          [3:0]      LD_sel_o        
);

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            dmemwe_o <= 'd0;
            dmemen_o <= 'd0;
            wa_o <= 'd0; 
            we_o <= 'd0;
            wdata_o <= 'd0;
            dmemdata_o <= 'd0;
            LD_sel_o     <= 'd0;
        end else begin
            dmemwe_o <= dmemwe_i;
            dmemen_o <= dmemen_i;
            wa_o <= wa_i; 
            we_o <= we_i;
            wdata_o <= wdata_i;
            dmemdata_o <= dmemdata_i;
            LD_sel_o     <= LD_sel_i;
        end
    end
    
endmodule //memory2writeback

