.section .text
.global _start

_start:
    addi t0, x0, 0      /* i = 0 */
    addi t1, x0, 5      /* N = 5 */
    addi t2, x0, 0      /* sum = 0 */

    /* Data memory starts at address 0 */
    addi t4, x0, 0      /* current array address */

loop:
    bge  t0, t1, end

    lw   t5, 0(t4)
    add  t2, t2, t5

    addi t4, t4, 4
    addi t0, t0, 1

    jal  x0, loop

end:
    jal  x0, end
