OUTPUT_ARCH( "riscv" )
ENTRY(entry)

SECTIONS
{
  . = 0x00000000;
  .text : {
    *(.text .text.*);
  }
  
  _input = 0x0000200;
  _output = 0x0000204;
  
}

