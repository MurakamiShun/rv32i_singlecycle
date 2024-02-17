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

    const auto sim_cycles = 10;
    for(auto i = 0; i < sim_cycles; ++i){
        top->clk = 0;
        top->rst_n = 1;
        top->eval();
        top->clk = 1;
        top->rst_n = 1;
        top->eval();
        std::cout << i << " : "  << std::setw(4) << std::hex << (uint32_t)top->pc << std::endl;
    }
}