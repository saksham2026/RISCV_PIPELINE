module register_tb;
  logic clk;
  logic rst;
  logic [7:0] data_in;
  logic [7:0] data_out;
  
  register #(8) uut(
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .data_out(data_out)
  );
  initial begin
    $dumpfile("testbench.vcd");
    $dumpvars(0,register_tb);
  end
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial begin
    rst = 0;
    #12 rst = 1'b1;
    #10 data_in = 8'h11;
    #10 data_in = 8'h3A;
    #10 data_in = 8'hF1;
    #10 $finish;
  end
              
endmodule