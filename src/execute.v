module execute(
    input         [31:0]    pc_i,
    input         [31:0]    data1_i,
    input         [31:0]    data2_i,
    input         [31:0]    imm_i,

    input         [4:0]     wa_i,
    input                   we_i,

    input                   aluAsel_i,
    input         [1:0]     aluBsel_i,
    input         [3:0]     alusel_i,
    input         [1:0]     BrUn,
    input         [2:0]     bresult_sel_i,

    output        [31:0]    aluout_o,
    output        [4:0]     wa_o,
    output                  we_o,

    input                   dmemen_i,
    input         [3:0]     dmemwe_i,
    output                  dmemen_o,
    output        [3:0]     dmemwe_o,
    input                   wdata_sel_i,
    output                  wdata_sel_o,
    input         [3:0]     LD_sel_i,
    output        [3:0]     LD_sel_o,
    output        [31:0]     data2_o,
    output                  predict_miss,
    output                  predict_hit
);

    wire           [31:0]       alu_a;
    wire           [31:0]       alu_b;
    wire                        BrEq;
    wire                        BrLt;

    assign   wa_o = wa_i;
    assign   we_o = we_i;
    assign   dmemen_o = dmemen_i;
    assign   dmemwe_o = dmemwe_i;
    assign   wdata_sel_o = wdata_sel_i;
    assign   LD_sel_o = LD_sel_i;
    assign   data2_o  = data2_i;

    mux4 u_alubselect(
    .data_0 ( imm_i ),
    .data_1 ( data2_i ),
    .sel_i  ( aluBsel_i  ),
    .data_2 ( 32'd4    ),
    .data_3 ( 32'd4   ),
    .result_o  ( alu_b  )
);

    mux2 u_aluaselect(
    .data_0 ( data1_i ),
    .data_1 ( pc_i ),
    .sel_i  ( aluAsel_i  ),
    .result_o  ( alu_a  )
);

    alu u_alu(
    .alu_sel ( alusel_i ),
    .data1   ( alu_a   ),
    .data2   ( alu_b   ),
    .data_output  ( aluout_o  )
);

    

    BranchComp u_BranchComp(
    .data1 ( data1_i ),
    .data2 ( data2_i ),
    .BrUn  ( BrUn  ),
    .BrEq  ( BrEq  ),
    .BrLt  ( BrLt  )
);

    predict u_predict(
    .bresult_sel ( bresult_sel_i ),
    .BrEq        ( BrEq        ),
    .BrLt        ( BrLt        ),
    .predict_hit ( predict_hit ),
    .predict_miss  ( predict_miss  )
);




endmodule