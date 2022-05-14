module Top (
    //input C_OSC_25
    input logic clk,
    input logic rst
);
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic       funct7_b5;
    logic [3:0] alu_flags;

    logic       RegWrite;
    logic [2:0] ImmSrc;
    logic       PCAdderSrc;
    logic       ALUSrcA;
    logic       ALUSrcB;
    logic       MemWrite;
    logic [1:0] ResultSrc;
    logic       pc_src;
    logic [3:0] alu_control;
    logic [1:0] mask_type;
    logic       ext_type;

    DataBlock datapath(
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .PCAdderSrc(PCAdderSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .pc_src(pc_src),
        .alu_control(alu_control),
        .mask_type(mask_type),
        .ext_type(ext_type),

        .opcode(opcode),
        .funct3(funct3),
        .funct7_b5(funct7_b5),
        .alu_flags(alu_flags)
    );

    ControlBlock controlpath(
        .opcode(opcode),
        .funct3(funct3),
        .funct7_b5(funct7_b5),
        .alu_flags(alu_flags),

        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .PCAdderSrc(PCAdderSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .pc_src(pc_src),
        .alu_control(alu_control),
        .mask_type(mask_type),
        .ext_type(ext_type)
    );

endmodule