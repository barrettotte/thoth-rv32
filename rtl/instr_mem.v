`timescale 1ns/1ps

// instruction memory
module instr_mem
#(
    parameter MEM_SIZE=1024 // memory size in bytes
)
(
    input wire clk_i,          // clock
    input wire [31:0] pc_i,    // program counter
    output wire [31:0] instr_o // instruction
);
    reg [31:0] rom [0:MEM_SIZE-1];

    // load initial ROM
    initial begin
        rom[0] = 32'b000000000000_00000_000_00001_0010011; // ADDI x1, x0, 0
        rom[1] = 32'b000000000001_00001_000_00001_0010011; // ADDI x1, x1, 1
        rom[2] = 32'b000000000001_00001_000_00001_0010011; // ADDI x1, x1, 1
        rom[3] = 32'b000000000001_00001_000_00001_0010011; // ADDI x1, x1, 1
    end

    // read instruction from ROM
    assign instr_o = rom[pc_i[31:2]];

endmodule
