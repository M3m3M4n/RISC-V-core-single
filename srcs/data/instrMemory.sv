module InstrMemory (
    input  logic [31:0] a,
    output logic [31:0] rd
);

    logic [31:0] RAM[127:0];

    // As this should not be synthesizable anyway...
    initial begin
        for (int i = 0; i < 64; i=i+1)
            RAM[i] = 32'h0;

        $readmemh("tests/test.txt",RAM);
    end

    assign rd = RAM[a[31:2]]; // word aligned

endmodule