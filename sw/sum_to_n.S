.section .text
.globl _start

_start:
    addi sp, x0, 128
    addi a0, x0, 5
    jal  ra, sum_to_n
    j    end

sum_to_n:
    addi t0, x0, 0

loop:
    bge  x0, a0, done
    add  t0, t0, a0
    addi a0, a0, -1
    j    loop

done:
    add  a0, x0, t0
    ret

end:
    j end
