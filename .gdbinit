target remote localhost:1234

tui new-layout srcreg {-horizontal src 1 regs 1} 2 status 0 cmd 1
tui new-layout asmreg {-horizontal asm 1 regs 1} 2 status 0 cmd 1
layout srcreg

b _start
c
