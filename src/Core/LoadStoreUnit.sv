`include "LoadStoreUnitFuncts.svh"
`include "RV32Consts.svh"
`include "AXI4LiteConsts.svh"

module LoadStoreUnit(
    input logic en,
    input RV32Consts::IntReg addr,
    input RV32Consts::IntReg wdata,
    input LoadStoreUnitFuncts::Type funct,
    input LoadStoreUnitBytes::Type bytes,
    output RV32Consts::IntReg rdata,
    AXI4LiteWriteIF.Master w_bus,
    AXI4LiteReadIF.Master r_bus
);

// write bus
always_comb begin
    w_bus.addr = addr;
    w_bus.avalid = (en && funct == LoadStoreUnitFuncts::ST);
    w_bus.data = wdata;
    unique case(bytes)
        LoadStoreUnitBytes::BYTE:begin
            unique case(addr[1:0])
                2'b00 : w_bus.strb = 4'b0001;
                2'b01 : w_bus.strb = 4'b0010;
                2'b10 : w_bus.strb = 4'b0100;
                2'b11 : w_bus.strb = 4'b1000;
            endcase
        end
        LoadStoreUnitBytes::HALF:begin
            unique case(addr[1])
                1'b0 : w_bus.strb = 4'b0011;
                1'b1 : w_bus.strb = 4'b1100;
            endcase
        end
        LoadStoreUnitBytes::WORD:begin
            w_bus.strb = 4'b1111;
        end
        default : begin
            w_bus.strb = 4'b0000; // write disable
        end
    endcase
    w_bus.valid = w_bus.aready & w_bus.ready;
    w_bus.bready = 1;
end

// read bus
logic[7:0]  ld_byte;
logic[15:0] ld_half;
always_comb begin
    unique case(addr[1:0])
        2'b00 : ld_byte = r_bus.data[7:0];
        2'b01 : ld_byte = r_bus.data[15:8];
        2'b10 : ld_byte = r_bus.data[23:16];
        2'b11 : ld_byte = r_bus.data[31:24];
    endcase
    unique case(addr[1])
        1'b0 : ld_half = r_bus.data[15:0];
        1'b1 : ld_half = r_bus.data[31:16];
    endcase
end
always_comb begin
    r_bus.addr = {addr[31:2], 2'b0};
    r_bus.avalid = (en && funct inside {LoadStoreUnitFuncts::LD, LoadStoreUnitFuncts::LDU});
    r_bus.ready = 1;
    unique case(funct)
        LoadStoreUnitFuncts::LD : begin
            unique case(bytes)
                LoadStoreUnitBytes::BYTE : rdata = {{24{ld_byte[7]}},  ld_byte};
                LoadStoreUnitBytes::HALF : rdata = {{16{ld_half[15]}}, ld_half};
                LoadStoreUnitBytes::WORD : rdata = r_bus.data;
                default : rdata = 0;
            endcase
        end
        LoadStoreUnitFuncts::LDU : begin
            unique case(bytes)
                LoadStoreUnitBytes::BYTE : rdata = {24'b0, ld_byte};
                LoadStoreUnitBytes::HALF : rdata = {16'b0, ld_half};
                LoadStoreUnitBytes::WORD : rdata = r_bus.data;
                default : rdata = 0;
            endcase
        end
        default: rdata = 0;
    endcase
end

endmodule