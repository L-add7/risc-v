module S_bitsel(
    input       [1:0]      imm,
    input       [31:0]     data,
    input       [3:0]      dmemwe_i,
    output  reg [31:0]     dataout,
    output  reg [3:0]      dmemwe_o
);
    always @(*) begin
        case(dmemwe_i)
            4'b1111 : begin dataout = data; dmemwe_o=4'b1111;end
            4'b0011 : begin dataout = imm[1] ? {data[15:0],16'b0}:{16'b0,data[15:0]};
                            dmemwe_o = imm[1] ? 4'b1100 : 4'b0011;
            end
            4'b0001 : case (imm)
                        2'b00 : begin dataout = {24'b0,data[7:0]};        dmemwe_o = 4'b0001; end
                        2'b01 : begin dataout = {16'b0,data[7:0],8'b0};   dmemwe_o = 4'b0010; end
                        2'b10 : begin dataout = {8'b0,data[7:0],16'b0};   dmemwe_o = 4'b0100; end
                        2'b11 : begin dataout = {data[7:0],24'b0};        dmemwe_o = 4'b1000; end
                    endcase
            default : dataout = 32'b0;
        endcase

    end
    
endmodule //S_bitsel
