`ifndef _DEFINES_VH
    `define _DEFINES_VH

    // ALU operations
    `define ALU_ADD  4'b0000
    `define ALU_SUB  4'b0001
    `define ALU_AND  4'b0010
    `define ALU_OR   4'b0011
    `define ALU_XOR  4'b0100
    `define ALU_SLL  4'b0101
    `define ALU_SRL  4'b0110
    `define ALU_SRA  4'b0111
    `define ALU_EQ   4'b1000
    `define ALU_LTU  4'b1001
    `define ALU_LT   4'b1010
    `define ALU_GTEU 4'b1011
    `define ALU_GTE  4'b1100
    `define ALU_JALR 4'b1101
    // undefined     4'b1110
    // undefined     4'b1111

    // Immediate types
    `define IMM_U 3'b000
    `define IMM_S 3'b001
    `define IMM_B 3'b010
    `define IMM_I 3'b011
    `define IMM_J 3'b100

`endif
