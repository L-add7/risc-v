`include "opcode.vh"
`include "control.vh"
module crtl(
    input      [31:0]     inst,
    input                 branchpredicted,
    output reg           we,
    output reg    [1:0]   aluBsel,        // 1 for rs2   0 for imm
    output reg   [3:0]   alu_sel,
    output reg   [1:0]   BrUn,
    output reg   [3:0]   LD_sel,
    output reg           dmemen,
    output reg   [3:0]   dmemwe,
    output reg           wdata_sel,
    output reg           aluAsel,
    output reg           pc_sel,
    output reg   [2:0]   bresult_sel,
    output reg           rstype
);
    always @(*) begin
        case (inst[6:0])
            `OPC_ARI_RTYPE : begin  we = 1'b1;    aluBsel =  2'b1   ;  dmemen = 1'b0; dmemwe = 4'b0000; wdata_sel = 1'b0; LD_sel = 4'b0000; aluAsel = 1'b0; pc_sel = 1'b0; bresult_sel = 3'b000; rstype = 1'b1;
                                    case (inst[14:12])
                                        `FNC_ADD_SUB : begin alu_sel = inst[30] ? `SUB : `ADD ; BrUn = `NotCare; end
                                        `FNC_SLL : begin alu_sel = `LeftShift ; BrUn = `NotCare; end
                                        `FNC_SLT : begin alu_sel = `SLT ; BrUn = `NotCare; end
                                        `FNC_SLTU: begin alu_sel = `SLTU ; BrUn = `NotCare; end
                                        `FNC_XOR: begin alu_sel = `XOR ; BrUn = `NotCare; end
                                        `FNC_OR : begin alu_sel = `OR ; BrUn = `NotCare; end
                                        `FNC_AND : begin alu_sel = `AND ; BrUn = `NotCare; end
                                        `FNC_SRL_SRA : begin alu_sel = inst[30] ? `RightShiftMath : `RightShiftLogic ; BrUn = `NotCare; end
                                        default : begin alu_sel = inst[30] ? `SUB : `ADD ; BrUn = `NotCare; end
                                    endcase 
                               end 
            `OPC_ARI_ITYPE : begin  we = 1'b1;    aluBsel =  2'b0  ;  dmemen = 1'b0; dmemwe = 4'b0000; wdata_sel = 1'b0; LD_sel = 4'b0000;  aluAsel = 1'b0; pc_sel = 1'b0; bresult_sel = 3'b000; rstype = 1'b0;
                                    case (inst[14:12])
                                        `FNC_ADD_SUB : begin alu_sel = `ADD ; BrUn = `NotCare; end
                                        `FNC_SLL : begin alu_sel = `LeftShift ; BrUn = `NotCare; end
                                        `FNC_SLT : begin alu_sel = `SLT ; BrUn = `NotCare; end
                                        `FNC_SLTU: begin alu_sel = `SLTU ; BrUn = `NotCare; end
                                        `FNC_XOR: begin alu_sel = `XOR ; BrUn = `NotCare; end
                                        `FNC_OR : begin alu_sel = `OR ; BrUn = `NotCare; end
                                        `FNC_AND : begin alu_sel = `AND ; BrUn = `NotCare; end
                                        `FNC_SRL_SRA : begin alu_sel = inst[30] ? `RightShiftMath : `RightShiftLogic ; BrUn = `NotCare; end
                                        default : begin alu_sel = `ADD ; BrUn = `NotCare; end
                                    endcase 
                                end
            `OPC_STORE :     begin  we = 1'b0;    aluBsel =  2'b0   ;  BrUn = `NotCare; alu_sel = `ADD; dmemen = 1'b1; wdata_sel = 1'b0; LD_sel = 4'b0000;  rstype = 1'b1;  aluAsel = 1'b0; pc_sel = 1'b0; bresult_sel = 3'b000;
                                case (inst[14:12])
                                    `FNC_SB :  dmemwe = 4'b0001;
                                    `FNC_SH :  dmemwe = 4'b0011;
                                    `FNC_SW :  dmemwe = 4'b1111;
                                    default: dmemwe = 4'b0000;
                                endcase
                            end
            `OPC_LOAD  :     begin  we = 1'b1;    aluBsel =  2'b0   ;  BrUn = `NotCare; alu_sel = `ADD; dmemen = 1'b1; dmemwe = 4'b0000; wdata_sel = 1'b1;  aluAsel = 1'b0; pc_sel = 1'b0; bresult_sel = 3'b000;  rstype = 1'b0;
                                case (inst[14:12])
                                    `FNC_LB : LD_sel = 4'b0001;
                                    `FNC_LH : LD_sel = 4'b0011;
                                    `FNC_LW : LD_sel = 4'b1111;
                                    `FNC_LBU: LD_sel = 4'b0101;
                                    `FNC_LHU: LD_sel = 4'b0111;
                                    default: LD_sel = 4'b0000;
                                endcase
                                end
            `OPC_BRANCH:     begin  we = 1'b0;    aluBsel =  2'b1   ;  BrUn = inst[13] ? `Branch_unsigned : `Branch_signed; alu_sel = `ADD; dmemen = 1'b0; dmemwe = 4'b0000; wdata_sel = 1'b0; LD_sel = 4'b0000; aluAsel = 1'b0; pc_sel = branchpredicted;   rstype = 1'b0;
                                case (inst[14:12])
                                    `FNC_BEQ : bresult_sel = 3'b001;    //EQUAL 
                                    `FNC_BNE : bresult_sel = 3'b011;    //NOT EQUAL
                                    `FNC_BLT : bresult_sel = 3'b101;    //LESS
                                    `FNC_BGE : bresult_sel = 3'b111;    // GREATER OR EQUAL
                                    `FNC_BLTU: bresult_sel = 3'b101;    // LESS 
                                    `FNC_BGEU: bresult_sel = 3'b111;    // GREATER OR EQUAL
                                    default:  bresult_sel = 3'b000; 
                                endcase
                            end
            `OPC_JAL   :     begin  we = 1'b1;    aluBsel =  2'b11   ;  BrUn = `NotCare; alu_sel = `ADD; dmemen = 1'b0; dmemwe = 4'b0000; wdata_sel = 1'b0; LD_sel = 4'b0000;  aluAsel = 1'b1; pc_sel = 1'b1;bresult_sel = 3'b000;  rstype = 1'b0; end
            `OPC_JALR  :     begin  we = 1'b1;    aluBsel =  2'b10   ;  BrUn = `NotCare; alu_sel = `ADD; dmemen = 1'b0; dmemwe = 4'b0000; wdata_sel = 1'b0; LD_sel = 4'b0000;  aluAsel = 1'b1; pc_sel = 1'b1;bresult_sel = 3'b000;  rstype = 1'b0; end
            `OPC_LUI:        begin  we = 1'b1;    aluBsel =  2'b0   ;  BrUn = `NotCare; alu_sel = `LUI; dmemen = 1'b0; dmemwe = 4'b0000; wdata_sel = 1'b0; LD_sel = 4'b0000;  aluAsel = 1'b0; pc_sel = 1'b0; bresult_sel = 3'b000;  rstype = 1'b0; end
            `OPC_AUIPC:      begin  we = 1'b1;    aluBsel =  2'b0   ;  BrUn = `NotCare; alu_sel = `ADD; dmemen = 1'b0; dmemwe = 4'b0000; wdata_sel = 1'b0; LD_sel = 4'b0000;  aluAsel = 1'b1; pc_sel = 1'b0; bresult_sel = 3'b000;  rstype = 1'b0; end
            default : begin we = 1'b0;    aluBsel =  2'b0   ;  BrUn = `NotCare; alu_sel = `ADD; dmemen = 1'b0; dmemwe = 4'b0000; wdata_sel = 1'b0; LD_sel = 4'b0000; aluAsel = 1'b0; pc_sel = 1'b0; bresult_sel = 3'b000;  rstype = 1'b0; end 
            //todo : add csrrw
        endcase
    end

endmodule