.section .rodata
.text
.globl doit
.type doit, @function

doit:
    pushl #ebp
    movl %esp, %ebp

    movl 12(%ebp), %ecx
    movl 8(%ebp), %edx
    movl (%edx), %eax
    movl %eax, (%ecx)

    movl %ebp, %esp
    popl %ebp
    ret

