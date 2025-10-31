# 프로그램: 논리 연산 함수 예제
# 설명: XOR, 산술 쉬프트, AND 연산을 수행하는 함수

.section .rodata              # 읽기 전용 데이터 섹션
.LC0:
    .string "%d\n"            # printf를 위한 포맷 문자열 (정수 출력)

    .text                     # 코드 섹션 시작
    .globl logical            # logical 함수를 전역으로 선언
    .type logical @function   # logical을 함수 타입으로 지정

# 함수: logical
# 매개변수:
#   - 8(%ebp): 첫 번째 정수 인자
#   - 12(%ebp): 두 번째 정수 인자
# 반환값: %eax (계산 결과)
# 설명: (arg1 XOR arg2) >> 17 & 8185 연산 수행
logical:
    pushl %ebp                # 이전 베이스 포인터를 스택에 저장
    movl %esp, %ebp           # 현재 스택 포인터를 베이스 포인터로 설정 (함수 프롤로그)

    movl 8(%ebp), %eax        # 첫 번째 인자를 %eax 레지스터에 로드
    xorl 12(%ebp), %eax       # 두 번째 인자와 XOR 연산 수행 (배타적 논리합)
    sarl $17, %eax            # 산술 오른쪽 쉬프트 17비트 (부호 확장)
    andl $8185, %eax          # 8185(0x1FF9)와 AND 연산 수행 (비트 마스킹)

    movl %ebp, %esp           # 스택 포인터 복원
    popl %ebp                 # 이전 베이스 포인터 복원 (함수 에필로그)
    ret                       # 호출자로 반환 (결과는 %eax에 저장됨)

    .globl main               # main 함수를 전역으로 선언
    .type main, @function     # main을 함수 타입으로 지정

# 함수: main
# 설명: 프로그램 진입점
# 동작: logical(2, 3)을 호출하고 결과를 출력
main:
    pushl %ebp                # 이전 베이스 포인터를 스택에 저장
    movl %esp, %ebp           # 현재 스택 포인터를 베이스 포인터로 설정
    subl $12, %esp            # 지역 변수를 위한 스택 공간 12바이트 할당
                              # -4(%ebp): 첫 번째 변수 (값: 2)
                              # -8(%ebp): 두 번째 변수 (값: 3)
                              # -12(%ebp): logical 함수의 반환값 저장

    movl $2, -4(%ebp)         # 첫 번째 지역 변수에 2 저장
    movl $3, -8(%ebp)         # 두 번째 지역 변수에 3 저장

    # logical 함수 호출 준비 (오른쪽에서 왼쪽으로 인자 푸시)
    pushl -8(%ebp)            # 두 번째 인자(3)를 스택에 푸시
    pushl -4(%ebp)            # 첫 번째 인자(2)를 스택에 푸시
    call logical              # logical 함수 호출
    addl $8, %esp             # 스택에서 인자 제거 (2개 × 4바이트 = 8바이트)
    movl %eax, -12(%ebp)      # logical 함수의 반환값을 지역 변수에 저장

    # printf 함수 호출 준비
    pushl -12(%ebp)           # logical 함수의 결과값을 스택에 푸시
    pushl $.LC0               # 포맷 문자열 주소를 스택에 푸시
    call printf               # printf 함수 호출하여 결과 출력
    addl $12, %esp            # 스택 정리 (포맷 문자열 포인터 4바이트 + 정수 4바이트 + 정렬 4바이트)

    movl $0, %eax             # 반환값 0 설정 (프로그램 정상 종료)

    movl %ebp, %esp           # 스택 포인터 복원
    popl %ebp                 # 베이스 포인터 복원

    ret                       # 프로그램 종료
