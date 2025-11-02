
.section .rodata                    # 읽기 전용 데이터 섹션
.LC0:
    .string "%d\n"                  # printf 포맷 문자열

.text                               # 코드 섹션
.globl doit                         # doit 함수를 전역으로 선언
.type doit, @function               # doit가 함수임을 명시

doit:
    # 함수 프롤로그: 스택 프레임 설정
    pushl %ebp                      # 이전 베이스 포인터 저장
    movl %esp, %ebp                 # 새로운 베이스 포인터 설정
    
    # 지역 변수를 위한 스택 공간 할당 (rval: -4(%ebp), t1: -8(%ebp))
    subl $8, %esp                   # 8바이트 스택 공간 할당
    
    # t1 = x + y 계산
    movl 8(%ebp), %eax              # x를 eax에 로드
    addl 12(%ebp), %eax             # y를 eax에 더함 (eax = x + y)
    movl %eax, -8(%ebp)             # t1에 결과 저장
    
    # t1 = t1 * 4 계산 (shift left by 2 = multiply by 4)
    movl -8(%ebp), %eax             # t1을 eax에 로드
    sall $2, %eax                   # 2비트 좌측 시프트 (x4)
    movl %eax, -8(%ebp)             # t1에 결과 저장
    
    # 반환값 설정 (C 코드 수정 가정: t1을 반환)
    movl -8(%ebp), %eax             # t1을 반환값 레지스터 eax에 로드
    
    # 함수 에필로그: 스택 프레임 정리
    movl %ebp, %esp                 # 스택 포인터 복원
    popl %ebp                       # 이전 베이스 포인터 복원
    ret                             # 호출자로 반환

.globl main                         # main 함수를 전역으로 선언
.type main, @function               # main이 함수임을 명시

main:
    # 함수 프롤로그: 스택 프레임 설정
    pushl %ebp                      # 이전 베이스 포인터 저장
    movl %esp, %ebp                 # 새로운 베이스 포인터 설정
    
    # 지역 변수를 위한 스택 공간 할당 (a: -4(%ebp), b: -8(%ebp), result: -12(%ebp))
    subl $16, %esp                  # 16바이트 스택 공간 할당 (16바이트 정렬)
    
    # int a = 1 초기화
    movl $1, -4(%ebp)               # a = 1
    
    # int b = 2 초기화
    movl $2, -8(%ebp)               # b = 2
    
    # doit(a, b) 함수 호출 준비
    pushl -8(%ebp)                  # b를 스택에 푸시 (두 번째 인자)
    pushl -4(%ebp)                  # a를 스택에 푸시 (첫 번째 인자)
    call doit                       # doit 함수 호출
    addl $8, %esp                   # 인자들을 스택에서 제거 (2 * 4바이트)
    
    # result = doit(a, b) 결과 저장
    movl %eax, -12(%ebp)            # doit의 반환값을 result에 저장
    
    # printf("%d\n", result) 호출 준비
    pushl -12(%ebp)                 # result를 스택에 푸시
    pushl $.LC0                     # 포맷 문자열 주소를 스택에 푸시
    call printf                     # printf 함수 호출
    addl $8, %esp                   # 인자들을 스택에서 제거
    
    # return 0
    movl $0, %eax                   # 반환값 0을 eax에 설정
    
    # 함수 에필로그: 스택 프레임 정리
    movl %ebp, %esp                 # 스택 포인터 복원
    popl %ebp                       # 이전 베이스 포인터 복원
    ret                             # 운영체제로 반환
