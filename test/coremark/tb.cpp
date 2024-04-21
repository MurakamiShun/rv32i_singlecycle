#include <iostream>
#include <memory>
#include <vector>
#include <iomanip>
#include <verilated.h>
#include "Vtop.h"

#include "Vtop_WriteIF.h"
#include "Vtop_ReadIF.h"

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    // Instance
    auto top = std::make_unique<Vtop>();
    const uint64_t sim_cycles = 1'000'000'000;
    // -- reset --
    top->clk = 0;
    top->rst_n = 0;
    top->eval();
    top->clk = 1;
    top->rst_n = 0;
    top->eval();
    top->rst_n = 1;
    for(uint64_t i = 0; i < sim_cycles; ++i){
        top->clk = 0;
        top->eval();
        top->clk = 1;
        top->eval();
        if(top->uart_tx_en){
            std::cout << (char)top->uart_data;
        }
    }
}