.section .text
.globl _start

_start:

addi a0, x0, 0
addi a1, x0, 5
jal ra, sum_positive
jal x0, end

sum_positive:

addi t3, x0, 0
add t0, x0, 0
add t4, x0, a0

loop:

bge t0, a1, done
slli t1, t0, 2
add t4, a0, t1
lw t2, 0(t4)
bge x0, t2, arttir
add t3, t3, t2

arttir:
addi t0, t0, 1
jal x0, loop

done:
add a0, x0, t3
jalr x0, 0(ra)

end:
jal x0, end
