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

    std::cout << "cycles, PC, wen, waddr, wdata" << std::endl;

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
        std::cout << std::setw(4) << i << ", "  << std::setw(4) << std::hex << (uint32_t)top->pc << ","
         << std::setw(4) << std::boolalpha << (bool)top->wen << "," << std::setw(4) << top->waddr << ", " << top->wdata << std::endl;
    }
}