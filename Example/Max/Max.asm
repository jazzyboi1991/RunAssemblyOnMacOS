# 읽기 전용 데이터 섹션
.section .rodata
.LC0:
    .string "%d\n"              # printf 포맷 문자열

# 코드 섹션
.text
.globl max                      # max 함수를 전역으로 선언
.type max @function

# max 함수: 두 정수 중 큰 값을 반환
# 매개변수: x (8(%ebp)), y (12(%ebp))
# 반환값: 더 큰 값 (%eax)
max:
    pushl %ebp                  # 이전 베이스 포인터 저장
    movl %esp, %ebp             # 새로운 스택 프레임 설정

    movl 8(%ebp), %edx          # 첫 번째 매개변수 x를 %edx에 로드
    movl 12(%ebp), %eax         # 두 번째 매개변수 y를 %eax에 로드
    cmpl %eax, %edx             # x와 y 비교 (x - y)
    jle L9                      # x <= y이면 L9로 점프
    movl %edx, %eax             # x > y이면 x를 반환값 레지스터로 복사
L9:
    movl %ebp, %esp             # 스택 포인터 복원
    popl %ebp                   # 이전 베이스 포인터 복원
    ret                         # 함수 반환

.globl main                     # main 함수를 전역으로 선언
.type main, @function

# main 함수: 프로그램의 진입점
main:
    pushl %ebp                  # 이전 베이스 포인터 저장
    movl %esp, %ebp             # 새로운 스택 프레임 설정
    subl $12, %esp              # 지역 변수를 위한 스택 공간 할당 (12바이트)

    # 지역 변수 초기화
    movl $1, -4(%ebp)           # int a = 1; (스택 오프셋 -4)
    movl $2, -8(%ebp)           # int b = 2; (스택 오프셋 -8)

    # max(a, b) 함수 호출
    pushl -8(%ebp)              # 두 번째 인자 b(2)를 스택에 푸시
    pushl -4(%ebp)              # 첫 번째 인자 a(1)를 스택에 푸시
    call max                    # max 함수 호출
    add $8, %esp                # 스택에서 인자들 제거 (8바이트)
    movl %eax, -12(%ebp)        # 반환값을 result 변수에 저장 (스택 오프셋 -12)

    # printf 함수 호출
    pushl -12(%ebp)             # 출력할 값(result)을 스택에 푸시
    pushl $.LC0                 # 포맷 문자열 주소를 스택에 푸시
    call printf                 # printf 함수 호출
    addl $8, %esp               # 스택에서 printf 인자들 제거 (8바이트)

    # 함수 종료
    movl $0, %eax               # 반환값 0을 %eax에 설정

    movl %ebp, %esp             # 스택 포인터 복원
    popl %ebp                   # 이전 베이스 포인터 복원

    ret                         # main 함수 반환
