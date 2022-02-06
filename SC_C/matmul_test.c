#include <stdio.h>
#include <stdlib.h>
#include <time.h>
  const int ROWS = 1000;
  const int COLS = 1000;
  const int ROWS1 = 1000;
  const int COLS1 = 1000;
  const int l = 1000;
  double random_matrix[ROWS][COLS];
  double random_matrix1[ROWS1][COLS1];

  double mult[l][l];
  int i;
  int j;
  /* generate number: */
  for (i = 0; i < ROWS; i++) {
      for (j = 0; j < COLS; j++)
          random_matrix[i][j] = i + j;
  }
  for (i = 0; i < ROWS1; i++) {
      for (j = 0; j < COLS1; j++)
          random_matrix1[i][j] = i + j;
  }


  for (size_t row = 0; row < ROWS; ++row) {
      for (size_t tmp = 0; tmp < COLS1; ++tmp) {
          mult[row][tmp] = random_matrix[row][0]*random_matrix1[0][tmp];
          for (size_t col = 1; col < COLS; ++col) {
              mult[row][tmp] += random_matrix[row][col] * random_matrix1[col][tmp];
          }
      }
  }
