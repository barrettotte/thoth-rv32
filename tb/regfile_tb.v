`timescale 1ns/1ps

`include "./include/assert.vh"
`include "../rtl/regfile.v"

module regfile_tb;
    // clock frequency in Hz
    localparam CLK_FREQ = 100 * (10**6); // 100MHz

    // clock period in ns
    // T = (1 / f) * (10^9)
    // Example: (1 / (100 * (10^6))) * (10^9) = 10ns
    localparam CLK_PERIOD = (10**9) / CLK_FREQ;

    // inputs
    reg clk = 0;
    reg reset = 0;
    reg wen = 0;
    reg [4:0] rs1_idx = 0;
    reg [4:0] rs2_idx = 0;
    reg [4:0] rd_idx = 0;
    reg [31:0] rd_data = 0;

    // outputs
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // design under test
    regfile DUT (
        .clk_i(clk), 
        .reset_i(reset),
        .wen_i(wen),
        .rs1_idx_i(rs1_idx),
        .rs2_idx_i(rs2_idx),
        .rd_idx_i(rd_idx),
        .rd_data_i(rd_data),
        .rs1_data_o(rs1_data),
        .rs2_data_o(rs2_data)
    );

    // clock generation (100MHz)
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        $dumpfile("regfile_tb.vcd");
        $dumpvars(0, regfile_tb);

        // init
        reset = 1;
        #(CLK_PERIOD);

        // reset and wait for stability
        reset = 0;
        #(3 * CLK_PERIOD);

        // test write and read
        rd_idx = 3;
        rs1_idx = 3;
        rs2_idx = 3;
        wen = 1'b1;
        rd_data = 'h1337;
        #(CLK_PERIOD);
        `ASSERT('h1337, rs1_data);
        `ASSERT('h1337, rs2_data);

        // test write disabled and read
        wen = 1'b0;
        rd_data = 'h1234;
        #(CLK_PERIOD);
        `ASSERT('h1337, rs1_data);
        `ASSERT('h1337, rs2_data);

        // test read zero register
        rs1_idx = 0;
        rs2_idx = 0;
        #(CLK_PERIOD);
        `ASSERT(0, rs1_data);
        `ASSERT(0, rs2_data);

        // wait a bit longer
        #(3 * CLK_PERIOD);

        // done
        $display("Simulation time: %t", $time);
        $display("Test finished.");
        #1 $finish;
    end

endmodule
