`include "Instruction.svh"
`include "MicroCode.svh"

module Core(
    input logic clk,
    input logic rst_n,
    AXI4LiteReadIF.Master inst_bus,
    AXI4LiteReadIF.Master data_rbus,
    AXI4LiteWriteIF.Master data_wbus
);
import RV32Consts::*;

IntReg pc = 0;
Instruction inst;

always_comb begin
    inst_bus.addr = pc;
    inst.inst32 = inst_bus.data;
    inst_bus.ready = 1;
    inst_bus.avalid = 1;
end

MicroCode micro_code;

Decoder decoder(
    .inst(inst),
    .micro_code(micro_code)
);

IntReg rs1_data, rs2_data, rd_data;

IntegerRegisters integer_registers(
    .clk(clk),
    .rs1_addr(micro_code.rs1_addr),
    .rs2_addr(micro_code.rs2_addr),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    
    .rd_addr(micro_code.rd_addr),
    .rd_data(rd_data),
    .rd_en(micro_code.rd_en)
);

IntReg pc4;
IntReg alu_op1, alu_op2;

always_comb begin
    pc4 = pc + 4;
    unique case(micro_code.alu.op1_src)
        OP1Src::RS1  : alu_op1 = rs1_data;
        OP1Src::ZERO : alu_op1 = 32'b0;
        OP1Src::PC   : alu_op1 = pc;
        default      : alu_op1 = 32'bx;
    endcase
    unique case(micro_code.alu.op2_src)
        OP2Src::RS2 : alu_op2 = rs2_data;
        OP2Src::IMM : alu_op2 = micro_code.imm_data;
        default     : alu_op2 = 32'bx;
    endcase
end

logic br_token;
IntReg alu_result;

ALU alu(
    .op1(alu_op1),
    .op2(alu_op2),
    .funct(micro_code.alu.funct),
    .result(alu_result)
);
BranchUnit br_unit(
    .op1(rs1_data),
    .op2(rs2_data),
    .funct(micro_code.br_unit.funct),
    .token(br_token)
);

IntReg csr_wdata, csr_rdata;

always_comb begin
    unique case(micro_code.csr_unit.rs1_src)
        RS1Src::REG  : csr_wdata = rs1_data;
        RS1Src::ADDR : csr_wdata = {27'b0, micro_code.rs1_addr};
        default      : csr_wdata = 32'bx;
    endcase
end

SysTimerIF sys_timer_if;

CSRUnit csr_unit(
    .en(micro_code.csr_unit.en),
    .addr(micro_code.imm_data[11:0]),
    .in_data(csr_wdata),
    .funct(micro_code.csr_unit.funct),
    .out_data(csr_rdata),
    .sys_timer_if(sys_timer_if)
);

IntReg ld_data;

LoadStoreUnit ld_st_unit(
    .en(micro_code.ld_st_unit.en),
    .addr(alu_result),
    .wdata(rs2_data),
    .funct(micro_code.ld_st_unit.funct),
    .bytes(micro_code.ld_st_unit.bytes),
    .rdata(ld_data),
    .w_bus(data_wbus),
    .r_bus(data_rbus)
);

always_comb begin
    unique case(micro_code.rd_src)
        RdSrc::ALU : rd_data = alu_result;
        RdSrc::CSR : rd_data = csr_rdata;
        RdSrc::LD  : rd_data = ld_data;
        RdSrc::PC4 : rd_data = pc4;
        default : rd_data = 32'bx;
    endcase
end

always_ff@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        pc <= 0;
    end else if(micro_code.br_unit.en && br_token)begin
        pc <= alu_result;
    end else begin
        pc <= pc4;
    end
end

// ------- System Control -------

SysTimer#(
    .CyclePerTick(128)
) sys_timer (
    .clk(clk),
    .rst_n(rst_n),
    .instret_en(1),
    .csr_if(sys_timer_if)
);


endmodule