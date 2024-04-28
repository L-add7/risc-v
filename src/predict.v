module predict(
    input       [2:0]       bresult_sel,
    input                   BrEq,
    input                   BrLt,

    output  reg             predict_hit,
    output  reg             predict_miss
);

    always @(*) begin
        if(bresult_sel[0] == 1'b1) begin
            case (bresult_sel[2:1])
                2'b00 :   begin predict_hit = BrEq; predict_miss = !BrEq; end
                2'b01 :   begin predict_hit = !BrEq; predict_miss = BrEq; end
                2'b10 :   begin predict_hit = BrLt; predict_miss = !BrLt; end
                2'b11 :   begin predict_hit = !BrLt; predict_miss = BrLt; end
            endcase
        end else begin
            predict_hit = 1'b0; predict_miss = 1'b0;
        end

    end
    
endmodule //predict

