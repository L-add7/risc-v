module decode(
    input       [31:0]      inst,      

    input       [31:0]      pc_i,
    output      [31:0]      pc_o,

    //from reg 
    input       [31:0]      reg1_i,
    input       [31:0]      reg2_i,

    //to reg
    output      [4:0]       wa_o,
    output                  we_o,
    output      [4:0]       ra1_o,
    output      [4:0]       ra2_o,           

    //forward logic 
    input       [1:0]       sel_ra1_i,
    input       [1:0]       sel_ra2_i,
    input       [31:0]      data_ex_i,
    input       [31:0]      data_wb_i,
    input       [31:0]      data_mem_i,


    output      [31:0]      data1_o,         // rs1
    output      [31:0]      data2_o,         // rs2 or immediate
    output      [31:0]      imm_o,
    output      [1:0]       aluBsel_o,
    output                  aluAsel_o,
    output      [1:0]       BrUn_o,
    output      [3:0]       alu_sel_o,

    // load and store for dmem
    output                  dmemen_o,       // cs
    output      [3:0]       dmemwe_o,       // write enable    
    output                  wdata_sel_o,
    output      [3:0]       LD_sel_o,
    output                  pc_sel_out_o,
    output      [31:0]      pc_branch_target,
    output      [2:0]       bresult_sel_o,
    output                  rstype_o,

    input                   branchpredicted           
);
    wire    [31:0]  imm;
    assign imm_o = imm;
    assign   wa_o = inst[11:7];
    assign   ra1_o = inst[19:15];
    assign   ra2_o = inst[24:20];

    assign pc_o = pc_i;
    assign pc_branch_target = (inst[3:2]==2'b01) ?  reg1_i + imm : pc_i + imm ;

    crtl u_crtl(
    .inst      ( inst      ),
    .branchpredicted(branchpredicted),
    .we        ( we_o        ),
    .aluBsel   ( aluBsel_o   ),
    .alu_sel   ( alu_sel_o   ),
    .BrUn      ( BrUn_o      ),
    .LD_sel    ( LD_sel_o    ),
    .dmemen    ( dmemen_o    ),
    .dmemwe    ( dmemwe_o    ),
    .wdata_sel ( wdata_sel_o ),
    .aluAsel   ( aluAsel_o   ),
    .pc_sel    ( pc_sel_out_o    ),
    .bresult_sel( bresult_sel_o ),
    .rstype     ( rstype_o  )
);

    Imm_gen u_Imm_gen(
    .inst ( inst ),
    .imm  ( imm  )
);

    mux4 u_data1_sel(
    .data_0 ( reg1_i ),
    .data_1 ( data_ex_i ),
    .data_2 ( data_mem_i ),
    .data_3 ( data_wb_i     ),
    .sel_i  ( sel_ra1_i  ),
    .result_o  ( data1_o  )
    );

    mux4 u_data2_Sel(
    .data_0 ( reg2_i ),
    .data_1 ( data_ex_i ),
    .data_2 ( data_mem_i ),
    .data_3 ( data_wb_i ),
    .sel_i  ( sel_ra2_i  ),
    .result_o  ( data2_o  )
    );





    
endmodule //decode
