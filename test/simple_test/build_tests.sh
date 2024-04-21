#!/bin/bash
riscv64-unknown-elf-gcc -O0 -march=rv32i -malign-data=natural -mno-strict-align -mabi=ilp32 -ffreestanding -nostartfiles -mcmodel=medany -static -Ibarebones entry.c main.c -g -T link.ld -o testprog.elf
riscv64-unknown-elf-objdump -D testprog.elf > testprog.dump
riscv64-unknown-elf-objcopy -O binary -K .text testprog.elf testprog.bin
od -An -tx4 -w4 -v testprog.bin > testprog.hex
