#include <stdio.h>

void swap(int *xp, int *yp) {
    int t0 = *xp;
    int t1 = *yp;
    *xp = t1;
    *yp = t0;
}

int main() {
    int a = 1;
    int b = 2;
    int *xp = &a;
    int *yp = &b;

    swap(xp, yp);
    printf("a: %d, b: %d\n", a, b);

    return 0;
}
