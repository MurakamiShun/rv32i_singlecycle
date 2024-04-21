OUTPUT_ARCH( "riscv" )
ENTRY(entry)

MEMORY{
    ROM (rx) : ORIGIN = 0x00000000, LENGTH = 0x1000 /*512*4*2bytes*/
    RAM (rw) : ORIGIN = 0x0001000, LENGTH = 0x100 /*256bytes*/
}

SECTIONS {
    PROVIDE(uart_tx = 0x00002000);
    
    .text : {
        . = ALIGN(4);
        *(.text.entry);
        *(.text .text.*);
        *(.rodata .rodata.*);
    } > ROM

    .data : {
        . = ALIGN(4);
        PROVIDE(__global_pointer$ = . + 2047);

        . = ALIGN(4);
        *(.data .data.*);
        *(.sdata .sdata.*);

        . = ALIGN(4);
        *(.bss .bss.*);
        *(.sbss .sbss.*);
    } > RAM
    
    PROVIDE(__stack_end = ORIGIN(RAM) + LENGTH(RAM));
}
