module LD_bitsel(
    input               [3:0]    LD_sel,
    input               [31:0]   dmemin,
    input               [1:0]    imm_sel,
    output  reg         [31:0]   dmemsel
);

    always @(*) begin
        case (LD_sel)
            4'b0000 : dmemsel = 32'b0;
            4'b0001 :   case (imm_sel)
                            2'b00 : dmemsel = {{24{dmemin[7]}},dmemin[7:0]};
                            2'b01 : dmemsel = {{24{dmemin[15]}},dmemin[15:8]};
                            2'b10 : dmemsel = {{24{dmemin[23]}},dmemin[23:16]};
                            2'b11 : dmemsel = {{24{dmemin[31]}},dmemin[31:24]};
                        endcase
            4'b0011 : dmemsel = (imm_sel == 2'd2) ? {{16{dmemin[31]}},dmemin[31:16]} :{{16{dmemin[15]}},dmemin[15:0]};
            4'b0111 : dmemsel = (imm_sel == 2'd2) ? {16'b0,dmemin[31:16]} :{16'b0,dmemin[15:0]};
            4'b0101 : case (imm_sel)
                            2'b00 : dmemsel = {24'b0,dmemin[7:0]};
                            2'b01 : dmemsel = {24'b0,dmemin[15:8]};
                            2'b10 : dmemsel = {24'b0,dmemin[23:16]};
                            2'b11 : dmemsel = {24'b0,dmemin[31:24]};
                        endcase
            4'b1111 : dmemsel = dmemin;
            default:  dmemsel = 32'b0;
        endcase
    end
    
endmodule //LD_bitsel

