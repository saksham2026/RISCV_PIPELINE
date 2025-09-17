//-----------------------------------------------------------------------------
// Title       : Parameterized 2:1 Multiplexer
// File        : mux2_1.sv
// Author      : Saksham Aggarwal
// Created     : 2025-09-17
// Description : Parameterized 2:1 multiplexer. Width can be configured using 
//               the parameter WIDTH. Uses 'always_comb' for combinational logic.
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module mux2_1 #(
    parameter WIDTH = 8   // Width of input and output buses
) (
    //-------------------------------------------------------------------------
    // Port Declarations
    //-------------------------------------------------------------------------
    input  logic [WIDTH-1:0] data_in0, // Input 0
    input  logic [WIDTH-1:0] data_in1, // Input 1
    input  logic             sel,      // Multiplexer select signal
    output logic [WIDTH-1:0] data_out // Multiplexer output
);

    //-------------------------------------------------------------------------
    // Combinational Logic
    //-------------------------------------------------------------------------
    // Use always_comb to infer combinational logic (synthesizable)
    always_comb begin
        // If sel = 0, output data_in0; else output data_in1
        if (!sel)
            data_out = data_in0;
        else
            data_out = data_in1;
    end

endmodule
