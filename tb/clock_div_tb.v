`timescale 1ns/1ps

`include "./include/assert.vh"
`include "../rtl/clock_div.v"

module clock_div_tb;
    // clock frequency in Hz
    localparam CLK_FREQ = 100 * (10**6); // 100MHz

    // clock period in ns
    // T = (1 / f) * (10^9)
    // Example: (1 / (100 * (10^6))) * (10^9) = 10ns
    localparam CLK_PERIOD = (10**9) / CLK_FREQ;

    // divided clock frequency in Hz
    localparam DIV_CLK_FREQ = 1 * (10**6); // 1MHz

    // divided clock period in ns
    localparam DIV_CLK_PERIOD = (10**9) / DIV_CLK_FREQ;

    // amount to divide clock by
    // 100 = (100 * 10^6) / (1 * 10^6)
    localparam CLK_DIVISOR = CLK_FREQ / DIV_CLK_FREQ;

    // inputs
    reg clk = 0;
    reg reset = 0;

    // outputs
    wire clk_div;

    // design under test
    clock_div #(
        .DIVISOR(CLK_DIVISOR)
    ) DUT (
        .clk_i(clk), 
        .reset_i(reset),
        .clk_o(clk_div)
    );

    // clock generation (100MHz)
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        $dumpfile("clock_div_tb.vcd");
        $dumpvars(0, clock_div_tb);

        // init
        reset = 1;
        #(CLK_PERIOD);

        // reset and wait for stability
        reset = 0;
        #(3 * CLK_PERIOD);

        // divided clock up
        #(DIV_CLK_PERIOD);
        `ASSERT(1'b1, clk_div)

        // divided clock down
        #(DIV_CLK_PERIOD);
        `ASSERT(1'b0, clk_div)

        // divided clock up
        #(DIV_CLK_PERIOD);
        `ASSERT(1'b1, clk_div)

        // divided clock down
        #(DIV_CLK_PERIOD);
        `ASSERT(1'b0, clk_div)

        // wait a bit longer
        #(3 * CLK_PERIOD);

        // done
        $display("Simulation time: %t", $time);
        $display("Test finished.");
        #1 $finish;
    end

endmodule
