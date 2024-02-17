`include "RV32Consts.svh"

module IntegerRegisters(
    input logic clk,
    input logic[4:0] rs1_addr,
    input logic[4:0] rs2_addr,
    output RV32Consts::IntReg rs1_data,
    output RV32Consts::IntReg rs2_data,
    
    input logic[4:0] rd_addr,
    input RV32Consts::IntReg rd_data,
    input logic rd_en
);
    RV32Consts::IntReg[31:0] int_regs;

    always_comb begin
        rs1_data = (rs1_addr == 0) ? 0 : int_regs[rs1_addr];
        rs2_data = (rs2_addr == 0) ? 0 : int_regs[rs2_addr];
    end

    always_ff@(posedge clk) begin
        if(rd_en && rd_addr != 0)begin
            int_regs[rd_addr] <= rd_data;
        end
    end


endmodule