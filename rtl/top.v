`timescale 1ns/1ps

`include "./clock_div.v"
`include "./core.v"

module top
(
    input wire clk_i,  // clock
    input wire reset_i // reset
);
    // constants
    localparam CLK_FREQ = 100 * (10**6);           // clock frequency; 100MHz
    localparam CLK_PERIOD = (10**9) / CLK_FREQ;    // clock period in ns; 10ns
    localparam CORE_FREQ = 1 * (10**6);            // clock frequency to use in core; 1MHz
    localparam CLK_DIVISOR = CLK_FREQ / CORE_FREQ; // amount to divide clock by

    // wires/regs
    wire core_clk; // divided clock signal to use with core

    initial begin
        // nop
    end

    // generate core clock signal
    clock_div #(
        .DIVISOR(CLK_DIVISOR)
    ) clk_div (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .clk_o(core_clk)
    );

endmodule
