# 읽기 전용 데이터 섹션
.section .rodata
.LC0:
    .string "%d\n"          # printf용 포맷 스트링

    # 코드 섹션
    .text
    .globl arith            # arith 함수를 전역으로 선언
    .type arith, @function  # arith를 함수 타입으로 지정
arith:
    # 함수 프롤로그: 스택 프레임 설정
    pushl %ebp              # 이전 베이스 포인터 저장
    movl %esp, %ebp         # 현재 스택 포인터를 베이스 포인터로 설정

    # 매개변수: x=8(%ebp), y=12(%ebp), z=16(%ebp)
    movl 8(%ebp), %eax          # %eax = x
    movl 12(%ebp), %edx         # %edx = y
    leal (%edx, %eax), %ecx     # %ecx = y + x (t1 = x + y)
    addl 16(%ebp), %ecx         # %ecx = z + t1 (t2 = z + x + y)
    leal 4(%eax), %eax          # %eax = x + 4 (t3 = x + 4)
    imull $48, %edx, %edx       # %edx = y * 48 (t4 = y * 48)
    addl %edx, %eax             # %eax = t3 + t4 (t5 = x + 4 + y*48)
    imull %ecx, %eax            # %eax = t2 * t5 (최종 결과)

    # 함수 에필로그: 스택 프레임 복원
    movl %ebp, %esp         # 스택 포인터 복원
    popl %ebp               # 이전 베이스 포인터 복원
    ret                     # 호출자로 반환 (결과는 %eax에 저장됨)

    .globl main             # main 함수를 전역으로 선언
    .type main, @function   # main을 함수 타입으로 지정
main:
    # 함수 프롤로그
    pushl %ebp              # 이전 베이스 포인터 저장
    movl %esp, %ebp         # 현재 스택 포인터를 베이스 포인터로 설정
    subl $16, %esp          # 지역 변수를 위한 스택 공간 할당 (16바이트)

    # int a = 1; int b = 2; int c = 3;
    movl $1, -4(%ebp)       # a = 1 (첫 번째 지역 변수)
    movl $2, -8(%ebp)       # b = 2 (두 번째 지역 변수)
    movl $3, -12(%ebp)      # c = 3 (세 번째 지역 변수)

    # result = arith(a, b, c);
    pushl -12(%ebp)         # 세 번째 인자 c를 스택에 푸시
    pushl -8(%ebp)          # 두 번째 인자 b를 스택에 푸시
    pushl -4(%ebp)          # 첫 번째 인자 a를 스택에 푸시
    call arith              # arith 함수 호출
    addl $12, %esp          # 스택 정리 (3개의 인자 * 4바이트 = 12바이트)
    movl %eax, -16(%ebp)    # 반환값(%eax)을 result 변수에 저장

    # printf("%d\n", result);
    pushl -16(%ebp)         # 두 번째 인자: result 값을 스택에 푸시
    pushl $.LC0             # 첫 번째 인자: 포맷 스트링 주소를 스택에 푸시
    call printf             # printf 함수 호출
    addl $8, %esp           # 스택 정리 (2개의 인자 * 4바이트 = 8바이트)

    # return 0;
    movl $0, %eax           # 반환값 0을 %eax에 저장

    # 함수 에필로그
    movl %ebp, %esp         # 스택 포인터 복원
    popl %ebp               # 이전 베이스 포인터 복원
    ret                     # 호출자로 반환
