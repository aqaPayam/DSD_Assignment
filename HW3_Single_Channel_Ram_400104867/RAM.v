module Ram(
    input clk,
    input write,
    inout [15:0] data,
    input [11:0] address
);

reg [15:0] memory [0 : 2 ** 12 -1];

assign data = write ?   'hz :memory[address] ; // khorouji ro handle shod

always @(posedge clk) begin
    if (write)
        memory[address] <= data;
end

endmodule


module TestBench;
    reg clk;
    reg write;
    wire [15:0] data;
    reg [11:0] address;

    Ram ram(
        .clk(clk),
        .write(write),
        .data(data),
        .address(address)
        );

    reg [15:0] data_driver;

    assign data = write ?  data_driver : 'hz ; // vasl kardan sim be ye driver

    always #5 clk = ~clk;

    initial
    begin
    $dumpfile("Ram.vcd");
    $dumpvars(0, TestBench);
    end

    initial begin
    clk <= 1;
    {write , data_driver , address} <= 0;

    //test(a,1,c); --> mem[c] = a
    //test(a,0,c); --> read mem[c]

    test(16'd55,1'b1,12'd20);
    test(16'd70,1'b1,12'd60);
    //write

    test(16'd0,1'b0,12'd20);
    test(16'd0,1'b0,12'd60);
    //read

    test(16'd345,1'b1,12'd20);
    test(16'd0,1'b0,12'd20);
    test(16'd85,1'b1,12'd60);
    test(16'd0,1'b0,12'd60);
    //overwrite

    $stop;

    end


task test(
input [15:0] data_in,
input wr,
input [11 : 0] addr
);
begin
    #5;
    address <= addr;
    write <= wr;
    data_driver <= data_in;
    #5;
    if (wr)
        $display("data : %d write in add : %d",data,address);
    else
        $display("read data is %d from address : %d",data,address);
  
end
endtask

    
endmodule