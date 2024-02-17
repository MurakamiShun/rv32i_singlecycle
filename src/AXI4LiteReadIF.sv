`include "AXI4LiteConsts.svh"

interface AXI4LiteReadIF(input logic clk, rst_n);
    logic[31:0] addr;
    logic avalid;
    logic aready;

    logic[31:0] data;
    AXI4LiteReadResp::Type resp;
    logic valid;
    logic ready;

    modport Master(
        output addr, avalid, ready, 
        input aready, valid, data, resp
    );
    modport Slave(
        input clk, rst_n, addr, avalid, ready,
        output aready, valid, data, resp
    );
endinterface