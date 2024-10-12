`timescale 1ns/1ps

`include "./n_dff.v"

module top (
        input wire clk_i,     // clock
        input wire reset_i,   // reset
        input wire [7:0] d_i, // input data
        output wire [7:0] q_o // output data
    );
    
    // instantiate n-bit D Flip-Flop
    n_dff #(.N_BITS(8)) dff (
        .clk_i(clk_i),
        .reset_i(reset_i),
        .d_i(d_i),
        .q_o(q_o)
    );

endmodule
