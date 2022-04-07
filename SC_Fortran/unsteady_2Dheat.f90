program fdm2Dheat_unsteady
  implicit none
  integer(8), parameter         :: NDIM = 61
  real(8), parameter            :: LX = 1.0D0, LY = 1.0D0, HX = LX/(FLOAT(NDIM)-1.D0)
  real(8), parameter            :: HY = LY/(FLOAT(NDIM)-1.D0), T_END = 0.35D0, T_START = 0.0D0
  real(8), parameter            :: ALPHA = 1.4D0, DT_EXP = HX**2.D0/(4.D0*ALPHA), DT_IMP = 0.01D0
  integer(8),parameter          :: NT_EXP = (T_END-T_START)/DT_EXP+1.D0, NT_IMP = (T_END-T_START)/DT_IMP+1.D0
  integer(8)                    :: i, j, k, m, nx, ny, count, num, in_x, in_y
  real(8)                       :: tol, err, w
  real(8)                       :: dT, K1
  real(8), dimension(NDIM)      :: x, y
  real(8), dimension(NT_EXP)    :: t_exp, Tmid_exp
  real(8), dimension(NT_IMP)    :: t_imp, Tmid_imp
  real(8), dimension(NDIM,NDIM) :: T, Told, T_prev_dt
  REAL(8)                       :: t1, t2, diff

!  print *, NT_EXP, NT_IMP, HX, DT_EXP
! Defining the domain and convergence criteria
  nx = NDIM
  ny = nx
! Additional parameters
  tol = 1e-4
  err = 1.0
  count = 0
  in_x = nx/2
  in_y = ny/2
! Defing the length of x and y vectors
! The size of the gridmap
  open(unit=9,file='x_y_unsteady.csv')
  do i = 1, nx
    x(i) = 0.0 + (i-1.0D0)*hx
    y(i) = 0.0 + (i-1.0D0)*hy
  end do
! Printing in a separate file x_y.csv
  do i = 1, nx
    WRITE ( 9, * ) x(i), ',',y(i)
  end do
! Close connection
  CLOSE(9)
! Inintializing the temperature field with BCs
  T = 0.0           ! matrix with all elements set to zero
  do i = 1, nx
    T(1,  i) = 500.0  ! Up
    T(nx, i) = 500.0  ! Down
    T(i,  1) = 300.0  ! Left
    T(i, nx) = 300.0  ! Right
  end do

  print *, 'Select the type of 2D transient numerical scheme:'
  print *, '[1] Explicit scheme'
  print *, '[2] Implicit'
  read *, num

! The temperature values along the plane
! Solved by either Explicit or Implicit
  if (num == 1) then
    ! Explicit scheme
    do i = 1, NT_EXP
      t_exp(i) = t_start + (i-1.0D0)*DT_EXP
    end do
    K1 = ALPHA*DT_EXP/(HX**2)
    print *, K1
    call CPU_TIME(t1)
    do k = 1, NT_EXP
      ! Store the temperature values from previous time-step
      Told = T
      ! Space loop
      do i = 2, nx-1
        do j = 2, ny-1
          dT = Told(i-1,j) + Told(i+1,j) + Told(i,j-1) + Told(i,j+1);
          T(i,j) = (1.0-4.0*K1)*Told(i,j) + K1*dT;
        end do
      end do
      !Tmid = T(x==0.5, y==0.5)
      count = count + 1
      Tmid_exp(k) = T(in_x,in_y)
    end do
    call CPU_TIME(t2)
!==============================================================================
  else if (num == 2) then
    ! Let user choose the method for solving
      print *, 'Select method for 2D steady heat conduction solver:'
      print *, '[1] Jacobi method'
      print *, '[2] Gauss-Seidel method'
      print *, '[3] SOR method'
      read *, m
    ! Implicit scheme
    do i = 1, NT_IMP
      t_imp(i) = t_start + (i-1)*DT_IMP
      !print *, tt(i)
    end do
    K1 = ALPHA*DT_IMP/(HX**2)
    !print *, "K1 = ", K1
    call CPU_TIME(t1)
    ! Time loop
    do k = 1, NT_IMP
      T_prev_dt = T
      err = 1.0
      do while (err >= tol)
        if (m == 1) then
        CALL Jacobi_implicit(T,T_prev_dt,nx,ny,K1,err)
        else if (m == 2) then
          CALL Gauss_Seidel_implicit(T,T_prev_dt,nx,ny,K1,err)
        else
          w = 1.26
          CALL SOR_implicit(T,T_prev_dt,nx,ny,K1,err,w)
        end if
        count = count + 1
        Tmid_imp(k) = T(in_x,in_y)
        !print *, count
      end do
      !Tmid(k) = T(x==0.5, y==0.5)
    end do
    call CPU_TIME(t2)
  end if

  diff = t2-t1
  print *, "Number of loops:", count
  if (m==1) then
    print *, 'Jacobi method took', diff,'seconds.'
  else if (m==2) then
    print *, 'Gauss-Seidel method took', diff,'seconds.'
  else
    print *, 'SOR method took', diff,'seconds.'
  end if
  print *, 'Calculation error:', err

