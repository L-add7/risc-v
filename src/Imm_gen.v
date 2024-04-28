`include "opcode.vh"

module Imm_gen(
    input      [31:0]     inst,

    output reg [31:0]     imm
);
    always @(*) begin
        case (inst[6:2])
            `OPC_ARI_RTYPE_5 : imm = 32'b0;
            `OPC_ARI_ITYPE_5 : imm = (inst[14:12]==3'b011) ? {20'b0,inst[31:20]} : {{20{inst[31]}},inst[31:20]};
            `OPC_STORE_5 :     imm = {{20{inst[31]}},inst[31:25],inst[11:7]};
            `OPC_LOAD_5  :     imm =  {20'b0,inst[31:20]} ;
            `OPC_BRANCH_5:     imm = {19'b0,inst[31],inst[7],inst[30:25],inst[11:8],1'b0} ;
            `OPC_JAL_5   :     imm = {{11{inst[31]}},inst[31],inst[19:12],inst[20],inst[30:21],1'b0};
            `OPC_JALR_5  :     imm = {{20{inst[31]}},inst[31:20]};
            `OPC_LUI_5:        imm = {inst[31:12],12'b0};
            `OPC_AUIPC_5:      imm = {inst[31:12],12'b0};
            //todo : add csrrw
        endcase
    end

endmodule