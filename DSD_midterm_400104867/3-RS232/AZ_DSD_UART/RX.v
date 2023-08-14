module RX # (
    parameter START_SIG = 0
) (
    input               rstN,
    input               clk,
    input               s_in,
    output  reg         received,
    output  reg         parity,
    output  reg [6:0]   data
);

localparam S_IDLE       = 0;
localparam S_PARITY     = 1;
localparam S_RECEIVE    = 2;
localparam S_STOP       = 3;

reg [1:0]   state;
reg [2:0]   data_index;
reg last_s_in = 1;

always @(posedge clk or negedge rstN) begin
    if (~rstN) begin
        state <= S_IDLE;
        data_index <= 0;
        received <= 0;
        data <= 0;
        last_s_in <= 1;
    end
    else begin
        case (state)
            S_IDLE: begin
                if (s_in == START_SIG &&
                 last_s_in == !START_SIG) begin
                    data_index <= 0;
                    data <= 0;
                    state <= S_PARITY;
                    received <= 0;
                    last_s_in = s_in;
                end
                else
                    last_s_in <= s_in;
            end
            S_PARITY: begin
                parity <= s_in;
                state <= S_RECEIVE;
            end
            S_RECEIVE: begin
                data[data_index] <= s_in;
                if (data_index == 6)
                    state <= S_STOP;
                data_index <= data_index + 1;
            end
            S_STOP: begin
                state <= S_IDLE;
                received <= 1;
            end
            default: state <= S_IDLE;
        endcase
    end
end

endmodule