OUTPUT_ARCH( "riscv" )

ENTRY( _start )
__stack_size = 2048;
PROVIDE( _stack_size = __stack_size );

MEMORY
{
  ram   (wxa!ri) : ORIGIN = @RAM_ADDR, LENGTH = 1M
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

  .got : { *(.got*) } >ram AT>ram :data

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