!  do i = 1, IMP
!    print *, Tmid_imp(i)
!  end do
!==============================================================================
  ! Formatting for CSV
  101 format(1x, *(g0, ", "))

  ! Open connection (i.e. create file where to write)
  OPEN(unit = 10, access = "sequential", action = "write", &
       status = "replace", file = "T_unsteady.csv", form = "formatted")
  ! Loop across rows
  do i= 1, nx
     WRITE(10, 101) T(i,:)
  end do
  ! Close connection
  CLOSE(10)
!==============================================================================
  open(unit=11,file='Tmid_t.csv')
  do i = 1, nx
    x(i) = 0. + (i-1)*hx
    y(i) = 0. + (i-1)*hy
  end do
  ! Printing in a separate file Tmid.csv
  if (num == 1) then
    do i = 1, NT_EXP
      WRITE ( 11, * ) Tmid_exp(i), ',',t_exp(i)
    end do
  else
    do i = 1, NT_IMP
      WRITE ( 11, * ) Tmid_imp(i), ',',t_imp(i)
    end do
  end if
  ! Close connection
  CLOSE(11)
end program fdm2Dheat_unsteady

! Subroutine for the Jacobi method
! Takes the most amount of loops
subroutine Jacobi_implicit(T,T_prev_dt,nx,ny,K1,err)
  implicit None
  integer(8)                :: i, j, nx, ny
  real(8)                   :: err, K1, dT
  real(8), dimension(nx,ny) :: T, Told, T_prev_dt
! Start of initial variables and calculations
  Told = T
  do i = 2, nx-1
    do j = 2 , ny-1
      dT = Told(i-1,j) + Told(i+1,j) + Told(i,j-1) + Told(i,j+1)
      T(i,j) = (1./(1.+4.*K1))*T_prev_dt(i,j) + (K1/(1.+4.*K1))*dT
    end do
  end do
  err = maxval(abs(T-Told))
  !print *, err
end subroutine Jacobi_implicit

! Subroutine for the Gauss-Seidel method
! Takes the intermediate amount of loops
subroutine Gauss_Seidel_implicit(T,T_prev_dt,nx,ny,K1,err)
  implicit None
  integer(8)                :: i, j, nx, ny
  real(8)                   :: err, K1, dT
  real(8), dimension(nx,nx) :: T, Told, T_prev_dt
! Start of initial variables and calculations
  Told = T
  do i = 2, nx-1
    do j = 2 , ny-1
      dT = T(i-1,j) + Told(i+1,j) + T(i,j-1) + Told(i,j+1)
      T(i,j) = (1/(1+4*K1))*T_prev_dt(i,j) + (K1/(1+4*K1))*dT
    end do
  end do
  err = maxval(abs(T-Told))
end subroutine Gauss_Seidel_implicit

! Subroutine for Successive Over-Relaxation method
! Takes the least amount of loops
subroutine SOR_implicit(T,T_prev_dt,nx,ny,K1,err,w)
  implicit None
  integer(8)                :: i, j, nx, ny
  real(8)                   :: w, err, K1, dT
  real(8), dimension(nx,nx) :: T, Told, T_prev_dt
! Start of initial variables and calculations
!  w = 1.813
  Told = T
  do i = 2, nx-1
    do j = 2 , ny-1
      dT = T(i-1,j) + Told(i+1,j) + T(i,j-1) + Told(i,j+1)
      T(i,j) = (1-w)*Told(i,j) + w*((1/(1+4*K1))*T_prev_dt(i,j)  &
                             & +         (K1/(1+4*K1))*dT)
    end do
  end do
  err = maxval(abs(T-Told))
end subroutine SOR_implicit
