interface ReadIF;
    logic[31:0] addr;
    logic[31:0] data;
    logic valid;

    modport Master(
        output addr, valid,
        input data
    );
    modport Slave(
        input addr, valid,
        output data
    );
endinterface