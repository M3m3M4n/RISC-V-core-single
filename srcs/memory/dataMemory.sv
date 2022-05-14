module DataMemory (
    input  logic        clk, we,
    input  logic [31:0] addr, wd,
    input  logic [1:0]  mask_type, // 00: byte, 01: halfword, 10: word
    input  logic        ext_type,  // 0: signed extension, 1: zero extension
    output logic [31:0] rd
);

    logic [31:0] RAM[63:0]; // 2K

    // As this should not be synthesizable anyway...
    initial begin
        for (int i = 0; i < 64; i=i+1)
            RAM[i] = 32'h0;
    end

    always_comb begin // mask output
        case(mask_type)
            2'b00:
                rd = ext_type ? {24'b0, RAM[addr][7:0]} : {{24{RAM[addr][7]}}, RAM[addr][7:0]};
            2'b01:
                if (ext_type)
                    rd = {16'b0, RAM[addr[31:1]][15:0]};
                else
                    rd = {{16{RAM[addr[31:1]][15]}}, RAM[addr[31:1]][15:0]};
                //rd = ext_type ? {16'b0, RAM[addr[31:1]][15:0]} : {16{RAM[addr[31:1]][15]}, RAM[addr[31:1]][15:0]};
            // 2'b10: // is default 
            default:  // full word read, no sign change
                rd = RAM[addr[31:2]]; // word aligned
        endcase
    end

    logic [31:0] _wd;

    always_comb begin // mask input
        case(mask_type)
            2'b00:
                _wd = ext_type ? {24'b0, wd[7:0]} : {{24{wd[7]}}, wd[7:0]};
            2'b01:
                _wd = ext_type ? {16'b0, wd[15:0]} : {{16{wd[15]}}, wd[15:0]};
            // 2'b10: // is default 
            default:  // full word read, no sign change
                _wd = wd; // word aligned
        endcase
    end

    always_ff @(posedge clk)
        if (we) RAM[addr[31:2]] <= _wd;

endmodule