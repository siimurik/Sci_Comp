program test_rand
  REAL, DIMENSION(5,5) :: r
  INTEGER, DIMENSION(2) :: shape_r

  CALL RANDOM_NUMBER(r)
  print *, "Size of r:", SIZE(r)
  print *, "Shape of r:", SHAPE(r)

  shape_r = SHAPE(r)
  print *, shape_r

  print *, "r = "
  DO i = 1, shape_r(1)
    print *, r(i, :)
  END DO
end program test_rand
