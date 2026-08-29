.section .text
.globl _start

_start:
    addi sp,x0, 0x100
    addi t0, x0, -4
    sw t0, 0(x0)
    addi t0, x0, 1
    sw t0, 4(x0)
    addi t0, x0, 2
    sw t0, 8(x0)
    addi t0, x0, 3
    sw t0, 12(x0)
    addi t0, x0, -4
    sw t0, 16(x0)

    addi a0,x0,0 // dizinin baslangic byte adresi 0
    addi a1,x0,5 // dizide 5 eleman var
    jal ra, sum_positive
    add s1,x0,a0 // sum sonucu s0 da kaydedilsin
    jal ra, blink_n
    jal x0, end

sum_positive:
    add t1,x0,a0 // t1 current pointer
    add t2,x0,a1 // kalan eleman
    add t3,x0,x0 // toplam
    add t4,x0,x0 // temp ram okuma registeri

loop:
    beq t2,x0,sum_done
    lw t4, 0(t1) //t1 memory adresindeki wordu t4 e yukle
    bge x0,t4, adder
    add t3,t3,t4

adder:
    addi t1,t1,4 // pointeri sonraki worde gecir.
    addi t2,t2,-1 // kalan eleman sayisi -1
    jal x0, loop

sum_done:
    add a0, x0, t3 // sonucu a0 a ver
    jalr x0, 0(ra) // ra adresine atla

blink_n:
    addi sp, sp, -16 // 4 wordluk yer ac
    sw ra, 0(sp)
    sw s0, 4(sp)
    add s0, x0, a0 //a0 dan gelen blink inputunu s0a at.

blink_loop:
    beq s0, x0, blink_done
    addi a0, x0, 1
    jal ra, delay
    add a0, x0,x0
    jal ra,delay
    addi s0, s0, -1
    jal x0, blink_loop

delay:
    addi t0,x0,2000 //outer delay  2000

inner_delay:
    addi t1,x0,2000 //inner delay 2000

delay_loop:
    beq t1,x0,azalt
    addi t1,t1,-1
    jal x0,delay_loop

azalt:
    addi t0,t0,-1
    beq t0,x0,delay_done
    jal x0, inner_delay

delay_done:
    jalr x0, 0(ra)

blink_done:
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 16
    jalr x0, 0(ra)


end:
    jal x0,end
