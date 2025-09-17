//-----------------------------------------------------------------------------
// Title       : 2:1 Multiplexer Testbench
// File        : mux2_1_tb.sv
// Author      : Saksham Aggarwal
// Created     : 2025-09-17
// Description : Testbench for parameterized 2:1 multiplexer module (mux2_1).
//               Demonstrates stimulus generation, waveform dumping, and 
//               verification of functionality.
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module mux2_1_tb;

  //-------------------------------------------------------------------------
  // Parameter Definitions
  //-------------------------------------------------------------------------
  localparam DATA_WIDTH = 8;       // Width of the input/output buses
  localparam DELAY      = 10;      // Delay for stimulus changes (ns)

  //-------------------------------------------------------------------------
  // Signal Declarations
  //-------------------------------------------------------------------------
  logic [DATA_WIDTH-1:0] data_in0; // Input 0 to the mux
  logic [DATA_WIDTH-1:0] data_in1; // Input 1 to the mux
  logic                  sel;      // Multiplexer select signal
  logic [DATA_WIDTH-1:0] data_out; // Multiplexer output

  //-------------------------------------------------------------------------
  // DUT Instantiation
  //-------------------------------------------------------------------------
  mux2_1 #(.WIDTH(DATA_WIDTH)) uut (
    .data_in0(data_in0),
    .data_in1(data_in1),
    .sel(sel),
    .data_out(data_out)
  );

  //-------------------------------------------------------------------------
  // Waveform Dumping
  //-------------------------------------------------------------------------
  initial begin
    $dumpfile("mux2_1_tb.vcd");     // VCD file for waveform viewing
    $dumpvars(0, mux2_1_tb);        // Dump all signals in this module
  end

  //-------------------------------------------------------------------------
  // Test Stimulus
  //-------------------------------------------------------------------------
  initial begin
    // Initialize inputs
    data_in0 = 8'h11;
    data_in1 = 8'h32;
    sel      = 1'b1;

    // Apply test cases with delays
    #DELAY; sel = 1'b0;              // Test select = 0
    #DELAY; data_in0 = 8'hAF;        // Change data_in0
    #DELAY; sel = 1'b1;              // Test select = 1
    #DELAY; data_in1 = 8'hFA;        // Change data_in1

    #DELAY; $finish;                 // End simulation
  end

  //-------------------------------------------------------------------------
  // Optional Monitoring (for console output)
  //-------------------------------------------------------------------------
  initial begin
    $display("Time(ns) | sel | data_in0 | data_in1 | data_out");
    $monitor("%8t |  %b  |   %h    |   %h    |   %h",
              $time, sel, data_in0, data_in1, data_out);
  end

endmodule
