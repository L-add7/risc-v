`include "opcode.vh"
`include "control.vh"

module riscv(
    input                               clk,
    input                               rst
    // input                   [31:0]      inst,
    // output                  [31:0]      pc,

    // input                   [31:0]      data_from_dmem,
    // output                  [31:0]      addr_to_dmem,
    // output                  [31:0]      data_to_dmem,
    // output                  [3:0]       we_dmem,
    // output                              en_dmem,
);    
// fetch
    (* keep = "true" *)  wire        [31:0]          pc_branch_target;
    (* keep = "true" *)  wire                        stall_from_ldsw;
    (* keep = "true" *)  wire                        pc_jump;
    (* keep = "true" *)  wire        [31:0]          pc_d_logic,pc_d_reg;
    (* keep = "true" *)  wire        [31:0]          inst;
    (* keep = "true" *)  wire        [31:0]          pc;
//decode 

    (* keep = "true" *)  wire         [1:0]               sel_ra1_i;
    (* keep = "true" *)  wire         [1:0]               sel_ra2_i;

    (* keep = "true" *)  wire        [4:0]       ra1_d,ra2_d;
    (* keep = "true" *)  wire [31:0] pc_e_logic;
    (* keep = "true" *)  wire [31:0] reg1_i,reg2_i;
    (* keep = "true" *)  wire [4:0]  wa_d,wa_e_logic;
    (* keep = "true" *)  wire [31:0] data1_d,data2_d,imm_d,data1_e_logic,data2_e_logic,imm_e_logic;
    (* keep = "true" *)  wire [1:0]  aluBsel_d,aluBsel_e_logic;
    (* keep = "true" *)  wire        aluAsel_d,aluAsel_e_logic;
    (* keep = "true" *)  wire [1:0]  BrUn_d,BrUn_e_logic;
    (* keep = "true" *)  wire [3:0]  alu_sel_d,alu_sel_e_logic;
    (* keep = "true" *)  wire        dmemen_d,dmemen_e_logic;
    (* keep = "true" *)  wire [3:0]  dmemwe_d,dmemwe_e_logic;
    (* keep = "true" *)  wire        wdata_sel_d,wdata_sel_e_logic;
    (* keep = "true" *)  wire [3:0]  LD_sel_d,LD_sel_e_logic;
    (* keep = "true" *)  wire        pc_sel_out_d;
    (* keep = "true" *)  wire        we_d,we_e_logic;
    (* keep = "true" *)  wire        flush_d,flush_f;


    (* keep = "true" *)  wire    [31:0]      aluout_e_reg;
    (* keep = "true" *)  wire    [4:0]       wa_e_reg;
    (* keep = "true" *)  wire                we_e_reg;
    (* keep = "true" *)  wire                dmemen_e_reg;
    (* keep = "true" *)  wire    [3:0]       dmemwe_e_reg;
    (* keep = "true" *)  wire                wdata_sel_e_reg;
    (* keep = "true" *)  wire    [3:0]       LD_sel_e_reg;
    (* keep = "true" *)  wire    [31:0]      data2_e_reg;


    (* keep = "true" *)  wire    [31:0]      aluout_m_logic,wdata_m_reg,dmemdata_m_reg;
    (* keep = "true" *)  wire    [4:0]       wa_m_logic,wa_m_reg;
    (* keep = "true" *)  wire                we_m_logic,we_m_reg;
    (* keep = "true" *)  wire                dmemen_m_logic,dmemen_m_reg;
    (* keep = "true" *)  wire    [3:0]       dmemwe_m_logic,dmemwe_m_reg;
    (* keep = "true" *)  wire                wdata_sel_m_logic;
    (* keep = "true" *)  wire    [3:0]       LD_sel_m_logic,LD_sel_m_reg;
    (* keep = "true" *)  wire    [31:0]      data2_m_logic;

    (* keep = "true" *)  wire        [3:0]       dmemwe_w_logic,dmemwe_w_reg;
    (* keep = "true" *)  wire                    dmemen_w_logic,dmemen_w_reg;
    (* keep = "true" *)  wire        [4:0]       wa_w_logic,wa_w_reg;
    (* keep = "true" *)  wire                    we_w_logic,we_w_reg;
    (* keep = "true" *)  wire        [31:0]      wdata_w_logic,wdata_w_reg;
    (* keep = "true" *)  wire        [31:0]      dmemdata_w_logic,dmemdata_w_reg;
    (* keep = "true" *)  wire        [3:0]       LD_sel_w_logic;

    (* keep = "true" *)  wire   [13:0] dmemaddr = LD_sel_m_reg[0] ? aluout_m_logic[15:2] : wdata_w_reg[15:2];
    (* keep = "true" *)  wire          dmemen_in= LD_sel_m_reg[0] ? dmemen_m_reg : dmemen_w_reg;

    (* keep = "true" *)  wire        stall_from_ld_1clk;
    (* keep = "true" *)  wire        stall_from_ld_2clk;
    (* keep = "true" *)  wire        rstype_d;
    (* keep = "true" *)  wire    [2:0]   bresult_sel_d,bresult_sel_e_logic;
    (* keep = "true" *)  wire        predict_hit,predict_miss;

    (* keep = "true" *)  wire        [31:0]  dmemin;
    (* keep = "true" *)  wire        branchpredicted;


    (* keep_hierarchy="yes" *)pc_reg u_pc_reg(
        .clk             ( clk             ),
        .rst             ( rst             ),
        .pc_i_jump       ( pc_branch_target       ),
        .stall_from_ld_2clk_i ( stall_from_ld_2clk ),
        .stall_from_ld_1clk_i ( stall_from_ld_1clk ),
        .pc_not_jump     ( pc_e_logic ),
        .predict_miss    ( predict_miss ),
        .pc_jump         ( pc_jump         ),
        .pc_o            ( pc            )
    );


    (* keep_hierarchy="yes" *)fetch2decode u_fetch2decode(
        .clk  ( clk  ),
        .rst  ( rst  ),
        .stall_from_ld_2clk_i ( stall_from_ld_2clk ),
        .stall_from_ld_1clk_i ( stall_from_ld_1clk ),
        .flush( flush_f),
        .pc_i ( pc ),
        .pc_o  ( pc_d_logic  )
    );

    (* keep_hierarchy="yes" *)imem imem(
        .clk   ( clk   ),
        .ena   ( 1'b0   ),
        .wea   ( 4'b0   ),
        .addra (  ),
        .dina  (   ),
        .addrb ( pc[15:2] ),
        .doutb  ( inst  )
);


    (* keep_hierarchy="yes" *)reg_file rf(
        .clk ( clk ),
        .we  ( we_w_reg  ),
        .ra1 ( ra1_d ),
        .ra2 ( ra2_d ),
        .wa  ( wa_w_reg  ),
        .wd  ( wdata_w_reg  ),
        .rd1 ( reg1_i ),
        .rd2  ( reg2_i  )
);



    (* keep_hierarchy="yes" *)decode u_decode(
        .inst        ( inst        ),
        .pc_i        ( pc_d_logic        ),
        .pc_o        ( pc_d_reg        ),
        .reg1_i      ( reg1_i      ),
        .reg2_i      ( reg2_i      ),
        .wa_o        ( wa_d        ),
        .we_o        ( we_d        ),
        .ra1_o       ( ra1_d       ),
        .ra2_o       ( ra2_d       ),
        .sel_ra1_i   ( sel_ra1_i   ),
        .sel_ra2_i   ( sel_ra2_i   ),
        .data_ex_i   ( aluout_e_reg   ),
        .data_mem_i  ( wdata_m_reg   ),
        .data_wb_i   ( wdata_w_reg   ),
        .data1_o     ( data1_d     ),
        .data2_o     ( data2_d     ),
        .imm_o       ( imm_d       ),
        .aluBsel_o   ( aluBsel_d   ),
        .aluAsel_o   ( aluAsel_d   ),
        .BrUn_o      ( BrUn_d      ),
        .alu_sel_o   ( alu_sel_d   ),
        .dmemen_o    ( dmemen_d    ),
        .dmemwe_o    ( dmemwe_d    ),
        .wdata_sel_o ( wdata_sel_d ),
        .LD_sel_o    ( LD_sel_d    ),
        .pc_sel_out_o  ( pc_jump  ),
        .pc_branch_target(pc_branch_target),
        .rstype_o    ( rstype_d),
        .bresult_sel_o( bresult_sel_d),
        .branchpredicted(branchpredicted)
);

    (* keep_hierarchy="yes" *)decode2execute u_decode2execute(
        .clk          ( clk          ),
        .rst          ( rst          ),
        .pc_i         ( pc_d_reg        ),
        .pc_o         ( pc_e_logic         ),
        .data1_i      ( data1_d      ),
        .data2_i      ( data2_d      ),
        .imm_i        ( imm_d        ),
        .aluBsel_i    ( aluBsel_d    ),
        .aluAsel_i    ( aluAsel_d    ),
        .BrUn_i       ( BrUn_d       ),
        .alu_sel_i    ( alu_sel_d    ),
        .dmemen_i     ( dmemen_d     ),
        .dmemwe_i     ( dmemwe_d     ),
        .wdata_sel_i  ( wdata_sel_d  ),
        .LD_sel_i     ( LD_sel_d     ),
        .pc_sel_out_i (  ),
        .data1_o      ( data1_e_logic      ),
        .data2_o      ( data2_e_logic     ),
        .imm_o        ( imm_e_logic        ),
        .aluBsel_o    ( aluBsel_e_logic    ),
        .aluAsel_o    ( aluAsel_e_logic    ),
        .BrUn_o       ( BrUn_e_logic       ),
        .alu_sel_o    ( alu_sel_e_logic    ),
        .dmemen_o     ( dmemen_e_logic     ),
        .dmemwe_o     ( dmemwe_e_logic     ),
        .wdata_sel_o  ( wdata_sel_e_logic  ),
        .LD_sel_o     ( LD_sel_e_logic     ),
        .pc_sel_out_o  (   ),
        .wa_i(wa_d),
        .wa_o(wa_e_logic),
        .we_i(we_d),
        .we_o(we_e_logic),
        .bresult_sel_i( bresult_sel_d ),
        .bresult_sel_o( bresult_sel_e_logic),
        .flush      ( flush_d),
        .stall_from_ld_1clk_i(stall_from_ld_1clk),
        .stall_from_ld_2clk_i(stall_from_ld_2clk)
);



    (* keep_hierarchy="yes" *)execute u_execute(
        .pc_i        ( pc_e_logic        ),
        .data1_i     ( data1_e_logic     ),
        .data2_i     ( data2_e_logic     ),
        .imm_i       ( imm_e_logic       ),
        .wa_i        ( wa_e_logic        ),
        .we_i        ( we_e_logic        ),
        .aluAsel_i   ( aluAsel_e_logic   ),
        .aluBsel_i   ( aluBsel_e_logic   ),
        .alusel_i    ( alu_sel_e_logic    ),
        .BrUn        ( BrUn_e_logic        ),
        .aluout_o    ( aluout_e_reg    ),
        .wa_o        ( wa_e_reg        ),
        .we_o        ( we_e_reg        ),
        .dmemen_i    ( dmemen_e_logic    ),
        .dmemwe_i    ( dmemwe_e_logic    ),
        .dmemen_o    ( dmemen_e_reg    ),
        .dmemwe_o    ( dmemwe_e_reg    ),
        .wdata_sel_i ( wdata_sel_e_logic ),
        .wdata_sel_o ( wdata_sel_e_reg ),
        .LD_sel_i    ( LD_sel_e_logic    ),
        .LD_sel_o    ( LD_sel_e_reg    ),
        .data2_o     ( data2_e_reg     ),
        .bresult_sel_i(bresult_sel_e_logic),
        .predict_miss(predict_miss),
        .predict_hit (predict_hit)
);



    (* keep_hierarchy="yes" *)execute2memory u_execute2memory(
        .clk         ( clk         ),
        .rst         ( rst         ),
        .aluout_i    ( aluout_e_reg    ),
        .wa_i        ( wa_e_reg        ),
        .we_i        ( we_e_reg        ),
        .dmemen_i    ( dmemen_e_reg    ),
        .dmemwe_i    ( dmemwe_e_reg    ),
        .wdata_sel_i ( wdata_sel_e_reg ),
        .LD_sel_i    ( LD_sel_e_reg    ),
        .data2_i     ( data2_e_reg     ),
        .aluout_o    ( aluout_m_logic    ),
        .wa_o        ( wa_m_logic        ),
        .we_o        ( we_m_logic        ),
        .dmemen_o    ( dmemen_m_logic    ),
        .dmemwe_o    ( dmemwe_m_logic    ),
        .wdata_sel_o ( wdata_sel_m_logic ),
        .LD_sel_o    ( LD_sel_m_logic    ),
        .data2_o     ( data2_m_logic     )
    );



    (* keep_hierarchy="yes" *)memory u_memory(
        .wa_i        ( wa_m_logic        ),
        .we_i        ( we_m_logic        ),
        .aluout_i    ( aluout_m_logic    ),
        .dmemin_i    ( dmemin    ),
        .data2_i     ( data2_m_logic     ),
        .wdata_sel_i ( wdata_sel_m_logic ),
        .LD_sel_i    ( LD_sel_m_logic    ),
        .dmemwe_i    ( dmemwe_m_logic    ),
        .dmemen_i    ( dmemen_m_logic    ),
        .dmemwe_o    ( dmemwe_m_reg    ),
        .dmemen_o    ( dmemen_m_reg    ),
        .wa_o        ( wa_m_reg        ),
        .we_o        ( we_m_reg        ),
        .wdata_o     ( wdata_m_reg     ),
        .dmemdata_o  ( dmemdata_m_reg  ),
        .LD_sel_o    ( LD_sel_m_reg    )
);



    (* keep_hierarchy="yes" *)memory2writeback u_memory2writeback(
        .clk        ( clk        ),
        .rst        ( rst        ),
        .dmemwe_i   ( dmemwe_m_reg   ),
        .dmemen_i   ( dmemen_m_reg   ),
        .wa_i       ( wa_m_reg       ),
        .we_i       ( we_m_reg       ),
        .wdata_i    ( wdata_m_reg    ),
        .dmemdata_i ( dmemdata_m_reg ),
        .LD_sel_i   ( LD_sel_m_reg   ),
        .dmemwe_o   ( dmemwe_w_logic   ),
        .dmemen_o   ( dmemen_w_logic   ),
        .wa_o       ( wa_w_logic       ),
        .we_o       ( we_w_logic       ),
        .wdata_o    ( wdata_w_logic    ),
        .dmemdata_o ( dmemdata_w_logic ),
        .LD_sel_o   ( LD_sel_w_logic   )
);


    (* keep_hierarchy="yes" *)writeback u_writeback(
        .wa_i       ( wa_w_logic       ),
        .we_i       ( we_w_logic       ),
        .wdata_i    ( wdata_w_logic    ),
        .dmemen_i   ( dmemen_w_logic   ),
        .dmemwe_i   ( dmemwe_w_logic   ),
        .LD_sel_i   ( LD_sel_w_logic   ),
        .dmemdata_i ( dmemdata_w_logic ),
        .wa_o       ( wa_w_reg       ),
        .we_o       ( we_w_reg       ),
        .wdata_o    ( wdata_w_reg    ),
        .dmemen_o   ( dmemen_w_reg   ),
        .dmemwe_o   ( dmemwe_w_reg   ),
        .dmemdata_o  ( dmemdata_w_reg  )
);



    (* keep_hierarchy="yes" *)dmem dmem(
        .clk  ( clk  ),
        .en   ( dmemen_in   ),
        .we   ( dmemwe_w_reg   ),
        .addr ( dmemaddr ),
        .din  ( dmemdata_w_reg  ),
        .dout  ( dmemin  )
);


    (* keep_hierarchy="yes" *)HazardUnit u_HazardUnit(
        .clk(clk),
        .rst(rst),
        .ra1_decode_i ( ra1_d ),
        .ra2_decode_i ( ra2_d ),
        .wa_execute_i ( wa_e_reg ),
        .we_execute_i ( we_e_reg ),
        .wa_memory_i  ( wa_m_reg  ),
        .we_memory_i  ( we_m_reg  ),
        .wa_writeback_i(wa_w_reg ),
        .we_writeback_i(we_w_reg),
        .sel_ra1_o    ( sel_ra1_i    ),
        .sel_ra2_o    ( sel_ra2_i    ),

        .LD_sel_e     ( LD_sel_e_reg[0]),
        .LD_sel_m     ( LD_sel_m_reg[0]),
        .rstype_d         ( rstype_d        ),
        .stall_from_ld_1clk_o( stall_from_ld_1clk),
        .stall_from_ld_2clk_o( stall_from_ld_2clk),
        .predict_miss(predict_miss),
        .predict_hit(predict_hit),
        .flush_d_o(flush_d),
        .flush_f_o(flush_f),
        .branchpredicted(branchpredicted)
);





endmodule