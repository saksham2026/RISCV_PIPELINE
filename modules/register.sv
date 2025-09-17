//-----------------------------------------------------------------------------
// Title       : Parameterized D Flip-Flop Register with Synchronous Reset
// File        : register.sv
// Author      : Saksham Aggarwal
// Created     : 2025-09-17
// Description : Parameterized register module with synchronous reset. 
//               Uses always_ff to infer flip-flops.
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module register #(
    parameter WIDTH = 8  // Width of the register
) (
    input  logic              clk,      // Clock input
    input  logic              rst,      // Active-high synchronous reset
    input  logic [WIDTH-1:0]  data_in,  // Data input
    output logic [WIDTH-1:0]  data_out  // Data output
);

    //-------------------------------------------------------------------------
    // Sequential Logic: Register with synchronous reset
    //-------------------------------------------------------------------------
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= '0;          // Reset output to 0
        else
            data_out <= data_in;     // Latch input on rising edge of clk
    end

endmodule
