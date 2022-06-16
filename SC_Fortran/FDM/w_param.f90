program SOR_w_parameter
  !use csv_file
  implicit none
  integer(8), parameter       :: nx = 31, DIM = 2000
  integer(8)                  :: i, j, k, m, ny, count
  real(8)                     :: Lx, Ly, hx, hy, tol, err, h
  real(8), dimension(nx)      :: x, y
  real(8), dimension(nx,nx)   :: T, T1, Told
  real(8),    dimension(DIM)  :: w
  integer(8), dimension(DIM)  :: niter
  REAL(8)                     :: time1, time2, diff

  print *, 'Code to calculate the parameter w in the SOR method'
  print *, 'SOR - Successive Over-Relaxation method:'
  print *, 'T(i,j) = (1-w(k))*Told(i,j) + w(k)*0.25*(T(i-1,j) + Told(i+1,j) &'
  print *, '                          & +            T(i,j-1) + Told(i,j+1))'

  ! Defining the domain and convergence criteria
  Lx = 6.0
  Ly = 4.0
  ny = nx
  hx = Lx/(nx-1)
  hy = Ly/(ny-1)

  ! Defing the length of x and y vectors
  ! The size of the gridmap
  do i = 1, nx
    x(i) = 0. + (i-1)*hx
    y(i) = 0. + (i-1)*hy
  end do
  tol = 1e-4
  err = 1.0
  count = 0


  ! Inintializing the temperature field with BCs
  T = 0.0           ! matrix with all elements set to zero
  do i = 1, nx
    T(1,  i) = 500.0
    T(nx, i) = 500.0
    T(i,  1) = 300.0
    T(i, nx) = 300.0
  end do

  h = 1./(DIM/2)
  do i = 1, size(w)
    w(i) = 0. + (i-1)*h
  end do
  niter = 0
  T1 = T

  ! The temperature values along the plane
  call CPU_TIME(time1)
  do k = 1, size(w)
      T = T1
      err = 1.0
      count = 0
    do while (err >= tol)
      Told = T
      do i = 2, nx-1
        do j = 2 , ny-1
          T(i,j) = (1-w(k))*Told(i,j) + w(k)*0.25*(T(i-1,j) + Told(i+1,j) &
                                 & +         T(i,j-1) + Told(i,j+1))
        end do
      end do
      count = count + 1
      err = maxval(abs(T-Told))
    end do
    niter(k) = count
    !print *, count
  end do
  call CPU_TIME(time2)
  diff = time2-time1
  !print *, minval(niter)
  print * , w( minloc(niter(2:size(w))) ) ! to exclude the first index which is 1
  print *, 'Finding the parameter took', diff,'seconds.'

end program SOR_w_parameter
