.section .text
.globl _start

_start:
    lui  s0, 0x10000    #GPIO base address
    lui  s1, 0x20000    #UART base address
    lui  s2, 0x30000    #TIMER base address
    addi s3, x0, 1      #led pattern
    addi s4, x0, 0      #led direction = 0
    li   s5, 6750000   #timer count = 0.5  s at 27MHz
    li   t4, 32         #pattern tasma kontrolu icin
    addi t5, x0, 1

boot_msg: #"SOC READY\n"
    li   a0, 83          # S
    jal  ra, putc
    li   a0, 79          # O
    jal  ra, putc
    li   a0, 67          # C
    jal  ra, putc
    li   a0, 32          # Space
    jal  ra, putc
    li   a0, 82          # R
    jal  ra, putc
    li   a0, 69          # E
    jal  ra, putc
    li   a0, 65          # A
    jal  ra, putc
    li   a0, 68          # D
    jal  ra, putc
    li   a0, 89          # Y
    jal  ra, putc
    li   a0, 10          # Newline
    jal  ra, putc

    jal  x0, main_loop

putc:
    lui  t0, 0x20000

wait_uart:
    lw   t1, 4(t0)
    bne  t1, x0, wait_uart

    sw   a0, 0(t0)
    ret

main_loop:
    sw  s5, 0(s2)       #timer degerini load a yukle

wait_timer:
    lw  t2, 4(s2)       #timer status oku
    bne t2, x0, wait_timer #bos degilse wait_timera don

    sw  s3, 0(s0)       #led patterini lede yaz.
    lw  t3, 4(s0)       # buton status oku
    beq t3, x0, move

    xori s4, s4, 1      #direction i tersle

wait_release:
    lw   t3, 4(s0)
    bne  t3, x0, wait_release


    beq s4, x0, uart_left
    jal x0, uart_right


uart_left:
    li   a0, 76          # L
    jal  ra, putc
    li   a0, 10
    jal  ra, putc
    jal  x0, move

uart_right:
    li   a0, 82          # R
    jal  ra, putc
    li   a0, 10
    jal  ra, putc
    jal  x0, move

move:
    beq s4, x0, move_left
    jal x0, move_right

move_left:
    beq s3, t4, wrap_left
    slli s3, s3, 1 #ledi bir sola kaydir
    jal x0, main_loop

wrap_left:
    addi s3, x0, 1
    jal x0, main_loop

move_right:
    beq s3, t5, wrap_right
    srli s3, s3, 1
    jal x0, main_loop

wrap_right:
    addi s3, x0, 32
    jal x0, main_loop
