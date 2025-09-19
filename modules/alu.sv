//-----------------------------------------------------------------------------
// Title       : Arithmetic Logic Unit (ALU)
// File        : alu.sv
// Author      : Saksham Aggarwal
// Created     : 2025-09-19
// Description : ALU implementation supporting arithmetic, logical, shift,
//               and comparison operations.
//-----------------------------------------------------------------------------

module alu (
  input  logic [4:0]  sel,     // ALU operation selector
  input  logic [31:0] data1,   // Operand 1
  input  logic [31:0] data2,   // Operand 2
  output logic [31:0] result   // ALU result
);

  // Combinational ALU operation
  always_comb begin
    unique case (sel)
      5'd0: result = $signed(data1) + $signed(data2);  // Signed addition
      5'd1: result = $signed(data1) - $signed(data2);  // Signed subtraction
      5'd2: result = data1 & data2;                    // Bitwise AND
      5'd3: result = data1 | data2;                    // Bitwise OR
      5'd4: result = data1 ^ data2;                    // Bitwise XOR
      5'd5: result = data1 << 1;                       // Logical left shift by 1
      5'd6: result = data1 >> 1;                       // Logical right shift by 1
      5'd7: result = $signed(data1) >>> 1;             // Arithmetic right shift by 1
      5'd8: result = (data1 > data2) ? 32'd1 : 32'd0;  // Comparison: data1 > data2
      5'd9: result = (data2 > data1) ? 32'd1 : 32'd0;  // Comparison: data2 > data1
      default: result = 32'd0;                         // Default case
    endcase
  end

endmodule
