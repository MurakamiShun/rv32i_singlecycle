module TestTop(
    input logic clk,
    input logic rst_n,
    output logic[31:0] pc,
    output logic[31:0] waddr,
    output logic[31:0] wdata,
    output logic wen
);

AXI4LiteReadIF inst_bus(clk, rst_n);
AXI4LiteReadIF data_rbus(clk, rst_n);
AXI4LiteWriteIF data_wbus(clk, rst_n);

Core core(
    .clk(clk),
    .rst_n(rst_n),
    .inst_bus(inst_bus),
    .data_rbus(data_rbus),
    .data_wbus(data_wbus)
);


logic[31:0] rom[127:0];

initial begin
    $readmemh("testprog.hex", rom);
end

always_comb begin
    inst_bus.data = rom[inst_bus.addr[8:2]];
    inst_bus.aready = 1;
    inst_bus.ready = 1;

    pc = inst_bus.addr;
    waddr = data_wbus.addr;
    wdata = data_wbus.data;
    wen = data_wbus.avalid;
end

endmodule