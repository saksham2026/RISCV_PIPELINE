//-----------------------------------------------------------------------------
// Title       : Testbench for Parameterized Instruction Memory
// File        : instruction_memory_tb.sv
// Author      : Saksham Aggarwal
// Created     : 2025-09-17
// Description : Testbench for instruction_memory module. Tests asynchronous
//               read functionality with read enable, memory initialization,
//               and waveform monitoring.
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module instruction_memory_tb;

    //-------------------------------------------------------------------------
    // Parameters
    //-------------------------------------------------------------------------
    localparam WIDTH        = 32;
    localparam SIZE         = 1024;
    localparam ADDRESS_SIZE = 10;
    localparam DELAY        = 10; // General delay for stimulus

    //-------------------------------------------------------------------------
    // Signals
    //-------------------------------------------------------------------------
    logic [ADDRESS_SIZE-1:0] addr;
    logic                     read_en;
    logic [WIDTH-1:0]         instruction;

    //-------------------------------------------------------------------------
    // DUT Instantiation
    //-------------------------------------------------------------------------
    instruction_memory #(
        .WIDTH(WIDTH),
        .SIZE(SIZE),
        .ADDRESS_SIZE(ADDRESS_SIZE),
        .MEM_INIT_FILE("instruction.mif")
    ) uut (
        .addr(addr),
        .read_en(read_en),
        .instruction(instruction)
    );

    //-------------------------------------------------------------------------
    // Waveform Dump
    //-------------------------------------------------------------------------
    initial begin
        $dumpfile("instruction_memory_tb.vcd");
        $dumpvars(0, instruction_memory_tb);
    end

    //-------------------------------------------------------------------------
    // Test Stimulus
    //-------------------------------------------------------------------------
    initial begin
        // Initialize signals
        addr    = 0;
        read_en = 0;

        // Wait a moment
        #DELAY;

        // Test 1: Read first instruction
        read_en = 1;
        addr    = 0;
        #DELAY;

        // Test 2: Read a middle instruction
        addr = 5;
        #DELAY;

        // Test 3: Read last instruction
        addr = SIZE - 1;
        #DELAY;

        // Test 4: Disable read
        read_en = 0;
        addr    = 0;
        #DELAY;

        // Test 5: Read multiple instructions sequentially
        read_en = 1;
        for (int i = 0; i < 10; i++) begin
            addr = i;
            #DELAY;
        end

        // End simulation
        #DELAY $finish;
    end

    //-------------------------------------------------------------------------
    // Optional Monitoring
    //-------------------------------------------------------------------------
    initial begin
        $display("Time(ns) | read_en | addr  | instruction");
        $monitor("%8t |    %b    | %h  | %h",
                 $time, read_en, addr, instruction);
    end

endmodule
