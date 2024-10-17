`timescale 1ns/1ps

`include "./alu.v"
`include "./ctrl_unit.v"
`include "./imm_ext.v"
`include "./regfile.v"

// RISC-V core
module core 
(
    input wire clk_i,                // clock
    input wire reset_i,              // reset
    input wire [31:0] instr_i,       // instruction
    input wire [31:0] dmem_rdata_i,  // word read from data memory

    output wire [31:0] pc_o,         // program counter (instruction memory address)
    output wire [31:0] dmem_addr_o,  // data memory address
    output wire [31:0] dmem_wdata_o, // word to write to data memory
    output wire [2:0] dmem_mask_o,   // data memory mode (byte, half, word)
    output wire dmem_wen_o,          // data memory write enable

    // debug ports
    output wire [31:0] r1_o,
    output wire [31:0] r2_o,
    output wire [31:0] r3_o
);

    wire [2:0] imm_sel;      // immediate type select
    wire [1:0] reg_sel;      // register write select
    wire [1:0] pc_sel;       // pc select
    wire reg_wen;            // register write enable
    wire rs1_sel;            // rs1 selector
    wire rs2_sel;            // rs2 selector

    wire [31:0] rs1_data;    // data read from rs1
    wire [31:0] rs2_data;    // data read from rs2
    wire [31:0] rd_data;     // data to write to rd

    wire [31:0] alu_src_a;   // operand A
    wire [31:0] alu_src_b;   // operand B
    wire [3:0] alu_op;       // operation to perform
    wire [31:0] alu_result;  // result of operation

    wire [31:0] imm;         // extended immediate
    wire do_branch;          // take branch

    wire [31:0] pc_curr;     // current pc
    reg [31:0] pc_next;      // next pc
    wire [31:0] pc_plus_4;   // pc + 4
    wire [31:0] pc_plus_imm; // pc + imm

    // immediate extender

    imm_ext imm_ext0 (
        .instr_i(instr_i),
        .imm_sel_i(imm_sel),
        .imm_o(imm)
    );

    // control unit
    assign do_branch = (alu_result == 0) ? 1'b1 : 1'b0;

    ctrl_unit ctrl_unit0 (
        .opcode_i(instr_i[6:0]),
        .func7_i(instr_i[31:25]),
        .func3_i(instr_i[14:12]),
        .do_branch_i(do_branch),
        .alu_op_o(alu_op),
        .imm_sel_o(imm_sel),
        .dmem_mask_o(dmem_mask_o),
        .reg_sel_o(reg_sel),
        .pc_sel_o(pc_sel),
        .reg_wen_o(reg_wen),
        .dmem_wen_o(dmem_wen_o),
        .rs1_sel_o(rs1_sel),
        .rs2_sel_o(rs2_sel)
    );

    // register file

    regfile regfile0 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .wen_i(reg_wen),
        .rs1_idx_i(instr_i[19:15]),
        .rs2_idx_i(instr_i[24:20]),
        .rd_idx_i(instr_i[11:7]),
        .rd_data_i(rd_data),
        .rs1_data_o(rs1_data),
        .rs2_data_o(rs2_data),

        // debug ports
        .r1_o(r1_o),
        .r2_o(r2_o),
        .r3_o(r3_o)
    );

    assign rd_data = (reg_sel == 2'b00) ? dmem_rdata_i
                   : (reg_sel == 2'b01) ? alu_result
                   : (reg_sel == 2'b10) ? imm 
                   : pc_plus_4;
    assign dmem_addr_o = alu_result;
    assign dmem_wdata_o = rs2_data;

    // ALU

    alu alu0 (
        .a_i(alu_src_a),
        .b_i(alu_src_b),
        .op_i(alu_op),
        .result_o(alu_result)
    );

    assign alu_src_a = (rs1_sel) ? pc_next : rs1_data;
    assign alu_src_b = (rs2_sel) ? imm : rs2_data;

    // program counter

    assign pc_plus_4 = pc_next + 4;
    assign pc_plus_imm = pc_next + imm;
    assign pc_curr = (pc_sel == 2'b00) ? pc_plus_4
                   : (pc_sel == 2'b01) ? alu_result
                   : (pc_sel == 2'b10) ? pc_plus_imm 
                   : 32'hx;
    assign pc_o = pc_next;

    always @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            pc_next <= 0;
        end
        else begin
            pc_next <= pc_curr;
        end
    end

endmodule
