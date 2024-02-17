`ifndef MICRO_CODE_SVH
`define MICRO_CODE_SVH

`include "RV32Consts.svh"
`include "BranchUnitFuncts.svh"
`include "ALUFuncts.svh"
`include "CSRUnitFuncts.svh"
`include "LoadStoreUnitFuncts.svh"


/* verilator lint_off DECLFILENAME */
package RS1Src;
    typedef enum logic {
        REG,
        ADDR
    } Type;
endpackage

package OP1Src;
    typedef enum logic[1:0] {
        RS1,
        ZERO,
        PC
    } Type;
endpackage

package OP2Src;
    typedef enum logic {
        RS2,
        IMM
    } Type;
endpackage

package RdSrc;
    typedef enum logic[1:0] {
        ALU,
        CSR,
        LD,
        PC4
    } Type;
endpackage

typedef struct packed {
    // depend on inst type
    logic[4:0] rs1_addr;
    logic[4:0] rs2_addr;
    logic[4:0] rd_addr;
    logic rd_en;
    RV32Consts::IntReg imm_data;

    // depend on each operation
    RdSrc::Type rd_src;
    struct packed{
        ALUFuncts::Type funct;
        OP1Src::Type op1_src;
        OP2Src::Type op2_src;
        logic en;
    } alu;
    struct packed{
        BranchUnitFuncts::Type funct;
        logic en;
    } br_unit;
    struct packed{
        LoadStoreUnitFuncts::Type funct;
        LoadStoreUnitBytes::Type bytes;
        logic en;
    } ld_st_unit;
    struct packed{
        CSRUnitFuncts::Type funct;
        RS1Src::Type rs1_src;
        logic en;
    } csr_unit;
} MicroCode;

`endif