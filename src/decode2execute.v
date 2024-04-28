module decode2execute(
    input                       clk,
    input                       rst,

    input                   stall_from_ld_2clk_i,
    input                   stall_from_ld_1clk_i,
    input                   flush,

    input           [31:0]      pc_i,
    output   reg    [31:0]      pc_o,

    input           [31:0]      data1_i,
    input           [31:0]      data2_i,
    input           [31:0]      imm_i,
    input           [1:0]       aluBsel_i,
    input                       aluAsel_i,
    input                       BrUn_i,
    input           [3:0]       alu_sel_i,

    input                       dmemen_i,       // cs
    input      [3:0]            dmemwe_i,       // write enable    
    input                       wdata_sel_i,
    input      [3:0]            LD_sel_i,
    input                       pc_sel_out_i,
    input       [4:0]           wa_i,
    input                       we_i,

    input         [2:0]         bresult_sel_i,
    output  reg   [2:0]         bresult_sel_o,

    output  reg   [4:0]         wa_o,
    output  reg                 we_o,

    output  reg           [31:0]      data1_o,
    output  reg           [31:0]      data2_o,
    output  reg           [31:0]      imm_o,
    output  reg           [1:0]       aluBsel_o,
    output  reg                       aluAsel_o,
    output  reg                       BrUn_o,
    output  reg           [3:0]       alu_sel_o,
    output  reg                       dmemen_o,       // cs
    output  reg      [3:0]            dmemwe_o,       // write enable    
    output  reg                       wdata_sel_o,
    output  reg      [3:0]            LD_sel_o,
    output  reg                       pc_sel_out_o
);

    always @(posedge clk or posedge rst ) begin
        if(rst) begin
            pc_o       <=  32'd0;
            data1_o    <=  32'd0;
            data2_o    <=  32'd0;
            imm_o      <=  32'd0;
            aluBsel_o  <=  2'd0;
            aluAsel_o  <=  'd0;
            BrUn_o     <=  'd0;
            alu_sel_o  <=  'd0;
            dmemen_o   <=  'd0;   
            dmemwe_o   <=  'd0;    
            wdata_sel_o<=  'd0;
            LD_sel_o   <=  'd0;
            pc_sel_out_o<=  'd0;
            wa_o <= 'd0;
            we_o <= 'd0;
            bresult_sel_o <= 'd0;
        end else if(stall_from_ld_2clk_i || stall_from_ld_1clk_i || flush) begin
            pc_o       <=  32'd0;
            data1_o    <=  32'd0;
            data2_o    <=  32'd0;
            imm_o      <=  32'd0;
            aluBsel_o  <=  2'd0;
            aluAsel_o  <=  'd0;
            BrUn_o     <=  'd0;
            alu_sel_o  <=  'd0;
            dmemen_o   <=  'd0;   
            dmemwe_o   <=  'd0;    
            wdata_sel_o<=  'd0;
            LD_sel_o   <=  'd0;
            pc_sel_out_o<=  'd0;
            wa_o <= 'd0;
            we_o <= 'd0;
            bresult_sel_o <= 'd0;
        end else begin
            pc_o       <=  pc_i;
            data1_o    <=  data1_i;
            data2_o    <=  data2_i;
            imm_o      <=  imm_i;
            aluBsel_o  <=  aluBsel_i;
            aluAsel_o  <=  aluAsel_i;
            BrUn_o     <=  BrUn_i;
            alu_sel_o  <=  alu_sel_i;
            dmemen_o   <=  dmemen_i;   
            dmemwe_o   <=  dmemwe_i;    
            wdata_sel_o<=  wdata_sel_i;
            LD_sel_o   <=  LD_sel_i;
            pc_sel_out_o<= pc_sel_out_i;
            wa_o <= wa_i;
            we_o <= we_i;
            bresult_sel_o <= bresult_sel_i;
        end
    end
    
endmodule //decode2execute
