.section .rodata
.LC0:
    .string "%d\n"

    .text
    .globl andor
    .type andor, @function

andor:
    pushl %ebp                      # 이전 베이스 포인터 저장
    movl %esp, %ebp                 # 새로운 스택 프레임 설정

    movl 8(%ebp), %eax              # eax = x (첫 번째 인자)
    andl 12(%ebp), %eax             # eax = x & y (t2 계산)
    orl $-1, %eax                   # eax = t2 | 0xffffffff (rval 계산)

    movl %ebp, %esp                 # 스택 포인터 복원
    popl %ebp                       # 이전 베이스 포인터 복원
    ret                             # 반환 (결과는 eax에 저장됨)

.globl main
.type main, @function

main:
    pushl %ebp                      # 이전 베이스 포인터 저장
    movl %esp, %ebp                 # 새로운 스택 프레임 설정
    subl $16, %esp                  # 지역 변수를 위한 스택 공간 확보

    movl $2, -4(%ebp)               # int a = 2
    movl $3, -8(%ebp)               # int b = 3

    # andor(a, b) 호출
    pushl -8(%ebp)                  # 두 번째 인자 b 푸시
    pushl -4(%ebp)                  # 첫 번째 인자 a 푸시
    call andor                      # andor 함수 호출
    addl $8, %esp                   # 스택 정리 (인자 2개 * 4바이트)

    movl %eax, -12(%ebp)            # int result = andor(a, b)

    # printf("%d\n", result) 호출
    pushl -12(%ebp)                 # 두 번째 인자 result 푸시
    pushl $.LC0                     # 첫 번째 인자 포맷 스트링 주소 푸시
    call printf                     # printf 함수 호출
    addl $8, %esp                   # 스택 정리 (인자 2개 * 4바이트)

    movl $0, %eax                   # 반환값 0 설정

    movl %ebp, %esp                 # 스택 포인터 복원
    popl %ebp                       # 이전 베이스 포인터 복원
    ret                             # main 함수 종료
