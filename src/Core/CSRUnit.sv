`include "CSRUnitFuncts.svh"
`include "SysTimerConsts.svh"

module CSRUnit(
    input logic en,
    input logic[11:0] addr,
    input RV32Consts::IntReg in_data,
    input CSRUnitFuncts::Type funct,
    output RV32Consts::IntReg out_data,
    SysTimerIF.CSRUnitPort sys_timer_if
);
import CSRUnitFuncts::*;

typedef enum logic[11:0] {
    CYCLE_ADDR  = 12'h0c00,
    CYCLEH_ADDR = 12'h0c80,
    TIME_ADDR  = 12'h0c01,
    TIMEH_ADDR = 12'h0c81,
    INSTRET_ADDR  = 12'h0c02,
    INSTRETH_ADDR = 12'h0c82
} CSRADDRS;

always_comb begin
    if(en)begin
        unique case(addr)
            CYCLE_ADDR : begin
                sys_timer_if.timer = SysTimerConsts::CYCLE;
                sys_timer_if.upper = 0;
                out_data = sys_timer_if.data;
            end
            CYCLEH_ADDR : begin
                sys_timer_if.timer = SysTimerConsts::CYCLE;
                sys_timer_if.upper = 1;
                out_data = sys_timer_if.data;
            end
            TIME_ADDR : begin
                sys_timer_if.timer = SysTimerConsts::TIME;
                sys_timer_if.upper = 0;
                out_data = sys_timer_if.data;
            end
            TIMEH_ADDR : begin
                sys_timer_if.timer = SysTimerConsts::TIME;
                sys_timer_if.upper = 1;
                out_data = sys_timer_if.data;
            end
            INSTRET_ADDR : begin
                sys_timer_if.timer = SysTimerConsts::INSTRET;
                sys_timer_if.upper = 0;
                out_data = sys_timer_if.data;
            end
            INSTRETH_ADDR : begin
                sys_timer_if.timer = SysTimerConsts::INSTRET;
                sys_timer_if.upper = 1;
                out_data = sys_timer_if.data;
            end
            default : begin
                // illegal CSR addr
            end
        endcase
    end else begin
        out_data = 0;
    end
end

endmodule