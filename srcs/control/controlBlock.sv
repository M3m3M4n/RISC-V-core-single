module ControlBlock (
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic       funct7_b5,
    input logic [3:0] alu_flags,
    // See opcodeDecoder
    output logic       RegWrite,
    output logic [2:0] ImmSrc,
    output logic       PCAdderSrc,
    output logic       ALUSrcA,
    output logic       ALUSrcB,
    output logic       MemWrite,
    output logic [1:0] ResultSrc,
    // See branchDecoder
    output logic       pc_src,
    // See aluDecoder
    output logic [3:0] alu_control,
    // See dataMaskDecoder
    output logic [1:0] mask_type,
    output logic       ext_type

);
    logic [1:0] ALUOp;        // for opcodeDecoder - aluDecoder
    logic       branch, jump; // for opcodeDecoder - branchDecoder

    OpcodeDecoder opcodeDecoder (
        .op(opcode),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .PCAdderSrc(PCAdderSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(branch),
        .Jump(jump),
        .ALUOp(ALUOp)
    );
    BranchDecoder branchDecoder (
        .alu_flags(alu_flags),
        .funct3(funct3),
        .branch(branch),
        .jump(jump),
        .pc_src(pc_src)
    );
    ALUDecoder aluDecoder(
        .op_b5(opcode[5]),
        .funct3(funct3),
        .funct7_b5(funct7_b5), 
        .alu_op(ALUOp),
        .alu_control(alu_control)
    );
    DataMaskDecoder dataMaskDecoder(
        .funct3(funct3),
        .mask_type(mask_type),
        .ext_type(ext_type)
    );

endmodule