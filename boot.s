
	.global _start

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
	addi t1, zero, 'H'
	sw t1, 0(t0)

	addi t1, zero, 'e'
	sw t1, 0(t0)

	addi t1, zero, 'l
	sw t1, 0(t0)

	addi t1, zero, 'l
	sw t1, 0(t0)

	addi t1, zero, 'o
	sw t1, 0(t0)

	addi t1, zero, '\n'
	sw t1, 0(t0)

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
	j finish
