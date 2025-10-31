# English description is below!

# 요약:
## macOS에서 예시:
./docker_compile.sh Swap/swap.asm swap
./docker_run.sh swap

# AT&T 어셈블리 컴파일 가이드 (macOS)

## 🎯 macOS에서 AT&T 어셈블리 사용하기

macOS는 LLVM 어셈블러를 사용하므로 GNU AT&T 어셈블리 문법을 직접 지원하지 않습니다.
하지만 **Docker**를 사용하면 macOS에서도 AT&T 어셈블리를 쉽게 컴파일하고 실행할 수 있습니다!

---

## 🚀 빠른 시작 (권장 방법)

### 1단계: Docker 설치
[Docker Desktop for Mac](https://www.docker.com/products/docker-desktop) 다운로드 및 설치

### 2단계: 컴파일 및 실행
```bash
# AT&T 어셈블리 컴파일
./docker_compile.sh Swap/swap.asm swap

# 컴파일된 프로그램 실행
./docker_run.sh swap
```

**끝!** 이게 전부입니다. 추가 설정 필요 없음.

---

## 📝 사용 방법

### Docker 기반 컴파일 (가장 쉬움)
```bash
# 기본 사용
./docker_compile.sh <파일.asm> [출력파일명]

# 예시
./docker_compile.sh Swap/swap.asm my_program
./docker_run.sh my_program
```

### Linux 환경에서 직접 컴파일
Linux나 WSL2를 사용하는 경우:
```bash
./compile.sh Swap/swap.asm swap
./swap
```

### C 버전으로 테스트
로직만 확인하려는 경우:
```bash
gcc -m32 Swap/swap.c -o swap
./swap
```

---

## 📁 파일 설명

| 파일 | 설명 | 사용 환경 |
|------|------|-----------|
| `docker_compile.sh` | Docker 기반 컴파일 스크립트 | **macOS (권장)** |
| `docker_run.sh` | Docker에서 실행 | macOS |
| `compile.sh` | 직접 컴파일 스크립트 | Linux/WSL2 |
| `compile_macos.sh` | macOS 형식 변환 시도 (실험용) | macOS |
| `convert_to_macos.sh` | 수동 변환 도구 | macOS |
| `Swap/swap.asm` | 원본 AT&T 어셈블리 | Linux |
| `Swap/swap.c` | C 버전 (테스트용) | 모든 환경 |

---

## ❓ FAQ

### Q: Docker가 없으면 어떻게 하나요?
**A:** 다음 중 하나를 선택하세요:
1. Docker 설치 (5분, 가장 쉬움)
2. Linux 가상 머신 사용 (VirtualBox, UTM)
3. C 버전으로 테스트 (`gcc -m32 Swap/swap.c -o swap`)

### Q: macOS에서 직접 컴파일이 불가능한 이유는?
**A:** macOS는 다음 문제들이 있습니다:
- LLVM 어셈블러가 GNU AT&T 문법을 지원하지 않음
- 32비트 실행 파일 지원 종료 (Catalina 이후)
- 세미콜론(`;`) 주석 미지원
- ELF 형식 대신 Mach-O 형식 사용

### Q: Docker 없이 macOS에서 할 수 있나요?
**A:** 이론적으로는 가능하지만 매우 복잡합니다:
- Homebrew로 GNU binutils 설치
- 크로스 컴파일 환경 구축
- 결과물을 실행할 수 없음 (32비트 미지원)

Docker가 훨씬 간단합니다!

---

## 🔧 트러블슈팅

### "Docker가 실행되고 있지 않습니다"
→ Docker Desktop 애플리케이션을 실행하세요

### "permission denied: ./docker_compile.sh"
```bash
chmod +x docker_compile.sh docker_run.sh
```

### "no matching manifest for linux/arm64/v8"
M1/M2 Mac의 경우, Docker가 자동으로 처리합니다. 시간이 조금 더 걸릴 수 있습니다.

---

## 🎓 학습 팁

1. **처음**: C 버전으로 로직 이해
2. **다음**: AT&T 어셈블리로 구현
3. **마지막**: 디버깅 시 `objdump` 활용
   ```bash
   docker run --rm -v "$(pwd)":/work gcc:latest objdump -d swap
   ```

---

## 💡 권장 워크플로우

```bash
# 1. 코드 작성/수정
vim Swap/swap.asm

# 2. 컴파일
./docker_compile.sh Swap/swap.asm swap

# 3. 실행 및 테스트
./docker_run.sh swap

# 4. 필요시 디버깅
docker run --rm -it -v "$(pwd)":/work gcc:latest bash
# 컨테이너 안에서: gdb swap
```

---

**🎉 이제 macOS에서도 AT&T 어셈블리를 자유롭게 사용할 수 있습니다!**

---
---

# Summary:
## Example on macOS:
./docker_compile.sh Swap/swap.asm swap
./docker_run.sh swap

# AT&T Assembly Compilation Guide (macOS)

## 🎯 Using AT&T Assembly on macOS

macOS uses the LLVM assembler, which does not directly support GNU AT&T assembly syntax.
However, using **Docker**, you can easily compile and run AT&T assembly on macOS!

---

## 🚀 Quick Start (Recommended Method)

### Step 1: Install Docker
Download and install [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop)

### Step 2: Compile and Run
```bash
# Compile AT&T assembly
./docker_compile.sh Swap/swap.asm swap

# Run the compiled program
./docker_run.sh swap
```

**Done!** That's all. No additional setup required.

---

## 📝 Usage

### Docker-based Compilation (Easiest)
```bash
# Basic usage
./docker_compile.sh <file.asm> [output_filename]

# Example
./docker_compile.sh Swap/swap.asm my_program
./docker_run.sh my_program
```

### Direct Compilation on Linux Environment
If you're using Linux or WSL2:
```bash
./compile.sh Swap/swap.asm swap
./swap
```

### Test with C Version
If you just want to verify the logic:
```bash
gcc -m32 Swap/swap.c -o swap
./swap
```

---

## 📁 File Description

| File | Description | Environment |
|------|-------------|-------------|
| `docker_compile.sh` | Docker-based compilation script | **macOS (Recommended)** |
| `docker_run.sh` | Run in Docker | macOS |
| `compile.sh` | Direct compilation script | Linux/WSL2 |
| `compile_macos.sh` | macOS format conversion attempt (experimental) | macOS |
| `convert_to_macos.sh` | Manual conversion tool | macOS |
| `Swap/swap.asm` | Original AT&T assembly | Linux |
| `Swap/swap.c` | C version (for testing) | All environments |

---

## ❓ FAQ

### Q: What if I don't have Docker?
**A:** Choose one of the following:
1. Install Docker (5 minutes, easiest)
2. Use a Linux virtual machine (VirtualBox, UTM)
3. Test with C version (`gcc -m32 Swap/swap.c -o swap`)

### Q: Why is direct compilation impossible on macOS?
**A:** macOS has the following issues:
- LLVM assembler does not support GNU AT&T syntax
- 32-bit executable support discontinued (since Catalina)
- Semicolon (`;`) comments not supported
- Uses Mach-O format instead of ELF format

### Q: Can I do it on macOS without Docker?
**A:** Theoretically possible, but very complex:
- Install GNU binutils via Homebrew
- Set up cross-compilation environment
- Cannot run the result (32-bit not supported)

Docker is much simpler!

---

## 🔧 Troubleshooting

### "Docker is not running"
→ Launch the Docker Desktop application

### "permission denied: ./docker_compile.sh"
```bash
chmod +x docker_compile.sh docker_run.sh
```

### "no matching manifest for linux/arm64/v8"
For M1/M2 Macs, Docker handles this automatically. It may take a bit longer.

---

## 🎓 Learning Tips

1. **First**: Understand the logic with C version
2. **Next**: Implement with AT&T assembly
3. **Finally**: Use `objdump` for debugging
   ```bash
   docker run --rm -v "$(pwd)":/work gcc:latest objdump -d swap
   ```

---

## 💡 Recommended Workflow

```bash
# 1. Write/modify code
vim Swap/swap.asm

# 2. Compile
./docker_compile.sh Swap/swap.asm swap

# 3. Run and test
./docker_run.sh swap

# 4. Debug if needed
docker run --rm -it -v "$(pwd)":/work gcc:latest bash
# Inside container: gdb swap
```

---

**🎉 Now you can freely use AT&T assembly on macOS!**
