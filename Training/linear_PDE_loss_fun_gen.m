function loss = linear_PDE_loss_fun_gen(param, X, hypoxia_data, V, dx)
% LINEAR_PDE_LOSS_FUN_GEN computes the loss function for sigmoidal form of hypoxia equation.

% INPUT:
%   param: Parameters involved in the PDE and hypoxia equation.
%   X: x-interval of the domain.
%   hypoxia_data: Density obtained from the images of CA9 scan.
%   V: Blood vessel density obtained from the images of CD31 scan.
%   dx: Discretization step.

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
x = 1:dx:size(X, 1);
y = 1:dx:size(X, 2);
Lx = length(x);
Ly = length(y);
N = Lx * Ly;

V = V(1:dx:end, 1:dx:end);
RHS_O = reshape(V, N, 1);
RHS_O = -beta * RHS_O ./ (1 + RHS_O);
A_O = set_const_diff(x, y, D_h, alpha);

%check for GPU
tf = canUseGPU();
if tf
    A_O = gpuArray(A_O);
end
[H_O1, ~] = bicgstab(A_O, RHS_O);
H_O1 = reshape(H_O1, Lx, Ly);
H_O1 = H_O1 / (max(eps, max(H_O1(:))));
H_O = gather(H_O1);

% Normalize
H_O = H_O / (max(eps, max(H_O(:))));

%% Calculate hypoxia

% Get hypoxia density obtained from CA9 scan and normalize it
hypoxia_data = hypoxia_data(1:dx:end, 1:dx:end);
hypoxia_data = hypoxia_data / (max(eps, max(hypoxia_data(:))));

% Calculate hypoxia using sigmoidal form
hypoxia_calculated = gamma * (k1 ./ (k1 + exp(k2 * (H_O - k3))));

% Set calculated hypoxia to zero beyond the lower and upper threshold
hypoxia_calculated(H_O <= O_l | H_O >= O_h) = 0;
hypoxia_calculated(hypoxia_data <= 1e-12) = 0;

% Loss function
loss = norm(hypoxia_calculated - hypoxia_data)^2;
end
