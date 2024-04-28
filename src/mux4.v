module mux4(
    input    [31:0]         data_0,
    input    [31:0]         data_1,
    input    [31:0]         data_2,
    input    [31:0]         data_3,
    input    [1:0]          sel_i,

    output  reg  [31:0]          result_o
);
    
    always @(*) begin
        case(sel_i)
            2'b00 : result_o = data_0;
            2'b01 : result_o = data_1;
            2'b10 : result_o = data_2;
            2'b11 : result_o = data_3;
        endcase 
    end
endmodule //mux4

