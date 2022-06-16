/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * SOR_steady.c
 *
 * Code generation for function 'SOR_steady'
 *
 */

/* Include files */
#include "SOR_steady.h"
#include "minOrMax.h"
#include "rt_nonfinite.h"
#include <math.h>
#include <string.h>

/* Function Definitions */
double SOR_steady(double T[961], double nx, double ny, double w)
{
  double Told[961];
  double varargin_1[961];
  double d;
  int b_i;
  int i;
  int i1;
  int j;
  int k;
  /*  Store the tempertaure values from previous iteration */
  memcpy(&Told[0], &T[0], 961U * sizeof(double));
  /*  Space loop */
  k = (int)((nx - 1.0) + -1.0);
  for (i = 0; i < k; i++) {
    b_i = (int)((ny - 1.0) + -1.0);
    for (j = 0; j < b_i; j++) {
      i1 = i + 31 * (j + 1);
      T[i1 + 1] = (1.0 - w) * Told[i1 + 1] +
                  w * 0.25 *
                      (((T[i1] + Told[i1 + 2]) + T[(i + 31 * j) + 1]) +
                       Told[(i + 31 * (j + 2)) + 1]);
    }
  }
  /*  Compute the error */
  for (k = 0; k < 961; k++) {
    d = T[k] - Told[k];
    Told[k] = d;
    varargin_1[k] = fabs(d);
  }
  return maximum(varargin_1);
}

/* End of code generation (SOR_steady.c) */
