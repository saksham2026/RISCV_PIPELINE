//-----------------------------------------------------------------------------
// Title       : Exhaustive Testbench for ALU with Waveforms
// File        : alu_tb.sv
// Author      : Saksham Aggarwal
// Created     : 2025-09-19
// Description : Testbench for alu.sv with exhaustive stimulus and waveform dump
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module alu_tb;

  // DUT interface signals
  logic [4:0]  sel;
  logic [31:0] data1, data2;
  logic [31:0] result;

  // Instantiate DUT
  alu uut (
    .sel    (sel),
    .data1  (data1),
    .data2  (data2),
    .result (result)
  );

  // Task to apply stimulus and check result
  task run_test(input [4:0] op_sel, input [31:0] a, input [31:0] b);
    logic [31:0] expected;
    begin
      sel   = op_sel;
      data1 = a;
      data2 = b;
      #5; // small delay for combinational settle

      // Compute expected value
      unique case (op_sel)
        5'd0: expected = $signed(a) + $signed(b);
        5'd1: expected = $signed(a) - $signed(b);
        5'd2: expected = a & b;
        5'd3: expected = a | b;
        5'd4: expected = a ^ b;
        5'd5: expected = a << 1;
        5'd6: expected = a >> 1;
        5'd7: expected = $signed(a) >>> 1;
        5'd8: expected = (a > b) ? 32'd1 : 32'd0;
        5'd9: expected = (b > a) ? 32'd1 : 32'd0;
        default: expected = 32'd0;
      endcase

      // Print results
      $display("Time=%0t | sel=%0d | data1=%0d | data2=%0d | result=%0d | expected=%0d %s",
               $time, op_sel, a, b, result, expected,
               (result === expected) ? "[PASS]" : "[FAIL]");
    end
  endtask

  // Stimulus process
  initial begin
    // 🔹 VCD dump for GTKWave
    $dumpfile("alu_tb.vcd");   // waveform output file
    $dumpvars(0, alu_tb);      // dump all signals recursively

    // Run tests
    run_test(0, 32'd10, 32'd5);     // Add
    run_test(1, 32'd10, 32'd5);     // Sub
    run_test(2, 32'hFF00FF00, 32'h0F0F0F0F); // AND
    run_test(3, 32'hF0F0F0F0, 32'h0F0F0F0F); // OR
    run_test(4, 32'hAAAA5555, 32'h12345678); // XOR
    run_test(5, 32'd8, 32'd0);      // Left shift
    run_test(6, 32'd8, 32'd0);      // Right shift
    run_test(7, -32'sd16, 32'd0);   // Arithmetic right shift
    run_test(8, 32'd20, 32'd10);    // Greater than
    run_test(9, 32'd5, 32'd15);     // Less than

    // Corner cases
    run_test(0, 32'h7FFFFFFF, 32'd1);  // Overflow add
    run_test(1, 32'h80000000, 32'd1);  // Underflow sub
    run_test(7, -32'sd1, 32'd0);       // Arithmetic shift of -1
    run_test(2, 32'hFFFFFFFF, 32'h0);  // AND with zero
    run_test(3, 32'hFFFFFFFF, 32'h0);  // OR with zero

    $display("All tests completed.");
    $finish;
  end

endmodule
