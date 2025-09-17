module mux2_1 #(
parameter WIDTH = 8)
  ( 
    input logic [WIDTH-1:0] data_in0,
    input logic [WIDTH-1:0] data_in1,
    input logic sel,
    output logic [WIDTH-1:0] data_out
  );
  always_comb begin
    
    if(!sel) data_out = data_in0;
    else data_out = data_in1;
    
  end
endmodule