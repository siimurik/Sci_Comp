/*
  Matrix multiplication using dynamic allocation
  Current matrix size def. under variable SIZE

  Siim Erik Pugal
*/
#include<stdio.h>
#include <stdlib.h>
#include <time.h>
#define SIZE 1000

const int DIMW = SIZE;
const int DIMH = SIZE;

int main()
{
    clock_t start, end;
    int i,j,k;
    double s, cpu_time_used, res;
/*allocating on the stack, can lead to a cap in allowed size
  resulting in a   "segmentation fault" */
//double A[DIMH][DIMW], B[DIMW][DIMH], Matrix[DIMH][DIMH];
/*solution to allocate on the heap using pointers*/
    double **matC, **matA, **matB;
    matA = (double **)malloc(DIMH*sizeof(double*));
    for(j=0;j<DIMH;j++)
        matA[j]=(double*)malloc(DIMW*sizeof(double));
    matB = (double **)malloc(DIMW*sizeof(double*));
    for(j=0;j<DIMW;j++)
        matB[j]=(double*)malloc(DIMH*sizeof(double));
    matC = (double **)malloc(DIMH*sizeof(double*));
    for(j=0;j<DIMH;j++)
        matC[j]=(double*)malloc(DIMH*sizeof(double));
/*end memory allocation*/
//-----------------------------------------------------------------------------
//Initialization of matricies
// Creates two random n x n matricies A and B between 0 and 1
  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j++) {
    matA[i][j] = ((double)rand()/(double)(RAND_MAX));
    matB[i][j] = ((double)rand()/(double)(RAND_MAX));
    //matA[i][j] = rand()%100;
    //matB[i][j] = rand()%100;
    //printf("%f\t", matA_100[i][j]);
    }
    //printf("\n");
  }
//------------------------------------------------------------------------------
// Prints elements of matrix A
    //printf("Elements of first matrix A\n");
    for (i = 0; i < SIZE; i++) {
      for (j = 0; j < SIZE; j++) {
    //    printf("%f\t", matA[i][j]);
      }
    //  printf("\n");
    }
//------------------------------------------------------------------------------
  // Prints elements of matrix B
    //  printf("Elements of first matrix B\n");
      for (i = 0; i < SIZE; i++) {
        for (j = 0; j < SIZE; j++) {
    //      printf("%f\t", matB[i][j]);
        }
    //    printf("\n");
      }
//------------------------------------------------------------------------------
// Matrix multiplication
// Version 1 code
/*
  start = clock();
  for(i = 0; i < SIZE; i++){
    for(j = 0; j < SIZE; j++){
      matC[i][j]=0;
      for(k = 0; k < SIZE; k++){
        matC[i][j] += matA[i][k] * matB[k][j];
      }
    }
  }
*/
/*
// Version 2 code
  for(j = 0; j < SIZE; j++){
    for(i = 0; i < SIZE; i++){
      matC[i][j]=0;
      for(k = 0; k < SIZE; k++){
        matC[i][j] += matA[i][k] * matB[k][j];
      }
    }
  }
*/
// Version 3 code
 /*
  for(k = 0; k < SIZE; k++){
    for(i = 0; i < SIZE; i++){
      matC[i][j]=0;
      for(j = 0; j < SIZE; j++){
        matC[i][j] += matA[i][k] * matB[k][j];
      }
    }
  }
  */

// /* Using transposed matricies
// Version 4
  for (i=0;i<SIZE;i++) //transposing matrix
  {
    for(j=0; j<i; j++)
    { s = matB[i][j]; matB[i][j] = matB[j][i]; matB[j][i] = s; }
  }
  for (j=0;j<SIZE;j++) //multiplication
  {
    for(i=0; i<SIZE; i++)
    {
      s=0;
      for(k=0; k<SIZE; k++)
      {
        s += matA[i][k] * matB[j][k]; //using transposed matrix B
      }
      matC[i][j] = s;
    }
  }
//  */
  end = clock();
  cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
//------------------------------------------------------------------------------
/* Printing the result of matrix multiplication
  //printf("Product of matrix multiplication C = A * B:\n");
  for (i = 0; i < SIZE; i++) {
    for (j = 0; j < SIZE; j++) {
  //    printf("%f\t", matC[i][j]);
    }
  //printf("\n");
  }
*/
//------------------------------------------------------------------------------
  printf("Matrix multiplication took %.3lf seconds.\n", cpu_time_used);

//get timing
    //time(&te);
    //tdiff=te-ts;
    //printf("%f %f %f\n",ts,te,tdiff);

//free memory if allocation on the heap was used
    free(matA);
    free(matB);
    free(matC);

    return 0;
}
