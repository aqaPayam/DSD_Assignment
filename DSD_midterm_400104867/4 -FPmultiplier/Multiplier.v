module Multiplication
#( 
    parameter frac_bits =23 ,
    parameter exp_bits = 8 
)
(
    input [exp_bits+frac_bits:0] a,
    input [exp_bits+frac_bits:0] b,
    output exception,
    output overflow,
    output underflow,
    output [exp_bits+frac_bits:0] res
);


wire sign,round,normalised,zero;
wire [exp_bits:0] exponent,sum_exponent;
wire [frac_bits - 1 :0] product_mantissa;
wire [frac_bits :0] op_a,op_b;  // inja ye yek ya sefr mizarim baghal mantisa
wire [2 * (frac_bits + 1) - 1:0] product , product_normalised; 


assign sign = a[frac_bits + exp_bits] ^ b[frac_bits + exp_bits];				
assign exception = (&a[frac_bits + exp_bits - 1 :frac_bits]) | (&b[frac_bits + exp_bits -1:frac_bits]);//111....11 = NAN bayad error dad

assign op_a = (|a[frac_bits + exp_bits - 1 :frac_bits]) ? {1'b1,a[frac_bits - 1 :0]} : {1'b0,a[frac_bits - 1 :0]};
assign op_b = (|b[frac_bits + exp_bits - 1 :frac_bits]) ? {1'b1,b[frac_bits - 1 :0]} : {1'b0,b[frac_bits - 1 :0]};

// alan op_a op_b ba tavajoh be denormiliza ya halat adi sakhte shodan va bayad zarb beshan

assign product = op_a * op_b;

assign normalised = product[2 * (frac_bits + 1) - 1] ? 1'b1 : 1'b0;	
//age yek bashe bayad frac taye 1 + 23bi(frac) + 24 bit round 
//age 0 bashe --> 0 + X. 23 bit(frac) + 23 bit round
assign product_normalised = normalised ? product : product << 1;
// alan kolan bayad X. 23 bit(frac) + 24(frac + 1) bit round berim 
assign round = |product_normalised[frac_bits:0]; //frac bit ya frac bit -1 SHAK DARAM DEBUG SHOD

assign product_mantissa = product_normalised[2 * (frac_bits ) :frac_bits + 1] + (product_normalised[frac_bits] & round); 	
 

assign zero = exception ? 1'b0 : (product_mantissa == {frac_bits{1'b0}}) ? 1'b1 : 1'b0;

assign sum_exponent = a[frac_bits + exp_bits -1 :frac_bits] + b[frac_bits + exp_bits -1 :frac_bits];
// jam zadan exp

assign exponent = sum_exponent - ({1'b0, {(exp_bits-1){1'b1}} }) + normalised;
//jam ke mizani - 127 ya 2 ^frac -1 -1 bayad bokoni age ham normalaie bood bekhatere yedoone shift in yedoone ziad mishe

assign overflow = ((exponent[exp_bits] & !exponent[exp_bits-1]) & !zero) ;
// bish az 255 beshe ke ja nemishe to exp
assign underflow = ((exponent[exp_bits] & exponent[exp_bits-1]) & !zero) ? 1'b1 : 1'b0;
//jam Exp ha kamtar az 127(2^frac-1 -1) --> underflow 

assign res = exception ? {(frac_bits + exp_bits +1) {1'b0}} : zero ? {{(frac_bits + exp_bits + 1) {1'b0}}} : overflow ? {sign,{exp_bits{1'b1}},{frac_bits{1'b0}} } : underflow ? {sign,{(frac_bits + exp_bits) {1'b0}}} : {sign,exponent[exp_bits - 1:0],product_mantissa};



endmodule

module TestBench;

// 32 bit be shekl 8 exp 23 frac test mikonim vali har chiz dige i ham ghabel teste
reg [31:0] a,b;
wire exception,overflow,underflow;
wire [31:0] res;

reg clk = 1'b1;

Multiplication #(.exp_bits(8),.frac_bits(23)) multiplier (a,b,exception,overflow,underflow,res);



initial
begin
$dumpfile("Fp_mult.vcd");
$dumpvars(0, TestBench);
end

initial
begin

test (32'hC2AEDFBE,32'h430F8F5C,32'hC64421D2);
//143.56 * -87.437 = -12552.455

test (32'h436A58BB,32'h3B83126F,32'h3F6FF88F);
// 234.3466 * 0.004 = 0.93738645

test (32'h4234851F,32'h427C851F,32'h453210EA);
// 45.13 * 63.13 = 2849.0571;

test (32'h4049999A,32'hC1663D71,32'hC2355063);
//3.15 * -14.39 = -45.328503

test (32'hC1526666,32'hC240A3D7,32'h441E5374);
//-13.15 * -48.16 = 633.30396

test (32'h00000000,32'h00000000,32'h00000000);
// 0 * 0 = 0;

test (32'hC1526666,32'h00000000,32'h00000000);
//-13.15 * 0 = 0;

test (32'h7F800000,32'h7F800000,32'h00000000); 
// Inf * Inf = Inf

test (32'h3089705F,32'h3089705F,32'h219392EE);
//1E-9 * 1E-9 = 9.999999E-19

test (32'h60AD78EC,32'h7E967699,32'h7F800000);
//1E20 * 1E38 = inf


test (32'h60AD78EC,32'h7E967699,32'h7F800000);
//1E20 * 1E38 = inf

$stop;

end

task test(
input [31:0] op_a,op_b,expected_Res
);
begin
	a = op_a;
	b = op_b;
    #10;
  //  $display("BINARY : \n");
 //	$display ("Run :a = %b , b = %b \n Result = %b \n expected result = %b, \n  Exception = %d,  Overflow = %d,   Underflow = %d  \n ",a,b,res,expected_Res,exception,overflow,underflow);
    $display("HEX : \n");
    $display ("Run :a = %h , b = %h \n Result = %h \n expected result = %h, \n  Exception = %d,  Overflow = %d,   Underflow = %d  \n ",a,b,res,expected_Res,exception,overflow,underflow);
    if (expected_Res == res)
        $display("True answer");
    else
        $display("False answer");
end
endtask

endmodule