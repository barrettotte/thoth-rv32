`timescale 1ns/1ps

// data memory
module data_mem
#(
    parameter MEM_SIZE=1024 // memory size in bytes
)
(
    input wire clk_i,          // clock
    input wire wen_i,          // write enable
    input wire [2:0] mask_i,   // mask (byte, half, word)
    input wire [31:0] addr_i,  // address
    input wire [31:0] wdata_i, // data to write
    output wire [31:0] rdata_o // data read
);
    reg [7:0] mem [MEM_SIZE-1:0];

    // read data from memory
    assign rdata_o = (mask_i == 3'b001) ? {{16{1'b0}}, mem[addr_i], mem[addr_i + 1]}           // 2 byte (LHU)
                   : (mask_i == 3'b101) ? {{16{mem[addr_i][7]}}, mem[addr_i], mem[addr_i + 1]} // 2 byte sign ext (LH)
                   : (mask_i == 3'b010) ? {{24{1'b0}}, mem[addr_i]}                            // 1 byte (LBU)
                   : (mask_i == 3'b110) ? {{24{mem[addr_i][7]}}, mem[addr_i]}                  // 1 byte sign ext (LB)
                   : {mem[addr_i], mem[addr_i + 1], mem[addr_i + 2], mem[addr_i + 3]};         // 4 byte (LW)
    
    // write data to memory
    always @(posedge clk_i) begin
        if (wen_i) begin
            case (mask_i)
                3'b001:  {mem[addr_i], mem[addr_i + 1]} <= wdata_i[15:0];                             // 2 byte (SH)
                3'b010:  {mem[addr_i]} <= wdata_i[7:0];                                               // 1 byte (SB)
                default: {mem[addr_i], mem[addr_i + 1], mem[addr_i + 2], mem[addr_i + 3]} <= wdata_i; // 4 byte (SW)
            endcase
        end
    end

endmodule
