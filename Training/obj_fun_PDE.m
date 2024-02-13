function [F, J] = obj_fun_PDE(sol, data)
% OBJ_FUN_PDE provides the system of nonlinear equations and their jacobian obtained
% from the discretization of the nonlinear PDE.

% INPUT:
%   sol: Array of unknowns.
%   data: Information containing constants and other details.

% OUTPUT:
%   F: System of algebraic equations.
%   J: Jacobian of the equations.

x = data.x;
y = data.y;
D_s = data.D_s;
b1 = data.alpha;
RHS_O = data.RHS_O;

del_x = x(2) - x(1);
del_y = y(2) - y(1);

Lx = length(x);
Ly = length(y);
N = Lx * Ly; % Total number of unknowns in the square grid

alpha = D_s / (del_x * del_x); % Elements of the matrix
beta = D_s / (del_y * del_y); % Elements of the matrix
gamma = 2 * (alpha + beta);

% Upper most diagonal
temp = beta * ones(N, 1);
temp(Lx:2 * Lx) = 2 * beta;

% Lower most diagonal
temp0 = beta * ones(N, 1);
temp0(N - 2 * Lx + 1:N) = 2 * beta;

% Sub-diagonal
temp1 = alpha * ones(N, 1);
temp1(Lx - 1:Lx:end) = 2 * alpha;
temp1(Lx:Lx:end) = 0;

% Super-diagonal
temp2 = alpha * ones(N, 1);
temp2(2:Lx:end) = 2 * alpha;
temp2(Lx + 1:Lx:end) = 0;

% Main diagonal
diag_s = (-gamma) * ones(N, 1) - b1 ./ (1 + sol);

% Matrix
A_s = spdiags([temp0, temp1, diag_s, temp2, temp], -[Lx, 1, 0, -1, -Lx], N, N);

F = A_s * sol - RHS_O;

diag_s_J = (-gamma) * ones(N, 1) - b1 ./ ((1 + sol).^2);

J = spdiags([temp0, temp1, diag_s_J, temp2, temp], -[Lx, 1, 0, -1, -Lx], N, N);
end
