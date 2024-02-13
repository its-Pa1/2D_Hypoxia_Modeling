function A_s = set_const_diff(x, y, D_s, b1)
% SET_CONST_DIFF computes the diffusion matrix for constant diffusion
% using central difference discretization with a constant diffusion coefficient.

% INPUT:
%   x: x-interval of the domain.
%   y: y-interval of the domain.
%   D_s: Constant diffusion coefficient.
%   b1: Constant decay rate.
%
% OUTPUT:
%   A_s: Sparse matrix obtained from the discretization.

% Compute grid spacing in x and y directions
del_x = x(2) - x(1);
del_y = y(2) - y(1);

Lx = length(x);
Ly = length(y);
N = Lx * Ly; % Total number of unknowns in the square grid

alpha = D_s / (del_x * del_x); % Elements of the matrix
beta = D_s / (del_y * del_y); % Elements of the matrix
gamma = 2 * (alpha + beta);

% Uppermost diagonal
temp = beta * ones(N, 1);
temp(Lx:2 * Lx) = 2 * beta;

% Lowermost diagonal
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
diag_s = (-gamma) * ones(N, 1) - b1;

% Construct the sparse matrix
A_s = spdiags([temp0, temp1, diag_s, temp2, temp], [-(Lx), -1, 0, 1, Lx], N, N);

end
