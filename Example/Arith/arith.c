#include <stdio.h>

int arith(int x, int y, int z)
{
    int t1 = x + y;
    int t2 = z + t1;
    int t3 = x + 4;
    int t4 = y * 48;
    int t5 = t3 + t4;
    int rval = t2 * t5;
    return rval;
}

int main()
{
    int a = 1;
    int b = 2;
    int c = 3;
    int result = arith(a, b, c);

    printf("%d\n", result);

    return 0;
}