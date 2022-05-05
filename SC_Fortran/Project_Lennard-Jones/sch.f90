!===========================================================
!
! File: sch.f90
!
!===========================================================
! Compile with
!
!   > gfortran sch.f90 schInfSq.f90 rk.f90 -o s
!
! Integrate 1d Schrodinger equation from xmin to xmax.
! Determine energy eigenvalue and eigenfunction by matching
! evolving solutions from xmin and from xmax at a point xm.
! Matching done by equating values of functions and their
! derivatives at xm.The poin xm chosen at the left most
! turning point of the potential at any given value of the
! energy.The potential and boundary conditions chosen in
! different file.
!----------------------------------------------------------
! Input:  energy: Trial value of energy
!         de:energy step,if matching fails de->e+de, if
!         logderivative changes sign de->-de/2
!         xmin, xmax, Nx
!----------------------------------------------------------
! Output: Final value of energy, number of nodes of
!         wavefunction in stdout
!         Final eigenfunction in file psi.dat
!         All trial functions and energies in file all.dat
!===========================================================
program schroedinger_equation_1D
  implicit none
  integer, parameter :: P=20001
  integer :: Nx,NxL,NxR
  real(8) :: psi(P),psip(P)
  real(8) :: dx
  real(8) :: xmin,xmax,xm     !left/right/matching points
  real(8) :: psixmin,psipxmin,psixmax,psipxmax
  real(8) :: psileft,psiright,psistep,psinorm
  real(8) :: psipleft,psipright,psipstep
  real(8) :: energy,de,epsilon,integrate
  common/params/energy
  real(8) :: matchlogd,matchold,psiold,norm,x
  integer :: iter,i,imatch,nodes
  real(8) :: V
  !----------Input:
  print *, '# Enter energy, de, xmin, xmax, Nx'
  print *, '# For schInfSq try:     1 0.5 -1  1 2000'
  print *, '# For schLJ    try:  -71. 0.1 0.7 6 2000 '
  read  *, energy, de, xmin, xmax, Nx
  !---needevenintervalsfornormalizationintegration
  if( mod(Nx,2).eq.0)Nx=Nx+1
  if(   Nx.gt.P     )stop 'Fatal Error: Nx > P'
  if( xmin.ge.xmax  )stop 'Error: xmin >= xmax'
  dx = (xmax-xmin)/(Nx-1)
  epsilon = 1.0D-6
  call boundary(xmin,xmax,psixmin,psipxmin,psixmax,psipxmax)
  print *,'########################################'
  print *,'#    Estart =', energy,'          de =', de
  print *,'#        Nx =', Nx,'             eps =', epsilon
  print *,'#      xmin =', xmin,   '       xmax =', xmax,' dx =', dx
  print *,'# psi(xmin) =', psixmin,' psip(xmin) =', psipxmin
  print *,'# psi(xmax) =', psixmax,' psip(xmax) =', psipxmax
  print *,'########################################'
!-----Calculate:
  open(unit=11,file='all.dat')
  matchold = 0.0D0
  do iter = 1, 10000
!----- Determine matching point at turning point from the left:
    imatch = -1
    do i = 1, Nx
      x=xmin+(i-1)*dx
      if( imatch.lt.0.and.(energy-V(x)).gt.0.0D0 ) imatch = i
    enddo
    if( imatch.le.100.or.imatch.ge.Nx-100 ) imatch = Nx/5
    xm  = xmin + (imatch-1) * dx
    NxL = imatch
    NxR = Nx - imatch+1
!----- Evolve wave func tion from the left:
    psi (1)  = psixmin
    psip(1)  = psipxmin
    psistep  = psixmin
    psipstep = psipxmin
    do i = 2, NxL
      x = xmin + (i-2)*dx   ! this is x before the step
      call RKSTEP(x,psistep,psipstep,dx)
      psi (i) = psistep
      psip(i) = psipstep
    enddo
! use this to normalize eigenfunction to match at xm
    psinorm   = psistep
    psipleft  = psipstep
