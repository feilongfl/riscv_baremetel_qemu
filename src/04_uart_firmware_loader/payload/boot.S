
	.global _start

.macro	PUT_CHAR char
# uart of risc-v opensbi ecall id is 0x1,
# storage char in a0, and ecall id to a7
	addi a0, zero, \char
	addi a7, zero, 0x1

	ecall
.endm

# _start is the entry point of the program
_start:

	PUT_CHAR 'H'
	PUT_CHAR 'e'
	PUT_CHAR 'l'
	PUT_CHAR 'l'
	PUT_CHAR 'o'
	PUT_CHAR '\n'
	PUT_CHAR 'W'
	PUT_CHAR 'o'
	PUT_CHAR 'r'
	PUT_CHAR 'l'
	PUT_CHAR 'd'
	PUT_CHAR '!'
	PUT_CHAR '\n'

	ret

# loop forever
finish:
	wfi
	j finish
