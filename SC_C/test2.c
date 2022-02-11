#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int main()
{

    int r1 = 5000, c1 = 5000, r2 = 5000, c2 = 5000, i, j, k;

    // Dynamic allocation.

    double(*a)[r1][c1] = malloc(sizeof *a);
    double(*b)[r2][c2] = malloc(sizeof *b);
    double(*result)[r1][c2] = malloc(sizeof *result);

    // Storing elements of first matrix.
    for (i = 0; i < r1; ++i)
    {
        for (j = 0; j < c1; ++j)
        {
            (*a)[i][j] = rand() /RAND_MAX;
        }
    }

    // Storing elements of second matrix.

    for (i = 0; i < r2; ++i)
    {
        for (j = 0; j < c2; ++j)
        {
            (*b)[i][j] = rand()/ RAND_MAX;
        }
    }
    // Initializing all elements of result matrix to 0
    for (i = 0; i < r1; ++i)
    {
        for (j = 0; j < c2; ++j)
        {
            (*result)[i][j] = 0;
        }
    }
     clock_t begin1 = clock();
    // Multiplying matrices a and b and
    // storing result in result matrix
    for (i = 0; i < r1; ++i)
        for (j = 0; j < c2; ++j)
            for (k = 0; k < c1; ++k)
            {
                (*result)[i][j] += (*a)[i][k] * (*b)[k][j];
            }

    clock_t end1 = clock();
    double time_taken = (double)(end1 - begin1) / CLOCKS_PER_SEC;
   printf("\n \nfunction took %f seconds to execute \n", time_taken);
return 0;
}