!----- Evolve wave function from the right:
    psi (Nx) = psixmax
    psip(Nx) = psipxmax
    psistep  = psixmax
    psipstep = psipxmax
    do i = 2, NxR
      x = xmax - (i-2) * dx
      call RKSTEP(x,psistep,psipstep,-dx)
      psi (Nx-i+1) = psistep
      psip(Nx-i+1) = psipstep
    enddo
    psinorm = psistep / psinorm
    psipright = psipstep
!----- Renormalize psil so that psil(xm) = psir(xm)
    do i = 1, NxL-1
      psi (i) = psinorm*psi(i)
      psip(i) = psinorm*psip(i)
    enddo
    psipleft =  psinorm*psipleft
!----- print current solution:
    do i = 1, Nx
      x = xmin + (i-1)*dx
      write(11,*) iter,energy,x,psi(i),psip(i)
    enddo
!----- matching using derivatives:
! Careful: this can fail if psi'(xm)=0 !! (use also |de|<1e-6
! criterion)
    matchlogd = (psipright-psipleft)/(DABS(psipright)+DABS(psipleft))
    print *,'# iter, energy, de, xm, logd: ', &
            iter, energy, de, xm, matchlogd
!-----Exit condition:
    if(DABS(matchlogd).le.epsilon.or.DABS(de/energy).lt.1.0D-12)&
        EXIT
    if( matchlogd*matchold.lt.0.0D0 ) de = -0.5D0*de
    energy   = energy + de
    matchold = matchlogd
  enddo !do iter = 1, 10000
  close(11)
!---------------------------------------------------
!----- Solution has been found and now it is stored:
  norm   = integrate(psi,dx,Nx)
  norm   = 1.0D0/sqrt(norm)
  do i   = 1, Nx
    psi(i) = norm*psi(i)
  enddo
!----- Count number of zeroes, add one and get energy level:
  nodes  = 1
  psiold = psi(1)
  do i   = 2, Nx-1
! should be 0 within epsilon
  if( DABS(psi(i)).gt.epsilon ) then
  if( psiold*psi(i).lt.0.0D0 ) nodes = nodes + 1
    psiold = psi(i)
  endif
  enddo     ! i = 2, Nx-1
!------- Print final solution:
  open(unit=11, file='psi.dat')
  print*,'Final result: E=',energy,' n =',nodes,' norm =',norm
  if( DABS(matchlogd).gt.epsilon ) print*&
          ,'Final result: SOS:logd>epsilon.logd =',matchlogd
  write(11,*) '# E =', energy,' n =',nodes,' norm =',norm
  do i = 1, Nx
    x = xmin + (i-1)*dx
    write(11,*) x, psi(i)
  enddo
  close(11)
end program schroedinger_equation_1D
!===========================================================
! Simpson's rule to integrate psi(x)*psi(x) for proper
! normalization. For n interval so f width dx(n even)
! Simpson's rule is:
! int(f(x)dx) =
! (dx/3)*(f(x_0)+4 f(x_1)+2 f(x_2)+...+4 f(x_{n-1})+f(x_n))
!
! Input:    Discrete values of function psi(Nx)
!           Integration step dx
! Returns:  Integral(psi(x)psi(x)dx)
!===========================================================
real(8) function integrate(psi,dx,Nx)
  implicit none
  integer :: Nx
!------------- Note: we need P due to geometry of array
  real(8) :: psi(Nx),dx
!-------------
  real(8) :: int
  integer :: i
!----- zeroth order point:
  i = 1
  int = psi(i)*psi(i)
!----- odd order points (i = k+1 is even):
  do i = 2, Nx-1, 2
    int = int + 4.0D0*psi(i)*psi(i)
  enddo
!----- even order points:
  do i = 3, Nx-2, 2
    int = int + 2.0D0*psi(i)*psi(i)
  enddo
!----- last point:
  i = Nx
  int = int + psi(i)*psi(i)
!----- measure normalization:
  int = int*dx/3.0D0
!----- final result:
  integrate = int
end function integrate
!===========================================================
