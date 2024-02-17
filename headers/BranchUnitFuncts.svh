`ifndef BRANCH_UNIT_FUNCTS_SVH
`define BRANCH_UNIT_FUNCTS_SVH

package BranchUnitFuncts;
    typedef enum logic[2:0] { 
        BEQ  = 'b000,
        BNE  = 'b001,
        BLT  = 'b100,
        BLTU = 'b101,
        BGE  = 'b110,
        BGEU = 'b111,
        JAL  = 'b011,
        JALR = 'b010
    } Type;
endpackage

`endif