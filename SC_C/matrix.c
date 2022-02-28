#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define N 1000
// Using N>590 resulted in segmentation fault.
// Solution was to make matrixes static.
// Running any large array was really slow anyway.
// N=1000 ->  5 sec.
// N=1900 -> 56 sec.
// N=2000 -> 60 sec.
// N=2100 -> 80 sec.
// Tested on WSL ubuntu

int main() {
  printf("%d  ", N);
  // Init matrices
  static double mtx1[N][N];
  static double mtx2[N][N];
  static double res[N][N];
  srand(clock()); // Seed?

  // Fill matrices
  int i, j;
  for (i = 0; i < N; i++) {
    for (j = 0; j < N; j++) {
      mtx1[i][j] = (double) rand();
      mtx2[i][j] = (double) rand();
    }
  }
  clock_t start = clock();
  // Get product of matrices
  int k;
  double t;
  // iterating by row of mtx1
  for (i = 0; i < N; i++) {
    //iterating by column by mtx2
    for (j = 0; j < N; j++) {
      t = 0;
      // iterating by rows of mtx2
      for (k = 0; k < N; k++) {
        t += mtx1[i][k] * mtx2[k][j];
      }
      res[i][j] = t;
    }
  }

  clock_t end = clock();
  // Output
  float seconds = (float)(end - start) / CLOCKS_PER_SEC;
  //printf("%lF %9.6f", res[0][0], seconds);
  printf("%9.6f\n", seconds);
  return 0;
}

// I think this is my first non-hello-world C program.