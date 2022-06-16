#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define SIZE 500

int main(void)
{
    static int A[SIZE][SIZE], B[SIZE][SIZE], C[SIZE][SIZE] = {0};
    int i, j, k;

    srand(time(NULL));

    for(i = 0; i < SIZE; i++)
    {
        for(j = 0; j < SIZE; j++)
        {
            A[i][j] = rand()%100;
            B[i][j] = rand()%100;
        }
    }

    clock_t begin, end;
    double time_spent;

    begin = clock();

    for(k = 0; k < SIZE; k++)
        for(i = 0; i < SIZE; i++)
            for(j = 0; j < SIZE; j++)
                C[i][j] += A[i][k] * B[k][j];

    end = clock();

    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;

    printf("Elapsed time: %.3lf seconds.\n", time_spent);

    // Testing different matrix multiplication algorithms
/*
  // This function multiplies mat1[][] and mat2[][],
  // and stores the result in res[][]
  void multiply(int A[][SIZE], int B[][SIZE], int C[][SIZE])
  {
      int i, j, k;
      for (i = 0; i < SIZE; i++) {
          for (j = 0; j < SIZE; j++) {
              C[i][j] = 0;
              for (k = 0; k < SIZE; k++)
                  C[i][j] += A[i][k] * B[k][j];
          }
      }
  }
  begin = clock();
  multiply(A, B, C);
  end = clock();
  time_spent = ((double)(end - begin)) / CLOCKS_PER_SEC;
  printf("2nd matrix multiplication took %.3lf seconds.\n", time_spent);


  void multiply2(int m1, int m2, int mat1[][m2], int n1,
              int n2, int mat2[][n2])
{
    int x, i, j;
    int res[m1][n2];
    for (i = 0; i < m1; i++)
    {
        for (j = 0; j < n2; j++)
        {
            res[i][j] = 0;
            for (x = 0; x < m2; x++)
            {
                *(*(res + i) + j) += *(*(mat1 + i) + x)
                                     * *(*(mat2 + x) + j);
            }
        }
    }

    for (i = 0; i < m1; i++)
    {
        for (j = 0; j < n2; j++)
        {
        //    printf("%d ", *(*(res + i) + j));
        }
        //printf("");
    }
}

int m1 = SIZE, m2 = SIZE, n1 = SIZE, n2 = SIZE;

// Function call

return 0;
begin = clock();
multiply2(m1, m2, A, n1, n2, B);
end = clock();
time_spent = ((double)(end - begin)) / CLOCKS_PER_SEC;
printf("3rd matrix multiplication took %.3lf seconds.\n", time_spent);*/


    return 0;
}
