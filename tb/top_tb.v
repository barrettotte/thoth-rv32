`include "../rtl/top.v"
`timescale 1ns/1ps

module top_tb;
    // clock frequency in Hz
    localparam CLK_FREQ = 100 * (10**6); // 100MHz

    // clock period
    // T = (1 / f) * (10^9)
    // Example: (1 / (100 * (10^6))) * (10^9) = 10ns
    localparam CLK_PERIOD = (10**9) / CLK_FREQ;

    // inputs
    reg clk = 0;
    reg reset = 0;

    // outputs

    // design under test
    top DUT (
        .clk_i(clk), 
        .reset_i(reset)
    );

    // clock generation (100MHz)
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        // init
        reset = 1;
        #(CLK_PERIOD);

        // reset and wait for stability
        reset = 0;
        #(3 * CLK_PERIOD);

        // test behavior

        // test reset again
        reset = 1;
        #(CLK_PERIOD);

        // wait a bit longer
        #(3 * CLK_PERIOD);

        // done
        $display("Simulation time: %t", $time);
        $display("Test finished.");
        #1 $finish;
    end

endmodule
