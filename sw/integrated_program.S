.section .text
.global _start

_start:
    /* i = 1 */
    addi x1, x0, 1

    /* sum = 0 */
    addi x2, x0, 0

    /* limit = 6 */
    addi x3, x0, 6


loop:
    /* sum = sum + i */
    add x2, x2, x1

    /* i = i + 1 */
    addi x1, x1, 1

    /* Go back to loop while i < 6 */
    blt x1, x3, loop


    /* Store sum to memory address 0 */
    sw x2, 0(x0)

    /* Load it back into x4 */
    lw x4, 0(x0)


    /* Call function, save return address in x5 */
    jal x5, function


return_point:
    /* Prove that function returned correctly */
    addi x6, x0, 99

    /* Store function result at address 4 */
    sw x4, 4(x0)

    /* Load result back into x7 */
    lw x7, 4(x0)

    /* Program finished marker */
    addi x8, x0, 1


end:
    /* Stay here forever */
    jal x0, end


function:
    /* x4 = x4 * 2 */
    slli x4, x4, 1

    /* x4 = x4 + 3 */
    addi x4, x4, 3

    /* Return to address stored in x5 */
    jalr x0, 0(x5)
