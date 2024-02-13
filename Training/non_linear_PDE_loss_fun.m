function loss = non_linear_PDE_loss_fun(param, X, Y, hypoxia_data, V, nxp)
% NON_LINEAR_PDE_LOSS_FUN computes the loss function for the nonlinear form of hypoxia equation.

% INPUT:
%   param: Parameters involved in the PDE and hypoxia equation.
%   X: x-interval of the domain.
%   Y: y-interval of the domain.
%   hypoxia_data: Density obtained from the images of CA9 scan.
%   V: Blood vessel density obtained from the images of CD31 scan.
%   nxp: Discretization points.

% OUTPUT:
%   loss: Loss function to be minimized by the optimizer.

% Parameters
alpha = param(1);
beta = param(2);
gamma = param(3);
O_l = param(4);
O_h = param(5);
k1 = param(6);
D_h = param(7);
k2 = param(8);
k3 = param(9);

% Solve the PDE
num_pts = nxp;
x = linspace(1, size(X, 1), num_pts);
y = linspace(1, size(X, 2), num_pts);
dx = x(2) - x(1);
Lx = length(x);
Ly = length(y);
N = Lx * Ly;

% Source
V = V(1:dx:end, 1:dx:end);
temp_rhs = reshape(V, N, 1);
RHS_O = -beta * temp_rhs ./ (1 + temp_rhs);

% Solve the system (nonlinear)
data.x = x;
data.y = y;
data.D_s = D_h;
data.alpha = alpha;
data.RHS_O = RHS_O;
ini_sol = zeros(size(RHS_O));
options = optimoptions('fsolve', 'Display', 'Off', 'SpecifyObjectiveGradient', true);
fun = @(sol) obj_fun_PDE(sol, data);
[sol_O, ~, exitflag, ~] = fsolve(fun, ini_sol, options);
O_sol = reshape(sol_O, Lx, Ly);
O_normalized = O_sol / (max(max(O_sol)));

%% Calculate hypoxia

% Get hypoxia density obtained from CA9 scan and normalize it
hypoxia_data = hypoxia_data(1:dx:end, 1:dx:end);
hypoxia_data = hypoxia_data / (max(max(hypoxia_data)));

hypoxia_calculated = gamma * (k1 ./ (k1 + exp(k2 * (O_normalized - k3))));

% Set calculated hypoxia to zero beyond the lower and upper threshold
mask = O_normalized <= O_l | O_normalized >= O_h;
hypoxia_calculated(mask) = 0;

% Loss function
loss = norm(hypoxia_calculated - hypoxia_data);
end
