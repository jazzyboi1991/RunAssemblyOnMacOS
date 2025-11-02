#include <stdio.h>

int doit(int x, int y)
{
    int rval;
    int t1 = x + y;
    t1 = t1 * 4;
    return rval;
}

int main()
{
    int a = 1;
    int b = 2;
    int result = doit(a, b);
    printf("%d\n", result);
    return 0;
}