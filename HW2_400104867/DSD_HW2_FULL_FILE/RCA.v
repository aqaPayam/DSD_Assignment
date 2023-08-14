`timescale 1ns/1ns 

module HA(a,b,sum,cout);
input a,b;
output reg sum,cout;

always @(*) 
  begin
   #2 
   cout = a & b;
  end
  
  always @(*) 
  begin
  #3
  sum = a ^ b;
  end
  
endmodule



module FA( 
  input a, b, Cin, 
  output S, Cout
  );  
  
  wire w1, w2, w3;    
  HA HA1(a, b, w1, w2);
  
  HA HA2(w1, Cin,S, w3);
  
  or(Cout,w2, w3);
  
endmodule  


module Adder(a,b,cin,sum,cout);
input [3:0]a,b;
input cin;
output wire [3:0]sum;
output cout;

wire cout1, cout2, cout3;

FA FA1(a[0],b[0],cin,sum[0],cout1);
FA FA2(a[1],b[1],cout1,sum[1],cout2);
FA FA3(a[2],b[2],cout2,sum[2],cout3);
FA FA4(a[3],b[3],cout3,sum[3],cout);
endmodule

