#include <stdio.h>

int andor(int x, int y)
{
    int t2 = x & y;
    int t3 = 0xffffffff;
    int rval = t3 | t2;
    return rval;
}

int main()
{
    int a = 2;
    int b = 3;
    int result = andor(a, b);
    printf("%d\n", result);
    return 0;
}