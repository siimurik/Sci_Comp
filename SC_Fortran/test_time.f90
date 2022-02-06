subroutine startclock(mytime, time)
  common / myclock / mytime
  integer mytime, time
  mytime = time()
  return
end subroutine startclock

integer function wallclock(wallclock, mytime, time, newtime)
  integer wallclock
  common / myclock / mytime
  integer mytime, time, newtime
  newtime = time()
  wallclock = newtime - mytime
  mytime = newtime
  return
end function wallclock

program test_time
  integer wallclock, elapsed
  character*24 greeting
  real dtime, timediff, timearray(2)
  !      print a heading
  call fdate( greeting )
  print*,  "      Hello, Time Now Is: ",  greeting
  print*,      "See how long 'sleep 4' takes, in seconds"
  call startclock
  call system( 'sleep 4' )
  elapsed = wallclock()
  print*, "Elapsed time for sleep 4 was: ", elapsed," seconds"
  !      now test the cpu time for some trivial computing
  timediff = dtime( timearray )
end program test_time
