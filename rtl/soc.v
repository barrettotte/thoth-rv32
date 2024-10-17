`timescale 1ns/1ps

`include "./clock_div.v"
`include "./core.v"
`include "./data_mem.v"
`include "./instr_mem.v"

// system on chip (SoC)
module soc
#(
    parameter CLK_FREQ = 100 * (10**6), // clock frequency; 100MHz
    parameter CORE_FREQ = 1 * (10**6),  // clock frequency to use in core; 1MHz
    parameter IMEM_SIZE = 1024,         // instruction memory size in bytes
    parameter DMEM_SIZE = 1024          // data memory size in bytes
)
(
    input wire clk_i,   // clock
    input wire reset_i, // reset

    // debug ports
    output wire [31:0] r1_o,
    output wire [31:0] r2_o,
    output wire [31:0] r3_o
);
    // constants
    localparam CLK_DIVISOR = CLK_FREQ / CORE_FREQ; // amount to divide clock by

    // wires/regs
    wire div_clk;           // divided clock signal
    wire [31:0] pc;         // program counter
    wire [31:0] instr;      // instruction
    wire dmem_wen;          // data memory write enable
    wire [2:0] dmem_mask;   // data memory write mask
    wire [31:0] dmem_addr;  // data memory address
    wire [31:0] dmem_wdata; // data to write to data memory
    wire [31:0] dmem_rdata; // data read from data memory

    // generate core clock signal
    clock_div #(
        .DIVISOR(CLK_DIVISOR)
    ) clock_div0 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .clk_o(div_clk)
    );

    // RISC-V core
    core core0 (
        .clk_i(div_clk),
        .reset_i(reset_i),
        .instr_i(instr),
        .dmem_rdata_i(dmem_rdata),

        .pc_o(pc),
        .dmem_addr_o(dmem_addr),
        .dmem_wdata_o(dmem_wdata),
        .dmem_mask_o(dmem_mask),
        .dmem_wen_o(dmem_wen),

        // debug ports
        .r1_o(r1_o),
        .r2_o(r2_o),
        .r3_o(r3_o)
    );

    // instruction memory
    instr_mem #(
        .MEM_SIZE(IMEM_SIZE)
    ) instr_mem0 (
        .clk_i(div_clk),
        .pc_i(pc),
        .instr_o(instr)
    );
    
    // data memory
    data_mem #(
        .MEM_SIZE(DMEM_SIZE)
    ) data_mem0 (
        .clk_i(div_clk),
        .wen_i(dmem_wen),
        .mask_i(dmem_mask),
        .addr_i(dmem_addr),
        .wdata_i(dmem_wdata),
        .rdata_o(dmem_rdata)
    );

endmodule
