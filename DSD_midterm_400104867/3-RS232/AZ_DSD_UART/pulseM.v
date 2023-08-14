module pulseM(
input		rst,
input		clk,
output reg	pulse
);

localparam r = 217;
integer counter = 1;
always @(posedge clk) begin
	if(rst) begin
		counter = 1;
		pulse <= 0;
	end else begin
		if(counter == r) begin
			counter = 1;
			pulse <= !pulse;
		end else begin
		    counter = counter + 1;
		end
	end
end

endmodule 