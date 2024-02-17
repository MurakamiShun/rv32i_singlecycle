OUTPUT_ARCH( "riscv" )
ENTRY(_start)

SECTIONS
{
  . = 0x00000000;
  .text : {
    *(.text .text.*);
  }
  
  _input_op1 = 0x0000200;
  _input_op2 = 0x0000204;
  _output_data = 0x0000208;
  
  . = 0x000020c;
  .rodata : ALIGN(4){
    *(.rodata .rodata.*);
  }

  .data : ALIGN(4){
    *(.data .data.*);
  }

  .bss : ALIGN(4){
    *(.bss .bss.*);
  }
}

