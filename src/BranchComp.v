// use for compare
module BranchComp(
    input       [31:0]      data1,
    input       [31:0]      data2,

    input       [1:0]       BrUn,           // branch instruction is unsigned 1 and signed 0

    output  reg             BrEq,           // branch equal
    output  reg             BrLt            // branch less than 
);

    always @(*) begin
        if(BrUn[0]) begin
            if(BrUn == 1'b1) begin
                BrEq = (data1 == data2) ? 1'b1 : 1'b0;
                BrLt = (data1 < data2)  ? 1'b1 : 1'b0;
            end
            else if(BrUn == 1'b0) begin
                BrEq = (data1 == data2) ? 1'b1 : 1'b0;
                if(data1[31]==1&&data2[31]==0)
                    BrLt=1;
                else if(data1[31]==0&&data2[31]==1)
                    BrLt=0;
                else if(data1[31]==1&&data2[31]==1)
                    BrLt = (data1>data2) ? 1 : 0;
                else
                    BrLt = (data1<data2) ? 1 : 0 ;
            end
        end
        else if(BrUn[0] == 1'b0)begin
            BrEq = 1'b0;
            BrLt = 1'b0;
        end
    end

endmodule
