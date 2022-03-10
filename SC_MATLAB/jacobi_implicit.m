function [T, err] = jacobi_implicit(T,T_prev_dt,nx,ny,K1)
  % Store the tempertaure values from previous iteration
  Told = T;
  % Space loop
  for i = 2:nx-1
    for j = 2:ny-1
      dT = Told(i-1,j) + Told(i+1,j) + Told(i,j-1) + Told(i,j+1);
      T(i,j) = (1/(1+4*K1))*T_prev_dt(i,j) + (K1/(1+4*K1))*dT;
    end
  end
  % Compute the error
  err = max(abs(T-Told),[],'all');
end
