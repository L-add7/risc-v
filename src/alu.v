`include "control.vh"

module alu(
    input           [3:0]       alu_sel,

    input   signed [31:0]       data1,
    input          [31:0]       data2,

    output   reg   [31:0]       data_output
);
    always @(*) begin
        case (alu_sel)
            `ADD : data_output = data1 + data2;
            `SUB : data_output = data1 - data2; 
            `AND : data_output = data1 & data2;
            `OR  : data_output = data1 | data2;
            `XOR : data_output = data1 ^ data2;
            `LeftShift : data_output = data1 << data2[4:0];
            `RightShiftLogic : data_output = data1 >> data2[4:0];
            `RightShiftMath : data_output = data1 >>> data2[4:0];
            `SLTU : data_output = (data1 < data2) ? 32'b1 : 32'b0;
            `SLT  : begin            
                if(data1[31]==1&&data2[31]==0)
                    data_output=1;
                else if(data1[31]==0&&data2[31]==1)
                    data_output=0;
                else if(data1[31]==1&&data2[31]==1)
                    data_output = (data1>data2) ? 1 : 0;
                else
                    data_output = (data1<data2) ? 1 : 0 ; end
            `LUI : data_output = data2;
           default: data_output = data1 + data2;
        endcase
    end

endmodule