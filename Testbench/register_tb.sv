//-----------------------------------------------------------------------------
// Title       : Testbench for Parameterized Register
// File        : register_tb.sv
// Author      : Saksham Aggarwal
// Created     : 2025-09-17
// Description : Testbench for register module. Generates clock, reset, and
//               stimulus. Dumps waveform and prints monitored output.
//-----------------------------------------------------------------------------

`timescale 1ns/1ps

module register_tb;

    //-------------------------------------------------------------------------
    // Parameters
    //-------------------------------------------------------------------------
    localparam WIDTH = 8;        // Width of the register
    localparam CLK_PERIOD = 10;  // Clock period in ns

    //-------------------------------------------------------------------------
    // Signals
    //-------------------------------------------------------------------------
    logic clk;
    logic rst;
    logic [WIDTH-1:0] data_in;
    logic [WIDTH-1:0] data_out;

    //-------------------------------------------------------------------------
    // DUT Instantiation
    //-------------------------------------------------------------------------
    register #(.WIDTH(WIDTH)) uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out)
    );

    //-------------------------------------------------------------------------
    // Clock Generation
    //-------------------------------------------------------------------------
    initial clk = 0;
    always #(CLK_PERIOD/2) clk = ~clk; // 50% duty cycle clock

    //-------------------------------------------------------------------------
    // Waveform Dump
    //-------------------------------------------------------------------------
    initial begin
        $dumpfile("register_tb.vcd");
        $dumpvars(0, register_tb);
    end

    //-------------------------------------------------------------------------
    // Test Stimulus
    //-------------------------------------------------------------------------
    initial begin
        // Initialize signals
        rst = 0;
        data_in = '0;

        // Apply reset
        #12 rst = 1'b1;
        #10 rst = 1'b0;

        // Apply data inputs
        #10 data_in = 8'h11;
        #10 data_in = 8'h3A;
        #10 data_in = 8'hF1;

        // Finish simulation
        #10 $finish;
    end

    //-------------------------------------------------------------------------
    // Optional Monitoring
    //-------------------------------------------------------------------------
    initial begin
        $display("Time(ns) | clk | rst | data_in | data_out");
        $monitor("%8t |  %b  |  %b  |   %h   |   %h",
                 $time, clk, rst, data_in, data_out);
    end

endmodule
