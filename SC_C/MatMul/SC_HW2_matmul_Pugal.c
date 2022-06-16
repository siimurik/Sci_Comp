#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(void)
{
  //srand((unsigned int)time(NULL));
  clock_t start, end;
  double cpu_time_used;
  int i,j,k,l,n;
  n = 5;
  double sum, matA_100[n][n], matB_100[n][n], matC_100[n][n], mult[n][n];

// Creates two random n x n matricies A and B between 0 and 1
  k = 1;
  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
    matA_100[i][j] = ((double)rand()/(double)(RAND_MAX)) * k;
    matB_100[i][j] = ((double)rand()/(double)(RAND_MAX)) * k;
    //printf("%f\t", matA_100[i][j]);
    }
    //printf("\n");
  }

// Prints elements of matrix A
  printf("Elements of first matrix A\n");
  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      printf("%f\t", matA_100[i][j]);
    }
    printf("\n");
  }

// Prints elements of matrix B
  printf("Elements of first matrix B\n");
  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      printf("%f\t", matB_100[i][j]);
    }
    printf("\n");
  }

// Matrix multiplication, which we want to measure
  start = clock();
  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      for (l = 0; l < n; l++) {
      sum = sum + matA_100[i][l]*matB_100[l][j];
      }
    matC_100[i][j] = sum;
    sum = 0.0;
    }
  }
  end = clock();
  cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;

/* Prolly sth wrong
// Different approach
  start = clock();
  for (i = 0; i < n; i++) {
    for (l = 0; l < n; l++) {
      mult[i][l] = matA_100[i][0]*matB_100[0][l];
      for (j = 1; j < n; j++) {
        mult[i][j] += matA_100[i][j] * matB_100[j][l];
      }
    }
  }
  end = clock();
  cpu_time_used = (end - start) / CLOCKS_PER_SEC;
  printf("/n%Matrix multiplication took %f seconds.\n", cpu_time_used);
  */


  printf("Product of matrix multiplication C = A * B:\n");
  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      printf("%f\t", matC_100[i][j]);
    }
  printf("\n");
  }
  printf("Matrix multiplication took %f seconds.\n", cpu_time_used);

  /*
  printf("\nProduct of matrix multiplication (2nd method) C = A * B:\n");
  for (i=0;i<n;i++){
    for (j=0;j<n;j++) {
      printf("%f\t", mult[i][j]); //display table
    }
    printf("\n");
  }
  */

  return 0;
}
