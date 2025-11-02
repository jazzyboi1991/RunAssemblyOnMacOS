# 읽기 전용 데이터 섹션
.section .rodata
.LC0:
    .string "%d, %d\n"          # printf 포맷 문자열

# 코드 섹션
.text
.globl goto_max                 # goto_max 함수를 전역으로 선언
.type goto_max @function

# goto_max 함수: goto문을 사용하여 두 정수 중 큰 값을 반환
# 매개변수: x (8(%ebp)), y (12(%ebp))
# 반환값: 더 큰 값 (%eax)
goto_max:
    pushl %ebp                  # 이전 베이스 포인터 저장
    movl %esp, %ebp             # 새로운 스택 프레임 설정
    subl $8, %esp               # 지역 변수를 위한 스택 공간 할당

    # int rval = y;
    movl 12(%ebp), %eax         # y를 %eax에 로드
    movl %eax, -4(%ebp)         # rval = y (스택 오프셋 -4)

    # int ok = (x <= y);
    movl 8(%ebp), %edx          # x를 %edx에 로드
    movl 12(%ebp), %eax         # y를 %eax에 로드
    cmpl %eax, %edx             # x와 y 비교 (x - y)
    setle %al                   # x <= y이면 %al = 1, 아니면 0
    movzbl %al, %eax            # %al을 32비트로 확장
    movl %eax, -8(%ebp)         # ok = (x <= y) (스택 오프셋 -8)

    # if (ok) goto done;
    cmpl $0, -8(%ebp)           # ok와 0 비교
    jne done                    # ok가 0이 아니면 done으로 점프

    # rval = x;
    movl 8(%ebp), %eax          # x를 %eax에 로드
    movl %eax, -4(%ebp)         # rval = x

done:
    # return rval;
    movl -4(%ebp), %eax         # rval을 반환값 레지스터로 로드

    movl %ebp, %esp             # 스택 포인터 복원
    popl %ebp                   # 이전 베이스 포인터 복원
    ret                         # 함수 반환

.globl main                     # main 함수를 전역으로 선언
.type main, @function

# main 함수: 프로그램의 진입점
main:
    pushl %ebp                  # 이전 베이스 포인터 저장
    movl %esp, %ebp             # 새로운 스택 프레임 설정
    subl $24, %esp              # 지역 변수를 위한 스택 공간 할당

    # int a = 1; int b = 2;
    movl $1, -4(%ebp)           # a = 1
    movl $2, -8(%ebp)           # b = 2

    # int result1 = goto_max(a, b);
    pushl -8(%ebp)              # b를 스택에 푸시
    pushl -4(%ebp)              # a를 스택에 푸시
    call goto_max               # goto_max 함수 호출
    addl $8, %esp               # 스택에서 인자들 제거
    movl %eax, -12(%ebp)        # result1 = 반환값

    # int c = 4; int d = 3;
    movl $4, -16(%ebp)          # c = 4
    movl $3, -20(%ebp)          # d = 3

    # int result2 = goto_max(c, d);
    pushl -20(%ebp)             # d를 스택에 푸시
    pushl -16(%ebp)             # c를 스택에 푸시
    call goto_max               # goto_max 함수 호출
    addl $8, %esp               # 스택에서 인자들 제거
    movl %eax, -24(%ebp)        # result2 = 반환값

    # printf("%d, %d\n", result1, result2);
    pushl -24(%ebp)             # result2를 스택에 푸시
    pushl -12(%ebp)             # result1을 스택에 푸시
    pushl $.LC0                 # 포맷 문자열을 스택에 푸시
    call printf                 # printf 함수 호출
    addl $12, %esp              # 스택에서 printf 인자들 제거

    # return 0;
    movl $0, %eax               # 반환값 0을 %eax에 설정

    movl %ebp, %esp             # 스택 포인터 복원
    popl %ebp                   # 이전 베이스 포인터 복원
    ret                         # main 함수 반환
