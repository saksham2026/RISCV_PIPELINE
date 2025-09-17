//-----------------------------------------------------------------------------
// Title       : Parameterized Instruction Memory (Read-Only)
// File        : instruction_memory.sv
// Author      : Saksham Aggarwal
// Created     : 2025-09-17
// Description : Parameterized instruction memory for RISC-V or similar CPUs.
//               Supports asynchronous read with read enable and memory
//               initialization from an external hex file.
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module instruction_memory #(
    //-------------------------------------------------------------------------
    // Parameter Definitions
    //-------------------------------------------------------------------------
    parameter WIDTH        = 32,                 // Instruction width in bits
    parameter SIZE         = 1024,               // Number of memory locations
    parameter ADDRESS_SIZE = 10,                 // Address width (log2(SIZE))
    parameter MEM_INIT_FILE = "instruction.mif" // Memory initialization file
) (
    //-------------------------------------------------------------------------
    // Port Declarations
    //-------------------------------------------------------------------------
    input  logic [ADDRESS_SIZE-1:0] addr,       // Address input
    input  logic                     read_en,   // Read enable
    output logic [WIDTH-1:0]         instruction // Instruction output
);

    //-------------------------------------------------------------------------
    // Memory Declaration
    //-------------------------------------------------------------------------
    logic [WIDTH-1:0] imem [0:SIZE-1];

    //-------------------------------------------------------------------------
    // Memory Initialization from file
    //-------------------------------------------------------------------------
    initial begin
    $readmemh(MEM_INIT_FILE, imem);
    for (int i = 16; i < SIZE; i++) imem[i] = 0;
	end


    //-------------------------------------------------------------------------
    // Asynchronous Read Logic
    //-------------------------------------------------------------------------
    always_comb begin
        if (read_en)
            instruction = imem[addr];  // Read instruction from memory
        else
            instruction = '0;          // Output zero when read disabled
    end

endmodule
