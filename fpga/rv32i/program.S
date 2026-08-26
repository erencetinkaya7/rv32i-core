.section .text
.globl _start

_start:
	addi a0, x0, 0

loop:
    addi a0, a0, 1
	jal x0, loop
