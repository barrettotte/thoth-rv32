`timescale 1ns/1ps

// immediate extension unit
module imm_ext
(
    input wire [2:0] imm_sel_i,
    input wire [31:0] instr_i,
    output reg [31:0] imm_o
);
    always @(*) begin
        // immediate types, sign-extended via bit 31
        case (imm_sel_i)
            `IMM_I:  imm_o <= {{21{instr_i[31]}}, instr_i[30:20]};
            `IMM_S:  imm_o <= {{21{instr_i[31]}}, instr_i[30:25], instr_i[11:7]};
            `IMM_B:  imm_o <= {{20{instr_i[31]}}, instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
            `IMM_U:  imm_o <= {instr_i[31], instr_i[30:12], {12{1'b0}}};
            `IMM_J:  imm_o <= {{12{instr_i[31]}}, instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
            default: imm_o <= 32'b0; // invalid
        endcase
    end

endmodule
