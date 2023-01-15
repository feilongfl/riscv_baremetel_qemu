OUTPUT_ARCH( "riscv" )

ENTRY( _start )
__stack_size = 2048;
PROVIDE( _stack_size = __stack_size );

MEMORY
{
  ram   (wxa!ri) : ORIGIN = 0x80000000, LENGTH = 1M
}

PHDRS
{
  text PT_LOAD;
  data PT_LOAD;
  bss PT_LOAD;
}

SECTIONS
{
  .text : {
    PROVIDE(_text_start = .);
    *(.text.init) *(.text .text.*)
    PROVIDE(_text_end = .);
  } >ram AT>ram :text

  .rodata : {
    PROVIDE(_rodata_start = .);
    *(.rodata .rodata.*)
    PROVIDE(_rodata_end = .);
  } >ram AT>ram :text

  .data : {
    . = ALIGN(4096);
    PROVIDE(_data_start = .);
    *(.sdata .sdata.*) *(.data .data.*)
    PROVIDE(_data_end = .);
  } >ram AT>ram :data

  .bss :{
    PROVIDE(_bss_start = .);
    *(.sbss .sbss.*) *(.bss .bss.*)
    PROVIDE(_bss_end = .);
  } >ram AT>ram :bss

  .stack ORIGIN(ram) + LENGTH(ram) - __stack_size :
  {
    . = ALIGN(4);
    PROVIDE( _sstack = . );
    . = . + __stack_size;
    PROVIDE( _estack = .);
  } >ram

  PROVIDE(_memory_start = ORIGIN(ram));
  PROVIDE(_memory_end = ORIGIN(ram) + LENGTH(ram));
}
