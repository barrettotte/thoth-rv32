`timescale 1ns/1ps

// n-bit D Flip-Flop
module n_dff
    #(
        parameter N_BITS = 8 // data bits
    )
    (
        input wire clk_i,            // clock
        input wire reset_i,          // reset
        input wire [N_BITS-1:0] d_i, // input data
        output reg [N_BITS-1:0]  q_o // output data
    );

    always @(posedge clk_i or posedge reset_i) begin
        if (reset_i) begin
            q_o <= 1'b0;
        end else begin
            q_o <= d_i;
        end
    end

endmodule
