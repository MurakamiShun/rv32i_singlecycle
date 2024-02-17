#!/bin/bash
#FILE_NAME="${$1%.*}"
riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -nostartfiles -mcmodel=medany -fvisibility=hidden -static -c testprog.c -o testprog.o
riscv32-unknown-elf-ld testprog.o -T link.ld -static -o testprog.elf
riscv32-unknown-elf-objdump -D testprog.elf > testprog.dump
riscv32-unknown-elf-objcopy -O binary testprog.elf testprog.bin
od -An -tx4 -w4 -v testprog.bin > testprog.hex