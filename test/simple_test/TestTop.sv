module TestTop(
    input logic clk,
    input logic rst_n,
    output logic[31:0] pc,
    output logic[31:0] waddr,
    output logic[31:0] wdata,
    output logic wen
);

ReadIF inst_bus();
ReadIF data_rbus();
WriteIF data_wbus();

Core core(
    .clk(clk),
    .rst_n(rst_n),
    .inst_bus(inst_bus),
    .data_rbus(data_rbus),
    .data_wbus(data_wbus)
);


logic[31:0] rom[1023:0];

initial begin
    $readmemh("testprog.hex", rom);
end
logic[31:0] ram[63:0];

logic[31:0] data_rbus_ram_addr;
logic[31:0] data_wbus_ram_addr;

always_comb begin
    inst_bus.data = rom[inst_bus.addr[11:2]];
    data_rbus_ram_addr = data_rbus.addr - 32'h1000;
    data_wbus_ram_addr = data_wbus.addr - 32'h1000;
    data_rbus.data = ram[data_rbus_ram_addr[7:2]];

    pc = inst_bus.addr;
    waddr = data_wbus.addr;
    wdata = data_wbus.data & {{8{data_wbus.strb[3]}},{8{data_wbus.strb[2]}}, {8{data_wbus.strb[1]}}, {8{data_wbus.strb[0]}}};
    wen = data_wbus.valid;
end

always_ff@(posedge clk)begin
    if(data_wbus.addr inside {[32'h1000:32'h1100]} && data_wbus.valid)begin
        if(data_wbus.strb[0])begin
            ram[data_wbus_ram_addr[7:2]][7:0] <= data_wbus.data[7:0];
        end
        if(data_wbus.strb[1])begin
            ram[data_wbus_ram_addr[7:2]][15:8] <= data_wbus.data[15:8];
        end
        if(data_wbus.strb[2])begin
            ram[data_wbus_ram_addr[7:2]][23:16] <= data_wbus.data[23:16];
        end
        if(data_wbus.strb[3])begin
            ram[data_wbus_ram_addr[7:2]][31:24] <= data_wbus.data[31:24];
        end
    end
end

endmodule