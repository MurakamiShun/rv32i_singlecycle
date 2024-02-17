`include "AXI4LiteConsts.svh"

interface AXI4LiteWriteIF(input logic clk, rst_n);
    // addr
    logic[31:0] addr;
    logic avalid;
    logic aready;
    // data
    logic[31:0] data;
    logic[3:0] strb; // 0 to ignore
    logic valid;
    logic ready;
    // response
    AXI4LiteWriteResp::Type bresp;
    logic bvalid;
    logic bready;

    modport Master(
        output addr, avalid, data, strb, valid, bready,
        input aready, ready, bresp, bvalid
    );
    modport Slave(
        input clk, rst_n, addr, avalid, data, strb, valid, bready,
        output aready, ready, bresp, bvalid
    );
endinterface