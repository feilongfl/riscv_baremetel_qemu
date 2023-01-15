
	.global _start

.macro	PUT_CHAR char
	addi t1, zero, \char
	sw t1, 0(t0)
.endm

# _start is the entry point of the program
_start:
	# Only proceed on the boot core. Park it otherwise.
	csrr t0, mhartid
	beqz t0, _boot_first_core
	# If execution reaches here, it not the boot core.
	j	finish

_boot_first_core:
# uart of risc-v virt machine is 0x1000_0000,
# lui: storage 0x10000 << 12 to t0
	lui t0, 0x10000

# load ascii to t1 reg, then storage to uart tx register
	PUT_CHAR 'H'
	PUT_CHAR 'e'
	PUT_CHAR 'l'
	PUT_CHAR 'l'
	PUT_CHAR 'o'
	PUT_CHAR '\n'

# prepare c runtime
_cstart:

# stoarge stack to sp register
	la sp, _estack

# storage finish to ra register
# jump to finish when main function return
	la ra, finish
# jump to main
	j main

# loop forever
finish:
	wfi
	j finish
