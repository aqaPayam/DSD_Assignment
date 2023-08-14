module TX # (
    parameter START_SIG = 0
) (
    input           rstN,
    input           clk,
    input           start,
    input   [6:0]   data_in,
    output  reg     s_out = 1,
    output  reg     sent
);

localparam S_START      = 0;
localparam S_PARITY     = 1;
localparam S_SEND       = 2;
localparam S_STOP       = 3;
reg stop = 0;
reg [1:0]   state = 0;
reg [6:0]   data;
reg [2:0]   data_index;

wire parity_sig;
assign parity_sig = ^data;

always @(posedge clk or negedge rstN) begin
    if (~rstN) begin
        state <= S_START;
        data_index <= 0;
        sent <= 0;
        stop <= 0;
        s_out <= ~START_SIG;
    end
    else begin
        case (state)
            S_START: begin
                if (start && !stop) begin
                    s_out <= START_SIG;
                    data_index <= 0;
                    data <= data_in;
                    state <= S_PARITY;
                    sent <= 0;
                end else if(!start)
                    stop <= 0;
            end
            S_PARITY: begin
                s_out <= parity_sig;
                state <= S_SEND;
            end
            S_SEND: begin
                s_out <= data[data_index];
                if (data_index == 6)
                    state <= S_STOP;
                data_index <= data_index + 1;
            end
            S_STOP: begin
                s_out <= !START_SIG;
                state <= S_START;
                sent <= 1;
                stop <= 1;
            end
            default: state <= S_START;
        endcase
    end
end
    
endmodule