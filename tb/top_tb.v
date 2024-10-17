`timescale 1ns/1ps

`include "./include/assert.vh"
`include "../rtl/top.v"

module top_tb;
    // clock frequency in Hz
    localparam CLK_FREQ = 100 * (10**6); // 100MHz

    // clock period in ns
    localparam CLK_PERIOD = (10**9) / CLK_FREQ;

    // core clock frequency in Hz
    localparam CORE_FREQ = 1 * (10**6); // 1MHz

    // core clock period in ns
    localparam CORE_PERIOD = (10**9) / CORE_FREQ;

    // inputs
    reg clk = 0;
    reg reset = 0;

    // outputs
    wire [15:0] r1;

    // test regs
    reg div_clk = 0;

    // design under test
    top DUT (
        .clk_i(clk), 
        .reset_i(reset),
        
        // debug ports
        .r1_o(r1)
    );

    // clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        // init
        reset = 1;
        #2;

        // reset and wait for stability
        reset = 0;
        
        // test ROM instructions set in instr_mem.v 
        #(2 * CORE_PERIOD); // ADDI x1, x0, 0
        #(2 * CORE_PERIOD); // ADDI x1, x1, 1
        #(2 * CORE_PERIOD); // ADDI x1, x1, 1
        #(2 * CORE_PERIOD); // ADDI x1, x1, 1

        // x1 should have been incremented three times
        `ASSERT(3, r1)

        // wait a bit longer
        #(10 * CORE_PERIOD);

        // done
        $display("Simulation time: %t", $time);
        $display("Test finished.");
        #1 $finish;
    end

endmodule
