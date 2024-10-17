`timescale 1ns/1ps

// register file
// x0-x31, x0 hardwired to zero
module regfile 
(
    input wire clk_i,              // clock
    input wire reset_i,            // reset
    input wire wen_i,              // write enable
    input wire [4:0] rs1_idx_i,    // source register 1 selector
    input wire [4:0] rs2_idx_i,    // source register 2 selector
    input wire [4:0] rd_idx_i,     // destination register selector
    input wire [31:0] rd_data_i,   // destination register data
    output wire [31:0] rs1_data_o, // source register 1 data
    output wire [31:0] rs2_data_o, // source register 2 data

    // debug ports
    output wire [31:0] r1_o,
    output wire [31:0] r2_o,
    output wire [31:0] r3_o
);
    reg [31:0] regs [31:0]; // 32x32-bit registers
    integer i;

    // outputs
    assign rs1_data_o = (rs1_idx_i == 0) ? 0 : regs[rs1_idx_i];
    assign rs2_data_o = (rs2_idx_i == 0) ? 0 : regs[rs2_idx_i];

    // debug outputs
    assign r1_o = regs[1];
    assign r2_o = regs[2];
    assign r3_o = regs[3];

    // register logic
    always @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] = 32'b0;
            end
        end else begin
            // only write if enabled and not zero register
            if (wen_i & (rd_idx_i != 0)) begin
                regs[rd_idx_i] <= rd_data_i;
            end
        end
    end

endmodule
