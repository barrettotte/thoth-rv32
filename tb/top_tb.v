`include "../rtl/top.v"
`timescale 1ns/1ps

module top_tb;
    // constants

    // clock frequency in megahertz
    localparam CLK_FREQ = 100 * (10**6); // 100MHz

    // clock period
    // T = (1 / f) * (10^7)
    // Example: (1 / (100 * (10^6))) * (10^9) = 10ns
    localparam CLK_PERIOD = (10**9 / (CLK_FREQ));

    // inputs
    reg clk = 0;
    reg reset = 0;
    reg [7:0] d = 0;

    // outputs
    wire [7:0] q;

    // design under test
    top DUT (
        .clk_i(clk), 
        .reset_i(reset),
        .d_i(d),
        .q_o(q)
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
        d = 0;
        reset = 1;
        #(CLK_PERIOD);

        // reset and wait for stability
        reset = 0;
        #(3 * CLK_PERIOD);

        // test data
        d = 8'b00110011;
        #(3 * CLK_PERIOD);
        d = 8'b11110000;
        #(3 * CLK_PERIOD);

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
