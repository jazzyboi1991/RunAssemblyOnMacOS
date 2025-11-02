// Assembly 코드를 C 언어로 변환한 함수
// 원본 Assembly 함수: doit
// 기능: 첫 번째 포인터가 가리키는 값을 두 번째 포인터가 가리키는 위치에 복사

void doit(int *src, int *dest) {
    // movl (%edx), %eax     ; 첫 번째 포인터가 가리키는 값을 읽기
    // movl %eax, (%ecx)     ; 두 번째 포인터가 가리키는 위치에 저장
    *dest = *src;
}