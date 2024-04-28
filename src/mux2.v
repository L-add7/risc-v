module mux2(
    input    [31:0]         data_0,
    input    [31:0]         data_1,

    input                   sel_i,

    output  reg  [31:0]          result_o
);
    
    always @(*) begin
        case(sel_i)
            1'b0 : result_o = data_0;
            1'b1 : result_o = data_1;
        endcase 
    end
endmodule //mux2

