program fem2Dheat
  !use csv_file
  implicit none
  integer(4), parameter     :: nx = 31
  integer(4)                :: i,j, ny, count
  real(4)                   :: Lx, Ly, hx, hy, tol, err
  real(4), dimension(nx)    :: x, y
  real(4), dimension(nx,nx) :: T, Told
  REAL(4)                   :: t1, t2, diff
!  real, dimension(:), allocatable :: err

! Defining the domain and cinvergence criteria
  Lx = 6.0
  Ly = 4.0
  ny = nx
  hx = Lx/(nx-1)
  hy = Ly/(ny-1)

! Defing the length of x and y vectors
! The size of the gridmap
  open(unit=9,file='x_y.csv')
  do i = 1, nx
    x(i) = 0. + (i-1)*hx
    y(i) = 0. + (i-1)*hy
  end do
  tol = 1-4
  err = 1.0
  count = 0

! Printing in a separate file x_y.csv
  do i = 1, nx
    WRITE ( 9, * ) x(i), ',',y(i)
  end do

! Inintializing the temperature field with BCs
  T = 0.0           ! matrix with all elements set to zero
  do i = 1, nx
    T(1,  i) = 500.0
    T(nx, i) = 500.0
    T(i,  1) = 300.0
    T(i, nx) = 300.0
  end do

! The temperature values along the plane
! Solved by Gauss-Seidel method
  call CPU_TIME(t1)
  do while (count <= 1018)
    Told = T
    do i = 2, nx-1
      do j = 2 , ny-1
        T(i,j) = 0.25*( T(i-1,j) + Told(i+1,j) + T(i,j-1) + Told(i,j+1) )
      end do
    end do
    count = count + 1
  end do
  call CPU_TIME(t2)
  diff = t1-t2
  print *, "count =", count
  print *, 'Gauss-Seidel method took', diff,'seconds.'

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
end program fem2Dheat

!real(4) function Gauss_Seidel(T,nx,ny)
!  implicit none
!  integer(4) :: i, j, nx ,ny
!  real(4), dimension(nx,ny) :: T, Told
!  real, dimension(:), allocatable :: err

!  Told = T

!  do i = 2, nx-1
!    do j = 2 , ny-1
!      T(i,j) = 0.25*( T(i-1,j) + Told(i+1,j) + T(i,j-1) + Told(i,j+1) )
!    end do
!  end do

!  err = max(abs(T-Told))

!end function
