#include <stdio.h>
//#include <conio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#define SIZE 31
//#define DT_EXP 1.984126984126984e-04
#define NT_EXP 1765
#define NT_IMP 36

void matrix_csv(char *filename,double a[][SIZE],int n,int m){
printf("\n Creating %s.csv file for matrix.",filename);
FILE *fp;
int i,j;
filename=strcat(filename,".csv");
fp=fopen(filename,"w+");
for(i = 0; i < m; i++){
    for(j = 0; j < n; j++){
        fprintf(fp,",%f ",a[i][j]);
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
//  const int SIZE = 31;
  const double LX = 1.0, LY = 1.0, HX = LX/((double)(31)-1), HY = LY/((double)(31)-1);
  const double T_END = 0.35, T_START = 0.0;
  const double ALPHA = 1.4, DT_EXP = HX*HX/(4.0*ALPHA), DT_IMP = 0.01 ;
//  const int NT_EXP = (T_END-T_START)/DT_EXP+1, NT_IMP = (T_END-T_START)/DT_IMP+1;
  int i, j, k, m, nx, ny, count, num, in_x, in_y;
  double tol, err, w, dT, K1;
  static double x[SIZE], y[SIZE];
  static double Te[SIZE][SIZE], Told[SIZE][SIZE], T_prev_dt[SIZE][SIZE], matrix[SIZE][SIZE];
  static double t_exp[NT_EXP], Tmid_exp[NT_EXP];
  static double t_imp[NT_IMP], Tmid_imp[NT_IMP];
  clock_t start, end;
  double cpu_time_used;

// Defining the domain and convergence criteria
  nx = SIZE;
  ny = nx;
  in_x = nx/2;
  in_y = ny/2;
  //printf("%f\n", hx);
// Defing the length of x and y vectors
// The size of the gridmap
  for(i = 1; i <= nx; i++ ){
    x[i] = 0.0 + (i-1.0)*HX;
    y[i] = 0.0 + (i-1.0)*HY;
    //printf("%f\n", y[i]);
  }
  tol   = 1e-4;
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

  printf("\nSelect the type of 2D transient numerical scheme:");
  printf("\n[1] Explicit scheme");
  printf("\n[2] Implicit\n");
  scanf("%d", &num);

/* */

// The temperature values along the plane
// Solved by 3 separate methods
if (num == 1){
  for(i = 0; i < NT_EXP; i++){
    t_exp[i] = T_START + (i-1.0)*DT_EXP;
  }
  K1 = ALPHA*DT_EXP/(HX*HX);
  start = clock();
  for(k = 0; k < NT_EXP; k++){
    // Store the temperature values from previous time-step
    for(i = 0; i < nx; i++){
      for(j = 0; j < ny; j++){
        Told[i][j] = Te[i][j];
      }
    }
    // Space loop
    for(i = 1; i < nx-1; i++){
      for(j = 1; j < ny-1; j++){
        dT = Told[i-1][j] + Told[i+1][j] + Told[i][j-1] + Told[i][j+1];
        Te[i][j] = (1.0-4.0*K1)*Told[i][j] + K1*dT;
      }
    }
    count = count + 1;
    Tmid_exp[k] = Te[in_x][in_y];
  } end = clock();
}else if (num = 2){
  printf("Input the method of approximation:");
  printf("\n[1] Jacobi method");
  printf("\n[2] Gauss-Seidel method");
  printf("\n[3] SOR method\n");
  scanf("%d", &m);
  // implicit scheme
  for(i = 1; i <= NT_IMP; i++){
    t_imp[i] = T_START + (i-1.0)*DT_IMP;
  }
  K1 = ALPHA*DT_IMP/(HX*HX);
  start = clock();
  for(k = 0; k < NT_IMP; k++){
    for(i = 0; i < nx; i++){
      for(j = 0; j < ny; j++){
        T_prev_dt[i][j] = Te[i][j];
      }
    }
    err = 1.0;
    while (err >= tol){
  //for(k = 0; k < 1018; k++){
    if (m == 1){
      // Set matrix Told equal to Te
      for(i = 0; i < nx; i++){
        for(j = 0; j < ny; j++){
          Told[i][j] = Te[i][j];
        }
      }
      // Jacobi iteration method
        for(i = 1; i < nx-1; i++){
          for(j = 1; j < ny-1; j++){
            dT = Told[i-1][j] + Told[i+1][j] + Told[i][j-1] + Told[i][j+1];
            Te[i][j] = (1./(1.+4.*K1))*T_prev_dt[i][j] + (K1/(1.+4.*K1))*dT;
          }
        }
        //count the number of loops
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
            dT = Te[i-1][j] + Told[i+1][j] + Te[i][j-1] + Told[i][j+1];
            Te[i][j] = (1.0/(1.0+4.0*K1))*T_prev_dt[i][j] + (K1/(1.0+4.0*K1))*dT;
          }
        }
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
      w = 1.26; // Determined in a separate program where 0 < w < 2
      for(i = 0; i < nx; i++){
        for(j = 0; j < ny; j++){
          Told[i][j] = Te[i][j];
        }
      }
      // Successive Over-Relaxation iteration method
        for(i = 1; i < nx-1; i++){
          for(j = 1; j < ny-1; j++){
            dT = Te[i-1][j] + Told[i+1][j] + Te[i][j-1] + Told[i][j+1];
            Te[i][j] = (1-w)*Told[i][j] + w*((1/(1+4*K1))*T_prev_dt[i][j] + (K1/(1+4*K1))*dT);
          }
        }
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
      count = count + 1;
      //for(k = 0; k<NT_IMP; k++){
        Tmid_imp[k] = Te[in_x][in_y];
      //}
    }
  }
  end = clock();
}

  printf("%d\n", k);
  printf("err = %f\n", err);
  printf("count = %d\n", count);
  char str[20] = "instat_temps";
  matrix_csv(str,Te,SIZE,SIZE);
  char stri[20] = "instat_xy";
  vector_csv(stri,x,y,SIZE);
  if (num == 1){
    char stri[20] = "Tmid_t";
    vector_csv(stri,Tmid_exp,t_exp,SIZE);
  } else if (num==2) {
    char stri[20] = "Tmid_t";
    vector_csv(stri,Tmid_imp,t_imp,SIZE);
  }

  cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;
  printf("\n\nChosen method took %f seconds.\n", cpu_time_used);
  return 0;
}
