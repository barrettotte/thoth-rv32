`timescale 1ns/1ps

`include "./include/assert.vh"
`include "../rtl/core.v"

module core_tb;
    // clock frequency in Hz
    localparam CLK_FREQ = 1 * (10**6); // 1MHz

    // clock period in ns
    // T = (1 / f) * (10^9)
    // Example: (1 / (100 * (10^6))) * (10^9) = 10ns
    localparam CLK_PERIOD = (10**9) / CLK_FREQ;

    // instructions

    // NOP (ADDI x0, x0, 0)
    //        imm          rs1   fn3 rd    op
    localparam NOP = 32'b000000000000_00000_000_00000_0010011;

    // inputs
    reg clk = 0;
    reg reset = 0;
    reg [31:0] instr = 0;
    reg [31:0] dmem_rdata = 0;
    reg do_branch = 0;

    // outputs
    wire [31:0] pc;
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    wire [2:0] dmem_mode;
    wire dmem_wen;
    wire [31:0] r1;
    wire [31:0] r2;
    wire [31:0] r3;

    // test
    reg [31:0] test_pc = 0;

    // design under test
    core DUT (
        .clk_i(clk), 
        .reset_i(reset),
        .instr_i(instr),
        .dmem_rdata_i(dmem_rdata),
        .do_branch_i(do_branch),
        .pc_o(pc),
        .dmem_addr_o(dmem_addr),
        .dmem_wdata_o(dmem_wdata),
        .dmem_mode_o(dmem_mode),
        .dmem_wen_o(dmem_wen),

        // debug ports
        .r1_o(r1),
        .r2_o(r2),
        .r3_o(r3)
    );

    // clock generation (100MHz)
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        $dumpfile("core_tb.vcd");
        $dumpvars(0, core_tb);

        // init
        reset = 1;
        #(CLK_PERIOD);

        // reset and wait for stability
        reset = 0;

        // ADDI x1, x0, 0
        //          imm          rs1   fn3 rd    op
        instr = 32'b000000000000_00000_000_00001_0010011;
        #(CLK_PERIOD);
        test_pc = test_pc + 4; // 4
        `ASSERT(0, r1)

        // ADDI x2, x0, 0
        //          imm          rs1   fn3 rd    op
        instr = 32'b000000000000_00000_000_00010_0010011;
        #(CLK_PERIOD);
        test_pc = test_pc + 4; // 8
        `ASSERT(0, r2)

        // ADDI x1, x0, 1337
        //          imm          rs1   fn3 rd    op
        instr = 32'b010100111001_00001_000_00001_0010011;
        #(CLK_PERIOD);
        test_pc = test_pc + 4; // 12
        `ASSERT(1337, r1)
        
        // ADD x2, x2, x1
        //          fn7     rs2   rs1   fn3 rd    op
        instr = 32'b0000000_00001_00010_000_00010_0110011;
        #(CLK_PERIOD);
        test_pc = test_pc + 4; // 16
        `ASSERT(1337, r2)

        #(CLK_PERIOD);
        test_pc = test_pc + 4; // 20
        `ASSERT((1337 * 2), r2)

        `ASSERT(20, pc)

        // wait a bit longer
        #(3 * CLK_PERIOD);

        // done
        $display("Simulation time: %t", $time);
        $display("Test finished.");
        #1 $finish;
    end

endmodule
