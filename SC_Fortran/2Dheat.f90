program fdm2Dheat
  implicit none
  integer(8), parameter         :: NDIM = 31
  integer(8)                    :: i, j, m, nx, ny, count
  real(8)                       :: Lx, Ly, hx, hy, tol, err, w
  real(8), dimension(NDIM)      :: x, y
  real(8), dimension(NDIM,NDIM) :: T, Told
  REAL(8)                       :: t1, t2, diff

! Defining the domain and convergence criteria
  Lx = 6.0
  Ly = 4.0
  nx = NDIM
  ny = nx
  hx = Lx/(nx-1)
  hy = Ly/(ny-1)
! Additional parameters
  tol = 1e-4
  err = 1.0
  count = 0
! Defing the length of x and y vectors
! The size of the gridmap
  open(unit=9,file='x_y.csv')
  do i = 1, nx
    x(i) = 0. + (i-1)*hx
    y(i) = 0. + (i-1)*hy
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

! Let user choose the method for solving
  print *, 'Input the method of approximation:'
  print *, '[1] Jacobi method'
  print *, '[2] Gauss-Seidel method'
  print *, '[3] SOR method'
  read *, m

! The temperature values along the plane
! Solved by Gauss-Seidel method
  call CPU_TIME(t1)
  do while (err >= tol)
    if (m == 1) then
      CALL Jacobi_method(T, nx, ny, err)
    else if (m == 2) then
      CALL Gauss_Seidel_method(T, nx, ny, err)
    else
      w = 1.813
      CALL SOR_method(w, T, nx, ny, err)
    end if
    count = count + 1
  end do
  call CPU_TIME(t2)
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

  ! Formatting for CSV
  101 format(1x, *(g0, ", "))

  ! Open connection (i.e. create file where to write)
  OPEN(unit = 10, access = "sequential", action = "write", &
       status = "replace", file = "data.csv", form = "formatted")
  ! Loop across rows
  do i= 1, nx
     WRITE(10, 101) T(i,:)
  end do
  ! Close connection
  CLOSE(10)
end program fdm2Dheat

! Subroutine for the Jacobi method
! Takes the most amount of loops
subroutine Jacobi_method(T, nx, ny, err)
  implicit None
  integer(8)                :: i, j, count, nx, ny
  real(8)                   :: err
  real(8), dimension(nx,nx) :: T, Told
! Start of initial variables and calculations
  Told = T
  do i = 2, nx-1
    do j = 2 , ny-1
      T(i,j) = 0.25*( Told(i-1,j) + Told(i+1,j) + Told(i,j-1) + Told(i,j+1) )
    end do
  end do
  err = maxval(abs(T-Told))
end subroutine Jacobi_method

! Subroutine for the Gauss-Seidel method
! Takes the intermediate amount of loops
subroutine Gauss_Seidel_method(T, nx, ny, err)
  implicit None
  integer(8)                :: i, j, count, nx, ny
  real(8)                   :: err
  real(8), dimension(nx,nx) :: T, Told
! Start of initial variables and calculations
  Told = T
  do i = 2, nx-1
    do j = 2 , ny-1
      T(i,j) = 0.25*( T(i-1,j) + Told(i+1,j) + T(i,j-1) + Told(i,j+1) )
    end do
  end do
  err = maxval(abs(T-Told))
end subroutine Gauss_Seidel_method

! Subroutine for Successive Over-Relaxation method
! Takes the least amount of loops
subroutine SOR_method(w, T, nx, ny, err)
  implicit None
  integer(8)                :: i, j, count, nx, ny
  real(8)                   :: w, err
  real(8), dimension(nx,nx) :: T, Told
! Start of initial variables and calculations
!  w = 1.813
  Told = T
  do i = 2, nx-1
    do j = 2 , ny-1
      T(i,j) = (1-w)*Told(i,j) + w*0.25*(T(i-1,j) + Told(i+1,j) &
                             & +         T(i,j-1) + Told(i,j+1))
    end do
  end do
  err = maxval(abs(T-Told))
end subroutine SOR_method
