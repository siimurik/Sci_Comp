clear all; close all;
clc;

% Defining the domain and convergence criteria
L = 1; % m
nx = 31; ny = nx;
x = linspace(0,L,nx); y = linspace(0,L,ny);
h = x(2) - x(1);
tol = 1e-4; err = 1; count = 0;

% Inintializing the temperature field with BCs
T = zeros(length(x), length(y));
%T(1,   2:end-1) = 900; % Bottom
%T(end, 2:end-1) = 600; % Top
%T(2:end-1,   1) = 400; % Left
%T(2:end-1, end) = 800; % Right
%T(1,1) = 650; T(1,end) = 850; T(end,end) = 700; T(end,1) = 500; % Corner nodes

T(1,   1:end) = 500; % Bottom
T(end, 1:end) = 500; % Top
T(1:end,   1) = 300; % Left
T(1:end, end) = 300; % Right
%T(1,1) = 300; T(1,end) = 500; T(end,end) = 500; T(end,1) = 300; % Corner nodes

% User input for the solver selection
list = {'Jacobi method', 'Gauss-Seidel method', 'SOR method'};
prompt = [{'Select method for 2D steady heat conduction solver:'},{''}];
[iterative_solver, selection] = listdlg('ListString', list, 'PromptString',...
                                        prompt, 'SelectionMode', 'single');
if selection~=1
  fprintf('nNo selection made for iterative solver, program exiting.nn');
  return;
else
  fprintf('nSelection made: %snn', list{iterative_solver});
end
if iterative_solver == 3
  %w = 1.82
  w = 1.81
end

% Computing through different solvers
tic;
% Convergence loop
while err(end) >= tol
  if iterative_solver == 1
    [T, e] = jacobi_steady(T,nx,ny);
  elseif iterative_solver == 2
    [T, e] = gauss_seidel_steady(T,nx,ny);
  elseif iterative_solver == 3
    [T, e] = SOR_steady(T,nx,ny,w);
  end
  if count == 0
    err = e;
  else
    err = [err, e];
  end
  count = count+1;
end
comp_time = toc

% Plotting the results
figure(1)
semilogy(err, 'LineWidth', 1.5);
grid on; ax = gca; ax.FontSize = 11;
xlabel('Iterations', 'FontSize', 14); xlim([0 count]);
ylabel('Log (Absolute Temperature Error)', 'FontSize', 14);
str = {'Steady state absolute error variation with no. of iterations';...
        [list{iterative_solver},': ', num2str(count),' iterations']};
title(str, 'FontSize', 12);

figure(2)
contourf(x,y,T,'ShowText', 'on'); ax = gca; ax.FontSize = 11;
c = colorbar; colormap(jet); c.FontSize = 11;
set(get(c, 'label'), 'string', 'Contour: Temperature (K)', 'FontSize', 14);
xlabel('X (m)', 'FontSize', 14); ylabel('Y (m)', 'FontSize', 14);
title(['Steady state temperature contour using ', list{iterative_solver}], 'FontSize', 11);
