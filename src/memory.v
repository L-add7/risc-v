module memory(
    input        [4:0]  wa_i,
    input               we_i,
    input        [31:0] aluout_i,
    input        [31:0] dmemin_i,
    input        [31:0] data2_i,
    input               wdata_sel_i,       

    input        [3:0]  LD_sel_i,
    input        [3:0]  dmemwe_i,
    input               dmemen_i,

    output       [3:0]  dmemwe_o,
    output              dmemen_o,

    output       [4:0]  wa_o,
    output              we_o,
    output       [31:0] wdata_o,
    output       [31:0] dmemdata_o,
    output       [3:0]  LD_sel_o        
);



    wire         [31:0] dmemsel;

    assign       dmemen_o = dmemen_i;
    assign       wa_o     = wa_i;
    assign       we_o     = we_i;
    assign       LD_sel_o = LD_sel_i;

    LD_bitsel uLD_bitsel(
        .LD_sel(LD_sel_i),
        .dmemin(dmemin_i),
        .imm_sel(aluout_i[1:0]),
        .dmemsel(dmemsel)
    );

    mux2 u_wdataselect(
    .data_0 ( aluout_i ),
    .data_1 ( dmemsel ),
    .sel_i  ( wdata_sel_i  ),
    .result_o  ( wdata_o  )
);

    S_bitsel u_S_bitsel(
    .imm  ( aluout_i[1:0]  ),
    .data ( data2_i ),
    .dmemwe_i(dmemwe_i),
    .dataout  ( dmemdata_o  ),
    .dmemwe_o(dmemwe_o)
);


endmodule