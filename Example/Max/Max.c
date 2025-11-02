#include <stdio.h>

int max(int x, int y)
{
    if (x > y)
        return x;
    else
        return y;
}

int main()
{
    int a = 1;
    int b = 2;
    int result = max(a, b);
    printf("%d\n", result);
    return 0;
}