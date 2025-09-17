module mux2_1_tb;
  logic [7:0] data_in0;
  logic [7:0] data_in1;
  logic sel;
  logic [7:0] data_out;
  
  mux2_1 #(8) uut(
    .data_in0(data_in0),
    .data_in1(data_in1),
    .sel(sel),
    .data_out(data_out)
  );
  
  initial begin
    $dumpfile("mux2_1_tb.vcd");
    $dumpvars(0,mux2_1_tb);
  end
  initial begin
    data_in0 = 8'h11;
    data_in1 = 8'h32;
    sel = 1'b1;
    #10;
    sel = 1'b0;
    #10;
    data_in0 = 8'hAF;
    #10;
    sel = 1'b1;
    #10;
    data_in1 = 8'hFA;
    #10 $finish;
  end
    
endmodule