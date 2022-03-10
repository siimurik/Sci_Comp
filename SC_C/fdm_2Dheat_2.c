#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#define SIZE 61

void matrix_csv(char *filename,double a[][SIZE],int n,int m){
printf("\n Creating %s.csv file for matrix.",filename);
FILE *fp;
int i,j;
filename=strcat(filename,".csv");
fp=fopen(filename,"w+");
for(i = 0; i < m; i++){
    for(j = 0; j < n; j++){
        fprintf(fp,"%10.14f, ",a[i][j]);
      }
      fprintf(fp, "\n");
    }
fclose(fp);
printf("\n %s file created",filename);
}

void vector_csv(char *filename,double v[SIZE],double u[SIZE], int n){
printf("\n Creating vector %s.csv file for x & y.",filename);
FILE *fp;
int i;
filename=strcat(filename,".csv");
fp=fopen(filename,"w+");
for(i = 1; i <= n; i++){
      fprintf(fp,"%f,   %f\n",v[i],u[i]);
//      fprintf(fp,"\n");
    }
fclose(fp);
printf("\n Vector %s file created.",filename);
}

int main(void){
  FILE *fp;
  char *filename;
  int i, j, k, nx, ny, count, num;
  double Lx, Ly, hx, hy, tol, err, w, max;
  static double x[SIZE], y[SIZE];
  static double Te[SIZE][SIZE], Told[SIZE][SIZE], matrix[SIZE][SIZE];
  clock_t start, end;
  double cpu_time_used;

// Defining the domain and convergence criteria
  Lx = 6.0;
  Ly = 4.0;
  nx = SIZE;
  ny = nx;
  hx = Lx/(nx-1);
  hy = Ly/(ny-1);
  //printf("%f\n", hx);
// Defing the length of x and y vectors
// The size of the gridmap
  for(i = 1; i <= nx; i++ ){
    x[i] = 0.0 + (i-1.0)*hx;
    y[i] = 0.0 + (i-1.0)*hy;
    //printf("%f\n", y[i]);
  }
  tol   = 1e-12;
  err   = 1.0;
  count = 0;
  //printf("%f\n", x[5]);
// Printing in a separate file x_y.csv


// Inintializing the temperature field with BCs
  for(i = 0; i < nx; i++){
    for(j = 0; j < ny; j++){
      Te[i][j] = 0.0;
    }
  }          // matrix with all elements set to zero
  for(i = 0; i < nx; i++){
    Te[0][i]      = 500.0;
    Te[SIZE-1][i] = 500.0;
    Te[i][0]      = 300.0;
    Te[i][SIZE-1] = 300.0;
  }

  printf("Input the method of approximation:");
  printf("\n[1] Jacobi method");
  printf("\n[2] Gauss-Seidel method");
  printf("\n[3] SOR method\n");
  scanf("%d", &num);

// The temperature values along the plane
// Solved by 3 separate methods
  start = clock();
  while (err >= tol){
  //for(k = 0; k < 1018; k++){
    if (num == 1){
      // Set matrix Told equal to Te
      for(i = 0; i < nx; i++){
        for(j = 0; j < ny; j++){
          Told[i][j] = Te[i][j];
        }
      }
      // Jacobi iteration method
        for(i = 1; i < nx-1; i++){
          for(j = 1; j < ny-1; j++){
            Te[i][j] = 0.25*( Told[i-1][j] + Told[i+1][j] + Told[i][j-1] + Told[i][j+1] );
          }
        }
        //count the number of loops
        count = count + 1;
        //printf("%d\n", count);
        for(i = 0; i < nx; i++){
          for(j = 0; j < ny; j++){
            matrix[i][j] = (Te[i][j]-Told[i][j]);
            //printf("%f\n", matrix[i][j]);
          }
        }
        // Find max element in matrix
        err = matrix[0][0];
        for(i = 0; i < nx; i++){
          for(j = 0; j < ny; j++){
            if(matrix[i][j] > err){
                err = matrix[i][j]; // max el will show total error of calc
                //printf("%f\n", max);
            }
          }
        }
      } else if (num == 2){
      for(i = 0; i < nx; i++){
        for(j = 0; j < ny; j++){
          Told[i][j] = Te[i][j];
        }
      }
      // Gauss-Seidel iteration method
        for(i = 1; i < nx-1; i++){
          for(j = 1; j < ny-1; j++){
            Te[i][j] = 0.25*( Te[i-1][j] + Told[i+1][j] + Te[i][j-1] + Told[i][j+1] );
          }
        }
        count = count + 1;
        //printf("%d\n", count);
        for(i = 0; i < nx; i++){
          for(j = 0; j < ny; j++){
            matrix[i][j] = (Te[i][j]-Told[i][j]);
            //printf("%f\n", matrix[i][j]);
          }
        }
        //err = matrix[0][1];
        err = matrix[0][0];
        for(i = 0; i < nx; i++){
          for(j = 0; j < ny; j++){
            if(matrix[i][j] > err){
                err = matrix[i][j];
                //printf("%f\n", max);
            }
          }
        }
      } else {
      w = 1.813; // Determined in a separate program where 0 < w < 2
      for(i = 0; i < nx; i++){
        for(j = 0; j < ny; j++){
          Told[i][j] = Te[i][j];
        }
      }
      // Successive Over-Relaxation iteration method
        for(i = 1; i < nx-1; i++){
          for(j = 1; j < ny-1; j++){
            Te[i][j] = (1-w)*Told[i][j] + w*0.25*(Te[i-1][j] + Told[i+1][j] + Te[i][j-1] + Told[i][j+1]);
          }
        }
        count = count + 1;
        //printf("%d\n", count);
        for(i = 0; i < nx; i++){
          for(j = 0; j < ny; j++){
            matrix[i][j] = (Te[i][j]-Told[i][j]);
            //printf("%f\n", matrix[i][j]);
          }
        }
        //err = matrix[0][1];
        err = matrix[0][0];
        for(i = 0; i < nx; i++){
          for(j = 0; j < ny; j++){
            if(matrix[i][j] > err){
                err = matrix[i][j];
                //printf("%f\n", max);
            }
          }
        }
      }
    }
  end = clock();

  printf("err = %E\n", err);
  printf("count = %d\n", count);
  char str[6] = "temps";
  matrix_csv(str,Te,SIZE,SIZE);
  char stri[3] = "xy";
  vector_csv(stri,x,y,SIZE);

  cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
  printf("\n\nChosen method took %f seconds.\n", cpu_time_used);
  return 0;
}
