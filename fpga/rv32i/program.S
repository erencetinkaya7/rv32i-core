.section .text
.globl _start

_start:
	addi a0, x0, 0 // led = a0

outer_loop:
    addi t1, x0, 1000 // dis sayaci 2000 yap

inner_loop:
    addi t0, x0, 2000 // ic sayaci 2000 yap


loop:
    addi t0, t0, -1 // ic sayac --
    beq t0, x0, arttir // ic sayac 0 olduysa dis sayaci 1 azaltmaya git
	jal x0, loop

arttir:
    addi t1, t1, -1 // dis sayaci 1 azalt
    beq t1, x0, delay // dis sayac sifirlanirsa delaye git
    jal x0, inner_loop // dis sayac sifirlanmamissa ic sayaci 2000 yap

delay:
    xori a0, a0, 1 // a0 in ilk bitini tersle
    jal x0, outer_loop









