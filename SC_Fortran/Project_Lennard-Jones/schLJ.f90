!===========================================================
! file: schLJ.f90 (Lennard-Jones)
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
  real(8) :: x, V0
  V0 = 250.0D0
  V  = 4.0D0*V0*(1.0D0/x**12 - 1.0D0/x**6)
end function V
!----- boundary conditions:
subroutine boundary(xmin,xmax,psixmin,psipxmin,psixmax,psipxmax)
  implicit none
  real(8) :: xmin,xmax,psixmin,psipxmin,psixmax,psipxmax,V
  real(8) :: energy
  common/params/energy
!----- Initail values at xmin and xmax
  psixmin  =  exp( -xmin * sqrt(DABS( energy - V(xmin))) )
  psipxmin =  sqrt(DABS(energy - V(xmin)))*psixmin
  psixmax  =  exp( -xmax*sqrt(DABS(energy - V(xmax))) )
  psipxmax = -sqrt(DABS(energy - V(xmax)))*psixmax
end subroutine boundary
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
