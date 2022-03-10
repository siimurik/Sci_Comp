clear; close all;
clc;

% Defining the domain and convergence criteria
L = 1; % m
nx = 61; ny = nx;
x = linspace(0,L,nx); y = linspace(0,L,ny);
h = x(2) - x(1); alpha = 1.4; tol = 1e-4; count = 0;
t_start = 0; t_end = 0.35; err = 1;

% Inintializing the temperature field with BCs
T = zeros(length(x), length(y));
%T(1,   2:end-1) = 900; % Bottom
%T(end, 2:end-1) = 600; % Top
%T(2:end-1,   1) = 400; % Left
%T(2:end-1, end) = 800; % Right
%T(1,1) = 650; T(1,end) = 850; T(end,end) = 700; T(end,1) = 500; % Corner nodes
Tmid = []; %Centre node
T(1,   1:end) = 500; % Bottom
T(end, 1:end) = 500; % Top
T(1:end,   1) = 300; % Left
T(1:end, end) = 300; % Right
T(1,1) = 300; T(1,end) = 500; T(end,end) = 500; T(end,1) = 300; % Corner nodes

% User input for the solver selection
list1 = {'Explicit scheme','Implicit scheme'};
prompt1 = [{'Select the type of 2D transient numerical scheme:'},{''}];
list2 = {'Jacobi method', 'Gauss-Seidel method', 'SOR method'};
prompt2 = [{'Select method for 2D steady heat conduction solver:'},{''}];
[numerical_scheme, selection1] = listdlg('ListString', list1, 'PromptString',...
                                        prompt1, 'SelectionMode', 'single');
if selection1~=1
  fprintf('nNo selection made for iterative solver, program exiting.nn');
  return;
else
  fprintf('nSelection made: %snn', list1{numerical_scheme});
    if numerical_scheme==2
      [iterative_solver, selection2] = listdlg('ListString', list2, 'PromptString',...
                                        prompt2, 'SelectionMode', 'single');
        if selection2~=1
            fprintf('nNo selection made for iterative solver, program exiting.nn');
            return;
        else
            fprintf('nSelection made: %snn', list2{iterative_solver});
        end
        if iterative_solver == 3
            w = 1.26;
        end
    end
end

% Computing through different solvers
if numerical_scheme==1
    % Explicit scheme
    dt = h^2/(4*alpha); t = t_start:dt:t_end; nt = length(t);
    K1 = alpha*dt/(h^2); tic;
    % Time loop
    for k = 1:nt
        % Store the temperature values from previous time-step
        Told = T;
        % Space loop
        for i = 2:nx-1
            for j = 2:ny-1
                dT = Told(i-1,j) + Told(i+1,j) + Told(i,j-1) + Told(i,j+1);
                T(i,j) = (1-4*K1)*Told(i,j) + K1*dT;
            end
        end
        Tmid = [Tmid, T(x==0.5, y==0.5)];
        count = count + 1;
    end
    comp_time = toc
elseif numerical_scheme==2
    % Implicit scheme
    dt = 0.01; t = t_start:dt:t_end; nt = length(t);
    K1 = alpha*dt/(h^2); tic;
    % Time loop
    for k=1:nt
        T_prev_dt = T; err = 1;
        % Convergence loop
        while err >= tol
            if iterative_solver == 1
                [T, err] = jacobi_implicit(T,T_prev_dt,nx,ny,K1);
            elseif iterative_solver == 2
                [T, err] = gauss_seidel_implicit(T,T_prev_dt,nx,ny,K1);
            elseif iterative_solver == 3
                [T, err] = SOR_implicit(T,T_prev_dt,nx,ny,K1,w);
            end
          count = count + 1;
        end
        Tmid = [Tmid, T(x==0.5, y==0.5)];
    end
    comp_time = toc;
end


% Plotting the results
figure(1)
semilogy(t, Tmid, 'LineWidth', 1.5);
grid on; ax = gca; ax.FontSize = 11;
xlabel('Iterations', 'FontSize', 14); xlim([0 t(end)]);
ylabel('Temperature (K)', 'FontSize', 14);
if numerical_scheme==1
    str = {'Temperature variation with time at central node';...
            ['Explicit solver: ', num2str(comp_time),' seconds'];...
            [num2str(count), ' iterations, dt = ', num2str(dt)]};
else
    str = {'Temperature variation with time at central node';...
            ['Implicit ', list2{iterative_solver},': ',...
            num2str(comp_time), ' seconds'];...
            [num2str(count), ' iterations, dt = ', num2str(dt)]};
end
title(str,'FontSize',12);

figure(2)
contourf(x,y,T,'ShowText', 'on'); ax = gca; ax.FontSize = 11;
c = colorbar; colormap(jet); c.FontSize = 11;
set(get(c, 'label'), 'string', 'Contour: Temperature (K)', 'FontSize', 14);
xlabel('X (m)', 'FontSize', 14); ylabel('Y (m)', 'FontSize', 14);
if numerical_scheme == 1
    str = {['Temperature contour at t = ', num2str(t_end),' using ',...
            list1{numerical_scheme}]};
elseif numerical_scheme==2
    str = {['Temperature contour at t = ', num2str(t_end),' using ',...
            list1{numerical_scheme},', ', list2{iterative_solver}]};
end
title(str, 'FontSize',11);
