`timescale 1ns/1ps

`include "./defines.vh"

// generate control signals
module ctrl_unit
(
    input wire [6:0] opcode_i,
    input wire [6:0] func7_i,
    input wire [2:0] func3_i,
    input wire do_branch_i,

    output reg [3:0] alu_op_o,
    output reg [2:0] imm_sel_o,
    output reg [2:0] dmem_mask_o,
    output reg [1:0] reg_sel_o,
    output reg [1:0] pc_sel_o,
    output reg reg_wen_o,
    output reg dmem_wen_o,
    output reg rs1_sel_o,
    output reg rs2_sel_o
);

    always @(*) begin
        // set default behavior first
        alu_op_o <= 4'b0000;
        imm_sel_o <= 2'b00;
        dmem_mask_o <= 2'b00;
        reg_sel_o <= 2'b00;
        pc_sel_o <= 2'b00;
        reg_wen_o <= 1'b0;
        dmem_wen_o <= 1'b0;
        rs1_sel_o <= 1'b0;
        rs2_sel_o <= 1'b0;

        // set control signals by opcode
        // TODO: combine signals for case? {opcode, func3, func7}
        case (opcode_i)

            7'b0000011: begin // LB, LH, LW, LBU, LHU
                case (func3_i)
                    3'b000: begin // LB
                        imm_sel_o <= 3'b011;
                        dmem_mask_o <= 3'b110;
                        reg_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end

                    3'b001: begin // LH
                        imm_sel_o <= 3'b011;
                        dmem_mask_o <= 3'b101;
                        reg_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end

                    3'b010: begin // LW
                        imm_sel_o <= 3'b011;
                        dmem_mask_o <= 3'b000;
                        reg_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end

                    3'b100: begin // LBU
                        imm_sel_o <= 3'b011;
                        dmem_mask_o <= 3'b010;
                        reg_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end
                    3'b101: begin // LHU
                        imm_sel_o <= 3'b011;
                        dmem_mask_o <= 3'b001;
                        reg_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end
                endcase
            end

            7'b0010011: begin // ADDI, SLLI, SLTI, SLTIU, XORI, SRLI, SRAI, ORI, ANDI
                case (func3_i)
                    3'b000: begin // ADDI
                        alu_op_o <= `ALU_ADD;
                        imm_sel_o <= 3'b011;
                        reg_sel_o <= 2'b01;
                        reg_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end

                    3'b001: begin // SLLI
                        if (func7_i == 7'b0000000) begin
                            alu_op_o <= `ALU_SLL;
                            imm_sel_o <= 3'b011;
                            reg_sel_o <= 2'b01;
                            reg_wen_o <= 1'b1;
                            rs2_sel_o <= 1'b1;
                        end
                    end

                    3'b010: begin // SLTI
                        alu_op_o <= `ALU_LT;
                        imm_sel_o <= 3'b011;
                        reg_sel_o <= 2'b01;
                        reg_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end

                    3'b011: begin // SLTIU
                        alu_op_o <= `ALU_LTU;
                        imm_sel_o <= 3'b011;
                        reg_sel_o <= 2'b01;
                        reg_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end

                    3'b100: begin // XORI
                        alu_op_o <= `ALU_XOR;
                        imm_sel_o <= 3'b011;
                        reg_sel_o <= 2'b01;
                        reg_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end

                    3'b101: begin // SRLI, SRAI
                        case (func7_i)
                            7'b0000000: begin // SRLI
                                alu_op_o <= `ALU_SRL;
                                imm_sel_o <= 3'b011;
                                reg_sel_o <= 2'b01;
                                reg_wen_o <= 1'b1;
                                rs2_sel_o <= 1'b1;
                            end

                            7'b0100000: begin // SRAI
                                alu_op_o <= `ALU_SRA;
                                imm_sel_o <= 3'b011;
                                reg_sel_o <= 2'b01;
                                reg_wen_o <= 1'b1;
                                rs2_sel_o <= 1'b1;
                            end
                        endcase
                    end

                    3'b110: begin // ORI
                        alu_op_o <= `ALU_OR;
                        imm_sel_o <= 3'b011;
                        reg_sel_o <= 2'b01;
                        reg_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end

                    3'b111: begin // ANDI
                        alu_op_o <= `ALU_AND;
                        imm_sel_o <= 3'b011;
                        reg_sel_o <= 2'b01;
                        reg_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end
                endcase
            end

            7'b0010111: begin // AUIPC
                imm_sel_o <= 3'b000;
                reg_sel_o <= 2'b01;
                reg_wen_o <= 1'b1;
                rs1_sel_o <= 1'b1;
                rs2_sel_o <= 1'b1;
            end

            7'b0100011: begin // SB, SH, SW
                case (func3_i)
                    3'b000: begin // SB
                        imm_sel_o <= 3'b001;
                        dmem_mask_o <= 3'b010;
                        dmem_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end

                    3'b001: begin // SH
                        imm_sel_o <= 3'b001;
                        dmem_mask_o <= 3'b001;
                        dmem_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end

                    3'b010: begin // SW
                        imm_sel_o <= 3'b001;
                        dmem_mask_o <= 3'b000;
                        dmem_wen_o <= 1'b1;
                        rs2_sel_o <= 1'b1;
                    end
                endcase
            end

            7'b0110011: begin // ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
                case (func3_i)
                    3'b000: begin // ADD, SUB
                        case (func7_i)
                            7'b0000000: begin // ADD
                                alu_op_o <= `ALU_ADD;
                                reg_sel_o <= 2'b01;
                                reg_wen_o <= 1'b1;
                            end

                            7'b0100000: begin // SUB
                                alu_op_o <= `ALU_SUB;
                                reg_sel_o <= 2'b01;
                                reg_wen_o <= 1'b1;
                            end
                        endcase
                    end

                    3'b001: begin // SLL
                        if (func7_i == 7'b0000000) begin
                            alu_op_o <= `ALU_SLL;
                            reg_sel_o <= 2'b01;
                            reg_wen_o <= 1'b1;
                        end
                    end

                    3'b010: begin // SLT
                        if (func7_i == 7'b0000000) begin
                            alu_op_o <= `ALU_LT;
                            reg_sel_o <= 2'b01;
                            reg_wen_o <= 1'b1;
                        end
                    end

                    3'b011: begin // SLTU
                        if (func7_i == 7'b0000000) begin
                            alu_op_o <= `ALU_LTU;
                            reg_sel_o <= 2'b01;
                            reg_wen_o <= 1'b1;
                        end
                    end

                    3'b100: begin // XOR
                        if (func7_i == 7'b0000000) begin
                            alu_op_o <= `ALU_XOR;
                            reg_sel_o <= 2'b01;
                            reg_wen_o <= 1'b1;
                        end
                    end

                    3'b101: begin // SRL, SRA
                        case (func7_i)
                            7'b0000000: begin // SRL
                                alu_op_o <= `ALU_SRL;
                                reg_sel_o <= 2'b01;
                                reg_wen_o <= 1'b1;
                            end
                            
                            7'b0100000: begin // SRA
                                alu_op_o <= `ALU_SRA;
                                reg_sel_o <= 2'b01;
                                reg_wen_o <= 1'b1;
                            end
                        endcase
                    end

                    3'b110: begin // OR
                        if (func7_i == 7'b0000000) begin
                            alu_op_o <= `ALU_OR;
                            reg_sel_o <= 2'b01;
                            reg_wen_o <= 1'b1;
                        end
                    end

                    3'b111: begin // AND
                        if (func7_i == 7'b0000000) begin
                            alu_op_o <= `ALU_AND;
                            reg_sel_o <= 2'b01;
                            reg_wen_o <= 1'b1;
                        end
                    end
                endcase
            end

            7'b0110111: begin // LUI
                imm_sel_o <= 3'b000;
                reg_sel_o <= 2'b10;
                reg_wen_o <= 1'b1;
            end

            7'b1100011: begin // BEQ, BNE, BLT, BGE, BLTU, BGEU
                case (func3_i)
                    3'b000: begin // BEQ
                        alu_op_o <= `ALU_EQ;
                        imm_sel_o <= 3'b010;
                        pc_sel_o <= (do_branch_i == 1'b1) ? 2'b10 : 2'b00;
                    end

                    3'b001: begin // BNE
                        alu_op_o <= `ALU_EQ;
                        imm_sel_o <= 3'b010;
                        pc_sel_o <= (do_branch_i == 1'b0) ? 2'b10 : 2'b00;
                    end

                    3'b100: begin // BLT
                        alu_op_o <= `ALU_LT;
                        imm_sel_o <= 3'b010;
                        pc_sel_o <= (do_branch_i == 1'b1) ? 2'b10 : 2'b00;
                    end

                    3'b101: begin // BGE
                        alu_op_o <= `ALU_GTE;
                        imm_sel_o <= 3'b010;
                        pc_sel_o <= (do_branch_i == 1'b1) ? 2'b10 : 2'b00;
                    end

                    3'b110: begin // BLTU
                        alu_op_o <= `ALU_LTU;
                        imm_sel_o <= 3'b010;
                        pc_sel_o <= (do_branch_i == 1'b1) ? 2'b10 : 2'b00;
                    end

                    3'b111: begin // BGEU
                        alu_op_o <= `ALU_GTEU;
                        imm_sel_o <= 3'b010;
                        pc_sel_o <= (do_branch_i == 1'b1) ? 2'b10 : 2'b00;
                    end
                endcase
            end

            7'b1100111: begin // JALR
                alu_op_o <= `ALU_JALR;
                imm_sel_o <= 3'b011;
                pc_sel_o <= 2'b01;
                reg_sel_o <= 2'b11;
                reg_wen_o <= 1'b1;
                rs2_sel_o <= 1'b1;
            end

            7'b1101111: begin // JAL
                imm_sel_o <= 3'b100;
                pc_sel_o <= 2'b10;
                reg_sel_o <= 2'b11;
                reg_wen_o <= 1'b1;
            end

            default: begin
                alu_op_o <= 4'b0000;
                imm_sel_o <= 2'b00;
                dmem_mask_o <= 2'b00;
                reg_sel_o <= 2'b00;
                pc_sel_o <= 2'b00;
                reg_wen_o <= 1'b0;
                dmem_wen_o <= 1'b0;
                rs1_sel_o <= 1'b0;
                rs2_sel_o <= 1'b0;
            end
        endcase
    end

endmodule
