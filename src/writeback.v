module writeback(
    input      [4:0]                 wa_i,
    input                            we_i,
    input      [31:0]                wdata_i,
    input                            dmemen_i,
    input      [3:0]                 dmemwe_i,
    input      [3:0]                 LD_sel_i,
    input      [31:0]                dmemdata_i,

    output      [4:0]                wa_o,
    output                           we_o,
    output      [31:0]               wdata_o,
    output                           dmemen_o,
    output      [3:0]                dmemwe_o,
    output      [31:0]               dmemdata_o

);
    assign      wa_o = wa_i;
    assign      we_o = we_i;
    assign      wdata_o = wdata_i;
    assign      dmemen_o = LD_sel_i[0] ? 1'b0 :  dmemen_i;
    assign      dmemwe_o = dmemwe_i;
    assign      dmemdata_o = dmemdata_i;
endmodule //writeback
