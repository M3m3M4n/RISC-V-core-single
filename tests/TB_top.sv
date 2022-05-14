`timescale 1ms/100us

module TB_Top (
);
    
logic clk = 1'b1;
logic rst = 1'b1;

Top UUT (
    .clk(clk),
    .rst(rst)
);

always begin
    #1 clk = ~clk;
end

initial begin
    $dumpfile(`DUMPFILENAME);
    $dumpvars(0, TB_Top);
    #5 rst = 0;
    #10 rst = 1;
    #100
    $finish;
end

endmodule