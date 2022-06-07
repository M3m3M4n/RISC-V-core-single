module DataBlock (
    input logic clk,
    input logic rst,
    // Control signals
    // See opcodeDecoder
    input logic       RegWrite,
    input logic [2:0] ImmSrc,
    input logic       PCAdderSrc,
    input logic       ALUSrcA,
    input logic       ALUSrcB,
    input logic       MemWrite,
    input logic [1:0] ResultSrc,
    // See branchDecoder
    input logic       pc_src,
    // See aluDecoder
    input logic [3:0] alu_control,
    // See dataMaskDecoder
    input logic [1:0] mask_type,
    input logic       ext_type,

    output logic [6:0] opcode,
    output logic [2:0] funct3,
    output logic       funct7_b5,
    output logic [3:0] alu_flags
);
    logic [31:0] pc, pc_p_4, pc_ext, instr;
    logic [31:0] reg_out_1, reg_out_2, reg_in;
    logic [31:0] alu_in_1, alu_in_2;
    logic [31:0] imm_ext;
    logic [31:0] pc_adder_in_1;
    logic [31:0] alu_result;
    logic [31:0] data_out;

    InstrBlock instrBlock(
        .clk(clk),
        .rst(rst),
        .pc_src(pc_src),
        .pc_ext(pc_ext),
        .pc_p_4(pc_p_4),
        .pc(pc),
        .instr(instr)
    );
    
    RegisterFile registerFile(
        .clk(clk),
        .we3(RegWrite), 
        .a1(instr[19:15]),
        .a2(instr[24:20]),
        .a3(instr[11:7]), 
        .wd3(reg_in), 
        .rd1(reg_out_1),
        .rd2(reg_out_2)
    );

    Mux2 aluInputA(
        .d0(reg_out_1),
        .d1(pc),
        .s(ALUSrcA),
        .y(alu_in_1)
    );

    Mux2 aluInputB(
        .d0(reg_out_2),
        .d1(imm_ext),
        .s(ALUSrcB),
        .y(alu_in_2)
    );

    ALU alu(
        .a(alu_in_1),
        .b(alu_in_2),
        .alu_control(alu_control),
        .result(alu_result),
        .alu_flags(alu_flags)
    );
    
    Mux2 pcAdderInputA(
        .d0(pc),
        .d1(reg_out_1),
        .s(PCAdderSrc),
        .y(pc_adder_in_1)
    );

    assign pc_ext = pc_adder_in_1 + imm_ext;

    ImmExtender  immExtender(
        .instr(instr[31:7]),
        .immsrc(ImmSrc),
        .immext(imm_ext)
    );

    DataMemory dataMemory(
        .clk(clk), 
        .we(MemWrite),
        .addr(alu_result), 
        .wd(reg_out_2),
        .mask_type(mask_type),
        .ext_type(ext_type),
        .rd(data_out)
    );

    Mux4 dataOutMux(
        .d0(alu_result),
        .d1(data_out),
        .d2(pc_p_4),
        .d3(imm_ext),
        .s(ResultSrc), 
        .y(reg_in)
    );

    assign opcode    = instr[6:0];
    assign funct3    = instr[14:12];
    assign funct7_b5 = instr[30];
endmodule