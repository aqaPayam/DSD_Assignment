module UART (
    input[6:0] data_in,
    input transmit_en,
    input rst,
    input clk,
    input rx_in_bit,

    output[6:0] data_out,
    output is_transmitted,
    output is_received,
    output parity,
    output tx_out_bit
);
wire pulse;
pulseM p(.rst(rst), .clk(clk), .pulse(pulse));

TX tx(.rstN(~rst), .clk(pulse), .start(transmit_en), 
    .data_in(data_in), .s_out(tx_out_bit),
    .sent(is_transmitted));

RX rx(.rstN(~rst), .clk(pulse), .s_in(rx_in_bit),
    .parity(parity), .data(data_out),
    .received(is_received));
    
endmodule