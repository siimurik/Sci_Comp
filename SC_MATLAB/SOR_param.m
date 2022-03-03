clear all; close all;
clc;

% Defining the domain and convergence criteria
L = 1; % m
nx = 31; ny = nx;
x = linspace(0,L,nx); y = linspace(0,L,ny);
h = x(2) -x(1);
tol = 1e-4; err = 1; count = 0;

% Inintializing the temperature field with BCs
T = zeros(length(x), length(y));
%T(1,   2:end-1) = 900; % Bottom
%T(end, 2:end-1) = 600; % Top
%T(2:end-1,   1) = 400; % Left
%T(2:end-1, end) = 800; % Right

T(1,   1:end) = 500; % Bottom
T(end, 1:end) = 500; % Top
T(1:end,   1) = 300; % Left
T(1:end, end) = 300; % Right
%T(1,1) = 300; T(1,end) = 500; T(end,end) = 500; T(end,1) = 300; % Corner nodes
%T(1,1) = 650; T(1,end) = 850; T(end,end) = 700; T(end,1) = 500; % Corner nodes
T1 = T; w = 0.01:0.01:1.99;
niter = zeros(length(w),1);

% For steady state
for k = 1:length(w)
  T = T1; err = 1;
  count = 0;
  while err>=tol
    [T, err] = SOR_steady(T,nx,ny,w(k));
    count = count + 1;
  end
  niter(k) = count;
end

% Optimal parameter
w_opt = w(niter==min(niter));

figure(1)
semilogy(w, niter,'LineWidth', 2); grid on;
xlabel('omega_{SOR}', 'FontSize', 16);
ylabel('Log (No. of iterations)', 'FontSize', 16);
title('No. of iterations taken by each SOR parameter for transient implicit solver');

