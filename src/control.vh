//ALU compute
`define ADD              4'b0000
`define SUB              4'b0001
`define AND              4'b0010
`define OR               4'b0011
`define XOR              4'b0100
`define LeftShift        4'b0101
`define RightShiftLogic  4'b0110
`define RightShiftMath   4'b0111
`define SLT              4'b1000
`define SLTU             4'b1001
`define LUI              4'b1010

//BrUn
`define Branch_signed   2'b01
`define Branch_unsigned 2'b11
`define NotCare         2'b00