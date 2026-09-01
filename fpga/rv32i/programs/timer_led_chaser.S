.section .text
.globl _start


_start:
    lui  s0, 0x10000   #gpio base addr
    lui  s1, 0x30000   #timer base addr
    addi s2, x0, 1    #led status = 1
    li   t0, 13500000   #0.5s at 27Mhz
    addi t2, x0,64

restart_timer:
    sw   t0, 0(s1)      #timer load a N = 1000 yaz

wait_timer:
    lw t1, 4(s1)      #timer status oku t1'e
    bne t1, x0, wait_timer

    sw s2, 0(s0)      #ledi degistir
    slli s2,s2, 1

    bne s2,t2, restart_timer
    addi s2,x0,1
    jal x0, restart_timer


