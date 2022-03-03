function [T, err] = SOR_steady(T,nx,ny,w)
  % Store the tempertaure values from previous iteration
  Told = T;
  % Space loop
  for i = 2:nx-1
    for j = 2:ny-1
      T(i,j) = (1-w)*Told(i,j) + w*0.25*(T(i-1,j) + Told(i+1,j)...
                               +         T(i,j-1) + Told(i,j+1));
    end
  end
  % Compute the error
  err = max(abs(T-Told),[],'all');
end
