#!/bin/bash

# Docker에서 Linux 실행 파일 실행
# 사용법: ./docker_run.sh <실행파일>

if [ $# -eq 0 ]; then
    echo "사용법: $0 <실행파일> [인자...]"
    exit 1
fi

EXECUTABLE="$1"
shift

if [ ! -f "$EXECUTABLE" ]; then
    echo "오류: 파일 '$EXECUTABLE'을 찾을 수 없습니다."
    exit 1
fi

# 32비트 실행 파일을 위한 환경 설정
docker run --rm \
    --platform linux/amd64 \
    -v "$(pwd)":/work \
    -w /work \
    ubuntu:20.04 \
    bash -c "
        # 32비트 라이브러리 설치 (처음 실행시에만)
        if [ ! -f /usr/lib32/libc.so.6 ]; then
            dpkg --add-architecture i386
            apt-get update -qq
            apt-get install -y libc6:i386 -qq > /dev/null 2>&1
        fi

        # 프로그램 실행
        /work/$EXECUTABLE $@
    "
