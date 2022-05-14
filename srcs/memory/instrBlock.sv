module InstrBlock (
    input  logic clk,
    input  logic rst,
    input  logic pc_src,
    input  logic [31:0] pc_ext,

    output logic [31:0] pc_p_4,
    output logic [31:0] pc,

    output logic [31:0] instr
);
    
    InstrMemory instrMemory(
        .a(pc),
        .rd(instr)
    );

    assign pc_p_4 = pc + 4;

    always_ff @(posedge clk, negedge rst) begin
        if (~rst)
            pc <= 0;
        else
            pc <= pc_src ? pc_ext : pc_p_4;
    end

endmodule