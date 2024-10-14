`timescale 1ns/1ps

// divide input clock signal by value to output clock signal
module clock_div 
#(
    parameter DIVISOR = 2 // amount to divide clock by
)
(
    input wire clk_i,   // clock
    input wire reset_i, // reset
    output reg clk_o    // divided clock
);
    // wires/regs
    reg [$clog2(DIVISOR)-1:0] counter = 0;

    // register logic
    always @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            counter <= 0;
            clk_o <= 0;
        end else begin
            // check if counter reached
            if (counter == (DIVISOR - 1)) begin
                counter <= 0;
                clk_o <= ~clk_o; // toggle
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
