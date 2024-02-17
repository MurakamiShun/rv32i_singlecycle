`include "RV32Consts.svh"
`include "ALUFuncts.svh"

module ALU(
    input RV32Consts::IntReg op1,
    input RV32Consts::IntReg op2,
    input ALUFuncts::Type funct,
    output RV32Consts::IntReg result
);

import RV32Consts::*;
import ALUFuncts::*;

always_comb begin
    unique case(funct)
        ADD  : result = op1 + op2;
        SUB  : result = op1 - op2;
        SLT  : result = { {(XLEN-1){1'b0}}, $signed(op1) < $signed(op2)};
        SLTU : result = { {(XLEN-1){1'b0}}, op1 < op2};
        AND  : result = op1 & op2;
        OR   : result = op1 | op2;
        XOR  : result = op1 ^ op2;
        SLL  : result = op1 << op2;
        SRL  : result = op1 >> op2;
        SRA  : result = op1 >>> op2;
        default: result = 'bx;
    endcase
end
endmodule