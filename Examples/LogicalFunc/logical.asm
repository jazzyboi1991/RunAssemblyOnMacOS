.section .rodata
.LC0:
    .string "%d\n"

    .text
    .globl logical
    .type logical @function

logical:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %eax
    xorl 12(%ebp), %eax
    sarl $17, %eax
    andl $8185, %eax

    movl %ebp, %esp
    popl %ebp
    ret

    .globl main
    .type main, @function

main:
    pushl %ebp
    movl %esp, %ebp
    subl $12, %esp

    movl $2, -4(%ebp)
    movl $3, -8(%ebp)

    pushl -8(%ebp)
    pushl -4(%ebp)
    call logical
    addl $8, %esp
    movl %eax, -12(%ebp)

    pushl -12(%ebp)
    pushl $.LC0
    call printf
    addl $12, %esp

    movl $0, %eax

    movl %ebp, %esp
    popl %ebp

    ret
