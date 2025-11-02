#include <stdio.h>

int goto_max(int x, int y)
{
    int rval = y;
    int ok = (x <= y);
    if (ok)
    {
        goto done;
    }
    rval = x;
    
    done:
    return rval;
}

int main()
{
    int a = 1;
    int b = 2;
    int result1 = goto_max(a, b);
    
    int c = 4;
    int d = 3;
    int result2 = goto_max(c, d);

    printf("%d, %d\n", result1, result2);
    
    return 0;
}