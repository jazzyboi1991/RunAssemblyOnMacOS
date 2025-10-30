#!/bin/bash

# AT&T 어셈블리 컴파일 스크립트 (Linux용)
# 사용법: ./compile.sh <파일명.asm|.s> [출력파일명]
# 주의: 이 스크립트는 Linux 환경에서 작동합니다. macOS에서는 Docker를 사용하세요.

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# OS 확인
OS=$(uname)
if [ "$OS" = "Darwin" ]; then
    echo -e "${RED}경고: macOS는 AT&T 어셈블리를 직접 지원하지 않습니다.${NC}"
    echo -e "${YELLOW}Linux 환경에서 실행하거나 Docker를 사용하세요.${NC}"
    echo ""
    echo -e "${BLUE}Docker 사용 예시:${NC}"
    echo "  docker run --rm -it -v \"\$(pwd)\":/work gcc:latest bash"
    echo "  cd /work"
    echo "  apt-get update && apt-get install -y gcc-multilib"
    echo "  ./compile.sh $@"
    echo ""
    read -p "계속하시겠습니까? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 인자 확인
if [ $# -eq 0 ]; then
    echo -e "${RED}오류: 어셈블리 파일을 지정해주세요.${NC}"
    echo "사용법: $0 <파일명.asm|.s> [출력파일명]"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_NAME="${2:-a.out}"

# 입력 파일 존재 확인
if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}오류: 파일 '$INPUT_FILE'을 찾을 수 없습니다.${NC}"
    exit 1
fi

# 파일 확장자 확인 및 basename 추출
FILENAME=$(basename "$INPUT_FILE")
DIRNAME=$(dirname "$INPUT_FILE")
EXTENSION="${FILENAME##*.}"
BASENAME="${FILENAME%.*}"
OBJ_FILE="${DIRNAME}/${BASENAME}.o"

echo -e "${YELLOW}=== AT&T 어셈블리 컴파일 시작 ===${NC}"
echo "입력 파일: $INPUT_FILE"
echo "출력 파일: $OUTPUT_NAME"
echo "OS: $OS"
echo ""

# 1단계: 어셈블
echo -e "${YELLOW}[1/2] 어셈블 중...${NC}"
gcc -m32 -c "$INPUT_FILE" -o "$OBJ_FILE" 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}어셈블 실패!${NC}"
    echo ""
    echo -e "${YELLOW}팁:${NC}"
    echo "1. Linux 환경인지 확인하세요"
    echo "2. gcc-multilib가 설치되어 있는지 확인하세요:"
    echo "   sudo apt-get install gcc-multilib"
    exit 1
fi
echo -e "${GREEN}✓ 어셈블 완료: $OBJ_FILE${NC}"
echo ""

# 2단계: 링킹
echo -e "${YELLOW}[2/2] 링킹 중...${NC}"
gcc -m32 "$OBJ_FILE" -o "$OUTPUT_NAME" -no-pie 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}링킹 실패!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ 링킹 완료: $OUTPUT_NAME${NC}"
echo ""

# 오브젝트 파일 정리 (선택사항)
# rm -f "$OBJ_FILE"

echo -e "${GREEN}=== 컴파일 성공! ===${NC}"
echo -e "실행하려면: ${YELLOW}./$OUTPUT_NAME${NC}"
