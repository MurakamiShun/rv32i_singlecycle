#include <iostream>
#include <memory>
#include <vector>
#include <iomanip>
#include <verilated.h>
#include "VTestTop.h"

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    // Instance
    auto top = std::make_unique<VTestTop>();

    std::cout << "cycles, PC, wen, waddr, wdata, rd_data" << std::endl;

    const auto sim_cycles = 150;
    // -- reset --
    top->clk = 0;
    top->rst_n = 0;
    top->eval();
    top->clk = 1;
    top->rst_n = 0;
    top->eval();

    for(auto i = 0; i < sim_cycles; ++i){
        top->clk = 1;
        top->rst_n = 1;
        top->eval();
        top->clk = 0;
        top->rst_n = 1;
        top->eval();
        std::cout << std::setw(4) << i << ", " 
        << std::setw(4) << std::hex << (uint32_t)top->pc << ","
        << std::setw(5) << std::boolalpha << (bool)top->wen << ","
        << std::setw(4) << top->waddr << ", "
        << std::setw(4) << top->wdata << ","
        << std::setw(4) << top->TestTop__DOT__core__DOT__rd_data << std::endl;
    }
}