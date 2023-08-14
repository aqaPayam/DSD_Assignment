module ALU #(
    parameter  data_width = 16
)
(
    input clk,
    input[data_width-1 : 0] data,
    input [2:0]control,
    output reg [data_width-1 : 0]Acc,
    output reg Carry ,
    output Zero ,
    output reg Overflow ,
    output Sign
);

assign Sign = Acc[data_width-1];
assign Zero = ~|Acc[data_width-1 : 0];

 always @(posedge clk)
  begin 
     case (control)
       3'b000 :  //HOLD
        begin
            Carry = 0;
            Overflow = 0;
        end 
       3'b001 : //CLEAR
        begin 
            Acc = 0; 
            Carry = 0;
            Overflow = 0;
        end
       3'b010 :  ///ADD
        begin 
            {Carry,Acc} <= Acc + data;
            if (Acc[data_width - 1] == data[data_width - 1] &&  ((Acc+data) >> (data_width - 1)) & 1'b1  !=  (Acc >> (data_width - 1))& 1'b1 )
                Overflow = 1;
            else
                Overflow = 0;    
        end
       3'b011 : //SUB
        begin 
            {Carry,Acc} <= Acc - data;
            if (Acc[data_width - 1] != data[data_width - 1] &&  ((Acc-data) >> (data_width - 1)) & 1'b1  !=  (Acc >> (data_width - 1))& 1'b1 )
                Overflow = 1;
            else
                Overflow = 0; 
        end
       3'b100 : //AND
        begin 
            Acc = Acc & data; 
            Carry = 0;
            Overflow = 0;
        end
       3'b101 : // NEGATIVE
        begin 
            Acc = - Acc ; 
            Carry = 0;
            Overflow = 0;
        end
       3'b110 : //NOT
        begin
            Acc = ~ Acc ;
            Carry = 0;
            Overflow = 0; 
        end
       3'b111 : //XOR
        begin 
            Acc = Acc ^ data ;
            Carry = 0;
            Overflow = 0;
        end
     endcase
  end

endmodule


module TestBench;
    reg clk;
    reg [15:0]in;
    reg [2:0]control;
    wire [15:0]out;
    wire Carry;
    wire Zero;
    wire Overflow;
    wire Sign;
    ALU #(16) alu(clk,in,control,out,Carry,Zero,Overflow,Sign);

    initial
    begin
    $dumpfile("Acc_ALU.vcd");
    $dumpvars(0, TestBench);
    end

    always #5 clk = ~ clk;

    initial begin
    clk <= 1;
    {in,control} <= 0 ;

    #1;
    test(3'b001,16'd0);
    test(3'b010,16'd5);
    test(3'b000,16'd0);
    test(3'b010,16'd15);

    test(3'b011,16'd7);

    test(3'b001,16'd0);

    test(3'b010,16'd5); 
    test(3'b111,16'd10);

    test(3'b110,16'd0);

    test(3'b000,16'd0);
    test(3'b010,16'd15);

    test(3'b101,16'd0);

    test(3'b100,16'b0101010100101001);


    test(3'b010,16'b0111111111111111);
    test(3'b010,16'b0111111111111111);
    test(3'b010,16'b0111111111111111);


    test(3'b011,16'b0111111111111111);
    test(3'b011,16'b0111111111111111);
    test(3'b011,16'b0111111111111111);
    test(3'b011,16'b1000000000000000);   
    test(3'b011,16'b1000000000000000);
    




    // "hold": control = 3'b000; OK
    // "clear": control = 3'b001; OK
    // "add": control = 3'b010;   OK
    // "sub": control = 3'b011; 
    // "and": control = 3'b100;  OK
    // "neg": control = 3'b101; OK
    // "not": control = 3'b110;  OK
    // "xor": control = 3'b111; OK

    $stop;

    end


task test(
input [2:0] act,
input [15:0] data_in
);
begin
    #5;
    in <= data_in;
    control <= act;
    #5;
    case(control)
    3'b000 : $display("hold");
    3'b001 : $display("clear");
    3'b010 : $display("add :: in is %d" ,in);
    3'b011 : $display("sub :: in is %d" , in);
    3'b100 : $display("and :: in is %d" ,in);
    3'b101 : $display("neg");
    3'b110 : $display("not");
    3'b111 : $display("xor :: in is %d" , in);
    endcase
    $display("out is(BINARY) : %b",out);
    $display("out is : %d",out);
    $display("Carry: %d Zero: %d Overflow: %d Sign : %d\n",Carry,Zero,Overflow,Sign);
  
end
endtask

    
endmodule



