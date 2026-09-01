
.section .text
.globl _start

_start:
    lui  s0, 0x20000      # UART base: 0x2000_0000
    addi s1, x0, 65       # ASCII 'A'

send:
    lw   t0, 4(s0)
    bne  t0, x0, send
    sw   s1, 0(s0)

    addi t2, x0, 1000

delay:
    addi t2, t2, -1
    bne  t2, x0, delay

    jal  x0, send
