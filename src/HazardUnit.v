module HazardUnit(
    input         [4:0]     ra1_decode_i,
    input         [4:0]     ra2_decode_i,
                   
    input         [4:0]     wa_execute_i,
    input                   we_execute_i,
    input         [4:0]     wa_memory_i,
    input                   we_memory_i,
    input         [4:0]     wa_writeback_i,
    input                   we_writeback_i,

    input                   LD_sel_e,
    input                   LD_sel_m,
    input                   rstype_d,

    input                   predict_hit,
    input                   predict_miss,
    output  reg   [1:0]     sel_ra1_o,
    output  reg   [1:0]     sel_ra2_o,

    output                  flush_d_o,
    output                  flush_f_o,
    output                  stall_from_ld_2clk_o,
    output                  stall_from_ld_1clk_o             
);

    always @(*) begin
        if((ra1_decode_i == wa_execute_i) && (we_execute_i == 1'b1 ))
            sel_ra1_o = 2'b01;
        else if((ra1_decode_i == wa_memory_i) && (we_memory_i == 1'b1))
            sel_ra1_o = 2'b10;
        else if((ra1_decode_i == wa_writeback_i) && (we_writeback_i == 1'b1))
            sel_ra1_o = 2'b11;
        else
            sel_ra1_o = 2'b00;
    end

    always @(*) begin
        if((ra2_decode_i == wa_execute_i) && (we_execute_i == 1'b1))
            sel_ra2_o = 2'b01;
        else if((ra2_decode_i == wa_memory_i) && (we_memory_i == 1'b1))
            sel_ra2_o = 2'b10;
        else if((ra2_decode_i == wa_writeback_i) && (we_writeback_i == 1'b1))
            sel_ra2_o = 2'b11;
        else
            sel_ra2_o = 2'b00;
    end
    
    //load use hazard
    assign stall_from_ld_2clk_o = rstype_d && LD_sel_e && ( (ra1_decode_i == wa_execute_i) || (ra2_decode_i == wa_execute_i));
    assign stall_from_ld_1clk_o = rstype_d && LD_sel_m && ( (ra1_decode_i == wa_memory_i) || (ra2_decode_i == wa_memory_i));

    assign flush_d_o = predict_hit;
    assign flush_f_o = predict_miss;

endmodule //HazardUnit

