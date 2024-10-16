`timescale 1ns/1ps

`include "./defines.vh"

// arithmetic logic unit
module alu
(
    input wire [31:0] a_i,     // first operand
    input wire [31:0] b_i,     // second operand
    input wire [3:0] op_i,     // operation
    output reg [31:0] result_o // ALU result
);

    always @(*) begin
        case (op_i)
            `ALU_ADD:   result_o <= (a_i + b_i);
            `ALU_SUB:   result_o <= (a_i - b_i);
            `ALU_AND:   result_o <= (a_i & b_i);
            `ALU_OR:    result_o <= (a_i | b_i);
            `ALU_XOR:   result_o <= (a_i ^ b_i);
            `ALU_SLL:   result_o <= (a_i << b_i[4:0]);
            `ALU_SRL:   result_o <= (a_i >> b_i[4:0]);
            `ALU_SRA:   result_o <= ($signed(a_i) >>> b_i[4:0]);
            `ALU_EQ:    result_o <= ((a_i == b_i) ? 1 : 0);
            `ALU_LTU:   result_o <= ((a_i < b_i) ? 1 : 0);
            `ALU_LT:    result_o <= (($signed(a_i) < $signed(b_i)) ? 1 : 0);
            `ALU_GTEU:  result_o <= ((a_i >= b_i) ? 1 : 0);
            `ALU_GTE:   result_o <= (($signed(a_i) >= $signed(b_i)) ? 1 : 0);
            `ALU_JALR:  result_o <= (($signed(a_i) + $signed(b_i)) & 32'hfffffffe);
            default:    result_o <= 'hx; // 4'b1110, 4'b1111
        endcase
    end

endmodule
