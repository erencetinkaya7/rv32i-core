.section .text
.globl _start

_start:
    lui s0, 0x10000        // s0 = 0x10000000 GPIO address

blink_loop:
    addi t2, x0, 1
    sw t2, 0(s0)           // GPIO = 1 -> LED on
    jal ra, delay

    addi t2, x0, 0
    sw t2, 0(s0)           // GPIO = 0 -> LED off
    jal ra, delay

    jal x0, blink_loop


delay:
    addi t0, x0, 2000

outer_loop:
    addi t1, x0, 2000

inner_loop:
    addi t1, t1, -1
    bne t1, x0, inner_loop

    addi t0, t0, -1
    bne t0, x0, outer_loop

    jalr x0, 0(ra)
