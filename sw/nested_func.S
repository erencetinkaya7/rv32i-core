.section .text
.globl _start

_start:
    addi sp, x0, 128
    addi a0, x0, 5
    jal  ra, f
    jal  x0, end

f:
    addi sp, sp, -16
    sw   ra, 12(sp)

    jal  ra, g
    addi a0, a0, 1

    lw   ra, 12(sp)
    addi sp, sp, 16
    ret

g:
    slli a0, a0, 1
    ret

end:
    jal x0, end
