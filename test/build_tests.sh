#!/bin/bash
FILE_NAME="${$1%.*}"
riscv64-unknown-elf-objcopy -O binary $1 $FILE_NAME.bin
od -An -tx4 -w4 -v $FILE_NAME.bin > $FILE_NAME.hex