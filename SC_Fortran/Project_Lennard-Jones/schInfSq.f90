!===========================================================
! file: schInfSq.f90
!
! Functions used in RKSTEP routine. Here:
! f1 = psip(x) = psi(x)'
! f2 = psip(x)'= psi(x)''
!
! Onehastoset:
!   1.V(x), the potential
!   2.The boundary conditions for psi, psip at x = xmin and x=xmax
!
!===========================================================
!----- potential:
real(8) function V(x)
  implicit none
  real(8) :: x
  V = 0.0D0
end function V
!-----boundary conditions:
subroutine boundary(xmin,xmax,psixmin,psipxmin,psixmax,psipxmax)
  implicit none
  real(8) :: xmin,xmax,psixmin,psipxmin,psixmax,psipxmax,V
  !for infinite square well we set psi = 0 at boundary
  !and psip = +/-1
  psixmin  =  0.0D0
  psipxmin =  1.0D0
  psixmax  =  0.0D0
  psipxmax = -1.0D0
  !----- Initial values at xmin and xmax
end subroutine boundary
!===========================================================
!===========================================================
!-----trivial function: derivative of psi
real(8) function f1(x,psi,psip)
  real(8) :: x,psi,psip
  f1 = psip
end function f1
!===========================================================
!----- the second derivative of wavefunction:
! psip(x)' = psi(x)'' = -(E - V) psi(x)
real(8) function f2(x,psi,psip)
  implicit none
  real(8) :: x,psi,psip,energy,V
  common/params/energy
!----- Schroedinger eq: RHS
  f2 = (V(x) - energy)*psi
end function f2
!===========================================================
