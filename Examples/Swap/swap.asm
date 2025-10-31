.section .rodata
.LC0:
    .string "a: %d, b: %d\n"

.text
    .globl swap
    .type swap, @function
swap:
    pushl %ebp              # 이전 프레임 포인터 저장
    movl %esp, %ebp         # 새로운 프레임 포인터 설정
    pushl %ebx              # callee-saved 레지스터 저장

    movl 12(%ebp), %ecx     # ecx = yp
    movl 8(%ebp), %edx      # edx = xp
    movl (%ecx), %eax       # eax = *yp (t1)
    movl (%edx), %ebx       # ebx = *xp (t0)
    movl %eax, (%edx)       # *xp = t1
    movl %ebx, (%ecx)       # *yp = t0

    popl %ebx               # ebx 복원
    movl %ebp, %esp         # 스택 포인터 복원
    popl %ebp               # 프레임 포인터 복원
    ret

    .globl main
    .type main, @function
main:
    pushl %ebp              # 이전 프레임 포인터 저장
    movl %esp, %ebp         # 새로운 프레임 포인터 설정
    subl $16, %esp          # 지역 변수를 위한 16바이트 할당

    movl $1, -4(%ebp)       # a = 1
    movl $2, -8(%ebp)       # b = 2

    leal -4(%ebp), %eax     # eax = &a
    movl %eax, -12(%ebp)    # xp = &a
    leal -8(%ebp), %eax     # eax = &b
    movl %eax, -16(%ebp)    # yp = &b

    pushl -16(%ebp)         # yp를 스택에 푸시
    pushl -12(%ebp)         # xp를 스택에 푸시
    call swap               # swap(xp, yp) 호출
    addl $8, %esp           # 스택 정리

    pushl -8(%ebp)          # b를 스택에 푸시
    pushl -4(%ebp)          # a를 스택에 푸시
    pushl $.LC0             # 포맷 문자열을 스택에 푸시
    call printf             # printf 호출
    addl $12, %esp          # 스택 정리

    movl $0, %eax           # 반환값 0

    movl %ebp, %esp         # 스택 포인터 복원
    popl %ebp               # 프레임 포인터 복원
    ret
