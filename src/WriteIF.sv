interface WriteIF;
    logic[31:0] addr;
    logic[31:0] data;
    logic[3:0] strb; // 0 to ignore
    logic valid;

    modport Master(
        output addr, valid, data, strb
    );
    modport Slave(
        input addr, valid, data, strb
    );
endinterface