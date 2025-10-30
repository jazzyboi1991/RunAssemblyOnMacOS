#!/bin/bash

# Docker를 사용한 AT&T 어셈블리 컴파일 스크립트 (macOS용)
# Linux GCC 환경에서 컴파일 수행

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_usage() {
    echo "사용법: $0 <파일명.asm> [출력파일명]"
    echo ""
    echo "이 스크립트는 Docker 컨테이너에서 Linux GCC를 사용하여"
    echo "AT&T 어셈블리 코드를 컴파일합니다."
    exit 1
}

# Docker 설치 확인
check_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}오류: Docker가 설치되어 있지 않습니다.${NC}"
        echo ""
        echo "Docker 설치 방법:"
        echo "1. https://www.docker.com/products/docker-desktop 방문"
        echo "2. Docker Desktop for Mac 다운로드 및 설치"
        echo "3. Docker Desktop 실행"
        exit 1
    fi

    # Docker 데몬 실행 확인
    if ! docker info &> /dev/null; then
        echo -e "${RED}오류: Docker가 실행되고 있지 않습니다.${NC}"
        echo "Docker Desktop을 실행해주세요."
        exit 1
    fi
}

if [ $# -eq 0 ]; then
    show_usage
fi

INPUT_FILE="$1"
OUTPUT_NAME="${2:-a.out}"

if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}오류: 파일 '$INPUT_FILE'을 찾을 수 없습니다.${NC}"
    exit 1
fi

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Docker AT&T 어셈블리 컴파일러       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Docker 확인
echo -e "${YELLOW}[0/3] Docker 환경 확인...${NC}"
check_docker
echo -e "${GREEN}✓ Docker 준비 완료${NC}"
echo ""

# 파일 정보
FILENAME=$(basename "$INPUT_FILE")
DIRNAME=$(dirname "$INPUT_FILE")
BASENAME="${FILENAME%.*}"
REL_DIR=$(basename "$DIRNAME")
OBJ_FILE="${BASENAME}.o"

echo "입력 파일: $INPUT_FILE"
echo "출력 파일: $OUTPUT_NAME"
echo ""

# Docker 컨테이너에서 컴파일 실행
echo -e "${YELLOW}[Docker] Linux 환경에서 컴파일 중...${NC}"
echo ""

docker run --rm \
    --platform linux/amd64 \
    -v "$(pwd)":/work \
    -w /work \
    ubuntu:20.04 \
    bash -c "
        echo '[Docker] 32비트 컴파일 환경 설치 중...'
        dpkg --add-architecture i386
        apt-get update -qq
        DEBIAN_FRONTEND=noninteractive apt-get install -y gcc-multilib g++ libc6-dev-i386 -qq

        if [ \$? -ne 0 ]; then
            echo '오류: 32비트 컴파일 도구 설치 실패'
            exit 1
        fi

        echo '✓ 환경 설치 완료'
        echo ''

        cd /work
        INPUT='$INPUT_FILE'
        BASENAME='$BASENAME'
        OUTPUT='$OUTPUT_NAME'
        OBJ=\"\${BASENAME}.o\"

        echo '[1/2] 어셈블 중...'
        gcc -m32 -x assembler -c \"\$INPUT\" -o \"\$OBJ\"
        if [ \$? -eq 0 ]; then
            echo '✓ 어셈블 완료: '\$OBJ
        else
            echo '✗ 어셈블 실패'
            exit 1
        fi

        echo ''
        echo '[2/2] 링킹 중...'
        gcc -m32 \"\$OBJ\" -o \"\$OUTPUT\" -no-pie
        if [ \$? -eq 0 ]; then
            echo '✓ 링킹 완료: '\$OUTPUT
        else
            echo '✗ 링킹 실패'
            exit 1
        fi

        # 권한 설정
        chmod +x \"\$OUTPUT\"

        echo ''
        echo '=== 컴파일 성공! ==='
    "

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║        컴파일 성공!                   ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}참고:${NC} 생성된 실행 파일은 Linux용입니다."
    echo "macOS에서 직접 실행할 수 없습니다."
    echo ""
    echo -e "Docker에서 실행: ${BLUE}docker run --rm -v \"\$(pwd)\":/work -w /work gcc:latest ./$OUTPUT_NAME${NC}"
    echo -e "또는 간단히: ${BLUE}./docker_run.sh $OUTPUT_NAME${NC}"
else
    echo -e "${RED}컴파일 실패!${NC}"
    exit 1
fi
