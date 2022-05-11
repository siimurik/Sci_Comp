/*
  Program for 2-D steady heat conduction equation using
  Finite Difference Method

  This solution uses the Jacobi method

  Author: Siim Erik Pugal
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#define NDIM 31

void transfer(char *filename, double a[][NDIM], int n, int m){
  printf("\n Creating %s.csv file.", filename);
  FILE *fp;
  int i,j;
  filename = strcat(filename,".csv");
  fp = fopen(filename,"w+");
  for(i = 0; i < n; i++){  // for ROWS
    for(j = 0; j < m; j++){  // for COLUMNS
      fprintf(fp,",%.15lf", a[i][j]);
      //printf("%f\n", Temp[0][j]);
    }
    fprintf(fp, "\n");
  }
  fclose(fp);
  printf("\n %s file has been created.\n\n", filename);
}

int main(void){
  int i, j, nx, ny, count;
  double Lx, Ly, hx, hy, tol, err;
  static double x[NDIM], y[NDIM];
  static double Temp[NDIM][NDIM], Tprev[NDIM][NDIM], matdiff[NDIM][NDIM];
  clock_t start, end;
  double time_diff;

  printf(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
  printf("                        FDM using Jacobi method\n");
  printf(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n\n");

// Defining the domain and convergence criteria
  Lx = 6.0;
  Ly = 4.0;
  nx = NDIM;
  ny = nx;
  hx = Lx/(nx-1);
  hy = Ly/(ny-1);

  for(i = 1; i <= nx; i++ ){
    x[i] = 0.0 + (i-1.0)*hx;
    y[i] = 0.0 + (i-1.0)*hy;
    //printf("%f\n", y[i]);
  }
  tol = 1e-4;
  err = 1.0;
  count = 0;

  for(i = 0; i < nx; i++){  // for ROWS
    for(j = 0; j < ny; j++){  // for COLUMNS
      Temp[i][j] = 0.0;
      //printf("%f\n", Temp[0][j]);
    }
  }

  for(i = 0; i < nx; i++){
    Temp[nx-1][i] = 500.0; // Bottom
    Temp[0][i]    = 500.0; // Top
    Temp[i][0]    = 300.0; // Left
    Temp[i][nx-1] = 300.0; // Right
  }

  start = clock();
  while (err >= tol){
    for(i = 0; i < nx; i++){  // for ROWS
      for(j = 0; j < ny; j++){  // for COLUMNS
        Tprev[i][j] = Temp[i][j];
      }
    }
    // Beginning of the Jacobi method of iteration
    for(i = 1; i < nx-1; i++){  // for ROWS
      for(j = 1; j < ny-1; j++){  // for COLUMNS
        Temp[i][j] = 0.25*( Tprev[i-1][j] + Tprev[i+1][j] + Tprev[i][j+1] + Tprev[i][j-1] );
      }
    }
    count = count + 1; // count the number of loops
    // Define a new matrix showing the difference
    for(i = 0; i < nx; i++){  // for ROWS
      for(j = 0; j < ny; j++){  // for COLUMNS
        matdiff[i][j] = Temp[i][j] - Tprev[i][j];
      }
    }
    // find the biggest value in new matrix
    err = matdiff[0][0];
    for(i = 0; i < nx; i++){  // for ROWS
      for(j = 0; j < ny; j++){  // for COLUMNS
        if(matdiff[i][j] > err){
          err = matdiff[i][j];
        }
      }
    }
  }
  end = clock();
  time_diff = ((double)(end-start)) / CLOCKS_PER_SEC;
  printf("err = %e\n", err);
  printf("count = %d\n", count);
  printf("Time of calculations = %lf seconds.\n", time_diff);

  char str[20] = "Temp_data";
  transfer(str, Temp, NDIM, NDIM);
  return 0;
}
