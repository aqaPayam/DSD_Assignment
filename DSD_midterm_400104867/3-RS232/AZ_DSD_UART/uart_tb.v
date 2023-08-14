module uart_tb;
reg clk=0;
always #5 clk = ~clk;

reg rst = 0;
reg rx_in_bit;
reg[6:0] data_in;
reg transmit_en = 0;

wire[6:0] data_out;
wire is_transmitted;
wire is_received;
wire parity;
wire tx_out_bit;
 
UART tx(.clk(clk), .rst(rst), .data_in(data_in), .transmit_en(transmit_en),
 .is_transmitted(is_transmitted), .tx_out_bit(tx_out_bit), .data_out(data_out),
  .is_received(is_received), .rx_in_bit(tx_out_bit), .parity(parity));

// UART rx(.clk(clk), .rst(rst), .data_out(data_out), .transmit_en(1'b0),
//  .is_received(is_received), .rx_in_bit(tx_out_bit), .parity(parity));

initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, uart_tb);
    rst = 1;
    #3000
    rst = 0;
    #1340
    #4340
    data_in = 7'b0010111;
    #4340
    transmit_en = 1;
    #4340
    #4340
    #4340
    #4340
    #4340
    #4340
    #4340
    #4340
    #4340
    #4340
    #4340
    transmit_en = 0;
    #4340
    transmit_en = 1;
    data_in = 7'b1100001;
    #4340
    #4340
    #4340
    #4340
    #4340
    #4340
    #4340
    #4340
    #4340
    #4340
    #4340
    #5
    $finish;
end



endmodule