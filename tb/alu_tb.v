`timescale 1ns/1ps

`include "./include/assert.vh"
`include "../rtl/defines.vh"
`include "../rtl/alu.v"

module alu_tb;

    // inputs
    reg [31:0] a = 0;
    reg [31:0] b = 0;
    reg [3:0] op = 0;

    // outputs
    wire [31:0] result;

    // design under test
    alu DUT (
        .a_i(a),
        .b_i(b),
        .op_i(op),
        .result_o(result)
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // init
        a = 42;   // 00101010
        b = 1337; // 00000101 00111001

        // ADD
        op = `ALU_ADD;
        #2 `ASSERT((42 + 1337), result)

        // SUB
        op = `ALU_SUB;
        #2 `ASSERT((42 - 1337), result)
        
        // AND
        op = `ALU_AND;
        #2 `ASSERT((42 & 1337), result)

        // OR
        op = `ALU_OR;
        #2 `ASSERT((42 | 1337), result)

        // XOR
        op = `ALU_XOR;
        #2 `ASSERT((42 ^ 1337), result)

        // SLL
        b = 4;
        op = `ALU_SLL;
        #2 `ASSERT((42 << 4), result)

        // SRL
        b = 4;
        op = `ALU_SRL;
        #2 `ASSERT((42 >> 4), result)

        // SRA
        a = -8; // 11111000
        b = 2;
        op = `ALU_SRA;
        #2 `ASSERT(32'b11111111_11111111_11111111_11111110, result)

        // EQ
        a = 42;
        b = 1337;
        op = `ALU_EQ;
        #2 `ASSERT(0, result)

        // LTU
        op = `ALU_LTU;
        #2 `ASSERT(1, result)

        // LT
        a = -2;
        b = -5;
        op = `ALU_LT;
        #2 `ASSERT(0, result)

        // GTEU
        a = 8;
        b = 2;
        op = `ALU_GTEU;
        #2 `ASSERT(1, result)

        // GTE
        a = -4;
        b = -2;
        op = `ALU_GTE;
        #2 `ASSERT(0, result)

        // JALR
        a = 4;
        b = -2;
        op = `ALU_JALR;
        #2 `ASSERT(2, result)

        // wait a little longer
        #10;

        // done
        $display("Simulation time: %t", $time);
        $display("Test finished.");
        #1 $finish;
    end

endmodule
