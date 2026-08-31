.section .text
.globl _start

_start:
    lui  s0, 0x10000       // s0 = 0x10000000 GPIO output
    addi s1, s0, 4         // s1 = 0x10000004 GPIO input

    addi s2, x0, 1         // LED pattern = 000001
    addi s3, x0, 0         // direction: 0 = left, 1 = right


main_loop:
    sw   s2, 0(s0)         // current LED pattern -> GPIO
    jal  ra, delay

    // Button oku
    lw   t2, 0(s1)
    beq  t2, x0, move_led  // 0 = basili degil

    // Button basildi: yonu ters cevir
    xori s3, s3, 1


wait_release:
    lw   t2, 0(s1)
    bne  t2, x0, wait_release   // button birakilana kadar bekle


move_led:
    // direction == 0 ise sola kay
    bne  s3, x0, move_right


move_left:
    addi t3, x0, 32        // 100000 = son LED
    beq  s2, t3, left_edge

    slli s2, s2, 1
    jal  x0, main_loop


left_edge:
    addi s3, x0, 1         // artik saga gidecegiz
    srli s2, s2, 1
    jal  x0, main_loop


move_right:
    addi t3, x0, 1         // 000001 = ilk LED
    beq  s2, t3, right_edge

    srli s2, s2, 1
    jal  x0, main_loop


right_edge:
    addi s3, x0, 0         // artik sola gidecegiz
    slli s2, s2, 1
    jal  x0, main_loop


delay:
    addi t0, x0, 2000

outer_loop:
    addi t1, x0, 1000

inner_loop:
    addi t1, t1, -1
    bne  t1, x0, inner_loop

    addi t0, t0, -1
    bne  t0, x0, outer_loop

    jalr x0, 0(ra)
