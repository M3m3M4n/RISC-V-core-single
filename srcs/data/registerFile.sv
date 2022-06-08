module RegisterFile (
    input  logic        clk, 
    input  logic        we3, 
    input  logic [ 4:0] a1, a2, a3, 
    input  logic [31:0] wd3, 
    output logic [31:0] rd1, rd2
);

    logic [31:0] regs[31:0];

    // As this should not be synthesizable anyway...
    initial begin
        for (int i = 0; i < 32; i=i+1)
            regs[i] = 32'h0;
    end

    // three ported register file
    // read two ports combinationally (A1/RD1, A2/RD2)
    // write third port on rising edge of clock (A3/WD3/WE3)
    // register 0 hardwired to 0

    always_ff @(posedge clk) begin
        if (we3) begin
            if (a3 != 0)
                regs[a3] <= wd3;
            else begin
                $display("[REG FILE] ATTEMPTED WRITE %H TO R0", wd3);
                regs[a3] <= 0;
            end
        end
    end

    assign rd1 = (a1 != 0) ? regs[a1] : 0;
    assign rd2 = (a2 != 0) ? regs[a2] : 0;

endmodule