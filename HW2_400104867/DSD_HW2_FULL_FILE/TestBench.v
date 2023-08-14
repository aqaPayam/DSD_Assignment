`timescale 1ns/1ns

module TestBench;
  
  initial begin     
  $dumpfile("waveform.vcd");     
  $dumpvars(0,TestBench);   
  end
  
  
  reg [3:0] A;
  reg [3:0] B;
  reg C_in;
  
  wire [3:0] S;
  wire C_out;

  Adder adder(A, B, C_in, S, C_out);

  initial
  begin
		A = 4'b1010; 
		B = 4'b0101; 
		C_in = 1'b1;
  end  

endmodule


