================================================
 Main file is "sch.f90".
 You need 3 Fortran files to run.
================================================
 sch.f90 - Main file that holds the equations
 for solving the Schrodinger equation. It uses
 Runge-Kutta Methods which is why it needs help
 from the "rk.f90" file.
-------------------------------------------------
 rk.f90 - A subroutine that solves a 2 ODE system
 using Runge-Kutta Method.
 User must supply derivatives
 dx1/dt = f1(t,x1,x2)  dx2/dt=f2(t,x1,x2)
 as real functions
 Output is written in file rk.dat
-------------------------------------------------
 schLJ.f90/schInfSq.f90 - boundary conditions
=================================================
Example:

Input:
 > gfortran sch.f90 schInfSq.f90 rk.f90 -o s
Output:
 # Enter energy, de, xmin, xmax, Nx
 # For schInfSq try:     1 0.5 -1  1 2000
 # For schLJ    try:  -71. 0.1 0.7 6 2000
