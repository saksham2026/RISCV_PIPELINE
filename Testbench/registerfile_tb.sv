//-----------------------------------------------------------------------------
// Title       : Testbench for Parameterized Register File
// File        : register_file_tb.sv
// Author      : Saksham Aggarwal
// Created     : 2025-09-18
// Description : Self-checking testbench for register_file module. 
//               - Tests reset, write, read enable, and zero-register protection
//               - Uses waveform dump for debugging
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module register_file_tb;

  // Parameters
  localparam int REG_COUNT    = 32;
  localparam int DATA_WIDTH   = 32;
  localparam bit ZERO_PROTECT = 1;

  // DUT signals
  logic clk_i;
  logic rst_i;
  logic write_en_i;
  logic read_en_i;
  logic [$clog2(REG_COUNT)-1:0] read_addr1_i;
  logic [$clog2(REG_COUNT)-1:0] read_addr2_i;
  logic [$clog2(REG_COUNT)-1:0] write_addr_i;
  logic [DATA_WIDTH-1:0]        write_data_i;
  logic [DATA_WIDTH-1:0]        read_data1_o;
  logic [DATA_WIDTH-1:0]        read_data2_o;

  // DUT instantiation
  register_file #(
      .REG_COUNT(REG_COUNT),
      .DATA_WIDTH(DATA_WIDTH),
      .ZERO_PROTECT(ZERO_PROTECT)
  ) dut (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .write_en_i(write_en_i),
      .read_en_i(read_en_i),
      .read_addr1_i(read_addr1_i),
      .read_addr2_i(read_addr2_i),
      .write_addr_i(write_addr_i),
      .write_data_i(write_data_i),
      .read_data1_o(read_data1_o),
      .read_data2_o(read_data2_o)
  );

  // Clock generation: 10 ns period
  initial clk_i = 0;
  always #5 clk_i = ~clk_i;

  // Reset
  initial begin
    rst_i = 1;
    write_en_i = 0;
    read_en_i  = 0;
    write_addr_i = '0;
    write_data_i = '0;
    read_addr1_i = '0;
    read_addr2_i = '0;
    repeat (2) @(posedge clk_i); // Hold reset for 2 cycles
    rst_i = 0;
  end

  // Test sequence
  initial begin
    $display("---- Starting Register File Testbench ----");
    $dumpfile("register_file_tb.vcd");
    $dumpvars(0, register_file_tb);

    // Wait for reset release
    @(negedge rst_i);

    // Test 1: Write and read back
    $display("Test 1: Write and read back");
    @(negedge clk_i); // Apply stimulus on negedge
    write_en_i   = 1;
    write_addr_i = 5'd5;
    write_data_i = 32'hDEADBEEF;
    @(posedge clk_i); // Data gets written here
    @(negedge clk_i);
    write_en_i = 0;

    // Read back
    @(negedge clk_i);
    read_en_i    = 1;
    read_addr1_i = 5'd5;
    @(posedge clk_i);
    if (read_data1_o !== 32'hDEADBEEF) begin
      $error("Readback mismatch: expected DEADBEEF, got %h", read_data1_o);
    end else begin
      $display("Readback OK: %h", read_data1_o);
    end
    read_en_i = 0;

    // Test 2: Zero register protection
    $display("Test 2: Zero register protection");
    @(negedge clk_i);
    write_en_i   = 1;
    write_addr_i = 5'd0;
    write_data_i = 32'hFFFFFFFF;
    @(posedge clk_i);
    @(negedge clk_i);
    write_en_i   = 0;
    read_en_i    = 1;
    read_addr1_i = 5'd0;
    @(posedge clk_i);
    if (read_data1_o !== 32'h0) begin
      $error("Zero register protection failed!");
    end else begin
      $display("Zero register protection OK");
    end
    read_en_i = 0;

    // Test 3: Multiple reads
    $display("Test 3: Multiple reads");
    @(negedge clk_i);
    write_en_i   = 1;
    write_addr_i = 5'd10;
    write_data_i = 32'h12345678;
    @(posedge clk_i);
    @(negedge clk_i);
    write_en_i = 0;

    @(negedge clk_i);
    read_en_i    = 1;
    read_addr1_i = 5'd10;
    read_addr2_i = 5'd5;
    @(posedge clk_i);
    $display("Read1: %h, Read2: %h", read_data1_o, read_data2_o);
    read_en_i = 0;

    // Finish
    $display("---- Register File Testbench Completed ----");
    #20 $finish;
  end

endmodule
