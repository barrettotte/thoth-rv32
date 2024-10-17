`timescale 1ns/1ps

`include "./soc.v"

module top
(
    input wire clk_i,   // clock
    input wire reset_i, // reset

    // debug ports
    output wire [15:0] r1_o 
);
    wire [31:0] r1;

    assign r1_o = r1[15:0];

    soc #(
        .CLK_FREQ(100 * (10**6)), // 100MHz
        .CORE_FREQ(1 * (10**6)),  // 1MHz
        .IMEM_SIZE(256),
        .DMEM_SIZE(256)
    ) soc0 (
        .clk_i(clk_i),
        .reset_i(reset_i),
        
        // debug ports
        .r1_o(r1),
        .r2_o(),
        .r3_o()
    );

endmodule
