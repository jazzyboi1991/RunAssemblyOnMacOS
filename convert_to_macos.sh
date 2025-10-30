#!/bin/bash

# AT&T 어셈블리를 macOS LLVM 형식으로 변환
# 주의: 완벽한 변환을 보장하지 않으며, 수동 조정이 필요할 수 있습니다.

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_usage() {
    echo "사용법: $0 <입력파일.s> [출력파일.s]"
    echo ""
    echo "AT&T 어셈블리 파일을 macOS LLVM 어셈블러 형식으로 변환합니다."
    echo ""
    echo "예시:"
    echo "  $0 swap.s swap_macos.s"
    echo ""
    echo "주의사항:"
    echo "  - 32비트 코드는 macOS Catalina 이후 실행 불가"
    echo "  - 일부 지시어는 수동 조정 필요"
    echo "  - printf 등 외부 함수 호출 시 '_' 접두사 필요"
    exit 1
}

if [ $# -eq 0 ]; then
    show_usage
fi

INPUT_FILE="$1"
OUTPUT_FILE="${2:-${INPUT_FILE%.s}_macos.s}"

if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}오류: 파일 '$INPUT_FILE'을 찾을 수 없습니다.${NC}"
    exit 1
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   AT&T → macOS 어셈블리 변환기       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo "입력 파일: $INPUT_FILE"
echo "출력 파일: $OUTPUT_FILE"
echo ""

# 변환 수행
echo -e "${YELLOW}변환 중...${NC}"

sed -e '
    # 주석 변환: ; → #은 이미 되어있다고 가정

    # .section .rodata → .section __TEXT,__cstring,cstring_literals
    s/\.section \.rodata/.section __TEXT,__cstring,cstring_literals/g

    # .section .text → .text
    # (이미 .text이므로 변경 불필요)

    # .type 지시어 제거 (macOS에서 지원하지 않음)
    /\.type.*@function/d
    /\.type/d

    # 라벨에서 .LC0: → L_.str: 형식으로 변경
    s/^\.LC\([0-9]*\):/L_.str\1:/g
    s/\$\.LC\([0-9]*\)/\$L_.str\1/g

    # 외부 함수 호출에 _ 접두사 추가
    s/call printf/call _printf/g
    s/call scanf/call _scanf/g
    s/call malloc/call _malloc/g
    s/call free/call _free/g
    s/call exit/call _exit/g

    # .globl 심볼에 _ 접두사 추가 (main과 사용자 정의 함수)
    s/\.globl main/.globl _main/g
    s/^main:/_main:/g

    # 사용자 정의 함수 처리 (swap 등)
    s/\.globl swap/.globl _swap/g
    s/^swap:/_swap:/g
    s/call swap/call _swap/g

' "$INPUT_FILE" > "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 변환 완료!${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  중요 안내:${NC}"
    echo "1. 변환된 파일은 수동 검토가 필요할 수 있습니다"
    echo "2. macOS Catalina(10.15) 이후에서는 32비트 실행 불가"
    echo "3. 64비트로 변환하려면 레지스터 이름 변경 필요:"
    echo "   %eax → %rax, %ebx → %rbx, %ecx → %rcx, %edx → %rdx"
    echo "   %esp → %rsp, %ebp → %rbp"
    echo "   pushl → pushq, popl → popq, movl → movq"
    echo ""
    echo -e "${BLUE}컴파일 시도:${NC}"
    echo "  as -arch x86_64 $OUTPUT_FILE -o ${OUTPUT_FILE%.s}.o"
    echo "  ld ${OUTPUT_FILE%.s}.o -o ${OUTPUT_FILE%.s} -lSystem -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"
    echo ""
    echo -e "${YELLOW}권장:${NC} 32비트 코드는 Docker 사용을 권장합니다:"
    echo "  ./docker_compile.sh $INPUT_FILE output"
    echo "  ./docker_run.sh output"
else
    echo -e "${RED}✗ 변환 실패${NC}"
    exit 1
fi
