.section .text
.globl _start



_start:
    addi a0, x0, 85
    jal ra, putc
    addi a0, x0, 65
    jal ra, putc
    addi a0, x0, 82
    jal ra, putc
    addi a0, x0, 84
    jal ra, putc
    addi a0, x0, 32
    jal ra, putc
    addi a0, x0, 79
    jal ra, putc
    addi a0, x0, 75
    jal ra, putc
    addi a0, x0, 10
    jal ra, putc
    jal x0, end

putc:
    lui t0, 0x20000  

wait_uart:
    lw  t1, 4(t0)
    bne t1, x0, wait_uart

    sw  a0, 0(t0)
    jalr x0, ra

end:
    jal x0, end
