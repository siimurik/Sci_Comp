!========================================================
! Program to solve a 2 ODE system using Runge-Kutta Method
! User must supply derivatives
! dx1/dt = f1(t,x1,x2)  dx2/dt=f2(t,x1,x2)
! as real functions
! Output is written in file rk.dat
!========================================================
!program rk_solve
!  implicit none
!  integer, parameter  :: P = 110000
!  real, dimension(P)  :: T,X1,X2
!  real                :: Ti,Tf,X10,X20
!  integer             :: Nt
!  integer             :: i
  !Input:
!  print *,'Runge-Kutta Method for 2-ODEs Integration'
!  print *,'Enter Nt, Ti, TF, X10, X20:'
!  read  *, Nt,Ti,Tf,X10,X20
!  print *,'Nt=',Nt
!  print *,'Time: Initial Ti =', Ti,'Final Tf =', Tf
!  print *,'          X1(Ti) =',X10,'  X2(Ti) =', X20
!  if( Nt.gt.P ) stop 'Nt > P'
!TheCalculation:
!  call RK(T,X1,X2,Ti,Tf,X10,X20,Nt)
!Output:
!  open(unit=11,file='rk.dat')
!  do i = 1, Nt
!    write(11,*) T(i), X1(i), X2(i)
!  enddo
!  close(11)
!end program rk_solve
!========================================================
! The functions f1,f2(t,x1,x2) provided by the user
!========================================================
!real function f1(t,x1,x2)
!  implicit none
!  real :: t,x1,x2
!  f1 = x2   !dx1/dt = v = x2
!end function f1
!--------------------------------------------------------
!real function f2(t,x1,x2)
!  implicit none
!  real :: t,x1,x2
!  f2 = -10.0D0*x1   !harmonic oscillator
!end function f2
!========================================================
! RK(T,X1,X2,Ti,Tf,X10,X20,Nt)is the driver
! for the Runge-Kutta integration routine RKSTEP
! Input:    Initial and final times Ti,Tf
!           Initial values at t = Ti   X10,X20
!           Number of steps of integration: Nt-1
!           Size of arrays T, X1, X2
! Output: real arrays T(Nt), X1(Nt), X2(Nt) where
! T(1) = Ti   X1(1) = X10     X2(1) = X20
! X1(k) = X1(at t=T(k))    X2(k)=X2(at t=T(k))
! T(Nt) = TF
!========================================================
subroutine RK(T,X1,X2,Ti,Tf,X10,X20,Nt)
  implicit none
  integer :: Nt
  real(8), dimension(Nt) :: T,X1,X2
  real(8)    :: Ti,Tf,X10,X20
  real(8)    :: dt
  real(8)    :: TS,X1S,X2S   !values of time and X1, X2 at given step
  integer :: i
!Initialize variables:
  dt = (Tf-Ti)/(Nt-1)
  T (1) = Ti
  X1(1) = X10
  X2(1) = X20
  TS    = Ti
  X1S   = X10
  X2S   = X20
!Make RKsteps: The arguments of RKSTEP
!are replaced with the new ones!
  do i = 2, Nt
    call RKSTEP(TS,X1S,X2S,dt)
    T (i) = TS
    X1(i) = X1S
    X2(i) = X2S
  enddo
end subroutine RK
!========================================================
! Subroutine RKSTEP(t,x1,x2,dt)
! Runge-Kutta Integration routine of ODE
! dx1/dt=f1(t,x1,x2)  dx2/dt=f2(t,x1,x2)
! User must supply derivative functions:
! real function f1(t,x1,x2)
! real function f2(t,x1,x2)
! Given initial point (t,x1,x2) the routine advances it
! by time dt.
! Input : Inital  time t    and function values x1, x2
! Output: Final   time t+dt and function values x1, x2
! Careful!: values of t, x1, x2 are overwritten...
!========================================================
subroutine RKSTEP(t,x1,x2,dt)
  implicit none
  real(8) :: t,x1,x2,dt
  real(8) :: f1,f2
  real(8) :: k11,k12,k13,k14,k21,k22,k23,k24
  real(8) :: h,h2,h6
  h   = dt      !h=dt,integration step
  h2  = 0.5D0*h !h2=h/2
  h6  = h/6.0   !h6=h/6

  k11 = f1(t,x1,x2)
  k21 = f2(t,x1,x2)
  k12 = f1(t+h2,x1+h2*k11,x2+h2*k21)
  k22 = f2(t+h2,x1+h2*k11,x2+h2*k21)
  k13 = f1(t+h2,x1+h2*k12,x2+h2*k22)
  k23 = f2(t+h2,x1+h2*k12,x2+h2*k22)
  k14 = f1(t+h,x1+h*k13,x2+h*k23)
  k24 = f2(t+h,x1+h*k13,x2+h*k23)

  t   = t+h
  x1  = x1+h6*(k11+2.0D0*(k12+k13)+k14)
  x2  = x2+h6*(k21+2.0D0*(k22+k23)+k24)
end subroutine RKSTEP
